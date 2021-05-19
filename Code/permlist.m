function A = permlist(nvars)

% A = permlist(nvars)
%
% Generates all permutations of n-variable BFs
% looking at the truth table forms (so length 2^n instead of n)
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

% First, generate all permutations in S^n
list = perms(1:nvars);
A = [];

% Then permute the index vector 1:2^n corresponding to
% all these permutations to get resulting
% indices for each
for i = 1:size(list,1)
A = [A; findperm([1:2^nvars],list(i,:),nvars)];
end


end