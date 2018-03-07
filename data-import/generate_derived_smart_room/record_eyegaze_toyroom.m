function [gaze] = record_eyegaze_toyroom(subject_id, subject_type)
%
%   This function generates the "cont2_eye_xy_child/parent" variable which contains the X-Y values of the gaze tracker for each frame.
%   It does so by opening e.g. supporting_files/child_eye.txt, which contains the raw gaze data, and opening supporting_files/eye_range.txt,
%   which contains the correct temporal onset/offset such that the correct range can be extracted from child_eye.txt.
%   All gaze values are in pixels where [1,1] is the top-left corner of the scene camera image. All gaze values that are outside of the pixel
%   range (resolution) of the scene camera image are set to NaN. Frames where the pupil could not be tracked (e.g. blinking) are also set to
%   NaN.
%
%   In addition, this function saves a heat map of the 2D gaze distribution under the "data_vis" folder. This heat map can be uses to quickly 
%   evaluate the quality of the eye gaze data.
%
%   Parameters: 
%       - subject_id: subject_id, e.g. 1208
%       - subject_type: either 'child' or 'parent'
%
%   This function was written by Sven (sbambach@indiana.edu)

    s_dir = get_subject_dir(subject_id);

    gaze_text_file = fullfile(s_dir, 'supporting_files', [subject_type '_eye.txt']);
    gaze = dlmread(gaze_text_file,' ', 7, 5); 
    gaze = gaze(:,1:2); % x y (col row)

    range_text_file = fullfile(s_dir, 'supporting_files','eye_range.txt');
    range = dlmread(range_text_file,' ');

    if strcmp(subject_type, 'child')
        frame_range = range(1,:);
    else
        frame_range = range(2,:);
    end

    % only for 1205 child! (fixes corruption in raw data)
    % frame_range_1 = [frame_range(1) frame_range(1) + 6145];
    % frame_range_2 = [frame_range(1) + 6148 frame_range(2)];
    % gaze = gaze([frame_range_1(1):frame_range_1(2) frame_range_2(1):frame_range_2(2)], :);

    gaze = gaze(frame_range(1):frame_range(2),:);
    gaze_x = gaze(:,1);
    gaze_y = gaze(:,2);

    % get resolution of frame
    trials = get_trials(subject_id);
    frame = imread(fullfile(s_dir, 'cam07_frames_p', ['img_' num2str(trials(1,1)) '.jpg']));
    [n_rows, n_cols, ~] = size(frame);

    out_of_range = gaze_x < 1 | gaze_x > n_cols;
    gaze_x(out_of_range) = NaN;

    out_of_range = gaze_y < 1 | gaze_y > n_rows;
    gaze_y(out_of_range) = NaN;

    % add frame number to gaze
    % frame_start = trials(1,1);
    % frames = frame_start:frame_start+length(gaze)-1;

    % always start with 1 !!!! (sven fix 02/26/18)
    frames = 1:size(gaze,1 );
    gaze = [frames' gaze_x gaze_y];

    % record variable
    gaze_time = [frame_num2time(gaze(:,1), subject_id) gaze(:,2:3)];
    var_name = ['cont2_eye_xy_' subject_type];
    record_variable(subject_id, var_name, gaze_time);

    % check visualization folder
    vis_dir = '';
    parts = strsplit(s_dir, filesep);
    for i = 1:numel(parts)-1
        vis_dir = fullfile(vis_dir, parts{i});
    end
    vis_dir = fullfile(vis_dir, 'data_vis', 'heatmap_eyegaze');
    if exist(vis_dir) ~= 7
        mkdir(vis_dir);
    end

    disp(['Generating gaze heatmap for subject ' num2str(subject_id)]);
    % HEATMAP visualization
    n_trials = size(trials, 1);
    for t = 1:n_trials
        s_frame = trials(t,1);
        e_frame = trials(t,2);

        % s_gaze = find(gaze(:,1) == s_frame);
        % e_gaze = find(gaze(:,1) == e_frame);

        heatmap = zeros(n_rows, n_cols);

        % for g = s_gaze:e_gaze
        for g = s_frame:e_frame
            gaze_row = round(gaze(g, 3));
            gaze_col = round(gaze(g, 2));
            if ~isnan(gaze_row) && ~isnan(gaze_col)
                heatmap(gaze_row, gaze_col) = heatmap(gaze_row, gaze_col) + 1;
            end
        end

        img = turn_into_heatmap_img(heatmap);
        imwrite(img, fullfile(vis_dir, [num2str(subject_id) '_' subject_type '_trial_' num2str(t) '_eyegaze.jpg']), 'Quality', 75);
    end
    % disp(['Done generating gaze heatmap for subject ' num2str(subject_id)]);
end

function img = turn_into_heatmap_img(dist)
    % first blurr for vis. purposes
    H = fspecial('gaussian', [20 20], 2);
    dist = imfilter(dist, H);

    m = max(dist(:));
    img = ind2rgb(gray2ind(uint8(255*dist/m), 255), jet(255));
end