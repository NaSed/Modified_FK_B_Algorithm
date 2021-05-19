% This function gets a cnf and dnf and makes key from them
% then it checks if the key is already in the hash table
% If the key is already there, it returns CA, otherwise it returns 'No
% hash'
function [CA, key] = Hashing_wo_perm(cnf, dnf)
global cellHash cellSize hash_cntr popularKey popu_ind
%  if(size(tempCNF,1) > thresh && size(D_x_1,1) > thresh)
key = MakeKey_wo_perm(cnf, dnf);

cmp = strcmp(key, cellHash(1:(cellSize-1),1));
if (any(cmp))
    popularKey(popu_ind) = find(cmp == 1, 1, 'first');
    popu_ind = popu_ind + 1;
    r = cellHash(cmp,2);
    r = r{1,1};
    if ismatrix(r)
        CA = r;
    else
        CA = cell2mat(r{1,1});
    end
    hash_cntr = hash_cntr + 1;
else
    CA = 'None';
end
end