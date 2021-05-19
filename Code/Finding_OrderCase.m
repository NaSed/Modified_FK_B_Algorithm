function case_prob = Finding_OrderCase(CA_tab, recentHist, split_var)

% Based on history
% It considers 5 previous iterations
temp = CA_tab(CA_tab(:,2) == split_var, :);
if(recentHist)
    if(size(temp, 1)> 6)
        temp = temp(end - 5: end, :);
    else
        temp = [];
    end
end
if(~isempty(temp))
    freq = tabulate(temp(:,5));
else
    freq =[];
end
if(~isempty(freq))
    if size(freq,1) == 1
        case_prob = freq(1,1);
    end
    if (isnan(case_prob))
        if (freq(2,2) > freq(1,2)) % the number of zeros > the number of ones
            case_prob = 1; %setting true
        else
            case_prob = 0; %setting false
        end
    end
else
    case_prob = 0; %setting false
end


end