function res = find_pos_to_neg_transitions(array)

counter = 0;
for i=1:(numel(array)-1)
    if array(i)  >  0 &&  array(i+1)< 0
        counter = counter + 1;
    end
end
res = counter;
end