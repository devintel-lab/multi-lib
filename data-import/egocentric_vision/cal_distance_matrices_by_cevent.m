function [extracted_frames, image_features, distance_matrix] = cal_distance_matrices_by_cevent(subexpIDs, agent_camera, agent_roi, cevent, cat_list, feature_function, distance_function, level)

subIDs = sort(unique(cIDs(subexpIDs)));
    
if ~ismember(lower(level), {'experiment', 'subject', 'trial', 'instance', 'extract-only'})
    error(['[-] The level parameter should be one of following:' newline '    ''experiment'', ''subject'', ''trial'', ''instance'', ''extract-only'''])
end

warning('off', 'MATLAB:table:RowsAddedExistingVars')
disp([newline '=================================================='])
disp('[*] extracting frame information...')
disp(['==================================================' newline])
pause(1)
extracted_frames = extract_obj_frames_by_cevent(subIDs, agent_camera, agent_roi, cevent, cat_list);
if isempty(extracted_frames)
    error('[-] no data found in extracted_frames. please make sure the cropped attended object instances were already generated for the entered subjects')
end

assignin('base', 'extracted_frames', extracted_frames)
disp('[+] frame information extraction finished')

image_features = table();
distance_matrix = table();
if ~strcmpi(level, 'extract-only')
    for subID = reshape(subIDs, 1, [])
        disp([newline '=================================================='])
        disp(['[*] calculating image features for subject - ' num2str(subID)])
        pause(1)
        sub_image_features = calculate_image_features(subID, extracted_frames, feature_function);
        assignin('base', ['image_features_' num2str(subID)], sub_image_features)
        image_features = vertcat(image_features, sub_image_features);
        assignin('base', 'image_features', image_features)
        disp(['[+] image features calculation finished' newline])
        
        disp(['[*] calculating feature distances for subject - ' num2str(subID)])
        pause(1)
        sub_distance_matrix = calculate_distance_matrix(image_features, cat_list, distance_function, level);
        assignin('base', ['distance_matrix_' num2str(subID)], sub_distance_matrix)
        distance_matrix = vertcat(distance_matrix, sub_distance_matrix);
        assignin('base', 'distance_matrix', distance_matrix)
        disp('[+] distance matrices generated')
    end
end
warning('on', 'MATLAB:table:RowsAddedExistingVars')
end

% extract image features
function image_features = calculate_image_features(subexpIDs, extracted_frames, feature_function)

subIDs = unique(cIDs(subexpIDs));
extracted_frames = table2cell(extracted_frames);
ind = ismember(cell2mat(extracted_frames(:, 1)), subIDs);
extracted_frames = extracted_frames(ind, :);

image_features = {};
if any(ind)
    for i = 1:size(extracted_frames, 1)
        disp(['[*] calculating image features - ' num2str(i) ' / ' num2str(size(extracted_frames, 1))])
        noneNanFrameNum = extracted_frames{i, 11};
        noneNanFrameNum = noneNanFrameNum(~isnan(noneNanFrameNum));
        noneNanFramePath = extracted_frames{i, 12};
        noneNanFramePath = noneNanFramePath(cellfun(@(x) ~any(isnan(x(:))), noneNanFramePath));
        if isempty(noneNanFramePath)
            continue
        end
        num_frames = numel(noneNanFramePath);
        image_features(end+1:end+num_frames, 1) = extracted_frames(i, 1);
        image_features(end-num_frames+1:end, 2) = extracted_frames(i, 2);
        image_features(end-num_frames+1:end, 3) = extracted_frames(i, 7);
        image_features(end-num_frames+1:end, 4) = extracted_frames(i, 8);
        image_features(end-num_frames+1:end, 5) = extracted_frames(i, 9);
        image_features(end-num_frames+1:end, 6) = num2cell(noneNanFrameNum);
        image_features(end-num_frames+1:end, 7) = noneNanFramePath;
        image_features(end-num_frames+1:end, 8) = cellfun(feature_function, noneNanFramePath, 'UniformOutput', false);
    end
    image_features = cell2table(image_features, 'VariableNames', {'subID', 'expID', 'category', 'trialsID', 'instanceID', 'frameNumber', 'imagePath', 'imageFeature'});
else
    warning(['[!] no extracted frames were detected for subject ' num2str(subIDs) '. skipped'])
    image_features = table();
end

end

% calculate distance matrix
function distance_matrix = calculate_distance_matrix(image_features, cat_list, distance_function, level)
image_features = table2cell(image_features);
distance_matrix = {};

cat_list = sort(cat_list);
cat_str_cell = strcat('cat_', sprintfc('%d', reshape(cat_list, 1, [])));

