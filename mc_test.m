%
%	mc_test
%
function P = mc_test(P,T,pos,A)
global Xt Tp C
% Find the node N for a given position:
for i = 1:size(T,2)
  if T(i).p == pos
    N = T(i);
    break
  end
end

X1 = (Xt(A,N.v) >= N.q); 
% The left branch:
A0 = find(X1 == 0);		
if N.t(1) == 0	% a splitting node
  P = mc_test(P,T,N.c(1),A(A0));			
elseif isempty(A0) == 0	% a terminal node
  P(:,A(A0)) = repmat(Tp(N.c(1),:)',1,length(A(A0)));    
end
% The right branch:
A1 = find(X1 == 1);		
if N.t(2) == 0
  P = mc_test(P,T,N.c(2),A(A1));			
elseif isempty(A1) == 0
  P(:,A(A1)) = repmat(Tp(N.c(2),:)',1,length(A(A1)));    
end    
return
