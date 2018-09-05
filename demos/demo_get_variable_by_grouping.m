% function results = demo_get_variable_by_grouping(DEMO_ID)
% This is a script for demonstrating how to use the function 
% get_variable_by_grouping

clear all
DEMO_ID = 1;

exp_id = 70;
sub_list = list_subjects(exp_id);

switch DEMO_ID
%% grouping method 1: trial_cat (the best way to extract data on subject level)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Selected trials for one subject is concatenated to one chunk
% So, it is one chunk per subject
case 1
    input.sub_list = sub_list;
    input.var_name = 'cevent_eye_roi_child';
    
    % Set input argument GROUPING == 'trial_cat': extract variable based on trial level, then concatenate 
    %   the variable chunks together within one subject. 
    %   No required fields; Optional field: TRIAL_VALUES (see below for 
    %   the meaning and value type of TRIAL_VALUES)
    input.grouping = 'trial_cat';

    [chunks, extra] = get_variable_by_grouping('sub', input.sub_list, input.var_name, ...
        input.grouping, input);
    % Output have two variables, one containing the variable data, one cell
    %   per trial; the other containing some extra information for future
    %   computation.
    %     
    %     chunks = 
    % 
    %     [ 87x3 double]
    %     [144x3 double]
    %     [135x3 double]
    %     ...
    %     [166x3 double]
    %     
    % extra = 
    % 
    %        mask_has_variable: [33x1 logical]
    %                 sub_list: [33x1 double]
    %        individual_ranges: {33x1 cell}
    %     individual_range_dur: [33x1 double]

    % By assigning values to the field 'individual_range_dur', cevent_cal_stats
    %   is able to calcuate frequency, instead of raw counts.
    input.individual_range_dur = extra.individual_range_dur;
    
    % Certain subjects don't have this particular variable, thus updating
    %   the sub_list will only calculate stats for valid subjects.
    input.sub_list = extra.sub_list;

    % One can combine all objects roi values [1 2 3] into one value [1]
    old_roi_list = {[1 2 3], [4]};
    new_roi_list = {[1], [4]};
    chunks_new = cell(size(chunks));
    for cidx = 1:length(chunks)
        chunk_one = chunks{cidx};
        chunk_one = cevent_reassign_categories(chunk_one, old_roi_list, new_roi_list);
        chunks_new{cidx} = chunk_one;
    end

    % The output results field will contain all types of statistics,
    %   individually, by different categories, and at group level
    % Please see 'help event_cal_stats' for detailed comments of this
    %   function.
    results = cevent_cal_stats(chunks_new, input);
    % After using function 'cevent_reassign_categories', one can see that
    % in results, all cevents now are in two categories, 1-object, 2-face
    %     results = 
    % 
    %                         sub_list: [33x1 double]
    %                       categories: [1 4]
    %                     total_number: 3749

%% grouping method 2: trial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% one chunk per trial
case 2
    input.sub_list = sub_list;
    input.var_name = 'event_motion_pos_head_big-moving_child';
    
    % Set input argument GROUPING == 'trial': extract variable based on trial level. 
    %   No required fields; Optional field: TRIAL_VALUES (see below for 
    %   the meaning and value type of TRIAL_VALUES)
    input.grouping = 'trial';

    [chunks, extra] = get_variable_by_grouping('sub', input.sub_list, input.var_name, ...
        input.grouping, input);
    % Output have two variables, one containing the variable data, one cell
    %   per trial; the other containing some extra information for future
    %   computation.
    %     
    %     chunks = 
    % 
    %     [20x2 double]
    %     [18x2 double]
    %     [11x2 double]
    %     ...
    %     [16x2 double]
    %     
    % extra = 
    % 
    %        mask_has_variable: [33x1 logical]
    %                 sub_list: [96x1 double]
    %        individual_ranges: [96x3 double]
    %     individual_range_dur: [96x1 double]

    % By assigning values to the field 'individual_range_dur', event_cal_stats
    %   is able to calcuate frequency, instead of raw counts.
    input.individual_range_dur = extra.individual_range_dur;
    
    % Certain subjects don't have this particular variable, thus updating
    %   the sub_list will only calculate stats for valid subjects.
    input.sub_list = extra.sub_list;

    % The output results field will contain all types of statistics,
    %   individually, by different categories, and at group level
    % Please see 'help event_cal_stats' for detailed comments of this
    %   function.
    results = event_cal_stats(chunks, input);

    
