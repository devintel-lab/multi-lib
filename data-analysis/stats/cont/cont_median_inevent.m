function res = cont_median_inevent(cont_data, event_data)
% Return the median value of the cont data within given event.
%   res = cont_median_inevent(cont_data, event_data)
%
data_in_event = get_data_in_event(cont_data, event_data);
res = cont_median(data_in_event);