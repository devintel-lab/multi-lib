function [ cell_pos_moving_event, cell_ori_moving_event] = run_moving_event_detection( sid, frequency, sensors, sensor_data )
% Imports the sensor data. Resample the data with frequency and
% calculate the speed. Based on the speed, this function detects the moving
% event and saves all the event datas into corresponding files. This
% function supposes the sensor ID and sensor name as follows:
%   %   sendor ID     sensor name         description
%	%   1           head_child          sensor in child's head
%	%   2           head_parent         sensor in parent's head
%	%   3           left-hand_child     sensor in child's left hand
%	%   4           right-hand_child    sensor in child's right hand
%	%   5           left-hand_parent    sensor in parent's left hand
%	%   6           right-hand_parent   sensor in parent's right hand
% If the sensor number or sensor name is differnet, you must update
% function get_sensor_name in the end of this file.
%
%INPUT:
%  SID              subject ID or list of subject ID
%  FREQUENCY        sample frequency. default is 60 Hz.
%
%OUTPUT:
%  CELL_POS_MOVING_EVENT    a cell of moving event based on position speed 
%                           for all sensors
%  CELL_ORI_MOVING_EVENT    a cell of moving event based on orientation
%                           speed for all sensors.
%
%SIDE EFFECT:
%  Data of position moving event and orientation moving event will be
%  saved in the directory 'drived' of specified subject ID(s).
%
%EXAMPLE 1:
%   run_moving_event_detection(1401);
% %   save position moving event and orientation moving event of subject
% %   1401.
%
%EXAMPLE 2:
%   subject_list = list_subjects(14);
%   run_moving_event_detection( subject_list );
% %   save position moving event and orientation moving event of subjects  
% %   of experiment 14.
%
%EXAMPLE 3:
%   run_moving_event_detection(1401, 50hz);
% %   save position moving event and orientation moving event of subject
% %   1401, the psotion data is resampled in 50HZ.
%
%

    if nargin < 1 || isempty(sid)
       error('you must provide parameter sid as subject ID or list of subject ID'); 
    end
    
    if nargin < 2 || isempty(frequency)
        frequency = 60;
    end
    
    if numel(sid) > 1
        %a list of subject ID
        for i = 1 : numel(sid)
            run_moving_event_detection(sid(i), frequency);
        end
        return
    end
    
    %read and resample the sensor data of all sensors.
    if ~exist('sensor_data', 'var') || isempty(sensor_data)
        try
            [s_pos, s_rot] = read_pos_sensor(sid, [ ], frequency);
        catch ME
            disp(ME);
            return;
        end
    else
        s_pos = sensor_data{1};
        s_rot = sensor_data{2};
    end
    
    max_sensor_id = numel( s_pos );
    sensor_list = 1:max_sensor_id;
    valid_sensor_list = [];

    %--select sensors with data and pair for hand-------------------------
    for sensor_id = sensor_list
        if ~isempty(s_pos{sensor_id})
            valid_sensor_list = [valid_sensor_list sensor_id];
        end
    end
    sensor_list = valid_sensor_list;
    
    if exist('sensors', 'var') && ~isempty(sensors)
        sensor_list = sensor_list(ismember(sensor_list, sensors));
    end
    
    %to ensure both hands are there - commented out not sure why this is
    %here - sbf
%     if (~ismember(3, sensor_list)) || (~ismember(4, sensor_list))
%         sensor_list = setdiff(sensor_list, [3 4]);
%     end 
%     if (~ismember(5, sensor_list)) || (~ismember(6, sensor_list))
%         sensor_list = setdiff(sensor_list, [5 6]);
%     end
    %-------------------------------------------------------------------
    
    %parameters for detect moving event of head
    params_rot.thresh_lo = 9;    % degree/sec
    params_rot.thresh_hi = 40;    % degree/sec
    params_rot.fixation_creep = 6;  %degree/sec
    params_rot.min_fixation = 0.5;       % sec - min. fixation after aggregation
    params_rot.fixation_filter = 0.1;    % sec - min. before aggregation
    params_rot.moving_filter = 0.1;      % sec
    
    factor = 25.4; %inches to mm
    params_pos.thresh_lo = 1*factor; % mm/sec
    params_pos.thresh_hi = 5*factor; % mm/sec
    params_pos.fixation_creep = 1*factor; % mm/sec
    params_pos.min_fixation = 0.5;
    params_pos.fixation_filter = 0.1;
    params_pos.moving_filter = 0.1;      % sec
    
    
    pos_movements = cell(numel( s_pos ), 1);
    rot_movements = cell( numel( s_rot ), 1);
    for sensor_index = 1 : numel(sensor_list) 
        sensor_id = sensor_list(sensor_index);
        if sensor_id <= 2 
            %head sensor, use the default parameters
        else
            %hand sensor, we should find a suitable parameters
            params_rot.thresh_lo = 50.0;
            params_rot.thresh_hi = 120.0;
            params_rot.fixation_creep = 15;
            
            params_pos.thresh_lo = 2*factor; % mm/sec
            params_pos.thresh_hi = 5*factor; % mm/sec
            params_pos.fixation_creep = 1*factor;
            %break; %now we produce moving event for head only.
        end
        
%         pos_mvmt = detect_movement(s_pos{sensor_id}, params_pos);
%         pos_movements{sensor_id} = cevent2event(cevent_category_equals(pos_mvmt, [2 3]));
% 
%         rot_mvmt = detect_movement(s_rot{sensor_id}, params_orient);
%         rot_movements{sensor_id} = cevent2event(cevent_category_equals(rot_mvmt, [2 3]));
        
        pos_movements{sensor_id} = detect_moving_event(s_pos{sensor_id}, params_pos);
        rot_movements{sensor_id} = detect_moving_event(s_rot{sensor_id}, params_rot);
    end
    
    %to save moving event to file
    save_path ='';% 'ywz/'; %save into a temp directory for test only, so we can compare variables
    for sensor_index = 1 : numel(sensor_list) 
        sensor_id = sensor_list(sensor_index);
        sensor_name = get_sensor_name( sensor_id ); %head_child, head_parent, ... 
        if isempty(sensor_name)
            disp(['senor ' num2str(sensor_id) ' may be wrong']);
            continue;
        end
        variable_name_suffix = regexprep(sensor_name, '_', '_moving_');
        
        %record position moving event
        variable_name = [save_path 'event_motion_pos_' variable_name_suffix];
        record_variable(sid, variable_name, pos_movements{sensor_id} );
        
        %record orientation moving event
        variable_name = [save_path 'event_motion_rot_' variable_name_suffix];
        record_variable(sid, variable_name, rot_movements{sensor_id} );
    end
    disp('Done with movement detection');
    cell_pos_moving_event = pos_movements;
    cell_ori_moving_event = rot_movements;
end


%%
function [ result ] = get_sensor_name( sensor_id )
    sensor_names = { 'head_child', 'head_parent', ...
                     'left-hand_child', 'right-hand_child', ...
                     'left-hand_parent', 'right-hand_parent' };
    if sensor_id <1 || sensor_id > numel(sensor_names)
        result =[];
    else
        result = sensor_names{ sensor_id };
    end
end

