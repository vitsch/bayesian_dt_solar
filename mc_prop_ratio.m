%
% mc_prop_ratio
%
function R = mc_prop_ratio(T,m1)
global R1 R2 Pp node_max
lenT = size(T,2);
Dq = 0;
for i = 1:lenT
  if sum(T(i).t) == 2
    Dq = Dq + 1;
  end
end
if lenT > node_max
  lenT = node_max;
end
switch m1
case 1
  R = (lenT + 1)/(Dq + 1)*R1(lenT)*Pp(1);
case 2
  R = Dq/lenT*R2(lenT)*Pp(2);
otherwise 
  R = 1;
end
return
