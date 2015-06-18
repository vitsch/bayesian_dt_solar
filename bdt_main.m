%
% Bayesian averaging over Decition Tree models 
% with Markov Chain Monte Carlo
%
% Scripts and functions: 
%     prop_ratio
%     mc_load_data
%     mc_split
% 		mc_log_lik
%     mc_create_move
%     mc_shrink
%     mc_prop_ratio
%     mc_prob
%     mc_test
%     mc_rpt
%
global X Y C num mvar Pr pmin Xt pC Tp K Cf q_nom x_min x_max  Pp 

% Set parameters:

% the minimal number of data points allowed in DT nodes  
pmin = 5;

% the variance of a Gaussian for change-rule moves for continuos features
q_sig = .1; 

% the variance of a uniform distribution for nominal features  
q_nom = 5; %1

% the number of burn-in samples
nb = 100*1000; %50000

% the number of post burn-in samples
np = 10*1000; % 5000

% the proposal probabilities for birth, death, 
% change-question, and change-rule moves
Pr = cumsum([0.2 0.2 0.2 0.4]);

% the sampling rate to convert MC into an i.i.d. process
sample_rate = 7;

% level of consistency of the post burn-in ensemble for mc_rpt.m
consist_lev = 0.99;

% store the DT outputs and models accepted in the post burn-in phase
hist_collect = 1; 
dt_collect = 1;

% print a sample
print_sample = 1000;

load prop_ratio R1 R2 node_max % see script prop_ratio


% load data
[C,mvar,X,Y,num,Xt,Yt,numt,Cf] = mc_load_data_cf(); 

Pp(1) = (Pr(2) - Pr(1))/Pr(1);
Pp(2) = Pr(1)/(Pr(2) - Pr(1));
Perf = []; % performance on the test   	
x_min = min(X); x_max = max(X);
K = q_sig*std(X);

% Class prior probabilities:
pC = zeros(1,C);
for i = 1:C
  pC(i) = length(find(Y == i));
end
pC = pC/num;     

n_samples = nb + np;
sum_yt = zeros(C,numt); % test output
store_prb = zeros(C,numt);

if hist_collect == 1
  hist_ar = zeros(C,numt); % save the DT outputs accepted 
end
Lik = zeros(1,n_samples);
Ts = zeros(1,n_samples);
ac = zeros(4,2);

% Initialize a DT:
v1 = unidrnd(mvar);
if Cf(v1) == 0 % the nominal variable
  A = x_min(v1):1:x_max(v1);
  T = struct('p',1,'v',v1,'q',A(ceil(length(A)*rand)),...
  'c',[1 2],'t',[1 1]);				    
else	% the discrete variable
  T = struct('p',1,'v',v1,'q',unifrnd(x_min(v1),...
	x_max(v1)),'c',[1 2],'t',[1 1]);				    
end

P = mc_split([],T,T(1).p,1:num);	

lik = mc_log_lik(P);	

tlen = 1;
mod1 = 1;
is = nb;
is1 = 0;
i1 = 0;

while is < n_samples 
  i1 = i1 + 1;

  % Make an available move:
  while 1
    [T1,m1] = mc_create_move(T);	

    N1 = mc_split([],T1,T1(1).p,1:num);	

    [N2,T2] = mc_shrink(N1,T1);	

    len = size(T1,2) - size(T2,2); 

    switch m1
    case 1
      if len == 0
        break;
      end
    case 2
      break;
    otherwise
      if len == 0
        break;
      end
    end
  end
  
  lik1 = mc_log_lik(N2);	% call the function 

  R = mc_prop_ratio(T2,m1);	% call the function

  r = exp(lik1 - lik)*R;
  
  if rand < r % then accept the DT
    T = T2;
    P = N2;
    lik = lik1;
    tlen = size(T2,2);
    mod1 = m1;
    accept = 1;
  else
    accept = 0;
  end
  
  if i1 <= nb % then burn-in phase
    Lik(i1) = lik;								
    Ts(i1) = tlen; 
    if accept == 1 
      ac(mod1,1) = ac(mod1,1) + 1;
    end
    if mod(i1,print_sample) == 0
      fprintf('%6i %7.1f %3i\n',i1,lik,tlen)
    end
    
  elseif mod(i1,sample_rate) == 0 % then post burn-in phase
    is = is + 1;
    Lik(is) = lik;  			
    Ts(is) = tlen;	
    if accept == 1  
      ac(mod1,2) = ac(mod1,2) + 1;
    end
    Tp = mc_prob(size(P,1),P);	% call the function
    sum_yt = mc_test(zeros(C,numt),T,T(1).p,1:numt);	
    store_prb = store_prb + sum_yt;	
    
    if hist_collect == 1
      [ym,yt] = max(sum_yt);
      for j = 1:numt
        hist_ar(yt(j),j) = hist_ar(yt(j),j) + 1;
      end
    end
    
    if dt_collect == 1
      is1 = is1 + 1;
      Dtp{is1,1} = T;
      Dtp{is1,2} = Tp;
    end
    
    if mod(is,print_sample) == 0
      fprintf('%6i %7.1f %3i\n',is - nb,lik,tlen)
    end
  end
end

mc_rpt;
return