%
%	mc_prob
%
function Tp = mc_prob(tlen,P)
global pC C
Tp = repmat(pC,[tlen 1]); 
Tn1 = sum(P')';
A1 = find(Tn1 > 0);
for i = 1:C
  Tp(A1,i) = P(A1,i)./Tn1(A1); 
end
return
