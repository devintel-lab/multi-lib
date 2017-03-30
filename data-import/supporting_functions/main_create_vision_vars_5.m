function main_create_vision_vars_5(sub_id, target_cam, dest_cam, agent_type, obj_num, obj_params, is_record_vision_vars, is_record_eye_vars, seg_image_overwrite_flag, seg_image_format, img_step)
% MAIN_EXP29_DETECT_OBJECTS: Segment three objects (and skin) for
% camera 6 of experiment 29; Only image frames within trials will be
% processed.
% 
% Input: 
%   sub_list: The list of ubjects
%   img_step:  Only process 1 frame in every img_step; default value is 1 (process all the image frames.
%   seg_image_overwrite_flag: If it is true, the output of this program will overwrite pre-existing segmentation result images.    
%                   Default value is true;
%
% Note: To do segmentation on subject 2901's images, the color parameter
% need to be changed in function detect_color_object.
%
%  Hongwei Shen, 03/25/2011
%  Re-write by: txu@indiana.edu update date: Oct. 15, 2013
%

if obj_num ~= 5
    error('This script is for processing experiments with 5 objects only');
end

if ~exist('is_record_vision_vars', 'var')
    is_record_vision_vars = false;
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

sub_dir = get_subject_dir(sub_id);
jpg_folder    = fullfile(sub_dir, [target_cam '_frames_p']);  % hard coding. May need to be changed.
output_folder = fullfile(sub_dir, [dest_cam '_frames_p']); % hard coding

[time, blob_size_all, blob_center_all, blob_dyn_all, center_mean_dist, center_min_dist] = ...
    main_detect_objects_5(sub_id, jpg_folder, output_folder, agent_type, obj_num, obj_params, seg_image_overwrite_flag, seg_image_format, img_step);

% start saving variables: size and location: 
if is_record_vision_vars   
%     record_variable(sub_id, ['cont_vision_size_skin_' agent_type ], [time blob_size_all(:,1)*100]);
    record_variable(sub_id, ['cont_vision_size_obj1_' agent_type ], [time blob_size_all(:,2)*100]);
    record_variable(sub_id, ['cont_vision_size_obj2_' agent_type ], [time blob_size_all(:,3)*100]);
    record_variable(sub_id, ['cont_vision_size_obj3_' agent_type ], [time blob_size_all(:,4)*100]);
    record_variable(sub_id, ['cont_vision_size_obj4_' agent_type ], [time blob_size_all(:,5)*100]);
    record_variable(sub_id, ['cont_vision_size_obj5_' agent_type ], [time blob_size_all(:,6)*100]);
    
%     record_variable(sub_id, ['cont_vision_dyn_skin_' agent_type ], [time blob_size_all(:,1)*100]);
    record_variable(sub_id, ['cont_vision_dyn_obj1_' agent_type ], [time blob_dyn_all(:,2)*100]);
    record_variable(sub_id, ['cont_vision_dyn_obj2_' agent_type ], [time blob_dyn_all(:,3)*100]);
    record_variable(sub_id, ['cont_vision_dyn_obj3_' agent_type ], [time blob_dyn_all(:,4)*100]);
    record_variable(sub_id, ['cont_vision_dyn_obj4_' agent_type ], [time blob_dyn_all(:,5)*100]);
    record_variable(sub_id, ['cont_vision_dyn_obj5_' agent_type ], [time blob_dyn_all(:,6)*100]);

%    record_variable(sub_id, ['cont2_vision_location_skin_' agent_type], [time blob_center(:, 1:2)]);
    record_variable(sub_id, ['cont2_vision_location_obj1_' agent_type], [time blob_center_all(:, 3:4)]);
    record_variable(sub_id, ['cont2_vision_location_obj2_' agent_type], [time blob_center_all(:, 5:6)]);
    record_variable(sub_id, ['cont2_vision_location_obj3_' agent_type], [time blob_center_all(:, 7:8)]);
    record_variable(sub_id, ['cont2_vision_location_obj4_' agent_type], [time blob_center_all(:, 9:10)]);
    record_variable(sub_id, ['cont2_vision_location_obj5_' agent_type], [time blob_center_all(:, 11:12)]);
    
%         record_variable(sub_id, 'cont_gaze_to_head_mean_distance', [time mean_dist(:,1)]);
    record_variable(sub_id, ['cont_vision_mean-dist_center-to-obj1_' agent_type], [time center_mean_dist(:,2)]);
    record_variable(sub_id, ['cont_vision_mean-dist_center-to-obj2_' agent_type], [time center_mean_dist(:,3)]);
    record_variable(sub_id, ['cont_vision_mean-dist_center-to-obj3_' agent_type], [time center_mean_dist(:,4)]);
    record_variable(sub_id, ['cont_vision_mean-dist_center-to-obj4_' agent_type], [time center_mean_dist(:,5)]);
    record_variable(sub_id, ['cont_vision_mean-dist_center-to-obj5_' agent_type], [time center_mean_dist(:,6)]);
    record_variable(sub_id, ['cont_vision_mean-dist_center-to-all_' agent_type], [time center_mean_dist(:,7)]);

%         record_variable(sub_id, 'cont_' agent_type '_gaze_to_head_min_distance', [time center_min_dist(:,1)]);
    record_variable(sub_id, ['cont_vision_min-dist_center-to-obj1_' agent_type], [time center_min_dist(:,2)]);
    record_variable(sub_id, ['cont_vision_min-dist_center-to-obj2_' agent_type], [time center_min_dist(:,3)]);
    record_variable(sub_id, ['cont_vision_min-dist_center-to-obj3_' agent_type], [time center_min_dist(:,4)]);
    record_variable(sub_id, ['cont_vision_min-dist_center-to-obj4_' agent_type], [time center_min_dist(:,5)]);
    record_variable(sub_id, ['cont_vision_min-dist_center-to-obj5_' agent_type], [time center_min_dist(:,6)]);
    record_variable(sub_id, ['cont_vision_min-dist_center-to-all_' agent_type], [time center_min_dist(:,7)]);
end

end

