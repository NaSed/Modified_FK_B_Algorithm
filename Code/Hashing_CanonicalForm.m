% This function gets a cnf and dnf and make key from them
% then it checks if the key is already in the hash table
% If the key is already there, it returns CA, otherwise it returns 'None'
function [CA, key, varperm] = Hashing_CanonicalForm(cnf, dnf)
global cellHash cellSize popularKey popu_ind
global canonicalKey canonic_fetch hash_cntr

canonicalKey  = 0;
[key, varperm] = MakeKey_CanonicalForm(cnf, dnf);

cmp = strcmp(key, cellHash(1:(cellSize-1),1));
if (any(cmp))
    popularKey(popu_ind) = find(cmp == 1, 1, 'first');
    popu_ind = popu_ind + 1;
    
    if (canonicalKey==1)
    canonic_fetch = canonic_fetch + 1;
    end
    r = cellHash(cmp,2);
    r = r{1,1};
    if ismatrix(r)
        CA = r;
        if(~isempty(CA))
            inverse_permutation = sortrows([varperm', (sort(varperm))'], 1);
            inverse_permutation = inverse_permutation(:,2);
            CA = CA(:, inverse_permutation);
%             canonic_cntr = canonic_cntr + 1;
        end
    else
        inverse_permutation = sortrows([varperm', (sort(varperm))'], 1);
        inverse_permutation = inverse_permutation(:,2);

        CA = cell2mat(r{1,1});
        CA = CA(:, inverse_permutation);
%         canonic_cntr = canonic_cntr + 1;
    end
    hash_cntr = hash_cntr + 1;
else
    CA = 'None';
end
end