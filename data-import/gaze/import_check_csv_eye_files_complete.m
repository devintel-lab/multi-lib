function gaze_info = import_check_csv_eye_files_complete(sub_id, child_eye_data, parent_eye_data, child_frame_offset, is_record_var, enable_visualize_heatmap, enable_check_visualize_range)
% Here is a complete list of what this function does:
% 1. Imports the child_eye.csv and parent_eye.csv files
% 2. Check if the file exist, and if the file is empty
% 3. Check if the eye csv file is created within 10 month after the main 
%     subject folder is created in case the csv files are tempered with
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
if ~exist('child_frame_offset', 'var')
    child_frame_offset = 0;
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

NUM_CHECK_FRAMES = 10;
EYE_X_RESCALE_TARGET = 720;

rescale_sub_list = get_rescale_gaze_subject_list();
is_need_rescale = ismember(sub_id, rescale_sub_list);
EYE_X_MAX = list_gaze_data_x_range(sub_id);
EYE_Y_MAX = 480;

child_frame_offset_cumulative = child_frame_offset;
exist_child_gaze_data = true;
exist_parent_gaze_data = true;
sub_timing = get_timing(sub_id);

gaze_info.sub_id = sub_id;
% gaze_info.CHILD_GAZE_TIME_OFFSET = get_;
% gaze_info.PARENT_GAZE_TIME_OFFSET = PARENT_GAZE_TIME_OFFSET;
gaze_info.is_need_rescale = is_need_rescale;
gaze_info.eye_x_max = EYE_X_MAX;
gaze_info.eye_y_max = EYE_Y_MAX;

fprintf('------------------------- %d begin -------------------------\n', sub_id);
sub_dir = get_subject_dir(sub_id);   

% Imports the child_eye.csv and parent_eye.csv files
% [child_eye_data_csv, parent_eye_data_csv, time_sub_folder, time_eye_csv_list] = import_csv_eye_files(sub_id);
gaze_info.sub_folder_create_time = time_sub_folder;

