% This function is called when one of the given cnf or dnf has less than 3 clauses or monomials and it checks equivalence between cnf and dnf based on Boolean algebra.

% Inputs:
% cnf: a binary matrix showing a monotone Boolean function in conjuctive normal form. Each row corresponds to a clause in CNF and each column corresponds to a variable.
% dnf: a binary matrix showing a monotone Boolean function in disjunctive normal form. Each row corresponds to a monomial in DNF and each column corresponds to a variable.
% The number of columns in cnf and dnf must be the same.

% Output: 
% CA: It is the conflict assignment(s) between the given cnf and dnf; each row corresponds to a conflict assignment. The variables corresponding to '1' in CA are considered as True and the other variables that might be '0' or '-1' are considered as False.
% If the given cnf and dnf are equivalent, CA would be [] (NULL).

function CA = MEasy_case(cnf,dnf)

CA = [];
% +++++++++++++++++++++++++++++++++++++++++++++++++
% Case like cnf=(1,2,3) and dnf= (1) (2) (3)
% +++++++++++++++++++++++++++++++++++++++++++++++++

if(size(cnf,1)==1 && size(dnf,1) == sum(sum(cnf)) && sum(sum(cnf))== sum(sum(dnf)))
    [~,dnf_vars] = find(dnf==1);
    cnf_vars = find(cnf==1);
    if(isequal(cnf_vars, dnf_vars'))
        CA = [];
        return
    end
end

if(size(dnf,1)==1 && size(cnf,1) == sum(sum(dnf)) && sum(sum(cnf))== sum(sum(dnf)))
    [~,cnf_vars] = find(cnf==1);
    dnf_vars = find(dnf==1);
    if(isequal(cnf_vars, dnf_vars))
        CA = [];
        return
    end
end

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Checking intersection between clauses and monomials
% If there is no intersection, conflict assignment would be the monomial
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% res = cnf * dnf';
% [r, c] = find(res==0);
% ind = [r c];
% % if ~isempty(ind)=0, it means that there is no zero in the res and
% % there is intersection between every monomials and clauses
% if (~isempty(ind))
%     CA = zeros(1, size(dnf,2));
%     CA(dnf(ind(1,1),:)) = 1;
% %     if (~isempty(CA))
% %         disp('Easy 1')
% %     end
%
%     return
% end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Case I:  When DNF has at most two monomials
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(size(dnf,1)<=2)
    % browser()
    res = CA_smallCNF(dnf, cnf);
    if(isempty(res))
        CA = [];
    else
        [~,vars]=find(dnf);
        vars = unique(vars);
        % % %         temp = setdiff(vars, res);
        
        CA = zeros(size(res,1), size(dnf,2));
        for tt=1:size(res,1)
            temp = setdiff(vars, find(res(tt,:)));
            CA(tt,temp) = 1;
        end
        %                 if (~isempty(CA))
        %                     disp('Easy 2')
        %                 end
        
    end
    return
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Case II:  When DNF has more than two monomials and CNF is the shorter one
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    temp =  CA_smallCNF(cnf, dnf);
    if(~isempty(temp))
        %%%        CA = zeros(1, size(dnf,2));
        % % %         CA(temp) = 1;
        CA=temp;
    end
    %         if (~isempty(CA))
    %             disp('Easy 3')
    %         end
    
    return
end
end