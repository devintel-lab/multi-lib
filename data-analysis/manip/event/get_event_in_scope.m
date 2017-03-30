function event_in_scope = get_event_in_scope(event, scope)
%event_in_scope: Return part of the events that is in the scope
%   USAGE: event_in_scope = get_event_in_scope(event, scope)
%   Input:
%     event: (binary) event data;
%     scope: the range 
%   Output:
%     event_in_scope:   part of the events that is in the scope
%   Example:
%     data = get_variable(52, 'cont_cam1_obj1');
%     event = get_variable(52,'event_motion_sensor1_orient');
%     event_in_scope = get_event_in_scope(event, [data(1,1) data(length(data),1)]);
%

if isempty(event)
    event_in_scope = [];
    return
end

start_too_late = event(:, 1) > scope(2);
end_too_soon = event(:, 2) < scope(1);
omit = start_too_late | end_too_soon;

shaggy = event(~ omit, :);

% now we trim it..
event_in_scope = [ max(shaggy(:, 1), scope(1)) , min(shaggy(:, 2), scope(2)) ];
if size(shaggy, 2) > 2
    event_in_scope = [ event_in_scope, shaggy(:, 3:end) ];
end