%%%%%%%%%%%%%%%%%%%%%%%%%%% we do not use csv for gaze anymore %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% eye_extra_p_child_path = fullfile(sub_dir, 'extra_p', 'cont2_eye_xy_child_tmp.mat');
% if exist(eye_extra_p_child_path, 'file')
%     eye_extra_p_child = load(eye_extra_p_child_path);
%     child_eye_data = [eye_extra_p_child.timebase eye_extra_p_child.xydata];
%     is_child_gaze_csv = false;
%     fprintf('The child gaze data is from %s\n', eye_extra_p_child_path);
% elseif isempty(child_eye_data_csv)
%     fprintf('The child_eye csv file is empty for subject %d\n', sub_id);
%     exist_child_gaze_data = false;
%     is_child_gaze_csv = false;
% else
%     child_eye_data = child_eye_data_csv;
%     is_child_gaze_csv = true;
%     fprintf('The child gaze data is from csv file\n');
% end
% 
% eye_extra_p_parent_path = fullfile(sub_dir, 'extra_p', 'cont2_eye_xy_parent_tmp.mat');
% if exist(eye_extra_p_parent_path, 'file')
%     eye_extra_p_parent = load(eye_extra_p_parent_path);
%     parent_eye_data = [eye_extra_p_parent.timebase eye_extra_p_parent.xydata];
%     is_parent_gaze_csv = false;
%     fprintf('The parent gaze data is from %s\n', eye_extra_p_parent_path);
% elseif isempty(parent_eye_data_csv)
%     fprintf('The parent_eye csv file is empty for subject %d\n', sub_id);
%     exist_parent_gaze_data = false;
%     is_parent_gaze_csv = false;
% else
%     parent_eye_data = parent_eye_data_csv;
%     is_parent_gaze_csv = true;
%     fprintf('The parent gaze data is from csv file\n');
% end
% disp('--------------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%% we do not use csv for gaze anymore %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isempty(child_eye_data)
    exist_child_gaze_data = false;
end
if isempty(child_eye_data)
    exist_parent_gaze_data = false;
end

%% start for child gaze data
gaze_info.exist_child_gaze_data = exist_child_gaze_data;
if exist_child_gaze_data
    % Currently, the csv files timing starts at 0 seconds.  This will add
    % 30 seconds to the timing (column 1).
    if is_child_gaze_csv
        if child_frame_offset > 0
            child_eye_data(:,1) = child_eye_data(:,1) + sub_timing.camTime + (child_frame_offset/sub_timing.camRate);
            fprintf('Incorperate child_frame_offset %d.\n', child_frame_offset);
            disp('--------------------------------------------------')
        else
            child_eye_data(:,1) = child_eye_data(:,1) + sub_timing.camTime;
        end
    end
    if ~is_need_rescale
        child_filter_mask = child_eye_data(:,2) > EYE_X_MAX | child_eye_data(:,2) < 0 | ...
            child_eye_data(:,3) > EYE_Y_MAX | child_eye_data(:,3) < 0;
    else
        child_filter_mask = child_eye_data(:,2) > EYE_X_RESCALE_TARGET | child_eye_data(:,2) < 0 | ...
            child_eye_data(:,3) > EYE_Y_MAX | child_eye_data(:,3) < 0;
    end
    child_eye_data(child_filter_mask, 2:3) = NaN;
    fprintf('%.5f data got filtered\n', sum(child_filter_mask)/length(child_filter_mask));
    if enable_visualize_heatmap
        h1 = figure;
        plot(child_eye_data(:,2), child_eye_data(:,3), 'r.');
        set(h1, 'Position', [100, 700, 500, 300]);
        if ~is_need_rescale
            xlim([0 EYE_X_MAX]);
        else
            xlim([0 EYE_X_RESCALE_TARGET]);
        end
        ylim([0 EYE_Y_MAX]);
        title(sprintf('%d child gaze data heatmap', sub_id));
        child_range_xy = [nanmax(child_eye_data(:,2)) nanmax(child_eye_data(:,3))];
        fprintf('The max xy value of child gaze data is [%.5f, %.5f]\n', child_range_xy(1), child_range_xy(2));
        if enable_check_visualize_range
            child_last_frame_num = time2frame_num(child_eye_data(end, 1), sub_id);
            check_frames_list = randi(child_last_frame_num, 1, NUM_CHECK_FRAMES);
            check_finished_number = 0;
            continue_check_child = true;
            while continue_check_child
                for checkidx = 1:length(check_frames_list)
                    child_gaze_one = child_eye_data(check_frames_list(checkidx),:);
                    check_frame_num = time2frame_num(child_gaze_one(1), sub_id);
                    check_frame_file = fullfile(sub_dir, 'cam01_frames_p', sprintf('img_%d.jpg', check_frame_num));
                    if exist(check_frame_file, 'file')
                        check_img = imread(check_frame_file);
                        fimg1 = figure;
                        imshow(check_img);
                        set(fimg1, 'Position', [100, 10, 1000, 600]);
                        title(sprintf('%d child gaze data at time %.2f frame %d: [%.5f, %.5f]', ...
                            sub_id, child_gaze_one(1), check_frame_num, ...
                            child_gaze_one(2), child_gaze_one(3)), 'FontSize', 16);
                        fprintf('Enter any key to see next frame\n');
                        pause
                        close(fimg1);
                        check_finished_number = check_finished_number + 1;
                    end
                    if check_finished_number >= 5
                        break
                    end
                end
                fprintf('Current child_frame_offset is %d. ', child_frame_offset_cumulative);
                is_adjust_child_frame = input('Do you want to adjust child frame? (y/n)\n', 's');
                if ~isempty(is_adjust_child_frame) && lower(is_adjust_child_frame(1)) == 'y'
                    child_frame_offset = input('Enter child_frame_offset(-5 to 5): ');
                    child_eye_data(:,1) = child_eye_data(:,1) + (child_frame_offset/sub_timing.camRate);
                    child_frame_offset_cumulative = child_frame_offset_cumulative + child_frame_offset;
                    check_frames_list = randi(child_last_frame_num, 1, NUM_CHECK_FRAMES);
                    check_finished_number = 0;
                else
                    is_continue_check = input('Check 5 more frames? (y/n)\n', 's');
                    if ~isempty(is_continue_check) && lower(is_continue_check(1)) == 'y'
                        lower_bound = input(sprintf('Enter starting frame(>= 1 and <= %d): ', child_last_frame_num));
                        while (isempty(lower_bound) || lower_bound < 1 || lower_bound >= child_last_frame_num)
                            lower_bound = input(sprintf('Invalid frame number, please enter another one: (>= 1 and <= %d)\n', child_last_frame_num));
                        end
                        upper_bound = input(sprintf('Enter ending frame(>= 1 and <= %d): ', child_last_frame_num));
                        while (isempty(upper_bound) || upper_bound < 1 || upper_bound > child_last_frame_num || upper_bound <= lower_bound)
                            upper_bound = input(sprintf('Invalid frame number, please enter another one: (>= 1 and <= %d)\n', child_last_frame_num));
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
        disp('------------------------- child rescale -------------------------');
        fprintf('All x values in child gaze data of %d need to be rescaled from 640 to 720\n', sub_id);
        child_filter_mask = child_eye_data(:,2) > EYE_X_MAX;
        child_eye_data(child_filter_mask, 2:3) = NaN;
        fprintf('%d data points got filtered during rescale\n', sum(child_filter_mask));
        child_eye_data(:,2) = child_eye_data(:,2)/EYE_X_MAX * EYE_X_RESCALE_TARGET; % HARD CODING, mapping
        if enable_visualize_heatmap
            plot(child_eye_data(:,2), child_eye_data(:,3), 'r.');
            xlim([0 EYE_X_RESCALE_TARGET]);
            ylim([0 EYE_Y_MAX]);
            title(sprintf('%d child gaze data heatmap after rescale', sub_id));
        end
        disp('------------------------- done rescale -------------------------');
    end
    child_gaze_valid_mask = ~isnan(child_eye_data(:,2)) & ~isnan(child_eye_data(:,3));
    gaze_info.child_csv_modify_time = time_eye_csv_list(1);
    gaze_info.child_frame_offset_cumulative = child_frame_offset_cumulative;
    gaze_info.child_gaze_data = child_eye_data;
    gaze_info.child_gaze_range_x = [nanmin(child_eye_data(:,2)) nanmax(child_eye_data(:,2))];
    gaze_info.child_gaze_range_y = [nanmin(child_eye_data(:,3)) nanmax(child_eye_data(:,3))];
    gaze_info.child_gaze_valid_prop = sum(child_gaze_valid_mask)/length(child_gaze_valid_mask);
end
% end for child gaze data

%% start for parent gaze data
gaze_info.exist_parent_gaze_data = exist_parent_gaze_data;

if exist_parent_gaze_data
    if is_parent_gaze_csv
        parent_eye_data(:,1) = parent_eye_data(:,1) + sub_timing.camTime;
    end
    if ~is_need_rescale
        parent_filter_mask = parent_eye_data(:,2) > EYE_X_MAX | parent_eye_data(:,2) < 0 | ...
            parent_eye_data(:,3) > EYE_Y_MAX | parent_eye_data(:,3) < 0;
    else
        parent_filter_mask = parent_eye_data(:,2) > EYE_X_RESCALE_TARGET | parent_eye_data(:,2) < 0 | ...
            parent_eye_data(:,3) > EYE_Y_MAX | parent_eye_data(:,3) < 0;
    end
    parent_eye_data(parent_filter_mask, 2:3) = NaN;
    fprintf('%.5f data got filtered\n', sum(parent_filter_mask)/length(parent_filter_mask));
    if enable_visualize_heatmap
        h2 = figure;
        plot(parent_eye_data(:,2), parent_eye_data(:,3), 'b.');
        set(h2, 'Position', [650, 700, 500, 300]);
        if ~is_need_rescale
            xlim([0 EYE_X_MAX]);
        else
            xlim([0 EYE_X_RESCALE_TARGET]);
        end
        title(sprintf('%d parent gaze data heatmap', sub_id));
        parent_range_xy = [nanmax(parent_eye_data(:,2)) nanmax(parent_eye_data(:,3))];
        fprintf('The max xy value of parent gaze data is [%.5f, %.5f]\n', parent_range_xy(1), parent_range_xy(2));
        if enable_check_visualize_range
            parent_last_frame_num = time2frame_num(parent_eye_data(end, 1), sub_id);
            check_frames_list = randi(parent_last_frame_num, 1, NUM_CHECK_FRAMES);
            check_finished_number = 0;
            continue_check_parent = true;
            while continue_check_parent
                for checkidx = 1:length(check_frames_list)
                    parent_gaze_one = parent_eye_data(check_frames_list(checkidx),:);
                    check_frame_num = time2frame_num(parent_gaze_one(1), sub_id);
                    check_frame_file = fullfile(sub_dir, 'cam02_frames_p', sprintf('img_%d.jpg', check_frame_num));
                    if exist(check_frame_file, 'file')
                        check_img = imread(check_frame_file);
                        fimg1 = figure;
                        imshow(check_img);
                        set(fimg1, 'Position', [650, 10, 1000, 600]);
                        title(sprintf('%d parent gaze data time %.2f frame %d: [%.5f, %.5f]', ...
                            sub_id, parent_gaze_one(1), check_frame_num, ...
                            parent_gaze_one(2), parent_gaze_one(3)), 'FontSize', 16);
                        fprintf('Enter any key to see next frame\n');
                        pause
                        close(fimg1);
                        check_finished_number = check_finished_number + 1;
                    end
                    if check_finished_number >= 5
                        break
                    end
                end
                is_continue_check = input('Check 5 more frames? (y/n)\n', 's');
                if ~isempty(is_continue_check) && lower(is_continue_check(1)) == 'y'
                    lower_bound = input(sprintf('Enter starting frame(>= 1 and <= %d): ', parent_last_frame_num));
                    while (isempty(lower_bound) || lower_bound < 1 || lower_bound >= parent_last_frame_num)
                        lower_bound = input(sprintf('Invalid frame number, please enter another one: (>= 1 and <= %d)\n', parent_last_frame_num));
                    end
                    upper_bound = input(sprintf('Enter ending frame(>= 1 and <= %d): ', parent_last_frame_num));
                    while (isempty(upper_bound) || upper_bound < 1 || upper_bound > parent_last_frame_num || upper_bound <= lower_bound)
                        upper_bound = input(sprintf('Invalid frame number, please enter another one: (>= 1 and <= %d)\n', parent_last_frame_num));
                    end
                    check_frames_list = randi([lower_bound upper_bound], 1, NUM_CHECK_FRAMES);
                    check_finished_number = 0;
                else
                    break
                end
            end
        end
    end

    if is_need_rescale
        disp('------------------------- parent rescale -------------------------');
        fprintf('All x values in parent gaze data of %d need to be rescaled from 640 to 720\n', sub_id);
        parent_filter_mask = parent_eye_data(:,2) > EYE_X_MAX;
        parent_eye_data(parent_filter_mask, 2:3) = NaN;
        fprintf('%d data points got filtered during rescale\n', sum(parent_filter_mask));
        parent_eye_data(:,2) = parent_eye_data(:,2)/EYE_X_MAX * EYE_X_RESCALE_TARGET; % HARD CODING, mapping
        if enable_visualize_heatmap
            plot(parent_eye_data(:,2), parent_eye_data(:,3), 'b.');
            xlim([0 EYE_X_RESCALE_TARGET]);
            ylim([0 EYE_Y_MAX]);
            title(sprintf('%d parent gaze data heatmap after rescale', sub_id));
        end
        disp('------------------------- done rescale -------------------------');
    end
    parent_gaze_valid_mask = ~isnan(parent_eye_data(:,2)) & ~isnan(parent_eye_data(:,3));
    if ~exist_child_gaze_data
        gaze_info.parent_csv_modify_time = time_eye_csv_list(1);
    else
        gaze_info.parent_csv_modify_time = time_eye_csv_list(2);
    end
    gaze_info.parent_gaze_data = parent_eye_data;
    gaze_info.parent_gaze_range_x = [nanmin(parent_eye_data(:,2)) nanmax(parent_eye_data(:,2))];
    gaze_info.parent_gaze_range_y = [nanmin(parent_eye_data(:,3)) nanmax(parent_eye_data(:,3))];
    gaze_info.parent_gaze_valid_prop = sum(parent_gaze_valid_mask)/length(parent_gaze_valid_mask);
end
% end for parent gaze data

if enable_visualize_heatmap
    fprintf('Now enter any key to close all heatmaps\n');
    pause
    if exist_child_gaze_data
        close(h1);
    end
    if exist_parent_gaze_data
        close(h2);
    end
    disp('--------------------------------------------------')
end

%% start saving variables
if is_record_var
    gaze_info
    is_save_var = input('After all the checking, do you still want to generate the cont_eye_x/y variables? (y/n)\n', 's');
    if ~isempty(is_save_var) && lower(is_save_var(1)) == 'y'
        % Save the variables: cont2_eye_xy, cont2_eye_x, cont2_eye_y
        if exist_child_gaze_data
            % Save xy
            record_variable(sub_id, 'cont2_eye_xy_child', child_eye_data);

            % Save x
            cont_child_x = child_eye_data(:,1:2);
            record_variable(sub_id, 'cont_eye_x_child', cont_child_x);

            % Save y
            cont_child_y = [child_eye_data(:,1) child_eye_data(:,3)];
            record_variable(sub_id, 'cont_eye_y_child', cont_child_y);
        end

        if exist_parent_gaze_data
            % % Save xy
            record_variable(sub_id, 'cont2_eye_xy_parent', parent_eye_data);

            % Save x
            cont_parent_x = parent_eye_data(:,1:2);
            record_variable(sub_id, 'cont_eye_x_parent', cont_parent_x);

            % Save y
            cont_parent_y = [parent_eye_data(:,1) parent_eye_data(:,3)];
            record_variable(sub_id, 'cont_eye_y_parent', cont_parent_y);
        end
    else
        fprintf('Exit function without generating the cont_eye_x/y variables.');
    end
end

fprintf('\n------------------------- %d finished -------------------------\n\n', sub_id);

end

