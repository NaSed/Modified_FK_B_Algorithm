function result = mts_to_mbf(M, nvars)

% result = mts_to_mbf(M, nvars)
%
% Given a matrix of minimal true statements, outputs the MBF f with these minterms.
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


comp = mat_2n(nvars);
result = zeros(1, 2^nvars);

if M == 0
    result = ones(1, 2^nvars);
    return
end

total = size(M,2);


for i = 1:total
   
    curr_col = M(:,i);
    ind = find(curr_col);
    card = size(ind);
    
    temp = ones(1, 2^nvars);
    
    for k = 1:card
        temp = bitand(temp,comp(ind(k),:));
    end
    
    result = bitor(result,temp);
    
end
