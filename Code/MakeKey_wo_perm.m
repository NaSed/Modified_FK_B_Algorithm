% This function makes a key for inserting in the hash table given cnf and dnf as binary matrices.
function key = MakeKey_wo_perm(cnf, dnf)

% n = size(cnf, 2);

delimiter = size(cnf,2);

if(size(cnf,1)>1)
    lcnf = reshape(cnf, 1, []);
else
    lcnf = cnf;
end

if(size(dnf,1)>1)
    ldnf = reshape(dnf, 1, []);
else
    ldnf = dnf;
end
% dnf_chr = strjoin(string(ldnf));
% dnf_chr =int2str(ldnf);

%key = strcat('CNF=[', cnf_chr, '];DNF=[', dnf_chr, ']');
comb = [lcnf, delimiter, ldnf];
key = int2str(comb);
key = char(key);
return
end