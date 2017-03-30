function mosdata = load_motion_data(subid, sensors)
sensor_names = {
    'head_child' % 1 2 3
    'head_parent' % 4 5 6
    'left-hand_child' % 7 8 9
    'right-hand_child' % 10 11 12
    'left-hand_parent' % 13 14 15
    'right-hand_parent'}; % 16 17 18
mosdata_x =[];
mosdata_y = [];
mosdata_z = [];
validsensors = [];

for s = 1:numel(sensors)
    if has_variable(subid, ['cont3_motion_pos_' sensor_names{sensors(s)}])
        data = get_variable(subid, ['cont3_motion_pos_' sensor_names{sensors(s)}]);
        idx = find(data(:,1) >= 30, 1);
        data = data(idx:end,:);
        data = data(:,[4 3 2]);
        data(:,3) = 700-data(:,3);
%         data(:,1) = 100-data(:,1);
        data = downsample(data, 2);
        mosdata_x = cat(2, mosdata_x, data(:,1));
        mosdata_y = cat(2, mosdata_y, data(:,2));
        mosdata_z = cat(2, mosdata_z, data(:,3));
        validsensors = cat(2, validsensors, sensors(s));
    end
end
fulldata = nan(size(mosdata_x,1), numel(sensor_names));
mosdata.x = fulldata;
mosdata.y = fulldata;
mosdata.z = fulldata;

mosdata.x(:, validsensors) = mosdata_x;
mosdata.y(:, validsensors) = mosdata_y;
mosdata.z(:, validsensors) = mosdata_z;

linemat = nan(1, numel(sensor_names)*3);
mosdata.x_line = linemat;
mosdata.y_line = linemat;
mosdata.z_line = linemat;

if ismember(1, validsensors)
    mosdata.x_line([1 7 10]) = median(mosdata.x(:,1), 1);
    mosdata.y_line([1 7 10]) = median(mosdata.y(:,1), 1);
    mosdata.z_line([1 7 10]) = 100;
end

if ismember(2, validsensors)
    mosdata.x_line([4 13 16]) = median(mosdata.x(:,2), 1);
    mosdata.y_line([4 13 16]) = median(mosdata.y(:,2), 1);
    mosdata.z_line([4 13 16]) = 100;
end