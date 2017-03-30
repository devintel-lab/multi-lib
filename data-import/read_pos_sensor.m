function [s_pos,s_orient] = read_pos_sensor(sid, sensor_id_list, new_freq)
% read_pos_sensor   Reads position sensor data, then puts it in timeseries 
%                   form for easy manip.  also resamples to 60 Hz or 
%                   new_freq Hz if specified. The function will try to read
%                   data from 'position_sensor_r/chopped.txt'. It this file
%                   does not exist, it will try the original data file
%                   'all-*.txt'.
% 
% [s_pos s_orient] = read_pos_sensor(sid, sensor_id_list,new_freq)
% INPUT
%     sid:              subject id.
%     sensor_id_list:   list of sensor ID. Default is all sensor, and empty [] means all sensors also.
%     new_freq:         resampling frequency of data. Default is 60 Hz, and empty [] means 60 Hz also.
%     adjust_para:      this parameter is used for unwrap orientation data
%                       for moving event detection only.
%
% OUTPUT
%     s_pos:            cell array; s_pos{i}: postions of sensor i. if i is
%                       not a member of sensor_id_list, s_pos{i} will be empty.
%     s_orient:         cell array; s_orient{i}: orientation of sensor i. if i is
%                       not a member of sensor_id_list, s_orient{i} will be empty.
%
%
%EXAMPLE 1
%   [s_pos s_ori] = read_pos_sensor(1701);
%       read all sensors' data and resample them in 60HZ
%
%EXAMPLE 2
%   [s_pos s_ori] = read_pos_sensor(1701, [1 3 5]);
%       read data of sensor 1, 3, and 5, and resample them in 60HZ
%
%%EXAMPLE 3
%   [s_pos s_ori] = read_pos_sensor(1701, [ ], 30);
%       read data of all sensors, and resample them in 30HZ
%
%

    if nargin < 1 || isempty(sid)
        help read_pos_sensor;
        error('You must provide the subject ID. Read help please!')
    end

    if nargin < 2 
        sensor_id_list = [];
    end

    if nargin < 3 || isempty( new_freq )     %change 2 to 3 by yiwen, because new_freq is the third parameter 
        new_freq = 60;
    end
    s_pos = []; s_orient = [];

    pos_file = fullfile(get_subject_dir(sid), 'position_sensor_r/chopped.txt');
    if exist(pos_file, 'file')
        very_raw_pos = load(pos_file);
    else
        wildcard = fullfile(get_subject_dir(sid),'position_sensor_r','all*.txt');
        dir_entry = dir(wildcard);
        if ~isempty(dir_entry)
        pos_file = fullfile(get_subject_dir(sid),'position_sensor_r',dir_entry.name);
        very_raw_pos = dlmread(pos_file, '', 2, 0);
        disp('Skipping first two lines of position sensor file');
        else
            fprintf('Sensor .txt file does not exist for subject %d\n', sid);
            return
        end
    end

    timing_info = get_timing(sid);
    % offset = desired start time - actual start time
    % so timestamp + offset = timestamp - start time + desired start time.
    offset = timing_info.motionTime - very_raw_pos(1, 9);

    %to check the sensor_id_list
    all_sensor_id_list = unique( very_raw_pos(:,1) )';
    if isempty(sensor_id_list)
        sensor_id_list = all_sensor_id_list;
    end
    not_existed_sensor = setdiff(sensor_id_list, all_sensor_id_list);
    if ~isempty( not_existed_sensor )
        disp('The following sensor can not be found in data file!');
        disp( not_existed_sensor );
    end

    sensor_num = max(sensor_id_list);

    pos_out    = cell(sensor_num,1); 
    orient_out = cell(sensor_num,1); 
    for sensor = sensor_id_list

        raw_pos = very_raw_pos(very_raw_pos(:, 1) == sensor, :);
        raw_orient = raw_pos(:, 5:7);
%         check_orientation_data(raw_orient);
%         if nargin < 4 || isempty( adjust_para )
            unwrapped_orient = unwrap(raw_orient * (pi / 180)) * (180 / pi); 
%         else
%             %This is for run_moving_event_detection. I don't know why it use a
%             %different parameter. Now, I think I have fixed this problem.
%             unwrapped_orient = unwrap(raw_orient * (pi / 180)) * adjust_para;
%         end

        pos = timeseries(raw_pos(:, 2:4), raw_pos(:, 9) + offset, 'Name', 'position');
        orient = timeseries(unwrapped_orient, raw_pos(:, 9) + offset, 'Name', 'orient');

        timeProps = get(pos, 'TimeInfo');
        new_basis = timeProps.Start:1/new_freq:timeProps.End;

    %    disp 'running linear interp'
        pos_lin = resample(pos, new_basis);
        orient_lin = resample(orient, new_basis);


    %     pchip_interp = @(new_Time,Time,Data)...
    %                interp1(Time,Data,new_Time,...
    %                        'pchip');
    %     pos = setinterpmethod(pos, pchip_interp);
    %     orient = setinterpmethod(orient, pchip_interp);
    %     
    %     disp 'running pchip interp'
    %     pos_pchip = resample(pos, new_basis);
    %     orient_pchip = resample(orient, new_basis);
    %     disp 'done'
    %     hold off
    %     plot(pos, ':')
    %     hold on
    %     plot(pos_lin, '--')
    %     plot(pos_pchip, '-.')


        pos_out{sensor} = pos_lin;
        orient_out{sensor} = orient_lin;    
    end

    s_pos = cell(sensor_num,1);
    s_orient = cell(sensor_num, 1);
    for id = sensor_id_list
        s_pos{id}    = ts2cont(pos_out{id});
        s_pos{id} = filter_convert(s_pos{id}, new_freq);
        s_orient{id} = ts2cont(orient_out{id});
    end
end
  

function check_orientation_data(orient) 
    for i = 1 : size(orient,1)-1
        isDisp = 0;
        for j = 1 : size(orient,2)
            if orient(i+1,j)-orient(i,j) > 180 || orient(i+1,j)-orient(i,j)<-180
                isDisp = 1;
            end
        end
        if isDisp
            disp(orient(i:i+1,:));
        end
    end
end

function result = filter_convert(data, freq)
SF = freq; % sampling frequency
NF = SF/2; % Nyquist frequency
CF = 12; % Cut-off frequency
% initalize normalized cut-off frequency Wn with a value between 0 and 1
Wn = CF/NF; % == 9Hz/30Hz = 0.3
% run butter
[b,a] = butter(2, Wn, 'low'); % 2nd order, low-pass filter

for ind = 2:4
    data(:,ind) = filtfilt(b,a,data(:,ind)); % b == numerator coefficients of filter, a == denominator coefficients, x == input data
end
data(:, 2:end) = data(:,2:end)*25.4;
result = data;
end

% % The following two functions have been added to development lib
% seperately
%
% function ts = cont2ts(cont)
% ts = timeseries(cont(:, 2:end), cont(:, 1));
% end
% 
% function cont = ts2cont(ts)
% cont = horzcat(get(ts, 'Time'), get(ts, 'Data'));
% end

