function imgsize_list = preprocess_check_image_size(sub_list, target_cam_list, is_check_all_frames)

if ~exist('is_check_all_frames', 'var')
    is_check_all_frames = false;
end

imgsize_list = cell(size(target_cam_list));

if ~iscell(target_cam_list)
    tmpcam = target_cam_list;
    target_cam_list = cell(1,1);
    target_cam_list{1} = tmpcam;
end

for camidx = 1:length(target_cam_list)
    cam_one = target_cam_list{camidx};
    imgsize_one = nan(length(sub_list), 2);
    
    for sidx = 1:length(sub_list)
        sub_id = sub_list(sidx);
        trial_frames = get_trials(sub_id);
        
        subj_dir = get_subject_dir(sub_id);
        jpg_folder = fullfile(subj_dir, [cam_one '_frames_p']);
        
        if ~is_check_all_frames
            tmprn = nan(size(trial_frames));

            for tidx = 1:size(trial_frames, 1)
                rindex = randi([trial_frames(tidx,:)], 1);
                jpg_file = sprintf('img_%d.jpg', rindex);
                jpg_file_path = fullfile(jpg_folder, jpg_file);
                if ~exist(jpg_file_path, 'file')
                    warning('Subject %d missing %s frame %d wthin trial %d', sub_id, cam_one, rindex, tidx);
                end
                img = imread(jpg_file_path);
                tmprn(tidx, :) = size(img(:,:,1));
            end

            tmpsize = unique(tmprn);
            if length(tmpsize) > 2
                error('Inconsistent image sizes within one camera for subject %d', sub_id);
            end
        else
            jpg_list = dir(fullfile(jpg_folder, 'img_*.jpg'));
            tmpj = nan(length(jpg_list));

            for jidx = 1:length(jpg_list)
                jpg_file = sprintf('img_%d.jpg', jidx);
                img = imread(fullfile(jpg_folder, jpg_file));
                tmpj(jidx, :) = size(img(:,:,1));
            end

            tmpsize = unique(tmpsz);
            if length(tmpsize) > 2
                error(['Inconsistent image sizes within one camera for subject %d' ...
                    ', frames sizes are %s'], sub_id, num2str(tmpsize));
            end
        end

        imgsize_one(sidx, :) = tmpsize;
    end
    
    imgsize_list{camidx} = imgsize_one;
end

if length(target_cam_list) < 2
    imgsize_list = imgsize_list{1};
end