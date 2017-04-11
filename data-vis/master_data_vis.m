function exceptions = master_data_vis(IDs, option, args)
% official [1 2 3 4 5]
% 1 object_size_eye
% 2 motion
% 3 eye_inhand_joint
% 4 inhand-eye_coordination
% 5 naming_holding_vision_gaze

if ~exist('IDs', 'var') || isempty(IDs)
    IDs = 'all';
end

if ~exist('option', 'var') || isempty(option)
     option = [3 4 5];
     args.print = 1;
%option = 99;
end

if numel(option) > 1
    exceptions = {};
    for o = 1:numel(option)
        exceptions{o,1} = master_data_vis(IDs, option(o), args);
    end
    if isempty(exceptions)
        disp('No exceptions');
    end
    if nargin < 1
%         exit();
    else
        return
    end
end

sub_list = cIDs(IDs);

if option == 99
    sub_list = [4301 4302];
    option = 4;
end

% clear
% sub_list = 7002;
% option = 5;

%default args
args.legend = {'blue object'; 'green object'; 'red object'; 'face'};
args.row_text_type = 'time';

args.colormap = { ...
    [0 0 1]% 1 BLUE
    [0 1 0] % 2 GREEN (pale)
    [1 0 0] % 3 RED
    [1 0 1] % 4 MAGENTA (pale)
    [0 0 0] % 5 BLACK
    [1 1 0] % 6 YELLOW (pale)
    [0 1 1] % 7 CYAN
    [0 0.75 0.75] % 8 TURQUOISE
    [0 0.5 0] % 9 GREEN (dark)
    [0.75 0.75 0] % 10 YELLOW (dark)
    [1 0.50 0.25] % 11 ORANGE
    [0.75 0 0.75] % 12 MAGENTA (dark)
    [.25 .5 1] % 13 COBOLT
    [0.6 1 0.6] % 14 GREEN (pale)
    [0.5 0 0]; % 15 RED (dark)
    [0 0 .5]; % 16 BLUE (dark)
    [0.4784 0.0627 0.8941]; % 17 VIOLET
    [0.5020 0.5020 0.5020]; % 18 GRAY
    [0.7490 0.7490 0]; % 19 OLIVE
    [1 0.6941 0.3922]; % 20 PEACH
    [0.3216 0.1882 0.1882]; % 21 CHOCOLATE
    [1 0.6 0.7843]; % 22 PINK
    [0.8549 0.7020 1]; % 23 LAVENDER
    [0.6824 0.4667 0]; % 24 LIGHT BROWN
    };
args.colormap = vertcat(args.colormap{:});
args.colormap = set_colors();

