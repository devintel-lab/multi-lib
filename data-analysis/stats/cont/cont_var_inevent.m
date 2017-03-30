function res = cont_var_inevent(cont_data, event_data)
% Return the variance of the cont data within given event.
%   res = cont_var_inevent(cont_data, event_data)
%
data_in_event = get_data_in_event(cont_data, event_data);
res = cont_var(data_in_event);
