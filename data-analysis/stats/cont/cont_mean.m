function result = cont_mean(data)
%cont_mean   Return the mean value of the cont data.
%   res = cont_mean(cont_data)
%
result = mean(data(:,2:end),'omitnan');
return;