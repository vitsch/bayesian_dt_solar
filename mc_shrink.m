%
% mc_shrink
%
function [N,T] = mc_shrink(N1,T1)
global num pmin
tree_len = size(T1,2);
tree_len1 = tree_len;
do_more = 1;
while do_more == 1 
  del_split = zeros(tree_len1,1);
  T2 = T1;
  for i = 1:tree_len1
    No = T1(i);
    if sum(No.t) == 2 
      t = [No.c(1) No.c(2)];
      ts = [sum(N1(t(1),:)) sum(N1(t(2),:))];
      if isempty(find(ts < pmin)) == 0
        del_split(i) = 1;      
        p1 = No.p;
        cm = min(No.c);
        for j = 1:tree_len
          za = find(T1(j).t == 0 & T1(j).c == p1);
          if isempty(za) == 0
            T2(j).t(za) = 1;
            T2(j).c(za) = cm;
            break
          end
        end
      end
    end
  end
  A0 = find(del_split == 0);
  if isempty(A0) == 1
    A0 = 1;
  end
  T1 = T2(A0);
  tree_len1 = size(T1,2);
  if tree_len1 < tree_len
    tree_len = tree_len1;
    N1 = mc_split([],T1,T1(1).p,1:num);	% call the function
  else
    do_more = 0;
  end
end 

do_more = 1;
while do_more == 1 
  del_split = zeros(tree_len1,1);
  T2 = T1;
  for i = 1:tree_len1
    No = T1(i);
    si = find(No.t == 0);
    if length(si) == 1 
      t = No.c(3 - si);
      if sum(N1(t,:)) < pmin
        del_split(i) = 1;      
        p1 = No.c(si);
        for j = 1:tree_len
          za = find(T1(j).t == 0 & T1(j).c == No.p);
          if isempty(za) == 0
            T2(j).t(za) = 0;
            T2(j).c(za) = p1;
            break
          end
        end
        break
      end
    end
  end
  A0 = find(del_split == 0);
  if isempty(A0) == 1
    A0 = 1;
  end
  T1 = T2(A0);
  tree_len1 = size(T1,2);
  if tree_len1 < tree_len
    tree_len = tree_len1;
    N1 = mc_split([],T1,T1(1).p,1:num);	% call the function
  else
    do_more = 0;
  end
end 
N = N1;
T = T1;
return
