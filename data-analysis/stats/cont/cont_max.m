function result = cont_max(data)
%cont_max   Return the maximum value of the cont data.
%   res = cont_max(cont_data)
%
result = nanmax(data(:,2:end), [], 1);
return;
