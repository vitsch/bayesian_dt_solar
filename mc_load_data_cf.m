%
% mc_load_data
%
function [C,mvar,X,Y,num,Xt,Yt,numt,Cf] = mc_load_data_cf()
%
% http://mlr.cs.umass.edu/ml/datasets/Solar+Flare
%
D=csvread('flar_num.csv');
[n,mvar] = size(D);
mvar=mvar-1;
A1 = 1:n;
A2 = 1:3:n;
A1(A2) = [];

% X, Xt are the training and test data
% Y, Yt are the target vectors for training and testing, respectively    

X=D(A1,1:mvar);
Y=D(A1,mvar+1);
Xt=D(A2,1:mvar);
Yt=D(A2,mvar+1);

num = length(Y);
numt = length(Yt);
C = max(Y); % the number of classes

% Sort features x(i) as nominal (0) or discrete (1):

discr_max = 12; % let be a criterion for discrete or nominal
Cf = zeros(1,mvar);
for i = 1:mvar
  A = 1:num;
  discr = 0;
  while isempty(A) == 0
    A1 = find(X(A,i) == X(A(1),i));
    discr = discr + 1;
    A(A1) = [];
  end
  if discr > discr_max
    Cf(i) = 1; 
  end
end
return
