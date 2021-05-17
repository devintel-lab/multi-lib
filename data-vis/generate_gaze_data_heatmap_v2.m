function [gaze_data] = generate_gaze_data_heatmap_v2(EXP_LIST, SUBJECT, FOLDER, EVENT_VAR, NEGATE_EVENT, TARGET_RESOLUTION)

    addpath('C:\space\CORE\repository\multi-lib\data-vis\supporting_functions');

    if nargin < 4
        EVENT_VAR = 'no_event';
    end

    if nargin < 5
        NEGATE_EVENT = false;
    end
    
    if nargin < 6
        TARGET_RESOLUTION = [480 640];
    end

    % get all subjects that have EVENT/CEVENT variable
    SUB_LIST = get_subjects_with_event(EXP_LIST, EVENT_VAR);
    
    % for each subject, check if it has the GAZE DATA variable
    GAZE_VAR = ['cont2_eye_xy_' SUBJECT];
    SUB_LIST = get_subjects_with_cont_data(SUB_LIST, GAZE_VAR);
    
    sc = 1;
    for SUBJ = SUB_LIST
        disp(['Working on subject ' num2str(SUBJ) ' (' num2str(sc) '/' num2str(length(SUB_LIST)) ')']);
        
        % check if gaze resolution needs to be adjusted
        try
            frame_res = get_frame_resolution_for_subject(SUBJ, GAZE_VAR);
            res_fac = [1 1];
            if ~all(frame_res == TARGET_RESOLUTION)
                disp('Eye gaze resolution for this subject DOES NOT fit target resolution. Eye gaze will be resized.');
                res_fac = TARGET_RESOLUTION ./ frame_res;
            end
        catch
            warning('Cannot retrive_target rsolution, use default: [640 480]')
            res_fac = [1 1];
        end
        
        % get gaze data
        gaze = get_variable_by_trial(SUBJ, ['cont2_eye_xy_' SUBJECT]);
        num_trials = length(gaze);
        
        % get event data (if required) 
        if ~strcmp(EVENT_VAR, 'no_event')
            event = get_variable_by_trial(SUBJ, EVENT_VAR);

        	% negate event
            if NEGATE_EVENT
        		trial_times = get_trial_times(SUBJ);
        		for t = 1:num_trials
        			event{t} = event_NOT(event{t}, trial_times(t, :));
        		end
        	end
        end

        % pre allocate heat map for all n trials
        gaze_data = struct('num_frames', {}, 'gaze_map', {});
        
        % go over each trial
        for tr = 1:num_trials
            if ~strcmp(EVENT_VAR, 'no_event')
                ev = event{tr};
            end
            ga = gaze{tr};
            
            % get rid of NaNs
            nan_i = isnan(ga(:,1)) | isnan(ga(:,2)) | isnan(ga(:,3));
            ga(nan_i, :) = [];
            
            % scale to target resolution
            res_fac_m = repmat(res_fac, size(ga,1), 1);
            ga(:,2:3) = ga(:,2:3) .* res_fac_m;
            
            % translate such that trial mean is centered
%             t = [TARGET_RESOLUTION(1)/2-mean(ga(:,3)) TARGET_RESOLUTION(2)/2-mean(ga(:,2))];
%             ga(:,3) = ga(:,3) + t(1);
%             ga(:,2) = ga(:,2) + t(2);
            
            % only use gaze during event (if required)
            if ~strcmp(EVENT_VAR, 'no_event')
                event_i = false(size(ga, 1), 1);
                for e = 1:size(ev, 1)
                   event_i(ga(:,1) >= ev(e,1) & ga(:,1) <= ev(e,2)) = 1;
                end
                ga = ga(event_i, :);
            end
            
            % turn list of 2d points into map
            map = gaze_points_to_2d_distribution(ga, TARGET_RESOLUTION);

            % store data
            gaze_data(tr).num_frames = size(ga, 1);
            gaze_data(tr).gaze_map = map; 
        end

        draw_and_save_heatmap_image(SUBJ, gaze_data, FOLDER, EVENT_VAR, SUBJECT, num_trials, TARGET_RESOLUTION, NEGATE_EVENT);
        
        sc = sc + 1;
    end
    %visualize_overall_map(all_gaze_maps, EVENT_VAR, TARGET_RESOLUTION);
    
