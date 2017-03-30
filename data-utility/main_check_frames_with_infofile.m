function checking_results = main_check_frames_with_infofile(sub_list, save_path, img_step)
% This function is written to check 
% for all the cameras in each subject, whether the frame images in ALL  
% the camera folder match up exactly with the trial info frame number.
% 
% Output:
% >> checking_results = main_check_frames_with_infofile(list_subjects(32));
% 
% The program will first prompt all the progress:
% 
% Checking done for cam01_frames_p for subject 3201
% 
% Checking done for cam02_frames_p for subject 3201
% 
% Checking done for cam03_frames_p for subject 3201
% 
% Checking done for cam04_frames_p for subject 3201
% 
% Checking done for cam07_frames_p for subject 3201
% 
% Checking done for cam08_frames_p for subject 3201
% 
% Checking done for cam01_frames_p for subject 3202
% 
% Checking done for cam02_frames_p for subject 3202
% 
% Checking done for cam03_frames_p for subject 3202
% 
% Checking done for cam04_frames_p for subject 3202
% 
% Frames do not match with info file in cam07_frames_p for subject 3202
% 
% Checking done for cam07_frames_p for subject 3202
% 
% Checking done for cam08_frames_p for subject 3202
% 
% ...
% 
% And at the end, it will generate a text error log file including all 
% the miss-matched frame numbers, for example:
% 
% <frame_check_errorlog_3202.txt>
% Subject 3202
% 
% Trial frames:
% 0  2648
% 5316  7944
% 8183  10768
% 11124  12993
% 
% Checking date:
% 11-7_2012_15-32
% 
% ==============
% cam07_frames_p
% missing frames: 0      1   5316   5317   8183   8184  11124  11125
% extra frames: 2649   2650   7945   7946  10769  10770  12994  12995

if ~exist('save_path', 'var')
    save_path = '.';
end

if ~exist('img_step', 'var')
    img_step = 1;
end

exp_id = unique(round(sub_list/100));
tmp_clock = clock;
tmp_clock_str = sprintf('%d-%d_%d', tmp_clock(2:3), tmp_clock(1));

summary_file_name = sprintf('frame_check_summary_exp%d_%s.txt', exp_id, tmp_clock_str);
fsummary = fopen(fullfile(save_path, summary_file_name), 'a');

for sid = 1:length(sub_list)    
    sub_id = sub_list(sid);
    checking_results(sid).sub_id = sub_id;
    % info_file = get_info_file_path(sub_id);
    % load info_file
    fprintf(fsummary, '%d\n', sub_id);

    trial_frames_sub = get_trials(sub_id);
    info_frame_seq = [];
    for tidx = 1:size(trial_frames_sub, 1);
        tmp_seq = trial_frames_sub(tidx,1):1:trial_frames_sub(tidx,2);
        info_frame_seq = [info_frame_seq; tmp_seq'];
    end

    sub_dir = get_subject_dir(sub_id);
    cam_list = dir(fullfile(sub_dir, '*_frames_p'));  % the list of all cameras
    checking_results(sid).cam_list = cam_list;
    num_missing_frames = nan(size(cam_list));
    num_extra_frames = nan(size(cam_list));
    
    exist_error_log = false;
    tmp_clock = clock;
    tmp_clock_str = sprintf('%d-%d_%d_%d-%d', tmp_clock(2:3), tmp_clock(1), tmp_clock(4:5));

    for camid = 1:length(cam_list)
        cam_name = cam_list(camid).name;
        cam_dir = fullfile(sub_dir, cam_name);

        jpg_list = dir(fullfile(cam_dir, 'img_*.jpg'));
        [jpg_list seq_no] = extract_img_name_list(jpg_list, img_step);
        sorted_seq = sort(seq_no);

        if length(info_frame_seq) == length(sorted_seq)
            is_frame_all_match = sum(info_frame_seq == sorted_seq) == length(sorted_seq);
        else
            is_frame_all_match = false;
        end

        if ~is_frame_all_match
            missing_frames = setdiff(info_frame_seq, sorted_seq);
            extra_frames = setdiff(sorted_seq, info_frame_seq);
            num_missing = length(missing_frames);
            num_extra = length(extra_frames);
            
            if  num_missing > 0
                error_msg_missing = sprintf('subject %d %s missing %d frames\n', sub_id, cam_name, num_missing);
                disp(error_msg_missing);
                fprintf(fsummary, error_msg_missing);
            end            
            if  num_extra > 0
                error_msg_extra = sprintf('subject %d %s have %d extra frames\n', sub_id, cam_name, num_extra);
                disp(error_msg_extra);
                fprintf(fsummary, error_msg_extra);
            end            
            
            num_missing_frames(camid) = num_missing;
            num_extra_frames(camid) = num_extra;

            error_msg_missing = sprintf('missing frames: %s\n', num2str(missing_frames'));
            error_msg_extra = sprintf('extra frames: %s\n', num2str(extra_frames'));

            % write error messages to file
            error_file_name = sprintf('frame_check_errorlog_%d_%s.txt', sub_id, tmp_clock_str);
            fid = fopen(fullfile(save_path, error_file_name), 'a');
            
            if ~exist_error_log
                fprintf(fid, 'Subject %d\n\nTrial frames:\n', sub_id);
                for tidx = 1:size(trial_frames_sub, 1)
                    fprintf(fid, num2str(trial_frames_sub(tidx,:)));
                    fprintf(fid, '\n');
                end
                
                fprintf(fid, ['\nChecking time:\n' tmp_clock_str '\n']);
                
                exist_error_log = true;
            end
            
            fprintf(fid, '\n==============\n');
            fprintf(fid, [cam_name '\n']);
            fprintf(fid, error_msg_missing);
            fprintf(fid, error_msg_extra);
            fprintf(fid, '\n\n\n');
            fclose(fid);
        end

        checking_results(sid).num_missing_frames = num_missing_frames;
        checking_results(sid).num_extra_frames = num_extra_frames;
        fprintf('Checking done for %s for subject %d\n\n', cam_name, sub_id);
    end
    fprintf(fsummary, '\n\n');
end
fclose(fsummary);