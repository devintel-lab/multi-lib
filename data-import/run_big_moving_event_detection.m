function [ ] = run_big_moving_event_detection( sid, frequency, sensors, sensor_data )


    if nargin < 1 || isempty(sid)
       error('you must provide parameter sid as subject ID or list of subject ID'); 
    end
    
    if nargin < 2 || isempty(frequency)
        frequency = 60;
    end
    
    params_rot.thresh_lo = 24;%3
    params_rot.thresh_hi = 65; %8
    params_rot.fixation_creep = 16;%2
    params_rot.min_fixation = 0.5;
    params_rot.fixation_filter = 0.1; %sec
    params_rot.moving_filter = 0.1;      % sec

    factor = 25.4; %inches to mm
    params_pos.thresh_lo = 3*factor;
    params_pos.thresh_hi = 8*factor;
    params_pos.fixation_creep = 2*factor;
    params_pos.min_fixation = 0.5;
    params_pos.fixation_filter = 0.1; %sec
    params_pos.moving_filter = 0.1;      % sec
    
    if numel(sid) > 1
        %a list of subject ID
        for i = 1 : numel(sid)
            run_big_moving_event_detection(sid(i), frequency);
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
        sensor_list = sensor_list(ismember(sensors, sensor_list));
    end

    %to ensure both hands are there. not sure why this is here -sbf
%     if (~ismember(3, sensor_list)) || (~ismember(4, sensor_list))
%         sensor_list = setdiff(sensor_list, [3 4]);
%     end 
%     if (~ismember(5, sensor_list)) || (~ismember(6, sensor_list))
%         sensor_list = setdiff(sensor_list, [5 6]);
%     end
    %-------------------------------------------------------------------
    
    pos_movements = cell(numel( s_pos ), 1);
    rot_movements = cell( numel( s_rot ), 1);
    for sensor_index = 1 : numel(sensor_list)
        sensor_id = sensor_list(sensor_index);
        if sensor_id <= 2 
            %head sensor, use the default parameters
        else
            %hand sensor, we should find a suitable parameters
            params_rot.thresh_lo = 120.0;
            params_rot.thresh_hi = 180.0;
            params_rot.fixation_creep = 15;

            params_pos.thresh_lo = 9*factor;
            params_pos.thresh_hi = 12*factor;
            params_pos.fixation_creep = 2*factor;
            %break; %now we produce moving event for head only.
        end
        
%         pos_mvmt = detect_movement(s_pos{sensor_id}, params_pos);
%         pos_movements{sensor_id} = cevent2event(cevent_category_equals(pos_mvmt, [2 3]));
% 
%         rot_mvmt = detect_movement(s_rot{sensor_id}, params_rot);
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
        variable_name_suffix = regexprep(sensor_name, '_', '_big-moving_');
        
        %record position moving event
        variable_name = [save_path 'event_motion_pos_' variable_name_suffix];
        record_variable(sid, variable_name, pos_movements{sensor_id} );
        
        %record orientation moving event
        variable_name = [save_path 'event_motion_rot_' variable_name_suffix];
        record_variable(sid, variable_name, rot_movements{sensor_id} );
    end
    disp('Done with movement detection');
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