end

function [] = visualize_overall_map(all_gaze_maps, EVENT_VAR, TARGET_RESOLUTION)
    % add up all heat maps
    master_map.no_event = zeros(TARGET_RESOLUTION);
    for s = 1:length(all_gaze_maps)
        master_map.no_event = master_map.no_event + all_gaze_maps(s).no_event;
    end
    if ~strcmp(EVENT_VAR, 'no_event')
        master_map.event = zeros(TARGET_RESOLUTION);
        for s = 1:length(all_gaze_maps)
            master_map.event = master_map.event + all_gaze_maps(s).event;
        end
    end
    

    if strcmp(EVENT_VAR, 'no_event')
        imshow(turn_into_heatmap_img(master_map.no_event));
        title(['Gaze map for ' num2str(length(all_gaze_maps)) ' subjects)']);
    else
        subplot(1,2,1);
        %imagesc(master_map.event);
        imshow(turn_into_heatmap_img(master_map.event));
        title(['Gaze map (' num2str(length(all_gaze_maps)) ' subjects) during ' strrep(EVENT_VAR, '_', '-')]);
        subplot(1,2,2);
        %imagesc(master_map.no_event);
        imshow(turn_into_heatmap_img(master_map.no_event));
        title(['Gaze map (' num2str(length(all_gaze_maps)) ' subjects) otherwise']);
    end
end

function img = turn_into_heatmap_img(dist)
    
    % first blurr 
    H = fspecial('gaussian', [20 20], 5);
    dist = imfilter(dist, H);
    
    m = max(dist(:));
    img = ind2rgb(gray2ind(uint8(255*dist/m), 255), jet(255));
end

function map = gaze_points_to_2d_distribution(points, target_resolution)
    map = zeros(target_resolution);
    for g = 1:length(points)
        r = round(points(g, 3));
        c = round(points(g, 2));
        r = min(max(1,r), target_resolution(1));
        c = min(max(1,c), target_resolution(2));
        map(r,c) = map(r,c) + 1;
    end
end

function frame_res = get_frame_resolution_for_subject(SUBJ, CONT_VAR)
    
    subj_dir = get_subject_dir(SUBJ);
    
    child_or_parent = strsplit(CONT_VAR);
    child_or_parent = child_or_parent{end};
    
    if strcmp(child_or_parent, 'child')
        jpg_folder = fullfile(subj_dir, 'cam07_frames_p');   % cam07 = child, cam08 = parent
    else
        jpg_folder = fullfile(subj_dir, 'cam07_frames_p');
    end
    %jpg_list = dir(fullfile(jpg_folder, 'img_*.jpg'));  % hard coding
    
    trials = get_trials(SUBJ);
    for i = 1:trials(1,2)
        im_src = fullfile(jpg_folder, ['img_' num2str(i) '.jpg']);
        if exist(im_src, 'file') == 2
            img = imread(im_src);
            break;
        end
    end
    
    frame_res = size(img(:,:,1));
end

function SUB_LIST = get_subjects_with_event(EXP_LIST, EVENT)

    if size(EXP_LIST, 2) == 1
        EXP_LIST = EXP_LIST';
    end

    if strcmp(EVENT, 'no_event')
        if length(num2str(EXP_LIST(1))) == 4
            SUB_LIST = EXP_LIST;
        else
            SUB_LIST = list_subjects(EXP_LIST);
        end
    else
        if length(num2str(EXP_LIST(1))) == 4
            SUB_LIST = [];
            for s = EXP_LIST
               if has_variable(s, EVENT)
                   SUB_LIST = [SUB_LIST s];
               end
            end
        else
            SUB_LIST = find_subjects(EVENT, EXP_LIST);
        end
    end

    disp(['Found a total of ' num2str(length(SUB_LIST)) ' subjects with EVENT = ' num2str(EVENT)]);
end

