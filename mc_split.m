%
% mc_split
%
function P = mc_split(P,T,pos,A)
global C X Y 
% Find the node N in a given position:
for i = 1:size(T,2)
  if T(i).p == pos
    N = T(i);
    break
  end
end

X1 = (X(A,N.v) >= N.q); 
% The left branch:
A0 = find(X1 == 0);		
if N.t(1) == 0	% a splitting node
  P = mc_split(P,T,N.c(1),A(A0));				
else	% a terminal node
  if isempty(A0) == 0
    for i = 1:C
      P(N.c(1),i) = sum(Y(A(A0)) == i); 
    end
  else
    P(N.c(1),:) = zeros(1,C); % go ahead     
  end
end
% The right branch:
A1 = find(X1 == 1);		
if N.t(2) == 0
  P = mc_split(P,T,N.c(2),A(A1));
else
  if isempty(A1) == 0
    for i = 1:C
      P(N.c(2),i) = sum(Y(A(A1)) == i); 
    end
  else
    P(N.c(2),:) = zeros(1,C);
  end
end    
return