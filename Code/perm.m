function result = perm(mat,sgn,dim)

% result = perm(mat,sgn,dim)
%
% Permutes the rows or columns of the matrix mat according to the
% permutation sgn, a row vector containing the numbers from 1 to n.
% Input dim is the dimension being permuted.
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


% Check for correct size, too.

if dim == 1    
    
    if size(mat,1) == length(sgn)
    else
        disp('Incorrect dimensions')
        return
    end

    result = mat(sgn,:);

elseif dim == 2

    if size(mat,2) == length(sgn)
    else
        disp('Incorrect dimensions')
        return
    end

    result = mat(:,sgn);

else
    disp('Invalid argument for dimension. dim should be 1 or 2')
    return
end


end