%% grouping method 3: subject
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 3
    input.sub_list = sub_list;
    input.var_name = 'cevent_eye_roi_parent';
    
    % Set input argument GROUPING == 'subject': extract variable based on subject level. 
    % When extracting data on subject level, you will receive a gentle warning: 
    %   "When grouping method is subject, data can be out of trials, 
    %	and individual_ranges will still be the trial times."
    input.grouping = 'subject';

    [chunks, extra] = get_variable_by_grouping('sub', input.sub_list, input.var_name, ...
        input.grouping, input);
    % Output have two variables, one containing the variable data, one cell
    %   per subject; the other containing some extra information for future
    %   computation.
    %     
    %     chunks = 
    % 
    %     [291x3 double]
    %     [475x3 double]
    %     [254x3 double]
    %     ...
    %     [359x3 double]
    %     
    % extra = 
    % 
    %        mask_has_variable: [33x1 logical]
    %                 sub_list: [33x1 double]
    %        individual_ranges: {33x1 cell}
    %     individual_range_dur: [33x1 double]
    
    % By assigning values to the field 'individual_range_dur', cevent_cal_stats
    %   is able to calcuate frequency, instead of raw counts.
    input.individual_range_dur = extra.individual_range_dur;
    
    % Certain subjects don't have this particular variable, thus updating
    %   the sub_list will only calculate stats for valid subjects.
    input.sub_list = extra.sub_list;
    
    % The output results field will contain all types of statistics,
    %   individually, by different categories, and at group level
    % Please see 'help cevent_cal_stats' for detailed comments of this
    %   function.
    results = cevent_cal_stats(chunks, input);
    
%% grouping method 4: event
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% one chunk per event
case 4
    input.sub_list = sub_list;
    input.var_name = 'cstream_eye_roi_child';
    
    % Set input argument GROUPING == 'event': extract variable based on event level for each
    %       subject. So the output will be one cstream chunk per event.
    %       Required field: EVENT_NAME; Optional fields: WHENCE and INTERVAL 
    %       (see below for the meaning and value type of WHENCE and INTERVAL).
    input.grouping = 'event';
    input.event_name = 'event_inhand_left-obj1_child';
    
    % One can specify the duration range of chunking event variable
    input.event_min_dur = 0.5;
    input.event_max_dur = 10;
    
    % When 'within_ranges' is set to true, we get the cstream data within the events;
    % When 'within_ranges' is set to false, we get the cstream data outside the events, but within the trials;
    input.within_ranges = true;
    
    [chunks, extra] = get_variable_by_grouping('sub', input.sub_list, input.var_name, ...
        input.grouping, input);
    % Output have two variables, one containing the variable data, one cell
    %   per subject; the other containing some extra information for future
    %   computation.
    %     
    %     chunks = 
    % 
    %     [ 35x2 double]
    %     [ 19x2 double]
    %     [ 63x2 double]
    %     ...
    %     [ 40x2 double]
    %     
    %   extra = 
    % 
    %        mask_has_variable: [33x1 logical]
    %                   trials: [125x3 double]
    %                 sub_list: [204x1 double]
    %        individual_ranges: [204x3 double]
    %     individual_range_dur: [204x1 double]

    input.individual_range_dur = extra.individual_range_dur;
    input.sub_list = extra.sub_list;

    % The output results field will contain all types of statistics,
    %   individually, by different categories, and at group level
    % Please see 'help cstream_cal_stats' for detailed comments of this
    %   function.
    results = cstream_cal_stats(chunks, input);

