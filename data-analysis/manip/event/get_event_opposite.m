function event_out = get_event_opposite(sub_id, event_data, trial_times)

% This function get the durations that are not within the event ranges but
% still within trials, return as events

if ~exist('trial_times', 'var')
    trial_times = get_trial_times(sub_id);
end

cevent_data = ones(size(event_data, 1), 3);
cevent_data(:, 1:2) = event_data;

event_out = get_cevent_opposite(sub_id, cevent_data, trial_times);