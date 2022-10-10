function result = cont_median(data)
%cont_median   Return the median value of the cont data.
%   res = cont_median(cont_data)
%
result = median(data(:,2:end),'omitnan');
return;
