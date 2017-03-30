function run_position_speed(sid, frequency, sensors, sensor_data)
% Imports the sensor data. Resample the data with frequency and
% calculate the speed. Save all the datas into corresponding files. This
% function supposes the sensor ID and sensor name as follows:
%   %   sendor ID     sensor name         description
%	%   1           head_child          sensor in child's head
%	%   2           head_parent         sensor in parent's head
%	%   3           left-hand_child     sensor in child's left hand
%	%   4           right-hand_child    sensor in child's right hand
%	%   5           left-hand_parent    sensor in parent's left hand
%	%   6           right-hand_parent   sensor in parent's right hand
%   %   7           object              sensor on object
% If the sensor number or sensor name is differnet, you must update
% function get_sensor_name in the end of this file.
%
%INPUT:
%  SID              subject ID or list of subject ID
%  FREQUENCY        sample frequency. default is 60 Hz.
%
%OUTPUT:
%  None
%
%SIDE EFFECT:
%  Data of position, unwrapped angle, speed of position and speed of rotation will be
%  saved in the directory 'drived' of specified subject ID(s).
%
%EXAMPLE 1:
%   run_position_speed(1401);
% %   save position, angle and speed of subject 1401 using 60Hz to resample
% %   data.
%
%EXAMPLE 2:
%   subject_list = list_subjects(14);
%   run_position_speed( subject_list );
% %   save position, angle and speed of subjects of experiment 14 using 60Hz 
% %   to resample data.
%
%EXAMPLE 3:
%   run_position_speed(1401, 30);
% %   save position, angle and speed of subject 1401 using 30Hz to resample
% %   data.
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
            run_position_speed(sid(i), frequency);
        end
        return
    else
        if ~exist('sensor_data', 'var') || isempty(sensor_data)
            try
                [s_pos,s_or] = read_pos_sensor(sid, [ ], frequency);
            catch ME
                %incase sensor data does not exist, exception will be throwed
                disp(ME.message);
                return
            end
        else
            s_pos = sensor_data{1};
            s_or = sensor_data{2};
        end

%         disp([num2str(sid) ':' num2str(numel(s_pos))]);
%         save_path = 'ywz/'; %save into a temp directory for test only, so we can compare variables
        save_path = '';
        
        max_sensor_id = numel( s_pos );
        sensor_list = 1:max_sensor_id;
        valid_sensor_list = [];
        
        %select sensors with data
        for sensor_id = sensor_list
            if ~isempty(s_pos{sensor_id})
                valid_sensor_list = [valid_sensor_list sensor_id];
            end
        end
        sensor_list = valid_sensor_list;
        if exist('sensors', 'var') && ~isempty(sensors)
            sensor_list = sensors(ismember(sensors, sensor_list));
        end
        
        %to ensure both hands are there - not sure why this is needed (sbf)
%         if (~ismember(3, sensor_list)) || (~ismember(4, sensor_list))
%             sensor_list = setdiff(sensor_list, [3 4]);
%         end 
%         if (~ismember(5, sensor_list)) || (~ismember(6, sensor_list))
%             sensor_list = setdiff(sensor_list, [5 6]);
%         end 
        
        for sensor_id = sensor_list

            sensor_name = get_sensor_name( sensor_id ); %head_child, head_parent, ...
            if isempty(sensor_name)
                disp(['senor ' num2str(sensor_id) ' may be wrong']);
                continue;
            end
            
%             disp(sensor_name);
%             size(s_pos{sensor_id})
%             size(s_or{sensor_id})

            %record position speed variable
            variable_name = [save_path 'cont_motion_pos-speed_' sensor_name];
            record_variable(sid, variable_name, cont_speed( s_pos{sensor_id} ) );

            %record orientation speed variable
            variable_name = [save_path 'cont_motion_rot-speed_' sensor_name];
            record_variable(sid, variable_name, cont_speed( s_or{sensor_id} ) );

            %record position data
            pos_dim = { 'x', 'y', 'z' };
            for pos_id = 1 : numel( pos_dim )
               variable_name = [save_path 'cont_motion_' pos_dim{pos_id} '_' sensor_name ];
               record_variable(sid, variable_name, s_pos{sensor_id}(:, [1 pos_id+1]) );
            end

            %record x, y, z into one file
            variable_name = [save_path 'cont3_motion_pos_' sensor_name ];
            record_variable(sid, variable_name, s_pos{sensor_id}(:, [1 2 3 4]) );

            %record orientation data
            ori_dim = { 'h', 'p', 'r' };
            for ori_id = 1 : numel( ori_dim )
               variable_name = [save_path 'cont_motion_' ori_dim{ori_id} '_' sensor_name ];
               record_variable(sid, variable_name, s_or{sensor_id}(:, [1 ori_id+1]) );
            end

            %record h, p, r into one file
            variable_name = [save_path 'cont3_motion_rot_' sensor_name ];
            record_variable(sid, variable_name, s_or{sensor_id}(:, [1 2 3 4]) );
        end
    end
end

%%
function [ result ] = get_sensor_name( sensor_id )
    sensor_names = { 'head_child', 'head_parent', ...
                     'left-hand_child', 'right-hand_child', ...
                     'left-hand_parent', 'right-hand_parent', 'object' };
    if sensor_id <1 || sensor_id > numel(sensor_names)
        result =[];
    else
        result = sensor_names{ sensor_id };
    end
end
