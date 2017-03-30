function main_create_eye_center_dist_vars(sub_id, agent_type,  img_w, img_h, eye_w, eye_h, is_record_vars)
% [eye_xy blob_centers min_dist mean_dist] = 

% MAIN_EXP29_DETECT_OBJECTS: Segment three objects (and skin) for
% camera 6 of experiment 29; Only image frames within trials will be
% processed.
% 
% Input: 
%   sub_list: The list of ubjects
%   img_step:  Only process 1 frame in every img_step; default value is 1 (process all the image frames.
%   overwrite_flag: If it is true, the output of this program will overwrite pre-existing segmentation result images.    
%                   Default value is true;
%
% Note: To do segmentation on subject 2901's images, the color parameter
% need to be changed in function detect_color_object.
%
%  Hongwei Shen, 03/25/2011
%  Re-write by: txu@indiana.edu
%  Update Apr. 3, 2013

if ~exist('is_record_vars', 'var')
    is_record_vars = 0;
end
% 
% if ~exist('img_w', 'var')
%     img_w = 360; % the number of columns = the width of the image by default
% end
% 
% if ~exist('img_h', 'var')
%     img_h = 240; % the number of rows = the height of the image by default
% end

% max_distance = sqrt(img_w^2 + img_h^2);
center_xy = [img_w/2 img_h/2];
max_dist = distance(center_xy', [0 0]');

error_log = {};
error_count = 0;
    
eye_var_name = ['cont2_eye_xy_' agent_type];
if has_variable(sub_id, eye_var_name)
    eye_xy = get_variable(sub_id, eye_var_name);

    trial_times = get_trial_times(sub_id);
    if eye_xy(end,1) < (trial_times(end, 2)-0.05)
        [trial_times(1, 1) trial_times(end, 2)]
        [eye_xy(1,1) eye_xy(end,1)]
        fprintf('Trial end time %d, eye dat end time %d', trial_times(end, 2), eye_xy(end,1));
        error('Subject %d variable %s missing within trial values!', sub_id, eye_var_name);
    end
    eye_xy = eye_xy(eye_xy(:,1) >= trial_times(1, 1) & eye_xy(:,1) <= trial_times(end, 2), :);

    time = eye_xy(:,1);
%         eye_xy = align_streams(time, {eye_xy});      %  align eye_data to the time stamps
%         eye_xy = [time eye_xy];
    eye_xy(:,2) = eye_xy(:,2)/eye_w * img_w; % HARD CODING, mapping
    eye_xy(:,3) = eye_xy(:,3)/eye_h * img_h; % HARD CODING, mapping
else
    warning('missing eye xy variable');
    return
end

N = length(time);
center_dist = NaN(N, 1);

for eidx = 1:N
%         this_eye_time = eye_xy(eidx, 1);
    this_eye_xy = eye_xy(eidx, 2:end);

    if this_eye_xy(1) > eye_w || this_eye_xy(2) > eye_h
        error('Subject %d eye data out of range!', sub_id);
    end

%     center_xy
%     this_eye_xy
    center_dist(eidx) = distance(center_xy', this_eye_xy');

    if center_dist(eidx) > max_dist
        error('Subject %d invalid distance value!', sub_id);
    end
end

% cont_eye_dist-to-center_child/parent
if is_record_vars
    record_variable(sub_id, ['cont_eye_dist-to-center_' agent_type], [time center_dist]);
end

end


