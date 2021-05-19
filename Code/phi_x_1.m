% phi_x_1 denotes the formula that consists of all terms of phi that do not contain x.

% For further information, please see the FK-B algorithm presented in "how to apply sat-solving for the equivalence test of mootone normal forms", page 5

% Inputs:
% MBF: Monotone Boolean Function as a binary matrix
% var: the variable that is supposed to be removed.

% Output:
% res: The monotone boolean function consists of all terms of MBF that do not contain 'var'.

function res = phi_x_1(MBF, var)

% [rows , ~]= find(MBF(:,var)==1);
% rows = unique(rows);
% MBF = MBF(setdiff(1:size(MBF,1), rows),:); % Only those rows that does not contain var

[rows , ~]= find(MBF(:,var)==0);
rows = unique(rows);
MBF = MBF(rows,:); % Only those rows that does not contain var

% If a clause is empty of any variable we remove that clause
rem = sum(MBF, 2)==0;
if (sum(rem)>0)
    MBF(rem, :) = [];
end

res = MBF;

end
