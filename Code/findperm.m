function fperm = findperm(f,sgn,nvars)

% fperm = findperm(f,sgn,nvars)
% 
% INPUTS
% nvars: number of variables
% f: function of length 2^nvars
% sgn: permutation in S^n
%
% Permutes the boolean function f (given in 0-1 form, with length 2^nvars)
% according to sgn, a permutation of nvars variables.
%
%
% Author: TJ Yusun, Simon Fraser University
% Copyright 2011
%
%  This file is part of InequivalentMBF.
%
%  InequivalentMBF is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
%
%  InequivalentMBF is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%
% 	You should have received a copy of the GNU General Public License
%	long with InequivalentMBF. If not, see <http://www.gnu.org/licenses/>.
%


% Check dimensions
if length(f) == 2^nvars && length(sgn) == nvars
else
    disp('One or more inputs are invalid.')
    return
end

mat = mat_2n(nvars);
mat_new = perm(mat, sgn, 1);

nperm = ones(1,2^nvars);

for k = 1:2^nvars
   col_temp = mat_new(:,k);
   
   mask = ones(1,2^nvars);
   
   for i = 1:nvars
      temp = or(and(col_temp(i),mat(i,:)),~or(col_temp(i),mat(i,:)));
      mask = and(mask,temp);
   end
    
    nperm(k) = find(mask,1);
    
end

fperm = perm(f,nperm,2);

end