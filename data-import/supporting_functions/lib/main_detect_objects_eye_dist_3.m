function [time, blob_size_all, blob_center_all, blob_dyn_all, eye_mean_dist, eye_min_dist, center_mean_dist, center_min_dist] = main_detect_objects_eye_dist_3(sub_id, jpg_folder, output_folder, agent_type, obj_num, obj_params, is_record_eye_vars, seg_image_overwrite_flag, seg_image_format, img_step)
%  Re-write by: txu@indiana.edu update date: Oct. 15, 2013

if obj_num > 3
    error('This script is for processing experiments with 3 objects only');
end

if ~exist('img_step', 'var')
    img_step = 1;
end

if ~exist('seg_image_overwrite_flag', 'var')
    seg_image_overwrite_flag = false;
end

if ~exist('seg_image_format', 'var')
    seg_image_format = 'png';
end

ratio = 0.5;    % resize the images before object detection to increase processing speed.

if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

if ismember(sub_id, list_subjects(14))
    max_distance_half = 1;
else
    max_distance_half = 0;
end
jpg_list = dir(fullfile(jpg_folder, '*img_*.jpg'));  % hard coding

img_seq_pos = -1;
jpg_list = sort_file_name_by_seq(jpg_list, img_seq_pos);  
[jpg_list, seq_no] = extract_img_name_list(jpg_list, img_step, img_seq_pos);
time = frame_num2time(seq_no, sub_id);

N = length(jpg_list);

blob_size_all = nan(N,(obj_num+1));
blob_center_all = nan(N,(obj_num+1)*2);
blob_dyn_all = nan(N,(obj_num+1));

if is_record_eye_vars
    eye_var_name = ['cont2_eye_xy_' agent_type];
    if ~has_variable(sub_id, eye_var_name)
        fprintf('Subject %d does not have variable cont2_eye_xy_%s\n', sub_id, agent_type)
        is_record_eye_vars = false;
    else
        eye_xy = get_variable(sub_id, eye_var_name);
        eye_xy = eye_xy(eye_xy(:,1) >= time(1) & eye_xy(:,1) <= time(end), :);
        eye_xy = align_streams(time, {eye_xy});      %  align eye_data to the time stamps
        eye_xy = [time eye_xy];
    end
end

eye_mean_dist = NaN(N, obj_num+2);
eye_min_dist  = NaN(N, obj_num+2);
center_mean_dist = NaN(N, obj_num+2);
center_min_dist  = NaN(N, obj_num+2);

fprintf('frame       ');

for j=1:N
    fprintf('\b\b\b\b\b\b%5d:', seq_no(j));

    jpg = jpg_list(j).name;       
    img = imread(fullfile(jpg_folder, jpg));
    img = imresize(img, ratio);

    [img_h, img_w] = size(img(:,:,1));
    total_pix = img_h*img_w;

    [blob_size, blob_center, blob_cells] = ...
        detect_color_object(img, agent_type, obj_num, obj_params);
    
    if is_record_eye_vars
        this_eye_xy = eye_xy(j, 2:end);
        [eye_mean_one, eye_min_one, center_mean_one, center_min_one] = cal_eye2obj_dist(this_eye_xy, obj_num, ratio, blob_cells, max_distance_half);
        eye_mean_dist(j, :) = eye_mean_one;
        eye_min_dist(j, :) = eye_min_one;
        center_mean_dist(j, :) = center_mean_one;
        center_min_dist(j, :) = center_min_one;
    else
        [~, ~, center_mean_one, center_min_one] = cal_eye2obj_dist([], obj_num, ratio, blob_cells, max_distance_half);
        center_mean_dist(j, :) = center_mean_one;
        center_min_dist(j, :) = center_min_one;
    end

    % combine four binary images into one.
    seg_img = combine_obj_detection_results(blob_cells(1:4), img_h, img_w);
    if j == 1
        blob_dyn = nan(1,obj_num+1);
    else
        blob_dyn = cal_dyn_obj_size(obj_num, total_pix, prev_blob_cells, blob_cells);
    end
    prev_blob_cells = blob_cells;

    blob_size_all(j,:) = blob_size;
    blob_center_all(j,:) = blob_center;
    blob_dyn_all(j,:) = blob_dyn;
        
    if seg_image_overwrite_flag
        output_file_name = fullfile(output_folder, sprintf('img_%g_seg.%s', seq_no(j), seg_image_format));
        imwrite(seg_img, output_file_name);
    end    
end
if max_distance_half
    center_mean_dist(isnan(center_mean_dist)) = 1;
    center_min_dist(isnan(center_min_dist)) = 1;
end

