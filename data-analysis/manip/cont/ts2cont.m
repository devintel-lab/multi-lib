function cont = ts2cont(ts)
%ts2cont   Convert timeseries to cont variable
%
% cont = ts2cont(ts)
%
cont = horzcat(get(ts, 'Time'), get(ts, 'Data'));
end
