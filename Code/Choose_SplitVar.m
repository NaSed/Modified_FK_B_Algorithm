% This function selects variable x which is most frequent in both CNF and DNF

% Inputs:
% cnf: a binary matrix showing a monotone Boolean function in conjuctive normal form. Each row corresponds to a clause in CNF and each column corresponds to a variable.
% dnf: a binary matrix showing a monotone Boolean function in disjunctive normal form. Each row corresponds to a monomial in DNF and each column corresponds to a variable.
% The number of columns in cnf and dnf must be the same.
% method: The method of choosing the splitting variable. Currently, the only method is 'mostFreq', and it is planted for further extension.

% Output:
% res: the chosen variable

function res = Choose_SplitVar( cnf, dnf, method )
global weight
if strcmp(method , 'mostFreq')
    [~, cnfVar] = sort(sum(cnf, 1), 'descend');
    [~, dnfVar] = sort(sum(dnf, 1), 'descend');
    
    for i=1:numel(cnfVar)
        var = intersect(cnfVar(1:i), dnfVar(1:i));
        if ~isempty(var)
            res = var(1);
            return
        end
    end
end
if strcmp(method , 'mostFreqinOne')
    [~, cnfVar] = sort(sum(cnf, 1), 'descend');
    [~, dnfVar] = sort(sum(dnf, 1), 'descend');
    
    tab1 = [1:size(cnf,2); sum(cnf, 1)];
    tab2 = [1:size(dnf,2); sum(dnf, 1)];
    
    tab = [tab1'; tab2'];
    [~,idx] = sort(tab(:,2), 'descend'); % sort just the second column
    sortedtab = tab(idx,:);
   
    res = sortedtab(1, 1);
    return
end
if strcmp(method , 'weightedVars')
    cnfVar = find(sum(cnf, 1) > 0);
    dnfVar = find(sum(dnf, 1) > 0);
    vars = sort(union(cnfVar, dnfVar));
    
    vars_weight = weight(vars);
    %     C = cumsum(vars_weight/max(vars_weight));
    %     res = vars(1+sum(C(end)*rand>C));
    if sum(vars_weight) == 0
        vars_weight = vars_weight + (1/numel(vars_weight));
    end
    res = randsrc(1,1,[vars; (vars_weight/sum(vars_weight))']);
end
end