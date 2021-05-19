% mu_function is needed for choosing splitting variable and is called by 'mu_frequent_in_A' function.
% For further information, please see the FK-B algorithm presented in "how to apply sat-solving for the equivalence test of mootone normal forms", page 5

function res = mu_function(n)    

res = log(n)/log(log(n));
return

end