%% grouping method 5: cevent
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% one chunk per cevent
case 5
    input.sub_list = sub_list;
    input.var_name = 'cstream_eye_roi_parent';    
    
    % Set input argument GROUPING == 'cevent': extract variable based on cevent level with
    %       specified cevent values.
    %       Required field: CEVENT_NAME, CEVENT_VALUES; 
    %       Optional fields: WHENCE, INTERVAL(see below for the meanings 
    %       and value types of WHENCE and TRIAL_VALUES).
    input.grouping = 'cevent';
    input.cevent_name = 'cevent_inhand_child';
    input.cevent_values = 1;
    
    % One can specify the duration range of chunking cevent variable
    input.cevent_min_dur = 0.5;
    input.cevent_max_dur = 10;
    
    %   WHENCE and INTERVAL
    %       Value of WHENCE can either be 'start' or 'end'. For example, if
    %       WHENCE is 'start' and interval is [-5 0], this means extract data
    %       from 5 seconds before the onset to the onset of each event; if
    %       WHENCE is 'end' and interval is [-1 3], this mean extract data from
    %       1 second before the offset to 3 seconds after the offset of each
    %       event. 
    input.whence = 'startend';
    input.interval = [0 0];
    
    [chunks, extra] = get_variable_by_grouping('sub', input.sub_list, input.var_name, ...
        input.grouping, input);
    % Output have two variables, one containing the variable data, one cell
    %   per subject; the other containing some extra information for future
    %   computation.
    %     
    %     chunks = 
    % 
    %     [ 151x2 double]
    %     [ 151x2 double]
    %     ...
    %     [ 34x2 double] - when the cstream chunk is cut off by trials
    %     ...
    %     [ 151x2 double]
    %     
    %   extra = 
    % 
    %        mask_has_variable: [33x1 logical]
    %                   trials: [125x3 double]
    %                 sub_list: [204x1 double]
    %        individual_ranges: [204x3 double]
    %     individual_range_dur: [204x1 double]

    input.individual_range_dur = extra.individual_range_dur;
    input.sub_list = extra.sub_list;
    
    % cstream_cal_stats allows the user to compute temporal profiles when
    % user specified the values for WHENCE and INTERVAL. If you only want
    % to get temporal profiles, you can set 'is_temporal_only' to be true;
    is_temporal_only = false;
    % When input argument 'is_cal_cevent_stats' is set to be true, the
    % cstreams will be converted into cevents, and funciton
    % cevent_cal_stats will be called to calculate cevent based stats.
    is_cal_cevent_stats = true;
    % The output results field will contain all types of statistics,
    %   individually, by different categories, and at group level
    % Please see 'help cstream_cal_stats' for detailed comments of this
    %   function.
    results = cstream_cal_stats(chunks, input, is_temporal_only, is_cal_cevent_stats);
    

%% grouping method 6: trialevent_cat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% one chunk per trial
    case 6
    input.sub_list = sub_list;
    input.var_name = 'cevent_eye_roi_parent';
    
    % Set input argument GROUPING == 'trialevent_cat': first extract variable based on event
    %       level within each trial. And for every trial, concatenate the
    %       extracted data into one stream. So the output will be one chunk per
    %       trial.
    input.grouping = 'trialevent_cat';
    
    % One can specify the duration range of chunking cevent variable
    input.event_name = 'event_inhand_left-obj1_child';
    input.event_min_dur = 0.5;
    input.event_max_dur = 10;
    
    [chunks, extra] = get_variable_by_grouping('sub', input.sub_list, input.var_name, ...
        input.grouping, input);
    % Output have two variables, one containing the variable data, one cell
    %   per subject; the other containing some extra information for future
    %   computation.
    %     
    %     chunks = 
    % 
    %     [ 2x3 double]
    %     []
    %     [ 1x3 double]
    %     []
    %     ...
    %     [ 4x3 double]
    %     
    %   extra = 
    % 
    %        mask_has_variable: [33x1 logical]
    %                 sub_list: [125x1 double]
    %        individual_ranges: {125x1 cell}
    %     individual_range_dur: [125x1 double]

    input.individual_range_dur = extra.individual_range_dur;
    input.sub_list = extra.sub_list;

    % The output results field will contain all types of statistics,
    %   individually, by different categories, and at group level
    % Please see 'help cevent_cal_stats' for detailed comments of this
    %   function.
    results = cevent_cal_stats(chunks, input);
    
