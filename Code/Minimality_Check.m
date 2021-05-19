% This script checks wheather 'vars' is minimal in the given monotone boolean function (MBF). Its output is the minimal version.

function minimal_vars = Minimality_Check( vars, MBF )

mat = MBF(:, vars); % keep only columns that are in x
remList = ones(1, numel(vars));
for i=size(mat,2):-1:1
    temp = mat;
    temp(:,i)=[];
    
    chk = sum(temp, 2) > 0;
    if sum(chk) == size(temp, 1)
        mat(:,i) = 0;
        remList(i) = 0;
    end
end
minimal_vars = vars(logical(remList));
return
end

