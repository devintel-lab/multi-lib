function extracted_frames = extract_obj_frames_by_cevent(subexpIDs, agent_camera, agent_roi, cevent, cat_list)

extracted_frames = {};

% loop through subjects
for sub_ind = 1:numel(subexpIDs)
    subID = subexpIDs(sub_ind);
    expID = sub2exp(subID);
    disp(['[*] extracting frames for subject - ' num2str(subID)])
    
    % check to see if subject has all the required variables. If not, skip to the next subject 
    skip_or_not = false;
    if ~has_variable(subID, cevent)
        warning(['[!] subject ' num2str(subID) ' does not have variable - ' cevent])
        skip_or_not = true;
    elseif ~has_variable(subID, agent_roi)
        warning(['[!] subject ' num2str(subID) ' does not have variable - ' agent_roi])
        skip_or_not = true;
    elseif ~has_variable(subID, 'cevent_trials')
        warning(['[!] subject ' num2str(subID) ' does not have variable - cevent_trials'])
        skip_or_not = true;
    end
    if skip_or_not
        warning(['[!] subject ' num2str(subID) ' does not have all the required variables. skipped'])
        continue
    end
    
    cropped_image_dir = fullfile(get_multidir_root, ['experiment_' num2str(expID)], 'included', 'all_attended_objs', agent_camera);
    
    sub_cropped_img_names = cellstr(ls(fullfile(cropped_image_dir, '*', [num2str(subID) '_*_*.jpg'])));
    
    if numel(sub_cropped_img_names) == 1 & isempty(sub_cropped_img_names{1})
        warning(['[!] no attended object instances were found for subject ' num2str(subID) '. skipped'])
        continue
    end
    
    % load the subject ROI variable and the cevent variable
    sub_cev = get_variable_by_trial_cat(subID, cevent);
    sub_roi = get_variable_by_trial_cat(subID, agent_roi);
    
    num_cev = size(sub_cev, 1);
    
    % turn the cevent onsets and offsets to frame numbers
    sub_cev_onsets_in_f_num = time2frame_num(sub_cev(:, 1), subID);
    sub_cev_offsets_in_f_num = time2frame_num(sub_cev(:, 2), subID);
    
    extracted_frames(end+1:end+num_cev, 1) = {subID};
    extracted_frames(end-num_cev+1:end, 2) = {expID};
    
    extracted_frames(end-num_cev+1:end, 3) = num2cell(sub_cev(:, 1));
    extracted_frames(end-num_cev+1:end, 4) = num2cell(sub_cev(:, 2));
    
    extracted_frames(end-num_cev+1:end, 5) = num2cell(sub_cev_onsets_in_f_num);
    extracted_frames(end-num_cev+1:end, 6) = num2cell(sub_cev_offsets_in_f_num);
    extracted_frames(end-num_cev+1:end, 7) = num2cell(sub_cev(:, 3));
    
    sub_trials = get_variable(subID, 'cevent_trials');
    
    trials_id = extract_ranges(sub_cev, 'cevent', sub_trials);
    trials_id = cellfun(@(a, b) num2cell(repmat(b, size(a, 1), 1)), trials_id, num2cell(sub_trials(:, end)), 'UniformOutput', false);
    trials_id = vertcat(trials_id{:});
    
    extracted_frames(end-num_cev+1:end, 8) = trials_id;
    
    extracted_frames(end-num_cev+1:end, 9) = num2cell((1:size(sub_cev, 1))');
    
    % for each cevent, list the frame numbers within the cevent (one cell per cevent instance)
    frame_IDs_within_cev = table2cell(rowfun(@(x, y) {(x:y-1)'}, table(sub_cev_onsets_in_f_num, sub_cev_offsets_in_f_num)));
    
    % find the frames that has the same categorical value as the ROI coding
    tb = make_time_base(subID);
    [~, sub_roi_cst] = evalc('cevent2cstream_v2(sub_roi, [], [], tb);'); % replacing cevent2cstreamtb(sub_roi, tb) with v2, more accurate way of conversion
    [~, sub_cev_cst] = evalc('cevent2cstream_v2(sub_cev, [], [], tb);'); % replacing cevent2cstreamtb(sub_cev, tb) with v2, same reason as above
    
    frame_IDs_have_same_cat_val = time2frame_num(tb(sub_roi_cst(:, 2) == sub_cev_cst(:, 2) & ismember(sub_cev_cst(:, 2), cat_list)), subID);
    frame_IDs_have_same_cat_val_cell = cellfun(@(x) intersect(x, frame_IDs_have_same_cat_val), frame_IDs_within_cev, 'UniformOutput', false);
        
    extracted_frames(end-num_cev+1:end, 10) = frame_IDs_have_same_cat_val_cell;
    
    sub_cropped_frames = cellfun(@img_name2frame_num, sub_cropped_img_names);
    sub_cropped_cat_vals = cellfun(@img_name2cat_val, sub_cropped_img_names);
    
    sub_frames_within_cev = cellfun(@(x) sort(intersect(x, sub_cropped_frames)), frame_IDs_have_same_cat_val_cell, 'UniformOutput', false);
    sub_frames_within_cev = cellfun(@fillNaN, sub_frames_within_cev, frame_IDs_have_same_cat_val_cell, 'UniformOutput', false);
    
    sub_frames_within_cev_full_paths = cellfun(@(a, b) frame_num_list2full_paths(subID, fullfile(cropped_image_dir), b, a, sub_cropped_frames, sub_cropped_cat_vals), num2cell(sub_cev(:, 3)), sub_frames_within_cev, 'UniformOutput', false);
    extracted_frames(end-num_cev+1:end, 11) = sub_frames_within_cev;
    extracted_frames(end-num_cev+1:end, 12) = sub_frames_within_cev_full_paths;
    
    frame_IDs_have_diff_cat_val = time2frame_num(tb(sub_roi_cst(:, 2) ~= sub_cev_cst(:, 2)), subID);
    frame_IDs_have_diff_cat_val_cell = cellfun(@(x) intersect(x, frame_IDs_have_diff_cat_val), frame_IDs_within_cev, 'UniformOutput', false);
    
    sub_frames_within_cev_diff_cat = cellfun(@(x) sort(intersect(x, sub_cropped_frames)), frame_IDs_have_diff_cat_val_cell, 'UniformOutput', false);
    sub_frames_within_cev_diff_cat = cellfun(@fillNaN, sub_frames_within_cev_diff_cat, frame_IDs_have_diff_cat_val_cell, 'UniformOutput', false);
    
    sub_frames_within_cev_diff_cat_full_paths = cellfun(@(a, b) frame_num_list2full_paths(subID, fullfile(cropped_image_dir), b, a, sub_cropped_frames, sub_cropped_cat_vals), cell(size(sub_frames_within_cev_diff_cat)), sub_frames_within_cev_diff_cat, 'UniformOutput', false);
    
    extracted_frames(end-num_cev+1:end, 13) = frame_IDs_have_diff_cat_val_cell;
    
    sub_roi_cst_fnum = [time2frame_num(sub_roi_cst(:, 1), subID), sub_roi_cst(:, 2)];
    diff_cat_vals_cell = cell(size(frame_IDs_have_diff_cat_val_cell));
    
    for i = 1:numel(frame_IDs_have_diff_cat_val_cell)
        frame_list = frame_IDs_have_diff_cat_val_cell{i};
        if isempty(frame_list)
            diff_cat_vals_cell{i, 1} = [];
        else
            temp_cat_vals_list = [];
            for f_num = reshape(frame_list, 1, [])
                temp_cat = sub_roi_cst_fnum(sub_roi_cst_fnum(:, 1) == f_num, 2);
                if numel(temp_cat) == 1
                    temp_cat_vals_list = [temp_cat_vals_list; sub_roi_cst_fnum(sub_roi_cst_fnum(:, 1) == f_num, 2)];
                end
            end
            diff_cat_vals_cell{i, 1} = temp_cat_vals_list;
        end
    end
    
    extracted_frames(end-num_cev+1:end, 14) = diff_cat_vals_cell;
    extracted_frames(end-num_cev+1:end, 15) = sub_frames_within_cev_diff_cat;
    extracted_frames(end-num_cev+1:end, 16) = sub_frames_within_cev_diff_cat_full_paths;
end

if ~isempty(extracted_frames)
    extracted_frames = cell2table(extracted_frames, 'VariableNames', {'subID', 'expID', 'onset_sec', 'offset_sec', 'onset_frame', 'offset_frame', 'category', 'trialsID', 'instanceID', 'sameCategoryFrames', 'sameCategoryCroppedImages', 'sameCategoryImagePaths', 'diffCategoryFrames', 'diffCategoryValues', 'diffCategoryCroppedImages', 'diffCategoryImagePaths'});
else
    extracted_frames = table();
end

end

% ====================
%   helper functions
% ====================

function frame_num = img_name2frame_num(img_name)
% chars -> double
% convert the image name to frame number
tmp = find(img_name=='_', 2);
frame_num = str2double(img_name(tmp(1)+1 : tmp(2)-1));
end

function cat_val = img_name2cat_val(img_name)
% chars -> double
% convert the image name to category value
tmp = find(img_name=='_', 2);
ext_ind = find(img_name=='.');
cat_val = str2double(img_name(tmp(2)+1 : ext_ind-1));
end

function full_paths_cell = frame_num_list2full_paths(subID, parent_folder, frame_num_list, cat_val, frames, cat_vals)
% double chars doubles double doubles doubles -> cell
num_of_frames = numel(frame_num_list);
full_paths_cell = {};
for i = 1:num_of_frames
    current_frame = frame_num_list(i);
    if isnan(current_frame)
        full_paths_cell{end+1, 1} = NaN;
        continue
    end
    current_cat_val = cat_vals(frames == current_frame);
    if ~isempty(cat_val)
        if current_cat_val == cat_val
            full_paths_cell{end+1, 1} = fullfile(parent_folder, num2str(cat_val), [num2str(subID) '_' num2str(current_frame) '_' num2str(cat_val) '.jpg']);
        end
    else
        if ismember(current_frame, frames)
            full_paths_cell{end+1, 1} = fullfile(parent_folder, num2str(current_cat_val), [num2str(subID) '_' num2str(current_frame) '_' num2str(current_cat_val) '.jpg']);
        end
    end
end
end

function result = fillNaN(incomplete_frame_list, complete_frame_list)
result = nan(size(complete_frame_list));
for i = 1:numel(complete_frame_list)
    if ismember(complete_frame_list(i), incomplete_frame_list)
        result(i) = complete_frame_list(i);
    end
end
end