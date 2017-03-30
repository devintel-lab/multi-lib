function res = cont_min_inevent(cont_data, event_data)
% Return the minimum value of the cont data within given event.
%   res = cont_min_inevent(cont_data, event_data)
%
data_in_event = get_data_in_event(cont_data, event_data);
res = cont_min(data_in_event);