function filtered_cont = cont_butterworth_lowpass(cont, cutoff_freq, sampling_rate, filter_order)
%cont_butterworth_lowpass  Zero-phrase buttherworth low-pass filter  
% 
% filtered_cont = cont_butterworth_lowpass(cont, cutoff_freq,sampling_rate, filter_order)
% 
if ~exist('filter_order', 'var')
    filter_order = 6;
end

[b,a] = butter(filter_order,  cutoff_freq/(sampling_rate/2), 'low');
filtered_cont = cont;
filtered_cont(:,2:end) = filtfilt(b,a, cont(:,2:end));
end