function [SUB_LIST_OUT] = get_subjects_with_cont_data(SUB_LIST_IN, CONT_VAR)
    SUB_LIST_OUT = [];
    
    if size(SUB_LIST_IN, 2) == 1
        SUB_LIST_IN = SUB_LIST_IN';
    end
        
    for s = SUB_LIST_IN
        try 
            if has_variable(s, CONT_VAR)
                SUB_LIST_OUT = [SUB_LIST_OUT s];
            end
        catch
            warning([get_subject_dir(s) ' does not exist'])
        end
    end
    
    disp(['Of those, found a total of ' num2str(length(SUB_LIST_OUT)) ' subjects with CONT VAR = ' CONT_VAR]);    
end

function subj = get_subject_infos(subj)
	trials = get_trials(subj.id);
    subj.num_trials = size(trials,1);

    %build image path
    subj.img_path = fullfile(get_subject_dir(subj.id), subj.folder);

    %get num/cols for maps
    frame_1 = num2str(trials(1,1));
    [subj.n_rows, subj.n_cols] = size(logical(imread([subj.img_path '/img_' frame_1 '_seg.' subj.ext])/255));
end

%function [] = draw_and_save_heatmap_image(subj, maps, FOLDER, CEVENT_VAR, SUBJECT)
function [] = draw_and_save_heatmap_image(SUBJ, gaze_data, FOLDER, EVENT_VAR, SUBJECT, num_trials, TARGET_RESOLUTION, NEGATE_EVENT)

	%create heatmap image
	f = figure;
	for tr = 1:num_trials+1
		% get map for current trial (or add all maps up for the last heat map)
	    if tr == num_trials+1
	        map = zeros(TARGET_RESOLUTION(1), TARGET_RESOLUTION(2));
	        num_frames = 0; 
	        for numtr = 1:num_trials
	            map = map + gaze_data(numtr).gaze_map;
	            num_frames = num_frames + gaze_data(numtr).num_frames;
	        end
	    else
	        map = gaze_data(tr).gaze_map;
	        num_frames = gaze_data(tr).num_frames;
	    end

	    % create heat map image for taget and distractor
        img = turn_into_heatmap_img(map);

	    % plot image at the right place
	    if tr == num_trials+1
	        subplot(3,2, [5,6]);
	        subimage(imresize(img, 2));
	    else
	        subplot(3,2, tr);
	        subimage(img);
	    end

	    % get number of seconds going into each heat map
	    t_info = get_timing(SUBJ);
	    secs = round(num_frames * 1/t_info.camRate);

	    % label things
	    if tr == num_trials+1
	        title(['ALL TRIALS (' num2str(secs) ' secs)'], 'FontSize', 16);
	    else
	        title(['Trial ' num2str(tr) ' (' num2str(secs) ' secs)'], 'FontSize', 14);
	    end
	    axis off;
	end
	if NEGATE_EVENT
		neg = ' NOT';
	else
		neg = '';
	end
	mtit([num2str(SUBJ) ', ' SUBJECT ' view'], 'FontSize', 16, 'xoff', 0, 'yoff', 0.03, 'zoff', 0);

	%set up width/height ratio for saved figure
	set(f, 'PaperPositionMode', 'manual');
	set(f, 'PaperUnits', 'inches');
	set(f, 'PaperPosition', [0 0 10 10]);

	%create save directory 
	exp_str = num2str(SUBJ);
	save_dir = ['C:/bell/multiwork/data_vis_new/heatmap_1/' FOLDER '/'];
	if ~exist(save_dir)
	    mkdir(save_dir);
	end

	if NEGATE_EVENT
		neg = 'NOT_';
	else
		neg = '';
    end
    try
        print(f, [save_dir num2str(SUBJ) '_eyegaze_' lower(SUBJECT) 'view.png'], '-dpng');
    catch
        warning([num2str(SUBJ) lower(SUBJECT) 'view.png cannot be saved'])
    end
% 	save([save_dir num2str(SUBJ) '_eyegaze_' EVENT_VAR '_' neg lower(SUBJECT) 'view.mat'], 'gaze_data');
    close all
end