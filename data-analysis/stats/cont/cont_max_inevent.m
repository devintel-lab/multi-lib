function res = cont_max_inevent(cont_data, event_data)
% Return the maximum value of the cont data within given event.
%   res = cont_max_inevent(cont_data, event_data)
%
data_in_event = get_data_in_event(cont_data, event_data);
res = cont_max(data_in_event);