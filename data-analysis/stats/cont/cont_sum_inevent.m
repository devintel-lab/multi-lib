function res = cont_sum_inevent(cont_data, event_data)
% Return the sum of the cont data within given event.
%   res = cont_sum_inevent(cont_data, event_data)
%
data_in_event = get_data_in_event(cont_data, event_data);
res = cont_sum(data_in_event);