%% grouping method 7: subevent_cat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% one chunk per subject
    case 7
    input.sub_list = sub_list;
    input.var_name = 'cstream_inhand_obj1_parent';
    
    % Set input argument GROUPING == 'subevent_cat': first extract variable based on event
    %       level within each subject. And for every subject, concatenate the
    %       extracted data into one stream. So the output will be one chunk per
    %       subject.
    input.grouping = 'subevent_cat';
    input.event_name = 'event_inhand_left-obj1_child';
    
    input.event_min_dur = 0.5;
    input.event_max_dur = 10;
    
    [chunks, extra] = get_variable_by_grouping('sub', input.sub_list, input.var_name, ...
        input.grouping, input);
    % Output have two variables, one containing the variable data, one cell
    %   per subject; the other containing some extra information for future
    %   computation.
    %     
    %     chunks = 
    % 
    %     [  54x2 double]
    %     []
    %     [1027x2 double]
    %     ...
    %     [ 270x2 double]
    %     
    % extra = 
    % 
    %        mask_has_variable: [33x1 logical]
    %                 sub_list: [33x1 double]
    %        individual_ranges: {33x1 cell}
    %     individual_range_dur: [33x1 double]
    
    % By assigning values to the field 'individual_range_dur', cevent_cal_stats
    %   is able to calcuate frequency, instead of raw counts.
    input.individual_range_dur = extra.individual_range_dur;
    % Certain subjects don't have this particular variable, thus updating
    %   the sub_list will only calculate stats for valid subjects.
    input.sub_list = extra.sub_list;

    % The output results field will contain all types of statistics,
    %   individually, by different categories, and at group level
    % Please see 'help cstream_cal_stats' for detailed comments of this
    %   function.
    results = cstream_cal_stats(chunks, input);

%% grouping method 8: trialevent_cat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% one chunk per trial
    case 8
    input.sub_list = sub_list;        
    input.var_name = 'cevent_eye_roi_parent';
    
    % Set input argument GROUPING == 'trialcevent_cat': first extract variable based on cevent
    %       level within each trial. And for every trial, concatenate the
    %       extracted data into one stream. So the output will be one chunk per
    %       trial.
    %       Required field: CEVENT_NAME, CEVENT_VALUES; 
    %       Optional fields: WHENCE, INTERVAL(see below for the meanings 
    %       and value types of WHENCE and TRIAL_VALUES).
    input.grouping = 'trialcevent_cat';
    input.cevent_name = 'cevent_inhand_child';
    input.cevent_values = 1;
    
    input.cevent_min_dur = 0.5;
    input.cevent_max_dur = 10;
    
    [chunks, extra] = get_variable_by_grouping('sub', input.sub_list, input.var_name, ...
        input.grouping, input);
    % Output have two variables, one containing the variable data, one cell
    %   per subject; the other containing some extra information for future
    %   computation.
    %     
    %     chunks = 
    % 
    %     [14x3 double]
    %     [10x3 double]
    %     [ 2x3 double]
    %     []
    %     []
    %     []
    %     ...
    %     [ 4x3 double]
    %     
    %   extra = 
    % 
    %        mask_has_variable: [33x1 logical]
    %                 sub_list: [125x1 double]
    %        individual_ranges: {125x1 cell}
    %     individual_range_dur: [125x1 double]
    
    input.individual_range_dur = extra.individual_range_dur;
    input.sub_list = extra.sub_list;

    % The output results field will contain all types of statistics,
    %   individually, by different categories, and at group level
    % Please see 'help cevent_cal_stats' for detailed comments of this
    %   function.
    results = cevent_cal_stats(chunks, input);

