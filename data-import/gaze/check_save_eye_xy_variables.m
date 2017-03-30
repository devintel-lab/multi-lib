function gaze_info = check_save_eye_xy_variables(sub_id, eye_data, agent_str, frame_offset, is_record_var, enable_visualize_heatmap, enable_check_visualize_range)
% Here is a complete list of what this function does:
% 4. Filter the gaze data accordingly 
% 5. Visualize the heatmap if 
%     enable_check_visualize == true
% 6. Select 5 random frames, see if the gaze data really match up with the
%     original eye image from child and parent if 
%     enable_check_visualize_range == true
% 7. Rescale the gaze data if the subject is in the list 
%     of function get_rescale_gaze_subject_list()
% 8. Report the actual gaze data range after everything, percentage of
%     valid gaze data
% 9. Ask the user whether they want to generate the gaze data based on the
%     information provided; if yes, then create
%     cont2_child_eye_xy and cont2_parent_eye_xy variables
%
%% Notes for filtering invalid eye datapoints.
% PosSci bounds: x=0-640 y=0-480
% LASA bounds: x=0-384 y=0-470

% Updated by txu@indiana.edu on Feb 6, 2013, add the step of rescaling
% old eye_xy data from [w=640 h=480] to [w=720, h=480]has been applied to 
% exp32, 34, 35 [3501-3512]
% mlelston@indiana.edu, subjects that generated after 3517, raw eye data 
% is already [w=720, h=480]

% Function modified by txu@indiana.edu on Jan 23, 2014
% clear all
% sub_id = 3204;
% enable_visualize_heatmap = true;
% enable_check_visualize_range = true;

%%
% sub_id = sid;
% agent_str = personid;

if ~exist('frame_offset', 'var')
    frame_offset = 0;
end
if ~exist('is_record_var', 'var')
    is_record_var = false;
end
if ~exist('enable_visualize_heatmap', 'var')
    enable_visualize_heatmap = false;
end
if ~exist('enable_check_visualize_range', 'var')
    enable_check_visualize_range = false;
end
if strcmp(agent_str, 'child')
    cam_str = 'cam01_frames_p';
elseif strcmp(agent_str, 'parent')
    cam_str = 'cam02_frames_p';
end

NUM_CHECK_FRAMES = 10;
EYE_X_RESCALE_TARGET = 720;

rescale_sub_list = get_rescale_gaze_subject_list();
is_need_rescale = ismember(sub_id, rescale_sub_list);
EYE_X_MAX = list_gaze_data_x_range(sub_id);
EYE_Y_MAX = 480;

frame_offset_cumulative = frame_offset;
% exist_gaze_data = true;
sub_timing = get_timing(sub_id);

gaze_info.sub_id = sub_id;
gaze_info.is_need_rescale = is_need_rescale;
gaze_info.eye_x_max = EYE_X_MAX;
gaze_info.eye_y_max = EYE_Y_MAX;

fprintf('------------------------- %d begin -------------------------\n', sub_id);
sub_dir = get_subject_dir(sub_id);   

% gaze_info.sub_folder_create_time = time_sub_folder;

