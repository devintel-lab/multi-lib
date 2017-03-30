function [blob_size_all, blob_center_all, blob_dyn_all, time] = main_detect_objects_3(jpg_folder, output_folder, agent_type, obj_num, obj_params, img_step, overwrite_flag)

if obj_num > 3
    error('This script is for processing experiments with 3 objects only');
end

if ~exist('img_step', 'var')
    img_step = 1;
end

if ~exist('overwrite_flag', 'var')
    overwrite_flag = true;
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

fprintf('frame       ');

for j=1:N        
    fprintf('\b\b\b\b\b\b%5d:', seq_no(j));
    if overwrite_flag
        jpg = jpg_list(j).name;       
        img = imread(fullfile(jpg_folder, jpg));
        img = imresize(img, ratio);
        
        [img_h, img_w] = size(img(:,:,1));
        total_pix = img_h*img_w;

        [blob_size, blob_center, blob_cells] = ...
            detect_color_object(img, agent_type, obj_num, obj_params);
        
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

        output_file_name = fullfile(output_folder, sprintf('img_%g_seg.jpg', seq_no(j)));
        imwrite(seg_img, output_file_name);
    end
end

end

