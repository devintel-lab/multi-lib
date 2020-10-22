function generate_acuity_video(subexpIDs, agent, renderGazeFlag, additionCamID, overwriteFlag, camID)

if ~exist('camID', 'var') || nargin < 6
    if strcmp(agent, 'child')
        camID = 'cam07';
    elseif strcmp(agent, 'parent')
        camID = 'cam08';
    end
end

if ~exist('overwriteFlag', 'var') || nargin < 5
    overwriteFlag = false;
end

if ~exist('additionCamID', 'var') || nargin < 4
    additionCamID = '';
end

if ~exist('renderGazeFlag', 'var') || nargin < 3
    renderGazeFlag = false;
end

subs = cIDs(subexpIDs);

if renderGazeFlag
    gaze_suffix = 'with_gaze';
else
    gaze_suffix = '';
end

if strcmp(additionCamID, '')
    addition_suffix = '';
else
    addition_suffix = ['+' additionCamID];
end

for sub = subs'
    disp(['[*] Processing subject ' num2str(sub) '_' gaze_suffix addition_suffix])
    
    sub_root = get_subject_dir(sub);
    acuity_img_dir = fullfile(sub_root, [camID '_acuity_p']);
    
    % check the existence of the acuity frame folder. If not exist, skip to next subject
    if ~exist(acuity_img_dir, 'dir')
        warning(['[-] Subject ' num2str(sub) ' does not have ' camID '_acuity_p folder. Skipped'])
        continue
    end
    
    addition_root = fullfile(sub_root, [additionCamID '_frames_p']);
    addition_dir_struct = dir(fullfile(addition_root, 'img_*.jpg'));
    if ~strcmp(additionCamID, '')
        % check the existence of the additional camera frame folder. If not exist, skip to next subject
        if ~exist(fullfile(sub_root, [additionCamID '_frames_p']), 'dir')
            warning(['[-] Subject ' num2str(sub) ' does not have ' additionCamID '_frames_p folder. Skipped'])
            continue
        end
        % look for additional cam images. If no images detected, skip to next subject
        if numel(addition_dir_struct) == 0
            warning(['[-] Subject ' num2str(sub) ' no images were found under ' additionCamID '_frames_p folder. Skipped'])
            continue
        end
    end
    
    if renderGazeFlag
        % check to see if the subject has gaze variable. If not exist, skip to next subject
        if ~has_variable(sub, ['cont2_eye_xy_' agent])
            warning(['[-] Subject ' num2str(sub) ' does not have cont2_eye_xy_' agent ' variable. Skipped'])
            continue
        end
        % load gaze
        gaze_cont = get_variable(sub, ['cont2_eye_xy_' agent]);
    end
    
    % look for acuity images. If no images detected, skip to next subject
    acuity_dir_struct = dir(fullfile(acuity_img_dir, 'img_*.jpg'));
    if numel(acuity_dir_struct) == 0
        warning(['[-] Subject ' num2str(sub) ' no images were found under ' camID '_acuity_p folder. Skipped'])
        continue
    end
    
    video_savedir = fullfile(sub_root, [camID '_acuity_r']);
    if ~exist(video_savedir)
        try
            mkdir(video_savedir)
        catch ME
            disp(ME.message)
            continue
        end
    end
    video_savepath = fullfile(video_savedir, [camID '_acuity_' gaze_suffix addition_suffix]);
    if ~overwriteFlag && exist([video_savepath '.avi'], 'file')
        warning(['[!] ' video_savepath ' already exists. Skipped'])
        continue
    end
    
    v = VideoWriter(video_savepath);
    open(v)
    
    acuity_img_paths = dir_struct2paths(acuity_dir_struct);
    acuity_fnums = dir_struct2frame_nums(acuity_dir_struct);
    addition_img_paths = dir_struct2paths(addition_dir_struct);
    addition_fnums = dir_struct2frame_nums(addition_dir_struct);
    
    [img_y, img_x, ~] = size(imread(acuity_img_paths{1}));
    empty_frame = zeros(img_y, img_x, 3);
    divider = ones(3, img_x, 3);
    
    max_frame_num = max([max(addition_fnums) max(acuity_fnums)]);
    empty_ind_acuity = 0;
    empty_ind_addition = 0;
    for i = 1:max_frame_num
        disp(['[*] processing ' num2str(sub) ' frame ' num2str(i) ' - ' num2str(max_frame_num)])
        
        acuity_ind = find(acuity_fnums==i);
        if numel(acuity_ind) == 0
            frame_top = empty_frame;
        else
            frame_top = imread(acuity_img_paths{acuity_ind});
        end
        
        addition_ind = find(addition_fnums==i);
        if numel(addition_ind) == 0
            frame_bottom = empty_frame;
        else
            frame_bottom = imread(addition_img_paths{addition_ind});
            [img_row, img_col, ~] = size(frame_bottom);
            if img_row ~= img_y || img_col ~= img_x
                frame_bottom = imresize(frame_bottom, [img_y img_x]);
            end
        end
        
        if renderGazeFlag
            gaze_row = gaze_cont(abs(gaze_cont(:, 1) - frame_num2time(i, sub)) < 0.01, :);
            gaze_x = gaze_row(2);
            gaze_y = gaze_row(3);
            gaze_x = max(1, min(gaze_x, img_x));
            gaze_y = max(1, min(gaze_y, img_y));
            frame_top = insertShape(frame_top, 'circle', [gaze_x gaze_y 20], 'LineWidth', 3, 'Color', [0.6 0.1 0.6]*255);
        end
        frame_whole = vertcat(vertcat(frame_top, divider), frame_bottom);
        writeVideo(v, frame_whole)
    end
    close(v)
end
end

function frame_nums = dir_struct2frame_nums(dir_struct)
frame_nums = cell2mat(cellfun(@(x) sscanf(x, 'img_%d.jpg'), {dir_struct.name}, 'UniformOutput', false))';
end

function img_paths = dir_struct2paths(dir_struct)
img_paths = strcat(dir_struct(1).folder, filesep(), {dir_struct.name})';
end



