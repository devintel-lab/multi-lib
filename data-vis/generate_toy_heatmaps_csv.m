function [SUB_LIST] = generate_toy_heatmaps_csv(SUBJECT, FOLDER, CSV_FILE, COLS, NUM_HEAD, CEVENT_NAME)
%GENERATE_TOY_HEATMAPS Summary of this function goes here
%   This functions generates spatial heatmaps of the toy objects,
%   conditioned on the cevent read from the CSV file
%   -   Images are saved under
%       /ein/multiwork/experiment_XX/included/data_vis/FOLDER/
%   -   A .mat file with the raw heatmap data is saved at the same place
%   Function Arguments:
%   -   SUBJECT: string saying either 'child' (default) or 'parent' --
%       determines whether the heatmaps are from the child's or the
%       parent's view
%   -   CSV_FILE: path the CSV file that cointains CEVENT-like data
%   -   COLS: columns of the CS that contian CEVENT (must be 
%       [subject_id onset offset category], default is 1:4
%   -   NUM_HEAD: number of lines in the CSV files with header info,
%       i.e. number of lines to skip (default: 2)
%   -   CEVENT_NAME: string that descibes the CEVENT (default: 'CSV_event')
    
    addpath('supporting_functions');

    if nargin < 6
        CEVENT_NAME = 'CSV_event';
    end
    if nargin < 5
        NUM_HEAD = 2;
    end
    if nargin < 4
        COLS = 1:4;
    end
    if nargin < 3
        error('Need at least 3 arguments: subject, folder, csv file');
    end

    disp(CSV_FILE);
    disp(COLS);
    disp(NUM_HEAD);

    % get a struct with all subject_ids and cevents from CSV file
    CEVENTS = get_cevents_from_csv(CSV_FILE, COLS, NUM_HEAD);
    
    % for each subject, check if a mask image exists (and store where)
    % also copy CEVENT(x).cevent to corresponding SUB_LIST(x).cevent
    SUB_LIST = get_subjects_with_toy_masks(CEVENTS, SUBJECT);

    % go over all subjects and create toy view heatmaps based on cevent
    for subj = SUB_LIST

		disp(['Working on subject ' num2str(subj.id) ' (This is slow as it takes about 40ms to read in each toy image mask...)']);

    	% get cevent vatiable
        %CEVENT = get_variable(subj.id, CEVENT_VAR);
        CEVENT = subj.cevent;

        % create frame to target/distractor mapping, e.g. FRAME_MAPPING = 
        % frame toy1 toy2 toy3
    	% 1234  0    0    1
    	% 1235  0    1    0
        FRAME_MAPPING = get_frame_to_target_mapping(subj, CEVENT);

        % get necessary subject infos: subj.num_trials, subj.img_path, subj.n_rows, subj.n_cols
        subj = get_subject_infos(subj);

        % initialize heatmap structs
        for tr = 1:subj.num_trials
            maps(tr).target_map = zeros(2*subj.n_rows, 2*subj.n_cols);
            maps(tr).dist_map = zeros(2*subj.n_rows, 2*subj.n_cols);
            maps(tr).num_frames = 0;
        end

        % go over all cevent frames
        parfor_progress(length(FRAME_MAPPING(:,1)'));
        f_idx = 1;
        for frame = FRAME_MAPPING(:,1)'

        	img_src = [subj.img_path '/img_' num2str(frame) '_seg.' subj.ext];  
            if exist(img_src, 'file')
                
                parfor_progress();

                % get mask image
                toys = logical(imread(img_src)/255);
                toys(subj.n_rows/2, :) = 0;
                toys(:, subj.n_cols/2) = 0;

                % crop out the right toy from the mask image and scale it back up
                blue_toy_mask = imresize(toys(1:subj.n_rows/2, subj.n_cols/2+1:subj.n_cols), [2*subj.n_rows 2*subj.n_cols], 'nearest');
                green_toy_mask = imresize(toys(subj.n_rows/2+1:subj.n_rows, 1:subj.n_cols/2), [2*subj.n_rows 2*subj.n_cols], 'nearest');
                red_toy_mask = imresize(toys(subj.n_rows/2+1:subj.n_rows, subj.n_cols/2+1:subj.n_cols), [2*subj.n_rows 2*subj.n_cols], 'nearest');

                % get current trial
                tr = get_current_trial(subj, frame);

                % add the toy either to the target or the distractor heat map
                if FRAME_MAPPING(f_idx, 2)
                    maps(tr).target_map= maps(tr).target_map+ blue_toy_mask;
                else
                    maps(tr).dist_map = maps(tr).dist_map + blue_toy_mask;
                end
                if FRAME_MAPPING(f_idx, 3)
                    maps(tr).target_map = maps(tr).target_map + green_toy_mask;
                else
                    maps(tr).dist_map = maps(tr).dist_map + green_toy_mask;
                end
                if FRAME_MAPPING(f_idx, 4)
                    maps(tr).target_map = maps(tr).target_map + red_toy_mask;
                else
                    maps(tr).dist_map = maps(tr).dist_map + red_toy_mask;
                end

                % increase frame count
                maps(tr).num_frames = maps(tr).num_frames + 1;
            end
            f_idx = f_idx + 1;
        end

        draw_and_save_heatmap_image(subj, maps, FOLDER, CEVENT_NAME, SUBJECT);

        parfor_progress(0);
    end

end


function SUB_LIST_OUT = get_subjects_with_toy_masks(CEVENTS, SUBJECT)

    SUB_LIST_IN = [];
    for s = 1:length(CEVENTS)
        s = CEVENTS(s).subj_id;
        SUB_LIST_IN = [SUB_LIST_IN; s];
    end

	SUB_LIST_OUT = [];
    subj_i = 1;
    cev_i = 1;
    disp('Finding subset of subjects with toy mask.');
    for subj = SUB_LIST_IN'

    	%possible folders to check
        if strcmp(SUBJECT, 'child')
            input_image_folder = {'cam01_frames_p', 'cam07_frames_p'};
        else
            input_image_folder = {'cam02_frames_p', 'cam08_frames_p'};
        end
    
    	%possible file extensions to check
    	file_extensions = {'png', 'jpg', 'jpeg', 'tif', 'tiff'};
    
    	%check files and store info
    	for imfo = 1:length(input_image_folder)
    		for fiex = 1:length(file_extensions)
    			frame_1 = get_trials(subj);
    			frame_1 = num2str(frame_1(1,1));
    			if exist([fullfile(get_subject_dir(subj), input_image_folder{imfo}) '/img_' frame_1 '_seg.' file_extensions{fiex}], 'file')
    				SUB_LIST_OUT(subj_i).id = subj;
    				SUB_LIST_OUT(subj_i).folder = input_image_folder{imfo};
    				SUB_LIST_OUT(subj_i).ext = file_extensions{fiex};
                    SUB_LIST_OUT(subj_i).cevent = CEVENTS(cev_i).cevent;
    				subj_i = subj_i + 1;
    				break;
    			end
    		end
    	end
        cev_i = cev_i + 1;
    end
    disp(['Found a total of ' num2str(length(SUB_LIST_OUT)) ' subjects.']);
end

function FRAME_MAPPING = get_frame_to_target_mapping(subj, CEVENT)
    %turn times into frame numbers
    CEVENT = [time2frame_num(CEVENT(:,1:2), subj.id) CEVENT(:, 3)];

    %get all frames with a cevent and store which toys are involved
    %i.e. the following two loops create a matrix of the form
    % frame toy1 toy2 toy3
    % 1234  0    0    1
    FRAME_MAPPING = [];
    for ev_idx = 1:size(CEVENT, 1)
    	if CEVENT(ev_idx, 3) >= 0 && CEVENT(ev_idx, 3) < 4 %only care about toys (e.g. number 1 - 3), no faces (4) or other things...
        	FRAME_MAPPING = union(FRAME_MAPPING, CEVENT(ev_idx, 1):CEVENT(ev_idx, 2));
        end
    end
    FRAME_MAPPING = [FRAME_MAPPING zeros(length(FRAME_MAPPING), 3)];
    for ev_idx = 1:size(CEVENT, 1)
    	if CEVENT(ev_idx, 3) >= 0 && CEVENT(ev_idx, 3) < 4 %only care about toys (e.g. number 1 - 3), no faces (4) or other things...
            from = find(FRAME_MAPPING(:,1) == CEVENT(ev_idx, 1));
            to = find(FRAME_MAPPING(:,1) == CEVENT(ev_idx, 2));
            FRAME_MAPPING(from:to, CEVENT(ev_idx, 3)+1) = 1;
        end
    end
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

function trial = get_current_trial(subj, frame)
	trials = get_trials(subj.id);
	trial = 1;
	for tnum = 2:subj.num_trials
		if frame >= trials(tnum, 1)
			trial = tnum;
		end
	end
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