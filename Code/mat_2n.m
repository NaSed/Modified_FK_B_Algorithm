function mat = mat_2n(nvars)

% Outputs matrix with n rows, where the ith row contains 2^(n - i + 1) 
% blocks of length 2^(i - 1), alternating between all 1's and all 0's. 
% Each column corresponds to a truth assignment where a 1 in row i means 
% that variable x_i is set to 1.
%
% Essentially the (0,1) Rademacher matrix of order n
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

if nvars == 0
    mat = [];
elseif nvars == 1
    mat = [1 0];
else
    mat_temp = mat_2n(nvars - 1);
    
    mat = [mat_temp mat_temp];
    last_row = [ones(1,2^(nvars-1)) zeros(1,2^(nvars - 1))];
    mat = [mat; last_row];
end

end