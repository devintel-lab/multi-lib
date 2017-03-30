function prop = cont_below(var_data, threshold)
% cont_below  Return the proportion of time when data value < threshold     
%  USAGE:
%    prop = cont_below(var_data, threshold)
%
%    Example: 
%    prop = cont_below(cont_data, 80); 
%

prop = sum(var_data(:, 2:end) < threshold) / size(var_data, 1);
