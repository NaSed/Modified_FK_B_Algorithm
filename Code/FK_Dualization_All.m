function [cnf, cput, cnf_len]= FK_Dualization_All( dnf, n_clause, split_method, Hashing, Canonical, Shrinkage, Ordering, recentHist)

% tic
global depth splitting Hash_thresh weight var_depth All_weight %All_CA

cnf = Initialize_CNF('random', dnf, n_clause);
cnf = Irredundant(cnf);
cnf_len_est = 3000;  % An estimation of the number of clasues in cnf
cnf_len = zeros(1, cnf_len_est);
while_counter = 0;
iter = 0;
CA = [];

if strcmp(split_method, 'weightedVars')
    var_cnf_occurrence = [];
    var_dnf_occurrence = [];
    %     All_CA = [];
    weight = 100 * ones(size(dnf, 2), 1);
    All_weight = [];
end
if (Hashing)
    %++++++++++++++++++++++++++++++++++++++
    % 		Initializing the hash table
    %++++++++++++++++++++++++++++++++++++++
    Hash_thresh = 3;
    StartHashing(Hash_thresh)
else
    Hash_thresh = 0;
end

while(while_counter <= cnf_len_est)
    depth = 0;
    var_depth = zeros(20000, 2);
    if strcmp(split_method, 'weightedVars')
        var_cnf_occurrence = [var_cnf_occurrence; sum(cnf, 1)];
        var_dnf_occurrence = [var_dnf_occurrence; sum(dnf, 1)];
    end
    
    if mod(while_counter,100)==0
        disp(['The length of CNF is ', num2str(size(cnf, 1))]);
    end
    iter = iter + 1;
    cnf_len(iter) = size(cnf, 1);
    CA = FK_All(cnf, dnf, split_method, Hashing, Canonical, Shrinkage, Ordering, recentHist);
    %     ind = find(depth==0, 1);
    %     depth(ind) = -Inf;
    %     ind = find(splitting==0, 1);
    %     splitting(ind) = Inf;
    CA(CA < 0) = 0;
    CA(sum(CA, 2)==0,:) = [];
    
    ind = find(splitting(:, 1) == 0, 1);
    splitting(ind, :) = Inf;
    
    if strcmp(split_method , 'weightedVars')
        % Updating weight of variables
        ind = var_depth(:,1) == 0;
        var_depth(ind,:) = [];
        var_depth = sortrows(var_depth, 2, 'ascend');
        % If one var has been selected twice or more, we keep the one with
        % the shallowest depth
        [~, ind] = unique(var_depth(:,1), 'stable');
        var_depth = var_depth(ind, :);
        var_weight = var_depth;
        var_weight(:,2) = var_weight(:,2) / max(var_weight(:,2));
        weight(var_weight(:,1)) = weight(var_weight(:,1)) .* var_weight(:,2);
        weight = 100 * weight / max(weight);
        All_weight = [All_weight, weight];
    end
    %         All_CA = [All_CA; CA];
    if isempty(CA)
        display('Assign is NULL', '\n')
        break
    end
    
    CA = Irredundant(CA);
    new_clause = [];
    for k=1:size(CA,1)
        MFP = Maximum_False_Point(find(CA(k,:)), dnf);
        temp = zeros(1,size(dnf,2));
        temp(setdiff(1:size(dnf,2), MFP)) = 1;
        new_clause = [new_clause; temp];
    end
    new_clause = unique(new_clause, 'rows');
    cnf = [cnf; new_clause];
    while_counter = while_counter + 1;
end%end while
% cput = toc;
cput = 0;
return
end

