% This function gets an MBF as a binary matrix and returns its canonical form as well as the corresponding permutation
% bigPermMat is a big binary matrix including whole possible permutations

function [res, varperm]= Find_CanonicalForm(MBF)

global bigPermMat

ind = sum(MBF,1)>0; % present variables in MBF
origg_MBF = MBF;
origg_vars = find(ind);
MBF = MBF(:, ind);
nvar = sum(ind); % active variables
n = 2^nvar;
nperm = factorial(nvar);

% bigPermMat = Perm_BinaryMatGen(nvar);

% Convert MBF to a binary vector
% vec is of size [n x 1]

vec = mts_to_mbf(MBF', nvar);

%+++++++++++++++++++++++++
%+++++++++++++++++++++++++

bigRes = 1*((bigPermMat{nvar} * vec') > 0); % bigRes is of dimension [2^nvar, 1]
decvec = zeros(1, nperm);

for i=1:nperm
    binvec = bigRes(((i-1)*n)+1:(i*n)); 
    decvec(i) = bi2de(binvec'); %convert binary vector to a decimal number
end

[~, ind] = min(decvec);

% Canonical is a binary vector
canonical = bigRes(((ind-1)*n)+1:(ind*n));
mapping = bigPermMat{nvar}(((ind-1)*n)+1:(ind*n),:);

[perm, ~] = find(mapping);

% the rows in truth table are sorted in lexicographical descending order
% because of the defalt considered order in Tamon's code
truthTable = sortrows(getcondvects(nvar), nvar:-1:1,'descend');
ind = find(sum(truthTable, 2)==1);

permuted_truthTable = truthTable(perm,:);
permuted_ind = find(sum(permuted_truthTable, 2)==1);

if ~isequal(ind, permuted_ind)
    error('There is something wrong in truth table and its permutation!!')
end

perm = perm(ind);

[~, old_var] = find(truthTable(perm,:)==1);

[r, new_var] = find(permuted_truthTable(perm,:)==1);
temp = sortrows([r, new_var]);
new_var = temp(:,2);

permutation = sortrows([old_var, new_var]);
permutation = permutation(:, 2)';
permutation = origg_vars(permutation);

varperm = 1:size(origg_MBF,2);
varperm(origg_vars) = permutation;
% Convert canonical to an MBF
mapped_MBF = mts(canonical', nvar)';
res = origg_MBF;
res(:,origg_vars) = mapped_MBF;
end

