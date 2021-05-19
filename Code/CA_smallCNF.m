%This function returns conflict assignment between cnf and dnf when |cnf|, i.e. the number of clauses in cnf, is <= 2.
% It is called by Easy_case function.

% Inputs:
% cnf: a binary matrix showing a monotone Boolean function in conjuctive normal form. Each row corresponds to a clause in CNF and each column corresponds to a variable.
% dnf: a binary matrix showing a monotone Boolean function in disjunctive normal form. Each row corresponds to a monomial in DNF and each column corresponds to a variable.
% The number of columns in cnf and dnf must be the same.

% Output:
% CA: It is the conflict assignment between the given cnf and dnf. The variables corresponding to '1' in CA are considered as True and the other variables that might be '0' or '-1' are considered as False.
% If the given cnf and dnf are equivalent, CA would be [] (NULL).

function CA = CA_smallCNF( cnf, dnf)

CA = [];

% dnf_vars = find(sum(dnf, 1));
cnf_vars = find(sum(cnf, 1));

%++++++++++++++++++++
%  Case II-A: length(cnf)==1
%++++++++++++++++++++
if(size(cnf,1)==1)
    for i=1:(2^numel(cnf_vars)-1) % We are seeking for a subset
        bin = dec2bin(i, numel(cnf_vars));
        S = zeros(1, size(cnf, 2));
        bb = zeros(1, length(bin));
        for u=1:length(bin)
            bb(u) = str2double(bin(u));
        end
        S(cnf_vars) = bb;
        
        chk = zeros(1, size(dnf,1));
        for j=1:size(dnf, 1)
            chk(j) = subsetCheck(dnf(j,:), S);
        end
        
        if (sum(chk)==0) % no monomial is subset of S
            CA = S;
            return
        end
    end
end
%++++++++++++++++++++++++++++
% Case II-B:  length(cnf)==2
%++++++++++++++++++++++++++++
if(size(cnf,1)==2)
    
    %## Case 1
    S = and(cnf(1,:), cnf(2,:));
    
    S1 = 1*((cnf(1,:) - cnf(2,:))>0);
    S2 = 1*((cnf(2,:) - cnf(1,:))>0);
    
    if(sum(S1)>0 && sum(S2)>0)
        cart_mult = cartprod(find(S1), find(S2)); %Cartsian Multiplication
        temp = zeros(size(cart_mult,1), size(cnf,2));
        out = zeros(1, size(cart_mult,1));
        
        for i=1:size(cart_mult,1)
            temp(i, cart_mult(i,:))=1;
            %            out(i) = sum(ismember(dnf,temp(i,:),'rows'))>0;
            out(i) = any(ismember(dnf,temp(i,:),'rows'));
        end
        
        % We are looknig for a member of cart_mult which is not appered in
        % dnf
        %         if sum(out==0)>1
        %             jgjhg=9;
        %         end
        
        %Just to TEST
        %         ind = find(out==0, 1, 'first');
        ind = find(out==0);
        if(numel(ind)>0)
            %             CA = find(temp(ind, :));
            CA = temp(ind, :);
            return
        end
        if (sum(S)==0)
            CA = [];
            return
        end
    end
    
    %## Case 2
    for i=1:((2^sum(S))-1) % We are seeking for proper subset of A
        bin = dec2bin(i, sum(S));
        binNum = zeros(1, size(S, 2));
        xs = zeros(1,numel(bin));
        for jj=1:numel(bin)
            xs(jj)= str2double(bin(jj));
        end
        binNum(logical(S))= xs;
        
        chk = zeros(1, size(dnf, 1));
        for l=1:size(dnf,1)
            chk(l) = subsetCheck(dnf(l,:), binNum);
        end
        
        if (sum(chk)==0) % no monomial is subset of S
            CA = binNum;
            return
        end
    end
    
    %## Case 3
    
    S = (cnf(1,:) - cnf(2,:)) > 0;
    out = zeros(1, size(dnf,1));
    for i=1:size(dnf,1)
        out(i) = subsetCheck(dnf(i,:), S);
    end
    
    ind = find(out==1, 1, 'first');
    if(~isempty(ind))
        CA = S;
        return
    end
    
    %## Case 4
    
    S = (cnf(2,:) - cnf(1,:)) > 0;
    out = zeros(1, size(dnf,1));
    for i=1:size(dnf,1)
        out(i) = subsetCheck(dnf(i,:), S);
    end
    
    ind = find(out==1, 1, 'first');
    if(~isempty(ind))
        CA = S;
        return
    end
    
    CA = [];
    return
end
end