%% start for gaze data
% gaze_info.exist_gaze_data = exist_gaze_data;
% if exist_gaze_data
    % Currently, the csv files timing starts at 0 seconds.  This will add
    % 30 seconds to the timing (column 1).
    if frame_offset > 0
        eye_data(:,1) = eye_data(:,1) + (frame_offset/sub_timing.camRate);
        fprintf('Incorperate frame_offset %d.\n', frame_offset);
        disp('--------------------------------------------------')
    else
        eye_data(:,1) = eye_data(:,1);
    end
    filter_mask = eye_data(:,2) > EYE_X_MAX | eye_data(:,2) < 0 | ...
        eye_data(:,3) > EYE_Y_MAX | eye_data(:,3) < 0;
    eye_data(filter_mask, 2:3) = NaN;
    fprintf('%.5f data got filtered\n', sum(filter_mask)/length(filter_mask));
    if enable_visualize_heatmap
        h1 = figure;
        plot(eye_data(:,2), eye_data(:,3), 'r.');
        set(h1, 'Position', [100, 700, 500, 300]);
        xlim([0 EYE_X_MAX]);
        ylim([0 EYE_Y_MAX]);
        title(sprintf('%d child gaze data heatmap', sub_id));
        range_xy = [nanmax(eye_data(:,2)) nanmax(eye_data(:,3))];
        fprintf('The max xy value of child gaze data is [%.5f, %.5f]\n', range_xy(1), range_xy(2));
        if enable_check_visualize_range
            last_frame_num = time2frame_num(eye_data(end, 1), sub_id);
            check_frames_list = randi(last_frame_num, 1, NUM_CHECK_FRAMES);
            check_finished_number = 0;
            continue_check_child = true;
            while continue_check_child
                for checkidx = 1:length(check_frames_list)
                    gaze_one = eye_data(check_frames_list(checkidx),:);
                    check_frame_num = time2frame_num(gaze_one(1), sub_id);
                    check_frame_file = fullfile(sub_dir, cam_str, sprintf('img_%d.jpg', check_frame_num));
                    if exist(check_frame_file, 'file')
                        check_img = imread(check_frame_file);
                        fimg1 = figure;
                        imshow(check_img);
                        set(fimg1, 'Position', [100, 10, 1000, 600]);
                        title(sprintf('%d child gaze data at time %.2f frame %d: [%.5f, %.5f]', ...
                            sub_id, gaze_one(1), check_frame_num, ...
                            gaze_one(2), gaze_one(3)), 'FontSize', 16);
                        fprintf('Enter any key to see next frame\n');
                        pause
                        close(fimg1);
                        check_finished_number = check_finished_number + 1;
                    end
                    if check_finished_number >= 5
                        break
                    end
                end
                fprintf('Current frame_offset is %d. ', frame_offset_cumulative);
                is_adjust_frame = input('Do you want to adjust child frame? (y/n)\n', 's');
                if ~isempty(is_adjust_frame) && lower(is_adjust_frame(1)) == 'y'
                    frame_offset = input('Enter frame_offset(-5 to 5): ');
                    eye_data(:,1) = eye_data(:,1) + (frame_offset/sub_timing.camRate);
                    frame_offset_cumulative = frame_offset_cumulative + frame_offset;
                    check_frames_list = randi(last_frame_num, 1, NUM_CHECK_FRAMES);
                    check_finished_number = 0;
                else
                    is_continue_check = input('Check 5 more frames? (y/n)\n', 's');
                    if ~isempty(is_continue_check) && lower(is_continue_check(1)) == 'y'
                        lower_bound = input(sprintf('Enter starting frame(>= 1 and <= %d): ', last_frame_num));
                        while (isempty(lower_bound) || lower_bound < 1 || lower_bound >= last_frame_num)
                            lower_bound = input(sprintf('Invalid frame number, please enter another one: (>= 1 and <= %d)\n', last_frame_num));
                        end
                        upper_bound = input(sprintf('Enter ending frame(>= 1 and <= %d): ', last_frame_num));
                        while (isempty(upper_bound) || upper_bound < 1 || upper_bound > last_frame_num || upper_bound <= lower_bound)
                            upper_bound = input(sprintf('Invalid frame number, please enter another one: (>= 1 and <= %d)\n', last_frame_num));
                        end
                        check_frames_list = randi([lower_bound upper_bound], 1, NUM_CHECK_FRAMES);
                        check_finished_number = 0;
                    else
                        break
                    end
                end
            end
        end
    end
    if is_need_rescale
        disp('------------------------- gaze rescale -------------------------');
        fprintf('All x values in gaze data of %d need to be rescaled from 640 to 720\n', sub_id);
        eye_data(:,2) = eye_data(:,2)/EYE_X_MAX * EYE_X_RESCALE_TARGET; % HARD CODING, mapping
        if enable_visualize_heatmap
            plot(eye_data(:,2), eye_data(:,3), 'r.');
            xlim([0 EYE_X_RESCALE_TARGET]);
            ylim([0 EYE_Y_MAX]);
            title(sprintf('%d child gaze data heatmap after rescale', sub_id));
        end
        disp('------------------------- done rescale -------------------------');
    end
    gaze_valid_mask = ~isnan(eye_data(:,2)) & ~isnan(eye_data(:,3));
    gaze_info.frame_offset_cumulative = frame_offset_cumulative;
    gaze_info.gaze_data = eye_data;
    gaze_info.gaze_range_x = [nanmin(eye_data(:,2)) nanmax(eye_data(:,2))];
    gaze_info.gaze_range_y = [nanmin(eye_data(:,3)) nanmax(eye_data(:,3))];
    gaze_info.gaze_valid_prop = sum(gaze_valid_mask)/length(gaze_valid_mask);
% end
% end for child gaze data

if enable_visualize_heatmap
    fprintf('Now enter any key to close all heatmaps\n');
    pause
    close(h1);
    disp('--------------------------------------------------')
end

%% start saving variables
if is_record_var
    gaze_info
    is_save_var = input('After all the checking, do you still want to generate the cont_eye_x/y variables? (y/n)\n', 's');
    if ~isempty(is_save_var) && lower(is_save_var(1)) == 'y'
        % Save the variables: cont2_eye_xy, cont2_eye_x, cont2_eye_y
        % Save xy
        record_variable(sub_id, ['cont2_eye_xy_' agent_str], eye_data);

        % Save x
        cont_x = eye_data(:,1:2);
        record_variable(sub_id, ['cont_eye_x_' agent_str], cont_x);

        % Save y
        cont_y = [eye_data(:,1) eye_data(:,3)];
        record_variable(sub_id, ['cont_eye_y_' agent_str], cont_y);
    else
        fprintf('Exit function without generating the cont_eye_x/y variables.');
    end
end

fprintf('\n------------------------- %d finished -------------------------\n\n', sub_id);

end

