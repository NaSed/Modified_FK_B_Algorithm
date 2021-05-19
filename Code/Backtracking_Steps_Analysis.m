% it takes a splitting array and extract thelength of backtracking and
% number of wrong paths causing backtracks
function [len, count, seenNodes] = Backtracking_Steps_Analysis(depths)

ind = find(depths(:, 1) == 0, 1);
depths(ind: end, :) = [];
res = {}; % Creating a cell
counter = 1;
for i = numel(depths):-1:1
    if(depths(i, 1) == Inf)
        counter = counter + 1;
        res{counter} = [];
    else
        %         if(depths(i-1, 1) == Inf)
        %             counter = counter + 1;
        %         end
        %         if(depths(i, 1) > 0)
        if  (counter <= numel(res))
            res{counter} = [res{counter}, depths(i, 1)];
        else
            res{counter} = depths(i, 1);
        end
        %         end
    end
end
res = res(:,end:-1:1);
res(cellfun(@numel,res)==0) = {0};
res = cellfun(@fliplr,res, 'UniformOutput',false);

count = 0;
len = 0;
seenNodes = 0;
for i =1: numel(res)
    if  res{i} ~= 0
        temp1 = remove_last_NegNumbers(res{i});
        count = count + find_pos_to_neg_transitions(temp1);
        len = len +  numel(find(temp1 < 0));
        seenNodes = seenNodes + numel(find(temp1 > 0));
    end
end
end
