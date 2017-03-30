function prop = cont_above(var_data, threshold)
% cont_above  Return the proportion of time when data value > threshold     
%  USAGE:
%    prop = cont_above(var_data, threshold)
%
%    Example: 
%    prop = cont_above(cont_data, 80); 
%

prop = sum(var_data(:, 2:end) > threshold) / size(var_data, 1);

