function p = event_proportion(event, scope)
% event_proportion: the proportion of event in a given time range
%   USAGE: p = event_proportion(event, scope)
%   Input:
%     event: (binary) event data;
%     scope: the range 
%   Output:
%     p: the proportion of time in the given range when the event is true.
%   Example:
%     data = get_variable(52, 'cont_cam1_obj1');
%     event = get_variable(52,'event_motion_sensor1_orient');
%     p = event_proportion(event, [data(1,1) data(length(data),1)]);
%
event_in_scope = get_event_in_scope(event, scope);
p = event_total_length(event_in_scope) / (scope(2)-scope(1));

