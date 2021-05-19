% This function gets the number of variables, n, and makes a big binary
% matrix corresponding to the whole possible permutations for an MBF with n
% variables.
% It works for small 'n'.

function bigMat = Perm_BinaryMatGen(n)

% Generating all permutations for n variables
% perms is of dimension [n!, 2^n]
perms = permlist(n);

% the number of possible permutations
nrow = factorial(n);
ncol = 2^n;

bigMat = zeros(nrow*(ncol), ncol);
mat = zeros(ncol, ncol);

for i=1:nrow
    p = perms(i, :);
    mat(sub2ind(size(mat), 1:ncol, p)) = 1;
    bigMat(((i-1)*ncol)+1:(i*ncol),:) = mat;
end

end