switch option
    
    case 1
        main_module = 'object_size_eye';
        dname = 'cont_1';
        var_name_list = {
            'cont_vision_size_obj1_child';
            'cont_vision_size_obj2_child';
            'cont_vision_size_obj3_child';
            'cevent_eye_roi_child';
            'cevent_eye_roi_parent';
            'cont_vision_size_obj1_parent';
            'cont_vision_size_obj2_parent';
            'cont_vision_size_obj3_parent';
            'cevent_speech_naming_local-id';
            };
        args.var_text = {'child 1-size', 'child 2-size', 'child 3-size', 'child eye', ...
            'parent eye', 'parent 1-size', 'parent 2-size', 'parent 3-size', 'naming'};
        
        args.convert_max_int = 100;
        args.cont_data_max = [8 8 8 nan nan 8 8 8 nan];
        args.cont_color_str = {'blue', 'green', 'red', '', '', 'blue', 'green', 'red', ''};
    
    case 2
        main_module = 'motion';
        dname = 'cont_2';
        var_name_list = {
            'cont_motion_pos-speed_left-hand_child';
            'cont_motion_pos-speed_right-hand_child';
            'cont_motion_pos-speed_head_child';
            'cont_motion_pos-speed_head_parent';
            'cont_motion_pos-speed_left-hand_parent';
            'cont_motion_pos-speed_right-hand_parent';
            'cont_motion_rot-speed_head_child';
            'cont_motion_rot-speed_head_parent';
            'event_motion_rot_head_moving_child';
            'event_motion_rot_head_moving_parent';
            
            };
        args.var_text = {'child left pos', 'child right pos', 'child head pos', ...
            'parent head pos', 'parent left pos', 'parent right pos',...
            'child head rot', 'parent head rot', 'child head moving', 'parent head moving'};
        args.convert_max_int = 100;
        args.cont_data_max = [10 10 6 6 10 10 55 55 nan nan];
        args.cont_color_str = {'blue', 'blue', 'red', 'red', 'blue',...
            'blue', 'green', 'green', 'red', 'red', '', ''};
        
    case 3
        main_module = 'eye_inhand_joint';
        dname = 'cstream_1';
        var_name_list = {
            'cevent_eye_roi_child';
            'cevent_eye_roi_parent';
            'cstream_inhand_left-hand_obj-all_child';
            'cstream_inhand_right-hand_obj-all_child';
            'cstream_inhand_left-hand_obj-all_parent';
            'cstream_inhand_right-hand_obj-all_parent';
            'cevent_eye_joint-attend_both';
            'cevent_eye_synched-attend_both';
            'cevent_vision_size_obj-dominant_child';
            'cevent_speech_utterance';
            };
        args.var_text = {'child eye', 'parent eye', 'child left', 'child right', ...
            'parent left', 'parent right', 'joint-attend', 'joint-synched', 'child dominant', 'naming'};
        
    case 4
        main_module = 'inhand-eye_coordination';
        dname = 'cstream_2';
        var_name_list = {
            'cevent_inhand-eye_child-child'
            'cevent_inhand-eye_parent-child'
            'cevent_inhand-eye_parent-parent'
            'cevent_inhand-eye_child-parent'
            'cevent_eye_joint-attend_both'
            'cevent_eye_synched-attend_both'
            'cevent_speech_utterance'
            };
        args.var_text = {'child-eye/child-hand', 'child-eye/parent-hand', ...
            'parent-eye/parent-hand', 'parent-eye/child-inhand', 'joint-attend',...
            'synched-attend', 'naming'};
    case 5
        main_module = 'naming_holding_vision_gaze';
        dname = 'cstream_cont_1';
        var_name_list = {
            'cevent_eye_roi_child';
            'cevent_eye_roi_parent';
            'cevent_eye_joint-attend_both';
            'cstream_inhand_left-hand_obj-all_child';
            'cstream_inhand_right-hand_obj-all_child';
            'cstream_inhand_left-hand_obj-all_parent';
            'cstream_inhand_right-hand_obj-all_parent';
            'cont_vision_size_obj1_child';
            'cont_vision_size_obj2_child';
            'cont_vision_size_obj3_child';
            'cevent_speech_utterance';
            };
        args.var_text = {'child eye', 'parent eye', 'sust JA', ...
            'child L-hand', 'child R-hand', 'parent L-hand', 'parent R-hand', ...
            'child size1', 'child size2', 'child size3', 'naming'};
        
        args.convert_max_int = 100;
        args.cont_data_max = [NaN,NaN,NaN,NaN,NaN,NaN,NaN,8,8,8,NaN];
        args.cont_color_str = {'', '', '', '', '', '', '', 'blue', 'green', 'red', ''};

        %% Not official  =========================     
    case 6
        % for Steven
        main_module = 'eye_inhand_JA';
        dname = 'cstream';
        var_name_list = {
            'cevent_eye_roi_child';
            'cevent_eye_roi_parent';
            'cstream_inhand_left-hand_obj-all_child';
            'cstream_inhand_right-hand_obj-all_child';
            'cstream_inhand_left-hand_obj-all_parent';
            'cstream_inhand_right-hand_obj-all_parent';
            'cevent_eye_joint-attend_both'
            'cevent_eye_synched-attend_both'
            };
        args.var_text = {'child eye', 'parent eye', ...
            'child left', 'child right', 'parent left', 'parent right',...
            'joint-attend', 'synched-attend'};
        root = '/scratch/sbf/data_vis_testing/';
        
    case 7
        main_module = 'responsivity';
        dname = 'responsivity';
        var_name_list = {
            'cstream_inhand_left-hand_obj-all_child';
            'cstream_inhand_right-hand_obj-all_child';
            'cstream_eye_roi_child';
            {'cevent_macro_action-response_all_child', {1,6}};
            {'cevent_macro_action-response_all_child', {3,8}};
            {'cevent_macro_action-response_all_child', {[2,4,5], [7,9,10]}};
            {'cevent_macro_action-response_clean_onset-onset_both', {'all', 5}};
            {'cevent_macro_action-response_all-clean_parent', {1:7, 11:17}};
            'cstream_eye_roi_parent';
            'cstream_inhand_left-hand_obj-all_parent';
            'cstream_inhand_right-hand_obj-all_parent';};
        
        args.var_text = {'child left', 'child right', 'child eye', 'child bid', 'child vocal', 'child action', 'onset-onset', 'parent response', 'parent eye', 'parent left', 'parent right'};
        args.legend = {'blue object'; 'green object'; 'red object'; 'face'; 'binary'; ...
            '   bids'; '   explore'; '   vocal'; '   play'; '   distracted';...
            '      affirmations'; '      imitations'; '      descriptions'; '      questions'; '      play'; '      explore'; '      attention';};
        root = '/scratch/sbf/responsive_graphs/stream_plots';
        create_gap = 1;
    case 8
        var_name_list = {
            'cstream_inhand_left-hand_obj-all_child';
            'cstream_inhand_right-hand_obj-all_child';
            'cstream_eye_roi_child';
            {'cevent_macro_action-response_all_child', {1,6}};
            {'cevent_macro_action-response_all_child', {3,8}};
            {'cevent_macro_action-response_all_child', {[2,4,5], [7,9,10]}};
            {'cevent_macro_action-response_no-response_child', {'all', 5}};
            {'cevent_macro_action-response_all-clean_parent', {1:7, 11:17}};
            'cstream_eye_roi_parent';
            'cstream_inhand_left-hand_obj-all_parent';
            'cstream_inhand_right-hand_obj-all_parent';};
        
        main_module = 'no-response';
        dname = 'no-response';
        args.var_text = {'child left', 'child right', 'child eye', 'child bid', 'child vocal', 'child action', 'no-response', 'parent response', 'parent eye', 'parent left', 'parent right'};
        args.legend = {'blue object'; 'green object'; 'red object'; 'face'; 'binary'; ...
            '   bids'; '   explore'; '   vocal'; '   play'; '   distracted';...
            '      affirmations'; '      imitations'; '      descriptions'; '      questions'; '      play'; '      explore'; '      attention';};
        create_gap = 1;
        root = '/scratch/sbf/responsive_graphs/stream_plots';
        
    case 9
        var_name_list = {
            {'cevent_macro_action-response_no-response_child', {1:5, repmat(2,1,5)}};
            {'cevent_macro_action-response_with-response_child', {1:5 , repmat(1,1,5)}};
            {'cevent_macro_action-response_clean_onset-onset_both', {'all', 3}};
            {'cevent_macro_action-response_all-clean_parent', {1:7, 4:10}}
            };
        
        dname = 'has_response';
        main_module = 'has_response';
        args.var_text = {'no response', 'with response', 'onset-onset', 'parent response'};
        args.legend = {'with response'; 'no response'; 'onset-onset';...
            '      affirmations'; '      imitations'; '      descriptions'; '      questions'; '      play'; '      explore'; '      attention'};
        
        args.colormap = { ...
            [0 0 1]% 1 BLUE
            [0 1 0] % 2 GREEN (pale)
            [1 0 0] % 3 RED
            [1 0.50 0.25] % 11 ORANGE
            [0.75 0 0.75] % 12 MAGENTA (dark)
            [.25 .5 1] % 13 COBOLT
            [0.6 1 0.6] % 14 GREEN (pale)
            [0.5 0 0]; % 15 RED (dark)
            [0 0 .5]; % 16 BLUE (dark)
            [0.4784 0.0627 0.8941]}; % 17 VIOLET
        args.colormap = vertcat(args.colormap{:});
        root = '/scratch/sbf/responsive_graphs/stream_plots';
        create_gap = 1;
        
    case 10
        var_name_list = {
            'cevent_inhand-eye_child-child'
            'cevent_inhand-eye-sustained_child-child'
            'cevent_inhand-eye_child-parent'
            'cevent_inhand-eye-sustained_child-parent'
            'cevent_inhand-eye_parent-child'
            'cevent_inhand-eye-sustained_parent-child'
            'cevent_inhand-eye_parent-parent'
            'cevent_inhand-eye-sustained_parent-parent'
            'cevent_vision_size_obj-dominant_child'
            'cevent_vision_size_obj-dominant-sustained_child'
            'cevent_eye_roi_child';
            'cevent_eye_roi_sustained-3s_child'};
        dname = 'sustained';
        main_module = 'sustained';
        root = '/scratch/sbf/testing_sustained';
        args.var_text = {'c hand / c eye', 'sustained', 'c hand / p eye', 'sustained',...
            'p hand / c eye', 'sustained', 'p hand / p eye', 'sustained',...
            'dom child', 'sustained dom', 'c eye', 'sustained eye'};
        args.legend = {'obj1', 'obj2', 'obj3', 'face'};
      
    case 11
        
        main_module = 'eye_inhand_inmouth';
        dname = 'inmouth';
        var_name_list = {
            'cevent_eye_roi_child';
            'cevent_eye_roi_parent';
            'cstream_inhand_left-hand_obj-all_child';
            'cstream_inhand_right-hand_obj-all_child';
            'cstream_inhand_left-hand_obj-all_parent';
            'cstream_inhand_right-hand_obj-all_parent';
            'cevent_eye_joint-attend_both';
            'cevent_vision_size_obj-dominant_child'
            'cevent_speech_naming_local-id';
            'cevent_inmouth_all_child'
            };
        args.var_text = {'child eye', 'parent eye', 'child left', 'child right', ...
            'parent left', 'parent right', 'joint-attend', 'child dominant', 'naming', 'inmouth'};

    case 12
        
        main_module = 'target_inview_inhand';
        dname = 'asd_data';
        var_name_list = {
            'cevent_target-type';
            'cevent_target';
            'cevent_inhand-left_child';
            'cevent_inhand-right_child';
            'cevent_inhand-left_parent';
            'cevent_inhand-right_parent';
            'cevent_face-inview_child';
            'cevent_child-hand-inview_child';
            'cevent_parent-hand-inview_child';
            'cont_obj-count-center_child';
            };
        args.var_text = {'target type', 'target', 'child left', 'child right', 'parent left', ...
            'parent right', 'parent face', 'child hand', 'parent hand', 'object count'};
            
        args.convert_max_int = 50;
        args.cont_data_max = [NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,10];
        args.cont_color_str = {'', '', '', '', '', '', '', '', '', 'blue'};
        
    case 13
        
        main_module = 'left hand motion-inhand';
        dname = 'motion-inhand';
        var_name_list = {
            'event_motion_pos_left-hand_moving_child'
            'event_motion_pos_left-hand_big-moving_child'
            'cont_motion_pos-speed_left-hand_child'
            'cevent_motion-inhand_left-hand_active-obj_child'
            'cevent_motion-inhand_left-hand_passive-obj_child'
            'cevent_inhand_child'
            'event_motion-inhand_left-hand_active-empty_child'
            'event_motion-inhand_left-hand_passive-empty_child'};
        args.var_text = {'moving', 'big-mov', 'speed', 'active-obj', 'passive-obj', 'inhand', 'active-empty', 'passive-empty'};
        args.convert_max_int = 100;
        args.cont_data_max = [NaN, NaN, 300];
        args.cont_color_str = {'', '' , 'red'};
        root = '/scratch/sbf/data_vis_testing/';
        
    case 14
        
        main_module = 'right hand motion';
        dname = 'motion-inhand';
        var_name_list = {
            'event_motion_pos_right-hand_moving_child'
            'event_motion_pos_right-hand_big-moving_child'
            'cont_motion_pos-speed_right-hand_child'
            'event_motion_pos_right-hand_active_child'
            'event_motion_pos_right-hand_passive_child'
            'event_motion_pos_right-hand_resting_child'};
        args.var_text = {'moving', 'big-mov', 'speed', 'active', 'passive', 'resting'};
        args.convert_max_int = 100;
        args.cont_data_max = [NaN, NaN, 300];
        args.cont_color_str = {'', '' , 'red'};
        root = '/scratch/sbf/data_vis_testing/';
        
    case 15
        main_module = 'six sensors';
        dname = 'six_sensors';
        var_name_list = {
            'cont_motion_pos-speed_left-hand_child'
            'cont_motion_pos-speed_right-hand_child'
            'cont_motion_pos-speed_head_child'
            'cont_motion_pos-speed_left-hand_parent'
            'cont_motion_pos-speed_right-hand_parent'
            'cont_motion_pos-speed_head_parent'
            };
        args.var_text = {'cleft', 'cright', 'chead', 'pleft', 'pright', 'phead'};
        args.convert_max_int = 50;
        args.cont_data_max= [400, 400, 400, 400, 400, 400];
        args.cont_color_str = {'blue', 'green', 'red', 'blue', 'green', 'red'};
        root = '/scratch/sbf/six_sensors/';
