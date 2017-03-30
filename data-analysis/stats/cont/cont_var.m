function result = cont_var(data)
%cont_var   Returns the variance of the cont data.
%   res = cont_var(cont_data)
%
result = nanvar(data(:,2:end), [], 1);
return;
