function event_out = get_cevent_opposite(sub_id, cevent_data, trial_times)

% This function get the durations that are not within the cevent ranges but
% still within trials, return as events. The input data can have
% overlapping events.

if ~exist('trial_times', 'var')
    trial_times = get_trial_times(sub_id);
end

cstream_data = cevent2cstream(cevent_data, trial_times(1,1), 0.01, 0, trial_times(end, 2));

tmp = cstream2cevent(cstream_data, 0.02, 1);
tmp = tmp(tmp(:,3) < 0.1, 1:2);

tmp = event_extract_ranges(tmp, trial_times);
event_out = vertcat(tmp{:});