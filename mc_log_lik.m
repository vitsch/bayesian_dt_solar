%
% mc_log_lik
%
function [lik] = mc_log_lik(N2)
global C
tlen = size(N2,1);
Lik = zeros(1,tlen);
for i = 1:tlen
  lik1 = sum(gammaln(N2(i,:) + 1));
  Lik(i) = lik1 - gammaln(sum(N2(i,:)) + 1);
end
lik = sum(Lik);  % log likelihood
return
