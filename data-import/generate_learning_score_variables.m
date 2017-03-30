function [sub_list_score, result_mat_score_counts] = generate_learning_score_variables(exp_id)
% This function reads stimulus_table.txt and TestInforExpXX.txt under
% multidir root with each experiment, and for every subject that has
% learning test scores, learning score variables will be generated.
% 
% TestInforExpXX.txt is recorded in this format:
% Subject	Subject_ID	  Dodi	Kookle	Mobit	Wawa	Riffy	Tema
% __20140627_16579	7106	1	0	2	0	0	1
% __20140717_16710	7107	1	1	1	1	0	0
% 
% Output: 4 learning score variables: 
% One overall score variable
% 1 - 'cevent_speech_naming_test-score', ...
% 
% For the first  'cevent_speech_naming_test-score', the first two columns 
% will be the same with 'cevent_speech_naming_local-id', and the categorical 
% value column will be 0, 1, 2, indicating the learning score.
% 
% Three separated learning score variables:
% 2 - 'cevent_speech_naming_learn-score-0_parent', ...
% 3 - 'cevent_speech_naming_learn-score-1_parent', ...
% 4 - 'cevent_speech_naming_learn-score-2_parent', ...
% 
% Each will only contain variables that are scored 0/1/2 according to title, and 
% the 3rd column will be the local naming object id. Some of them will be
% empty, when a particular subject didn't have objects learned with that
% score.
% 
% Each cevent corresponds to one naming instance.
% Warning: there are utterances containing 2 object names; as a result,
% certain naming cevent has two learning scores.
% 
% Last updated by Linger, txu@indiana.edu on 07/21/2016
% 
% The script was ran for experiments 14, 32, 34, 43, 44, 71, 72 on
% 07/21/2016 by Linger, txu@indiana.edu.

% clear all;
% exp_id = 44;

% Two boolean variables for debugging purposes.
is_visual_examine = false;
is_record_variable = true;

multidir = get_multidir_root();

% STEP 1: parse the stimulus table to get vocal id and object trial info
filename_stimulus = 'stimulus_table.txt';
fname_stimulus = fullfile(multidir, filename_stimulus);
[exp_num_in_obj_rec,local_id,trial,color,labelme_name, object_id, word,vocab_id] = ...
    textread(fname_stimulus,'%d%d%d%s%s%d%s%d','delimiter',',','headerlines',1);

mask_exp = exp_num_in_obj_rec == exp_id;
local_id = local_id(mask_exp);
trial = trial(mask_exp);
% object_id = object_id(mask_exp);
word = word(mask_exp);
vocab_id = vocab_id(mask_exp);

fname_testinfo = sprintf('TestInfoExp%d.txt', exp_id);
fname_testinfo = fullfile(multidir, fname_testinfo);
sub_list = list_subjects(exp_id);

% STEP 2: parse the test score file
% Subject	Subject_ID	  Dodi	Kookle	Mobit	Wawa	Riffy	Tema
% __20140627_16579	7106	1	0	2	0	0	1
% __20140717_16710	7107	1	1	1	1	0	0
% __20140701_16824	7109	1	1	1	1	0	1
% __20140710_16646	7110	1	0	1	0	0	0
% __20140904_16729	7116	1	1	1	2	0	0
% __20141004_16869	7121	2	0	1	2	0	0
% __20141024_17095	7122	2	1	1	0	1	1
% __20150306_17062	7129	1	1	2	1	1	1
% __20150225_17049	7131	2	0	0	2	2	0
% __20150324_17332	7132	2	1	1	0	0	0
% __20150609_17282	7127	1	1	1	1	0	0
% __20150708_17154	7135	1	1	1	1	1	1

fid = fopen(fname_testinfo);
object_list = fgets(fid);
sub_dir_list = {};
score_mat = [];
score_sub_mat = [];

obj_name_list = strsplit(object_list);
obj_name_list = obj_name_list(3:end-1);
tline = fgets(fid);
while ischar(tline)
    tmp_split = strsplit(tline);
    score_subid = str2double(tmp_split{2});
    if score_subid == 1425
        tline = fgets(fid);
        continue
    end
    sub_dir_list = [sub_dir_list; tmp_split(1)];
    tmp_line = [];
    for tmpi = 2:length(tmp_split)
        tmp_char = tmp_split{tmpi};
        if length(tmp_char) == 1
            tmp_line = [tmp_line str2num(tmp_char)];
        end
    end
    score_sub_mat = [score_sub_mat; score_subid];
    score_mat = [score_mat; tmp_line];
    tline = fgets(fid);
end

fclose(fid);

