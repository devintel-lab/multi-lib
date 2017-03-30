function resampled_cont = cont_resample(cont, sampling_rate)
%cont_resample   resample cont variable to given sampling rate
%
% resampled_cont = cont_resample(cont, sampling_rate)
%
% We convert pos into a time series so that it's easy to resample it.
ts = cont2ts(cont);
timeProps = get(ts, 'TimeInfo');
new_basis = timeProps.Start:1/sampling_rate:timeProps.End;
ts = resample(ts, new_basis);
resampled_cont = ts2cont(ts);
end
