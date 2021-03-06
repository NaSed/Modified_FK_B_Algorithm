% phi_x_0 denotes the formula that consists of terms of phi from which x is removed.
% For further information, please see the FK-B algorithm presented in "how to apply sat-solving for the equivalence test of mootone normal forms", page 5

% Inputs:
% MBF: Monotone Boolean Function as a binary matrix
% var: the variable that is supposed to be removed.

% Output:
% res: The monotone boolean function after removing variable 'var'.

function res = phi_x_0(MBF, var)

[rows , ~]= find(MBF(:,var)==1);
rows = unique(rows);
MBF = MBF(rows,:); % Only those rows that contain var
MBF(:,var) = 0; % removing variable var from clauses that var was included
% If a clause is empty of any variable we remove that clause

rem = sum(MBF, 2)==0;
if (sum(rem)>0)
    MBF(rem, :) = [];
end

res = MBF;

end