end

args.var_name_list = var_name_list;
visualize_check_cont_input(args);

%%
input.sub_list = sub_list;
input.grouping = 'trial';
input.check_var_exist = 1;

title_str = main_module;
save_name = [main_module '_vis_across_modules'];

% for vidx = 1:length(var_name_list)
%     var_name = var_name_list{vidx};
%     title = [title '  ' no_underline(var_name) ';'];
% end
args.is_cont2cevent = false(size(var_name_list));


COLOR_DARK_IDX = [];
input.is_reassign_categories = false;
input.old_roi_list = {1, 2, 3};
input.new_roi_list = {11, 12, 13};

args.ForceZero = 0;
args.ref_column = 1;
args.color_code = 'cevent_value';
% args.transparency = 0.3;
args.xlabel = 'time';
args.set_position = [20 20 1600 (280+80*length(var_name_list))];
% args.vert_line = 0:10:100;
% obj_list = 1:3;
% obj_str_list = {'blue', 'green', 'red'};

input.convert_cstream2cevent = true;
input.convert_cstream_max_gap = 0.2;
input.convert_event2cevent = true;
input.event2cevent_value = 13;
input.fill_empty_with_nan = true;

exceptions = {};
e = 1;
for sidx = 1:length(sub_list)
    sub_id = sub_list(sidx);
    fprintf('%d\n',sub_id);
    try
    timing = get_timing(sub_id);
    args.sample_rate = 1/timing.camRate;
    title = sprintf('subject %d data vis: ', sub_id);
    args.title = [title title_str];
    
    if exist('save_name', 'var')
        args.save_name = sprintf('%d_%s', sub_id, save_name);
    end
    
    if exist('root', 'var')
        args.save_multiwork_exp_dir = fullfile(root, dname);
    else
        args.save_multiwork_exp_dir = fullfile(get_multidir_root, sprintf('experiment_%d',sub2exp(sub_id)),'included','data_vis', dname);
    end
    if ~exist(args.save_multiwork_exp_dir, 'dir')
        mkdir(args.save_multiwork_exp_dir);
    end
    args.sub_id = sub_id;
    input.sub_list = sub_id;
    trials_one = get_trial_times(sub_id);
    
    args.time_ref = trials_one(:,1);
    args.trial_times = trials_one;
    data = cell(size(trials_one, 1), length(var_name_list));
    
    args.row_text = {'T1', 'T2', 'T3', 'T4'};
    
    for vidx = 1:length(var_name_list)
        cat_vals = [];
        change_to = [];
        if iscell(var_name_list{vidx})
            input.var_name = var_name_list{vidx}{1};
            if iscell(var_name_list{vidx}{2})
                cat_vals = var_name_list{vidx}{2}{1};
                change_to = var_name_list{vidx}{2}{2};
            else
                cat_vals = var_name_list{vidx}{2};
            end
        else
            input.var_name = var_name_list{vidx};
        end
        
        var_type = get_data_type(input.var_name);
        
        if ismember(vidx, COLOR_DARK_IDX)
            input.is_reassign_categories = true;
        else
            input.is_reassign_categories = false;
        end
        [chunks_one, ~] = get_variable_by_grouping('sub', input.sub_list, input.var_name, input.grouping, input);
        
        if strcmp(var_type, 'cont')
            new_chunks = cell(size(chunks_one));
            args.cont_value_offset = 100;
            if isfield(args, 'cont_reverse_mask')
                for cidx = 1:length(chunks_one)
                    new_chunks{cidx} = visualize_cont2cevents(chunks_one{cidx}, ...
                        args.sample_rate, args.cont_data_max(vidx), ...
                        args.convert_max_int, args.cont_value_offset, args.cont_reverse_mask(vidx));
                end
            else
                for cidx = 1:length(chunks_one)
                    new_chunks{cidx} = visualize_cont2cevents(chunks_one{cidx}, ...
                        args.sample_rate, args.cont_data_max(vidx), ...
                        args.convert_max_int, args.cont_value_offset);
                end
            end
            args.is_cont2cevent(vidx) = true;
            chunks_one = new_chunks;
        end
        if isempty(chunks_one)
            for tidx = 1:size(trials_one, 1)
                data{tidx, vidx} = [nan(1,2) 0];
            end
        else
            chunks_len_one = cellfun(@length, chunks_one);
            if sum(chunks_len_one > 0) < 1
                fprintf('The variable %s exist for subject %d, but is completely empty.\n', input.var_name, sub_id);
                for tidx = 1:size(trials_one, 1)
                    data{tidx, vidx} = nan(1,3);
                end
            else
                if ~strcmp(var_type, 'cont')
                    if exist('create_gap', 'var') && create_gap
                        chunks_one = cellfun(@(A) [A(:,1)+0.2 A(:,2:end)], chunks_one, 'un', 0);
                    end
                    if ~isempty(cat_vals)
                        if ~strcmp(cat_vals, 'all')
                            chunks_one = cellfun(@(A) A(ismember(A(:,3), cat_vals), :), chunks_one, 'un', 0);
                        end
                        if ~isempty(change_to)
                            if strcmp(cat_vals, 'all')
                                for c = 1:numel(chunks_one)
                                    chunks_one{c}(:,3) = change_to;
                                end
                            else
                                if numel(cat_vals) ~= numel(change_to)
                                    error('cat_vals and change_to must be same size');
                                end
                                log = arrayfun(@(A) cellfun(@(C) C(:,3)==A,chunks_one, 'un', 0), cat_vals, 'un', 0); %I don't even know what this line is, but it works;
                                for l = 1:numel(log)
                                    for c = 1:numel(log{l})
                                        chunks_one{c}(log{l}{c},3) = change_to(l);
                                    end
                                end
                            end
                        end
                    end

                end
                data(:,vidx) = chunks_one;
            end
        end
    end
%     assignin('base', 'data', data);
    visualize_cevent_patterns(data, args)
    catch ME
        exceptions(e,1:2) = {sub_list(sidx), ME.message};
        e = e + 1;
        continue;
    end
end
if isempty(exceptions)
    exceptions = 'No exceptions';
end
c = clock();
% save(sprintf('/home/sbf/exceptions/master_data_vis_%s_option-%d', num2str(c([2 3 1]), '%d-%d-%d'), option), 'exceptions');
if nargin < 1
%     exit();
end
end
