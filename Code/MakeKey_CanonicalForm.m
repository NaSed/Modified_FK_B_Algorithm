% This function makes canonical form based on "COUNTING INEQUIVALENT MONOTONE BOOLEAN FUNCTIONS" paper.

% Inputs: 
% cnf: a binary matrix showing a monotone Boolean function in conjuctive normal form. Each row corresponds to a clause in CNF and each column corresponds to a variable.
% dnf: a binary matrix showing a monotone Boolean function in disjunctive normal form. Each row corresponds to a monomial in DNF and each column corresponds to a variable.

%Outputs:
% key: the key to be used in hash table
% varperm: the permutation that converts cnf to its canonical form
function [key, varperm] = MakeKey_CanonicalForm(cnf, dnf)
global canonicalKey
% n = size(cnf, 2);
cnf_perm = 1:size(cnf, 2);

delimiter = size(cnf,2);
active_vars = sum(sum(cnf,1)>0); % active variables in cnf
if(~isempty(cnf) && active_vars > 1 && active_vars < 7)
    [cnf, cnf_perm] = Find_CanonicalForm(cnf);
    %mat_temp = dnf;
    dnf(:, sort(cnf_perm)) = dnf(:, cnf_perm);
    canonicalKey = 1;
end

if(size(cnf,1)>1)
    lcnf = reshape(cnf, 1, []);
else
    lcnf = cnf;
end
% cnf_chr = strjoin(string(lcnf));
% cnf_chr = int2str(lcnf);


% reshaping DNF as a vector
if(size(dnf,1)>1)
    ldnf = reshape(dnf, 1, []);
else
    ldnf = dnf;
end

%key = strcat('CNF=[', cnf_chr, '];DNF=[', dnf_chr, ']');
comb = [lcnf, delimiter, ldnf];
key = int2str(comb);
key = char(key);

varperm = 1:size(cnf,2);
varperm(sort(cnf_perm)) = cnf_perm;
return
end