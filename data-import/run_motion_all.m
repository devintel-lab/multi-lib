function run_motion_all(IDs, frequency, sensors)
if numel(num2str(IDs(1))) > 2
    subs = IDs;
else
    subs = list_subjects(IDs);
end

if ~exist('frequency', 'var') || isempty(frequency)
    frequency = 60;
end

if ~exist('sensors', 'var') || isempty(sensors)
    sensors = [];
end

for s = 1:numel(subs)
    sid = subs(s);
    s_pos = [];s_or = [];
    [s_pos,s_or] = read_pos_sensor(sid, [ ], frequency);
    if ~isempty(s_pos)
        sensor_data = {s_pos, s_or};
        run_position_speed(sid, frequency, sensors, sensor_data);
        run_moving_event_detection(sid, frequency, sensors, sensor_data);
        run_big_moving_event_detection(sid, frequency, sensors, sensor_data);
    end
end

end