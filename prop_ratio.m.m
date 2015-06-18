%
% prop_ratio.m 
%
S = zeros(1,node_max);
S(1) = 1;
for n = 2:node_max
  if mod(n,2) == 0
    S(n) = 2*sum(S(1:n - 1));
  else
    S(n) = 2*sum(S(1:n - 1)) - S((n - 1)/2);
  end
end
R2 = S(2:node_max)./S(1:node_max - 1);	
R1 = S(1:node_max - 1)./S(2:node_max);	
save prop_ratio R1 R2 node_max
return