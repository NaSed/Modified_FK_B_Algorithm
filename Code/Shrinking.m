function [rescnf, resdnf] = Shrinking(cnf, dnf)
% cpy_cnf = cnf;
% cpy_dnf = dnf;
%**************************************
%Removing sigletons
%**************************************

% single var is in cnf
var = singleton_allonecolumn(cnf, dnf);

if ~isempty(var)
        cnf(:,var) = 0;
        dnf(:,var) = 0;
end


% single var is in dnf
var = singleton_allonecolumn(dnf, cnf);

if ~isempty(var)
        cnf(:,var) = 0;
        dnf(:,var) = 0;
end

cnf(sum(cnf,2)==0,:) = [];
dnf(sum(dnf,2)==0,:) = [];

rescnf = cnf;
resdnf = dnf;
%***********************************
%Removing identical columns
%***********************************
% nonzero_cols = find(sum(dnf ,1));
% num_cols = numel(nonzero_cols);
% dnf_trans = dnf';
% res = zeros(num_cols, num_cols);
% for i=1:numel(nonzero_cols)
%     for j = i+1:numel(nonzero_cols)
%         if (sum(xor(dnf(:,nonzero_cols(i)), dnf_trans(nonzero_cols(j),:)')) == 0)
%             res(i,j) = 1;
%             res(j,i) = 1;
%         end
%     end
% end
%
% bins = conncomp(graph(res));
% freq = tabulate(bins);
% bigbins = freq(freq(:,2)>1,1); % components that have more than one node
% if numel(bigbins)>0
%     dsfs = 9;
% end
% % temp = bins.*ismember(bins,bigbins);
% % cmps = setdiff(temp, [0]);
% resdnf = dnf;
% rescnf = cnf;
% for i=1:numel(bigbins)
%     ind = bins == bigbins(i);
%     cols = nonzero_cols(ind);
%     resdnf(:, cols(2:end)) = 0;
%     tmp = 1*sum(rescnf(:,cols),2) > 0;
%     rescnf(:, cols(2:end)) = 0;
%     rescnf(:,cols(1)) = tmp;
% end
% n1 = size(rescnf,1);
% rescnf = unique(rescnf, 'rows');
% n2 = size(rescnf,1);
% if (n1~=n2)
%     rescnf = Irredundant(rescnf);
% end
%
% n1 = size(resdnf,1);
% resdnf = unique(resdnf, 'rows');
% n2 = size(resdnf,1);
% if (n1~=n2)
%     resdnf = Irredundant(resdnf);
% end
% a = FK_M(cpy_cnf, cpy_dnf, 'mostFreq') ;
% c = DNF_value(cpy_dnf, a);
% d = CNF_value(cpy_cnf, a);
% 
% if sum(xor(c,d)) ~= numel(c)
%     hgjh = 9;
% end
% 
% if isempty(rescnf) || isempty(rescnf)
%     fferw = 0;
% end
% b = FK_M(rescnf, resdnf, 'mostFreq');
% e = DNF_value(dnf, b);
% f = CNF_value(cnf, b);
% if sum(xor(e,f)) ~= numel(e)
%     hgjh = 9;
% end
% if (a ~= b)
%     fdsdf = 0;
% end
% rescnf = cpy_cnf;
% resdnf = cpy_dnf;
end