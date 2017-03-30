function result = cont_median(data)
%cont_median   Return the median value of the cont data.
%   res = cont_median(cont_data)
%
result = nanmedian(data(:,2:end));
return;