%% grouping method 9: subcevent_cat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% one chunk per subject
    case 9
    input.sub_list = sub_list;
    input.var_name = 'cevent_eye_roi_child';
    
    % Set input argument GROUPING == 'subcevent_cat': first extract variable based on cevent
    %       level within each subject. And for every subject, concatenate the
    %       extracted data into one stream. So the output will be one chunk per
    %       subject.
    %       Required field: CEVENT_NAME, CEVENT_VALUES; 
    %       Optional fields: WHENCE, INTERVAL(see below for the meanings 
    %       and value types of WHENCE and TRIAL_VALUES).
    input.grouping = 'subcevent_cat';
    input.cevent_name = 'cevent_vision_size_obj-dominant_child';
    input.cevent_values = [1 2 3];
    input.cevent_min_dur = 0.5;
    input.cevent_max_dur = 10;
    
    [chunks, extra] = get_variable_by_grouping('sub', input.sub_list, input.var_name, ...
        input.grouping, input);
    % Output have two variables, one containing the variable data, one cell
    %   per subject; the other containing some extra information for future
    %   computation.
    %     
    %     chunks = 
    % 
    %     [ 19x3 double]
    %     [ 94x3 double]
    %     [ 33x3 double]
    %     ...
    %     [101x3 double]
    %     
    % extra = 
    % 
    %        mask_has_variable: [33x1 logical]
    %                 sub_list: [33x1 double]
    %        individual_ranges: {33x1 cell}
    %     individual_range_dur: [33x1 double]
    %           chunks_pre_cat: {33x1 cell}
    
    input.individual_range_dur = extra.individual_range_dur;
    input.sub_list = extra.sub_list;
    
    % One can combine all objects roi values [1 2 3] into one value [1]
    old_roi_list = {[1 2 3], [4]};
    new_roi_list = {[1], [4]};
    chunks_new = cell(size(chunks));
    for cidx = 1:length(chunks)
        chunk_one = chunks{cidx};
        chunk_one = cevent_reassign_categories(chunk_one, old_roi_list, new_roi_list);
        chunks_new{cidx} = chunk_one;
    end

    % The output results field will contain all types of statistics,
    %   individually, by different categories, and at group level
    % Please see 'help event_cal_stats' for detailed comments of this
    %   function.
    results = cevent_cal_stats(chunks_new, input);
    % After using function 'cevent_reassign_categories', one can see that
    % in results, all cevents now are in two categories, 1-object, 2-face
    %     results = 
    % 
    %                         sub_list: [33x1 double]
    %                       categories: [1 4]
    %                     total_number: 1903
    
%% grouping method 13: Both hands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This case is specifically designated for calculating more precise
% statistics for inhand data. It will calculate left and right hand data
% saperately, and combine them together.
case 21
    input.sub_list = sub_list;
    input.var_name = 'cstream_inhand_left-hand_obj-all_child';
    input.grouping = 'trial_cat';
    input.convert_cstream2cevent = true;
    input.convert_cstream_max_gap = 0.035;
    
    [chunks_left, extra_left] = get_variable_by_grouping('sub', input.sub_list, input.var_name, ...
        input.grouping, input);
    
    input.individual_range_dur = extra_left.individual_range_dur;
    input.sub_list = extra_left.sub_list;
    input.sample_rate = 0.0334;
    
    results_left = cevent_cal_stats(chunks_left, input);
    
    input.var_name = 'cstream_inhand_right-hand_obj-all_child';
    
    [chunks_right, extra_right] = get_variable_by_grouping('sub', input.sub_list, input.var_name, ...
        input.grouping, input);
    
    input.individual_range_dur = extra_right.individual_range_dur;
    input.sub_list = extra_right.sub_list;
    input.sample_rate = 0.0334;
    
    results_right = cevent_cal_stats(chunks_right, input);
otherwise
    error('Invalid DEMO_ID!');
end
