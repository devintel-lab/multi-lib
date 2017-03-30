function [] = findAndReplaceBlueFrames( subject_id, folders_to_check )
    
    if nargin < 2
        folders = 3:8; % meaning cam01_frames_p, ..., cam08_frames_p
    end
    
    for fid = folders
        folder_name = ['cam0' num2str(fid) '_frames_p'];
        folder_dir = fullfile(get_subject_dir(subject_id), folder_name);
        
        if exist(folder_dir, 'dir') == 7
            disp(['Subject: ' num2str(subject_id) ' - Checking all in-trial frames in folder ' folder_name]);
            
            % loop over trials
            trials = get_trials(subject_id);
            for trial = 1:size(trials, 1)
                % loop over frames
                for frame = trials(trial, 1):trials(trial, 2)
                    img_path = [folder_dir '/img_' num2str(frame) '.jpg'];
                    if exist(img_path, 'file')
                        img = imread(img_path);
                        if all(all(img(1:10,1:10,3) > 250))
                            new_img = replaceBlueImage(subject_id, frame, folder_dir);
                            disp(['Found and replaced a blue frame! - Frame ' num2str(frame) ' of subject ' num2str(subject_id) ' in folder ' folder_name]);
                            imwrite(new_img, img_path);
                        end
                    end
                end
            end
        else
            warning(['Skipped folder ' folder_name ' as it does not exist']);
        end
        
    end
end

function new_img = replaceBlueImage(subject_id, blue_image_id, folder_dir)
    trials = get_trials(subject_id);
    all_frames = [];
    for tr = 1:size(trials, 1)
        all_frames = [all_frames trials(tr, 1):trials(tr, 2)];
    end
    
    if ismember(blue_image_id-1, all_frames)
        img_src = [folder_dir '/img_' num2str(blue_image_id-1) '.jpg'];
        new_img = imread(img_src);
    else
        img_src = [folder_dir '/img_' num2str(blue_image_id+1) '.jpg'];
        new_img = imread(img_src);
    end
end