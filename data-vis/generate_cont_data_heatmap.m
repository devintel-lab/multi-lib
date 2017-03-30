function [all_gaze_maps] = generate_cont_data_heatmap(EXP_LIST, CONT_VAR, FOLDER, EVENT_VAR, TARGET_RESOLUTION)

    addpath('supporting_functions');
    
    if nargin < 4
        EVENT_VAR = 'no_event';
    end
    if nargin < 5
        TARGET_RESOLUTION = [480 640];
    end
    
    % get all subjects that have EVENT/CEVENT variable
    SUB_LIST = get_subjects_with_event(EXP_LIST, EVENT_VAR);
    
    % for each subject, check if it has the CONT DATA variable
    [SUB_LIST] = get_subjects_with_cont_data(SUB_LIST, CONT_VAR);
    
    % pre allocate struct array that will store per-subject heat maps...
    all_gaze_maps = struct('event', {}, 'no_event', {});
    
    sc = 1;
    for SUBJ = SUB_LIST
        disp(['Working on subject ' num2str(SUBJ) ' (' num2str(sc) '/' num2str(length(SUB_LIST)) ')']);
        
        % check if gaze resolution needs to be adjusted
        frame_res = get_frame_resolution_for_subject(SUBJ, CONT_VAR);
        res_fac = [1 1];
        if ~all(frame_res == TARGET_RESOLUTION)
            disp('Eye gaze resolution for this subject DOES NOT fit target resolution. Eye gaze will be resized.');
            res_fac = TARGET_RESOLUTION ./ frame_res;
        end
        
        % get gaze data
        gaze = get_variable_by_trial(SUBJ, CONT_VAR);
        
        % get event data (if required) 
        if ~strcmp(EVENT_VAR, 'no_event')
            event = get_variable_by_trial(SUBJ, EVENT_VAR);
        end
        
        % pre allocate heat map
        all_gaze_maps(sc).no_event = zeros(TARGET_RESOLUTION);
        if ~strcmp(EVENT_VAR, 'no_event')
            all_gaze_maps(sc).event = zeros(TARGET_RESOLUTION);
        end
        
        % go over each trial
        for tr = 1:length(gaze)
            if ~strcmp(EVENT_VAR, 'no_event')
                ev = event{tr};
            end
            ga = gaze{tr};
            
            % get rid of NaNs
            nan_i = isnan(ga(:,1)) | isnan(ga(:,2));
            ga(nan_i, :) = [];
            
            % scale to target resolution
            res_fac_m = repmat(res_fac, size(ga,1), 1);
            ga(:,2:3) = ga(:,2:3) .* res_fac_m;
            
            % translate such that trial mean is centered
            t = [TARGET_RESOLUTION(1)/2-mean(ga(:,3)) TARGET_RESOLUTION(2)/2-mean(ga(:,2))];
            ga(:,3) = ga(:,3) + t(1);
            ga(:,2) = ga(:,2) + t(2);
            
            % split gaze into event and non event (if required)
            if ~strcmp(EVENT_VAR, 'no_event')
                event_i = false(size(ga, 1), 1);
                for e = 1:size(ev, 1)
                   event_i(ga(:,1) >= ev(e,1) & ga(:,1) <= ev(e,2)) = 1;
                end
                gaze_event = ga(event_i, :);
                gaze_no_event = ga(~event_i, :);
            else
                gaze_no_event = ga;
            end
            
            map = gaze_points_to_2d_distribution(gaze_no_event, TARGET_RESOLUTION);
            all_gaze_maps(sc).no_event = all_gaze_maps(sc).no_event + map;
            
            if ~strcmp(EVENT_VAR, 'no_event')
                map = gaze_points_to_2d_distribution(gaze_event, TARGET_RESOLUTION);
                all_gaze_maps(sc).event = all_gaze_maps(sc).event + map;
            end
        end

        draw_and_save_heatmap_image(SUBJ, all_gaze_maps(sc), FOLDER, EVENT_VAR, 'child')
        
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
        if has_variable(s, CONT_VAR)
            SUB_LIST_OUT = [SUB_LIST_OUT s];
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


function [] = draw_and_save_heatmap_image(subj, maps, FOLDER, CEVENT_VAR, SUBJECT)

	%create heatmap image
	f = figure;
	for tr = 1:subj.num_trials+1
		% get map for current trial (or add all map up for the last heat map)
	    if tr == subj.num_trials+1
	        target_map = zeros(size(maps(1).target_map));
	        dist_map = target_map;
	        num_frames = 0; 
	        for numtr = 1:subj.num_trials
	            target_map = target_map + maps(numtr).target_map;
	            dist_map = dist_map + maps(numtr).dist_map;
	            num_frames = num_frames + maps(numtr).num_frames;
	        end
	    else
	        target_map = maps(tr).target_map;
	        dist_map = maps(tr).dist_map;
	        num_frames = maps(tr).num_frames;
	    end

	    % create heat map image for taget and distractor
	    m = max(target_map(:));
	    img_tar = ind2rgb(gray2ind(uint8(255*target_map/m), 255), jet(255));
	    m = max(dist_map(:));
	    img_dis = ind2rgb(gray2ind(uint8(255*dist_map/m), 255), jet(255));
	    img = cat(2, img_tar, img_dis);
	    img(:, 2*subj.n_cols-2:2*subj.n_cols+2, :) = 255;

	    % plot image at the right place
	    if tr == subj.num_trials+1
	        subplot(3,2, [5,6]);
	        subimage(imresize(img, 2));
	    else
	        subplot(3,2, tr);
	        subimage(img);
	    end

	    % get number of seconds going into each heat map
	    t_info = get_timing(subj.id);
	    secs = round(num_frames * 1/t_info.camRate);

	    % label things
	    if tr == subj.num_trials+1
	        title(['ALL TRIALS, left: target, right: distractor (' num2str(secs) ' secs)'], 'FontSize', 16);
	    else
	        title(['Trial ' num2str(tr) ', left: target, right: distractor (' num2str(secs) ' secs)'], 'FontSize', 14);
	    end
	    axis off;
	end
	mtit([num2str(subj.id) ', ' strrep(CEVENT_VAR, '_', ' ') ', child view'], 'FontSize', 16);

	%set up width/height ratio for saved figure
	set(f, 'PaperPositionMode', 'manual');
	set(f, 'PaperUnits', 'inches');
	set(f, 'PaperPosition', [0 0 10 10]);

	%create save directory 
	exp_str = num2str(subj.id);
	save_dir = ['/ein/multiwork/experiment_' exp_str(1:2) '/included/data_vis/' FOLDER '/'];
	if ~exist(save_dir)
	    mkdir(save_dir);
	end

	print(f, [save_dir num2str(subj.id) '_' CEVENT_VAR '_' lower(SUBJECT) 'view.png'], '-dpng');
	save([save_dir num2str(subj.id) '_' CEVENT_VAR '_' lower(SUBJECT) 'view.mat'], 'maps');
end