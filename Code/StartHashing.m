% This function starts hash tables and the related variables. 
% Since they are global variables, at first we clear them to make sure everything is clear in the begining.

% Input: 
% hash_threshold: An integer number that is used as a threshold to use hash table or not. The hash table is used when the number of clauses and monomials are larger than 'hash_threshold'.
% hash_threshold = 0 means that we use hash table for every cnf and dnf without considering their size.
function StartHashing(hash_threshold)

clear global cellHash cellSize repchk Hash_thresh popularKey 
clear global popuInd canonic_cntr hash_cntr bigPermMat
global cellHash cellSize Hash_thresh popularKey popu_ind bigPermMat
global hash_cntr canonic_cntr canonic_fetch

cellHash = cell(10000,4);
popularKey = zeros(10000, 1); popu_ind = 1;
cellSize = 1;

canonic_fetch=0; hash_cntr=0; canonic_cntr=0;
Hash_thresh = hash_threshold;

% bigPermMat is used for finding canonical form.
for i=1:6
    if i>1
        bigPermMat{i} = Perm_BinaryMatGen(i);
    end
end

end