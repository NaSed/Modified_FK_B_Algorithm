% This function randomly finds 'n_clauses' clauses included in cnf based on the given dnf.

% Inputs:
% method: currently it can be only 'randomly'; It is for future extensions.
% dnf: a binary matrix showing a monotone Boolean function in disjunctive normal form. Each row corresponds to a clause in CNF and each column corresponds to a variable.
% n_clause: The number of clauses to initialize cnf

% Output:
% cnf: a binary matrix showing a monotone Boolean function in disjunctive normal form. Each row corresponds to a clause in CNF and each column corresponds to a variable.
%		The number of rows in cnf is equal to 'n_clause'


function cnf = Initialize_CNF( method, dnf, n_clause )

if(strcmp(method,'random'))
    
    counter = 1;
    cnf = []; 
    while(size(cnf, 1) < n_clause)
        
        minimal_vars = [];
        tst = dnf;

        while (sum(sum(tst))>0)
            ss = sum(tst, 1);
            I = datasample(find(ss>0), 1, 'Replace',false);
            minimal_vars = union(minimal_vars, I);
            tst(logical(tst(:,I)),:) = [];
%             tst(:,I) = 0;
        end
        minimal_vars = Minimality_Check(minimal_vars, dnf);
        new = zeros(1, size(dnf, 2));
        new(minimal_vars) = 1;
        cnf = [cnf; new];
        cnf = Irredundant(cnf);
        counter = counter + 1;
    end
    
end
if(strcmp(method,'complete_random'))
    
    cnf = randi([0,1], n_clause, size(dnf,2));
    cnf = Irredundant(cnf);
    % Each clause should have an intersection with every monomial
    check = zeros(size(cnf,1), 1);
    for i=1:size(cnf,1)
        
        temp = repmat(cnf(i,:), size(dnf,1), 1);
        res = temp .* dnf;
        test = sum(res, 2)>0; 
        if (sum(test) == size(dnf,1))
            check(i) = 1;
        end
    end
    
    cnf = cnf(check==1,:);
    
    % max{|c|: c \in CNF} <= |D|
    
    test = sum(cnf, 2) <= size(dnf,1);
    cnf = cnf(test,:);  
    if size(cnf,1)==0
        cnf = Initialize_CNF( 'random', dnf, 5);
    end
end

return
end

