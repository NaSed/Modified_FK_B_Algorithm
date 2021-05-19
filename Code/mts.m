function result = mts(f, nvars)

% result = mts(f, nvars)
%
% Given a MBF f in truth table form, this function outputs its minimal true statements.
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

comp = mat_2n(nvars);
result = zeros(nvars,0);

if f == 1
    result = zeros(nvars,1);
    return
end

while find(f) ~= 0
    
    x = ones(1, 2^nvars);
    
    curr_bit = find(f, 1, 'last');
    col = comp(:,curr_bit);
    result = [result col];
    
    ind = find(col);
    card = size(ind);
    
    for k = 1:card
        x = bitand(x,comp(ind(k),:));
    end
    
    f = max(f - x,0);
    
end