if ~isempty(image_features)
    unique_exps = sort(unique(cell2mat(image_features(:, 2))));
    for i = 1:numel(unique_exps)
        current_exp = unique_exps(i);
        current_ind_exp = cell2mat(image_features(:, 2)) == current_exp;
        if strcmpi(level, 'experiment')
            variable_names = {'expID'};
            distance_matrix{end+1, 1} = current_exp;
            for x = 1:numel(cat_list)
                current_cat = cat_list(x);
                current_ind_cat = current_ind_exp & cell2mat(image_features(:, 3)) == current_cat;
                distance_matrix{end, x+1} = img_features2distance_matrix(image_features(current_ind_cat, 7), image_features(current_ind_cat, 8), distance_function);
            end
            continue
        end
        unique_subs = sort(unique(cell2mat(image_features(current_ind_exp, 1))));
        for j = 1:numel(unique_subs)
            current_sub = unique_subs(j);
            current_ind_sub = current_ind_exp & cell2mat(image_features(:, 1)) == current_sub;
            if strcmpi(level, 'subject')
                variable_names = {'expID', 'subID'};
                distance_matrix{end+1, 1} = current_exp;
                distance_matrix{end, 2} = current_sub;
                for x = 1:numel(cat_list)
                    current_cat = cat_list(x);
                    current_ind_cat = current_ind_sub & cell2mat(image_features(:, 3)) == current_cat;
                    distance_matrix{end, x+2} = img_features2distance_matrix(image_features(current_ind_cat, 7), image_features(current_ind_cat, 8), distance_function);
                end
                continue
            end
            unique_trials = sort(unique(cell2mat(image_features(current_ind_sub, 4))));
            for k = 1:numel(unique_trials)
                current_trial = unique_trials(k);
                current_ind_trial = current_ind_sub & cell2mat(image_features(:, 4)) == current_trial;
                if strcmpi(level, 'trial')
                    variable_names = {'expID', 'subID', 'trialID'};
                    distance_matrix{end+1, 1} = current_exp;
                    distance_matrix{end, 2} = current_sub;
                    distance_matrix{end, 3} = current_trial;
                    for x = 1:numel(cat_list)
                        current_cat = cat_list(x);
                        current_ind_cat = current_ind_trial & cell2mat(image_features(:, 3)) == current_cat;
                        distance_matrix{end, x+3} = img_features2distance_matrix(image_features(current_ind_cat, 7), image_features(current_ind_cat, 8), distance_function);
                    end
                    continue
                end
                unique_insts = sort(unique(cell2mat(image_features(current_ind_trial, 5))));
                for w = 1:numel(unique_insts)
                    current_inst = unique_insts(w);
                    current_ind_inst = current_ind_trial & cell2mat(image_features(:, 5)) == current_inst;
                    if strcmpi(level, 'instance')
                        variable_names = {'expID', 'subID', 'trialID', 'instanceID'};
                        distance_matrix{end+1, 1} = current_exp;
                        distance_matrix{end, 2} = current_sub;
                        distance_matrix{end, 3} = current_trial;
                        distance_matrix{end, 4} = current_inst;
                        for x = 1:numel(cat_list)
                            current_cat = cat_list(x);
                            current_ind_cat = current_ind_inst & cell2mat(image_features(:, 3)) == current_cat;
                            distance_matrix{end, x+4} = img_features2distance_matrix(image_features(current_ind_cat, 7), image_features(current_ind_cat, 8), distance_function);
                        end
                    end
                end
            end
        end
    end
    distance_matrix = cell2table(distance_matrix, 'VariableNames', horzcat(variable_names, cat_str_cell));
else
    warning('[!] no frame features were extracted. skipped')
    distance_matrix = table();
end

end

% ====================
%   helper functions
% ====================

% pdist if features are 1xn vectors
function matrix = img_features2distance_matrix(img_names, img_features, distance_function)
num_imgs = numel(img_features);
matrix = nan(num_imgs, num_imgs);
for i = 1:numel(img_features)
    for j = 1:numel(img_features)
        if i == j
            matrix(i, j) = 0;
        elseif i > j
            matrix(i, j) = matrix(j, i);
        else
            if isnan(img_features{i}) | isnan(img_features{j})
                matrix(i, j) = NaN;
            else
                matrix(i, j) = distance_function(img_features{i}, img_features{j});
            end
        end
    end
end

img_names = cellfun(@get_img_name_from_path, img_names, 'UniformOutput', false);
if ~isempty(matrix)
    matrix = cell2table(num2cell(matrix), 'VariableNames', img_names, 'RowNames', img_names);
else
    matrix = table();
end
end

function img_name = get_img_name_from_path(img_path)
[~, img_name, ~] = fileparts(img_path);
end
