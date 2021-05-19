% This function tests a cnf and dnf to find singleton vars in cnf that
% appear in all terms in dnf
function res = singleton_allonecolumn(cnf, dnf)

dnf_sum = sum(dnf,1);
cnf_sum = sum(cnf(sum(cnf,2)==1,:),1);

allOne_cols = find(dnf_sum  == size(dnf,1)); % single var is in cnf
singletones_cols = find(cnf_sum  == 1); % single var is in cnf
res = intersect(allOne_cols, singletones_cols);

end
