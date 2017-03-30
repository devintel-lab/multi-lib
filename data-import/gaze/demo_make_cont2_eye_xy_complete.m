clear all;

exp_id = 34;
sub_list = list_subjects(exp_id);

enable_visualize_heatmap = false;
enable_check_visualize_range = false;
is_record_var = true;

% for sidx = 1:length(sub_list)
    sidx = 16;
    sub_id = sub_list(sidx);
    
    child_frame_offset = 0;
    gaze_info = import_check_csv_eye_files_complete(sub_id, child_frame_offset, ...
        is_record_var, ...
        enable_visualize_heatmap, enable_check_visualize_range);
% end