if is_visual_examine
    args.sample_rate = 0.03334;
    main_module = sprintf('naming_score');

    var_name_list = {
        'cevent_speech_naming_learn-score-0_parent'
        'cevent_speech_naming_learn-score-1_parent'
        'cevent_speech_naming_learn-score-2_parent'
        'cevent_speech_naming_local-id'
        'cevent_speech_naming_test-score'
        };
    args.var_text = get_vis_vartext(var_name_list);

    args.legend = {'blue object'; 'green object'; 'red object'; 'nan'; 'nan'; 'nan'; 'nan'; 'nan'; 'nan'; ...
        'score0'; 'score1'; 'score2'};
    args.row_text_type = 'time'; % or it can be label such as shown below
    save_path = '.';
    args.set_position = [50 50 1800 (280+30*length(var_name_list))];
    args.var_name_list = var_name_list;
    
    input.sub_list = sub_list;
    input.grouping = 'trial';
    input.check_var_exist = 1;
    title_str = main_module;
    
    args.colormap = [...
        [0 0 1]; ... % blue 1
        [0 1 0]; ... % green 2
        [1 0 0]; ... % red 3
        [0.4 0.4 0.4]; ... % grey 5
        [0.4 0.4 0.4]; ... % grey 5
        [0.4 0.4 0.4]; ... % grey 6
        [0.4 0.4 0.4]; ... % grey 7
        [0.4 0.4 0.4]; ... % grey 8
        [0.4 0.4 0.4]; ... % grey 9
        [1 0.5 0.2]; ... % orange 10
        [0.7 0 0.7]; ... % purple 11
        [0 1 1]; ... % cran 12
        ];
    args.ForceZero = false;
    args.ref_column = 1;
    args.color_code = 'cevent_value';
    % args.transparency = 0.3;
    args.xlabel = 'time';
    args.row_text = {'T1', 'T2', 'T3', 'T4'};
end

% STEP 3: Generate the 4 naming variable files
varname = 'cevent_speech_naming';
varname_type = get_data_type(varname);

mask_sub_has_score = false(size(sub_list));
result_mat_score_items = nan(length(sub_list), 6);
result_mat_score_counts = nan(length(sub_list), 3);

for sidx = 1:length(sub_list)
    sub_id = sub_list(sidx);
    
    trials_one = get_trial_times(sub_id);
    
    if is_visual_examine
        title = sprintf('subject %d data vis: ', sub_id);
        args.title = [title title_str];
        args.sub_id = sub_id;
        input.sub_list = sub_id;
        args.time_ref = trials_one(:,1);
        args.trial_times = trials_one;
        data = cell(size(trials_one, 1), length(var_name_list));
        var_type = 'cevent';
    end
    
    if ~has_variable(sub_id, 'cevent_speech_naming_local-id')
        fprintf('Subject %d does not have variable %s', sub_id, 'cevent_speech_naming_local-id');
        continue
    end
    
    sub_dir_str = get_subject_dir(sub_id);
    sub_dir_str = strsplit(sub_dir_str, {'/', '\'});
    sub_dir_str = sub_dir_str{end};
    mask_subdir = ismember(sub_dir_list, sub_dir_str);
    
    if sum(mask_subdir) > 0
        mask_sub_has_score(sidx) = true;
        cevents_naming = get_variable(sub_id, varname);
        cevents_namelocal = get_variable(sub_id, 'cevent_speech_naming_local-id');
        cevents_score = cevents_naming;
        score_per_sub = score_mat(mask_subdir, :);
        result_mat_score_items(sidx, :) = score_per_sub;

        for objidx = 1:length(obj_name_list)
            obj_score = obj_name_list{objidx};
            mask_obj_sore = strcmpi(word, obj_score);
            vid = vocab_id(mask_obj_sore);
            score_oneword = score_per_sub(objidx);
            mask_vid = ismember(cevents_naming(:,3), vid);
            cevents_score(mask_vid, 3) = score_oneword;
        end
        
        if is_visual_examine
            data(:,4) = extract_ranges(cevents_namelocal, var_type, trials_one);
            cevents_tmp = cevents_score;
            cevents_tmp(:,3) = cevents_tmp(:,3) + 10;
            data(:,5) = extract_ranges(cevents_tmp, var_type, trials_one);
        end
        
        if is_record_variable
            record_variable(sub_id, 'cevent_speech_naming_test-score', cevents_score);
        end

        scorename_list = {'cevent_speech_naming_learn-score-0_parent', ...
            'cevent_speech_naming_learn-score-1_parent', ...
            'cevent_speech_naming_learn-score-2_parent'};
        
        score_list = 0:2;
        for scoreidx = 1:length(score_list)
            score_one = score_list(scoreidx);
            mask_score = ismember(cevents_score(:, 3), score_one);
            cevents_one = cevents_namelocal(mask_score, :);
            if is_visual_examine
                chunks_one = extract_ranges(cevents_one, var_type, trials_one);
                chunks_len_one = cellfun(@length, chunks_one);
                if sum(chunks_len_one > 0) < 1
                    fprintf('The variable %s exist for subject %d, but is completely empty.\n', scorename_list{scoreidx}, sub_id);
                    for tidx = 1:size(trials_one, 1)
                        data{tidx, scoreidx} = nan(1,3);
                    end
                else
                    data(:,scoreidx) = chunks_one;
                end
            end
            
            if is_record_variable
                record_variable(sub_id, scorename_list{scoreidx}, cevents_one);
            end
            result_mat_score_counts(sidx, scoreidx) = sum(score_per_sub == score_one);
        end
        if is_visual_examine
            save_name = sprintf('%s_all_vis_across_modules', main_module);
            args.save_name = sprintf('%d_%s', sub_id, save_name);
            visualize_cevent_patterns(data, args);
        end
    end
end

sub_list_score = sub_list(mask_sub_has_score);
% result_mat_score_items = score_mat(mask_sub_has_score, :);
result_mat_score_counts = result_mat_score_counts(mask_sub_has_score, :);

mask_incomplete_objs = sum(result_mat_score_counts, 2) ~= 6;
if sum(mask_incomplete_objs) > 0
    sub_error_list = sub_list_score(mask_incomplete_objs)';
    error('These subjects %d do not have scores for every object, please check file %s', ...
        sub_error_list, fname_testinfo);
end