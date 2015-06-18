%
% mc_create_move
%
function [T,m1] = mc_create_move(T)
global X mvar Pr K Cf q_nom x_max x_min
tlen = size(T,2);
r1 = rand;
if r1 < Pr(1)
  m1 = 1;
elseif r1 < Pr(2)
  if tlen > 1 
    m1 = 2;
  else 
    m1 = 4;
  end
elseif r1 < Pr(3)
  m1 = 3;
else
  m1 = 4;
end
switch m1
case 1	% make the birth move
	t1 = tlen + 1; % the number of terminals
  T1 = zeros(3,t1);
  T2 = zeros(1,tlen); % a list of node positions
  k = 0;
  for i = 1:tlen
    T2(i) = T(i).p;				
    va = find(T(i).t == 1);
    for j = va
      k = k + 1;
      T1(:,k) = [i; j; T(i).c(j)]; 
    end
  end
  t = unidrnd(t1);		% random choice of a terminal node 
  vi = T1(1,t);	% an index of the above node
  va = T1(2,t);			
  t3 = T(vi).c(va);	% keep a replaced terminal index 
  t2 = 1;		% find a skipped/new split position  
  while isempty(find(T2 == t2, 1)) == 0  
    t2 = t2 + 1;
  end
  T(vi).c(va) = t2;	% change the parent node
  T(vi).t(va) = 0; 
  v1 = unidrnd(mvar);
  q1 = unifrnd(x_min(v1),x_max(v1));	% a new rule
  t4 = 1;		% find a skipped/new terminal node position  
  while isempty(find(T1(3,:) == t4)) == 0  
    t4 = t4 + 1;
  end
  N = struct('p',t2,'v',v1,'q',q1,'c',[t3 t4],'t',[1 1]);
  T(t1) = N;
  return

case 2 % make the death move
  A = [];
  for i = 1:tlen
    if sum(T(i).t) == 2
      A = [A i];
    end
  end
  t = A(unidrnd(length(A)));
  c1 = min(T(t).c);
  p1 = T(t).p;
  T(t) = [];
  tlen = tlen - 1;
  for vi = 1:tlen
    ap = find(T(vi).c == p1 & T(vi).t == 0);
    if isempty(ap) == 0
      T(vi).c(ap) = c1; % connected to a terminal node c1
      T(vi).t(ap) = 1;
      break
    end
  end
  return  

case 3	% make the change-question move
  ni = unidrnd(tlen);
  vnew = 1:mvar;
  vnew(T(ni).v) = [];
  v1 = vnew(unidrnd(mvar - 1));
  T(ni).v = v1;
  if Cf(v1) == 0 % nominal
    T(ni).q = round(unifrnd(x_min(v1),x_max(v1)));    
  else
    T(ni).q = unifrnd(x_min(v1),x_max(v1));    
  end
  return

case 4 % make the change-rule move
  ni = unidrnd(tlen);
  v1 = T(ni).v; 
  if Cf(v1) == 0	% nominal
    if rand > 0.5
      T(ni).q = T(ni).q + ceil(q_nom*rand); 
    else
      T(ni).q = T(ni).q - ceil(q_nom*rand);
    end
  else	% discrete (continue)
    T(ni).q = T(ni).q + K(v1)*randn;		
  end
  return
end
return
