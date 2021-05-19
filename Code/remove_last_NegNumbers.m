function res = remove_last_NegNumbers(array)

ind = find(array > 0, 1, 'last');
res = array(1: ind);

end