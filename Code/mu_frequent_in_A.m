% This function checks whether split variable satisfy the below condition:
% |{m \in A: x \in m}|/|A| <= 1/mu(|A| . |B|)
% which we say that x is at most frequent in A
% For further information, please see the FK-B algorithm presented in "how to apply sat-solving for the equivalence test of mootone normal forms", page 5

% Inputs:
% split_var: the variable chosen as splitting variable
% A: A monotone boolean function as a binary matrix
% B: A monotone boolean function as a binary matrix
% The number of columns in A and B must be the same.

% Output: True or False

function res = mu_frequent_in_A( split_var, A, B )

ss = sum(A, 1);
len = size(A, 1);
left_side = ss(split_var) / len;
right_side = 1/mu_function(len * size(B,1));

res = left_side <= right_side;
return

end

