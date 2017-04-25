function [time, blob_size_all, blob_center_all, blob_dyn_all, center_mean_dist_all, center_min_dist_all] = main_detect_objects_5(sub_id, jpg_folder, output_folder, agent_type, obj_num, obj_params, seg_image_overwrite_flag, seg_image_format, img_step)
%  Re-write by: txu@indiana.edu update date: Sep. 22, 2014

if obj_num ~= 5
    error('This script is for processing experiments with 5 objects only');
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

jpg_list = dir(fullfile(jpg_folder, 'img_*.jpg'));  % hard coding

img_seq_pos = -1;
jpg_list = sort_file_name_by_seq(jpg_list, img_seq_pos);  
[jpg_list, seq_no] = extract_img_name_list(jpg_list, img_step, img_seq_pos);
time = frame_num2time(seq_no, sub_id);

N = length(jpg_list);

blob_size_all = nan(N,(obj_num+1));
blob_center_all = nan(N,(obj_num+1)*2);
blob_dyn_all = nan(N,(obj_num+1));
center_mean_dist_all = NaN(N, obj_num+2);
center_min_dist_all = NaN(N, obj_num+2);

fprintf('frame       ');

for j=1:8300        
    fprintf('\b\b\b\b\b\b%5d:', seq_no(j));
    jpg = jpg_list(j).name;       
    img = imread(fullfile(jpg_folder, jpg));
    img = imresize(img, ratio);

    [img_h, img_w] = size(img(:,:,1));
    total_pix = img_h*img_w;

    [blob_size, blob_center, blob_cells] = ...
        detect_color_object_5(img, agent_type, obj_num, obj_params);
    [center_mean_dist, center_min_dist] = cal_center2obj_dist(obj_num, blob_cells);

    % combine four binary images into one.
    seg_img = combine_obj_detection_results(blob_cells, img_h, img_w);
    if j == 1
        blob_dyn = nan(1,obj_num+1);
    else
        blob_dyn = cal_dyn_obj_size(obj_num, total_pix, prev_blob_cells, blob_cells);
    end
    prev_blob_cells = blob_cells;

    blob_size_all(j,:) = blob_size;
    blob_center_all(j,:) = blob_center;
    blob_dyn_all(j,:) = blob_dyn;
    center_mean_dist_all(j,:) = center_mean_dist;
    center_min_dist_all(j,:) = center_min_dist;

    if seg_image_overwrite_flag
        output_file_name = fullfile(output_folder, sprintf('img_%g_seg.%s', seq_no(j), seg_image_format));
        imwrite(seg_img, output_file_name);
    end
end

