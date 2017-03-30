function res = cont_mean_inevent(cont_data, event_data, param)
% Return the mean value of the cont data within given event.
%   res = cont_mean_inevent(cont_data, event_data)
%
data_in_event = get_data_in_event(cont_data, event_data);
res = cont_mean(data_in_event);
