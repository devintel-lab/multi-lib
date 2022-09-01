function results = event_cal_stats(chunks, input)

%EVENT_CAL_STATS Report various stypes of statistics of event type data 
%chunks according to user input.
% 
% INPUT: 
%   CHUNKS: a cell of data. See also GET_VARIABLE,
%   GET_VARIABLE_BY_GROUPING, GET_VARIABLE_BY_SUBJECT,
%   GET_VARIABLE_BY_TRIAL, GET_VARIABLE_BY_EVENT, GET_VARIABLE_BY_CEVENT.
%   INPUT: (optional parameter) a struct that specifies the types of
%   statistics user wants to calculate. Optional fields are:
%       grouping: the grouping method of data chunks, see 
%       GET_VARIABLE_BY_GROUPING;
%       hist_bins: value bins for generating histogram of event durations.
%       high_threshold: for calculating the proportion of events whose
%       duration is longer than a certain value;
%       low_threshold: for calculating the proportion of events whose
%       duration is shorter than a certain value;
%       whence: value 'start' or 'end', indicating whether the chunks of
%       data were extracted based on onset/offser of a certain types of
%       events/cevents.
%       interval: used with the parameter WHENCE, indicating the starting 
%       time and ending time when chunks were extracted based on
%       events/cevents.
% 
% OUTPUT:
%   RESULTS: a struct containing all the statistics. Also, individual
%   statistic within one chunk of data will be reported.
% 
% EXAMPLE:
%     exp_id = 18;
%     sub_list = list_subjects(exp_id);
%     input.sub_list = sub_list;
%     input.var_name = 'event_obj1_inhand_child';
%     input.grouping = 'subject';
%     chunks = get_variable_by_grouping('sub', input.sub_list, input.var_name, ...
%         input.grouping, input);
% 
%     input.hist_bin = [0 2.5 5 7.5 10 15 20 100];
%     input.low_threshold = 2;
%     input.high_threshold = 10;
%     results = event_cal_stats(chunks, input);
% 
% Example results:
%     results = 
%                 total_number: 107
%            individual_number: [13x1 double]
%                     mean_dur: 8.7804
%          individual_mean_dur: [13x1 double]
%                   median_dur: 4
%        individual_median_dur: [13x1 double]
%                         prop: 0.2284
%              individual_prop: [13x1 double]
%                         freq: 1.5609
%              individual_freq: [13x1 double]
%             trial_time_total: 4.1131e+003
%        individual_range_dur: [13x1 double]
%                 dur_low_prop: 0.3645
%      individual_dur_low_prop: [13x1 double]
%                dur_high_prop: 0.2617
%     individual_dur_high_prop: [13x1 double]
%
%   See also: GET_VARIABLE_BY_GROUPING
% 
% For more example, go to: 
% https://einstein.psych.indiana.edu/trac/browser/projects/txu_remodule/txu_test_stats_event.m

% check fileds in 'input'
if ~exist('input', 'var')
    % this line of code is just to prevent from generating errors when
    % script checks whether a certain field exists.
    input.none_filed = 'No information here';
end

% if isfield(input, 'var_name')
%     if ~strcmp(get_data_type(input.var_name), 'event')
%         error('Error! This function can only accept EVENT data type');
%     end
% end

if isfield(input, 'sub_list')
    results.sub_list = input.sub_list;
end

if isfield(input, 'grouping')    
    grouping = input.grouping;
else
    grouping = '';
end

% If user only wants to calculate stats for cevents that fall within a
% specified duration range
if isfield(input, 'min_dur_thresh')
    for cidx = 1:length(chunks)
        chunk_one = chunks{cidx};
        if size(chunk_one, 1) > 0
            chunk_one = cevent_remove_small_segments(...
                chunk_one, input.min_dur_thresh);
        end
        chunks{cidx} = chunk_one;
    end
end

if isfield(input, 'max_dur_thresh') 
    for cidx = 1:length(chunks)
        chunk_one = chunks{cidx};
        if size(chunk_one, 1) > 0
            chunk_one = cevent_remove_long_segments(...
                chunk_one, input.max_dur_thresh);
        end
        chunks{cidx} = chunk_one;
    end
end

if isfield(input, 'individual_range_dur')
    individual_range_dur = input.individual_range_dur;
    
    if size(individual_range_dur, 1) == 1
        individual_range_dur = repmat(individual_range_dur, ...
            length(chunks), 1);
        input.individual_range_dur = individual_range_dur;
    elseif length(chunks) ~= length(individual_range_dur)
        disp(['Warning: the length of data chunks and the length ' ...
            'of individual_range_dur are not the same, therefore, ' ...
            'input.individual_range_dur will be discarded.']);
        input = rmfield(input, 'individual_range_dur');
    end
elseif strcmp(grouping, 'subject') && isfield(input, 'sub_list') ...
        && length(chunks) == length(input.sub_list)
    chunks_trial_time = arrayfun(@(sub_id) ...
        event_total_length(get_trial_times(sub_id)), ...
        input.sub_list, ...
        'UniformOutput', false);
    individual_range_dur = vertcat(chunks_trial_time{:});
    input.individual_range_dur = individual_range_dur;
end

%% calculate statistics
cat_chunks = cat(1,chunks{:});
cat_durations = cat_chunks(:,2) - cat_chunks(:,1);
individual_number = nan(length(chunks), 1);
individual_duration = nan(length(chunks), 1);
individual_mean_dur = nan(length(chunks), 1);
individual_std_dur = nan(length(chunks), 1);
individual_median_dur = nan(length(chunks), 1);

for chunkidx = 1:length(chunks)
    chunk_one = chunks{chunkidx};
    
    individual_number(chunkidx) = event_number(chunk_one);
    individual_duration(chunkidx) = event_total_length(chunk_one);
    individual_mean_dur(chunkidx) = event_average_dur(chunk_one);
    if isempty(chunk_one)
        individual_std_dur(chunkidx) = NaN;
    else
        individual_std_dur(chunkidx) = std(chunk_one(:,2) - chunk_one(:,1));
    end
    individual_median_dur(chunkidx) = event_median_dur(chunk_one); 
end

% total number of events
results.total_number = event_number(cat_chunks);
results.individual_number = individual_number;

% total duration, within one chunk
results.total_duration = event_total_length(cat_chunks);
results.individual_duration = individual_duration;

% mean duration
results.mean_dur = mean(cat_durations,'omitnan');
results.individual_mean_dur = individual_mean_dur;
results.individual_std_dur = individual_std_dur;

% median duration
results.median_dur = median(cat_durations,'omitnan');
results.individual_median_dur = individual_median_dur;

% proportion and frequency are only calculated when individual trial
% time is included in input or when grouping is 'subject' and the subject
% list is included
if isfield(input, 'individual_range_dur')    
    trial_time_total = sum(individual_range_dur,'omitnan');
    
    % proportions
    results.prop = results.mean_dur * results.total_number / trial_time_total;
    results.individual_prop = (results.individual_mean_dur .* ...
        results.individual_number) ./ individual_range_dur;
    
    % frequency
    results.freq = results.total_number / (trial_time_total/60);
    results.individual_freq = results.individual_number ./ (individual_range_dur/60);
    
    results.trial_time_total = trial_time_total;
    results.individual_range_dur = individual_range_dur;
end

% hist_bins
if isfield(input, 'hist_bins')
    res_dur_hist = nan(length(chunks), length(input.hist_bins));
    for i = 1: length(chunks)
        res_dur_hist(i,:) = event_duration_hist(chunks{i}, input.hist_bins);
        res_dur_hist(i,:) = res_dur_hist(i,:)/sum(res_dur_hist(i,:));
    end
       
    results.dur_hist = event_duration_hist(cat_chunks, input.hist_bins);
    results.dur_hist = results.dur_hist/sum(results.dur_hist);
    results.individual_dur_hist = res_dur_hist;
end

% low shreshold
if isfield(input, 'low_threshold')
    res_low_prop = nan(length(chunks), 1);    
    for i = 1: length(chunks)
        durations_one = chunks{i};
        durations_one = durations_one(:,2) - durations_one(:,1);
        res_low_prop(i) = sum(durations_one < input.low_threshold) ...
            / length(durations_one);
    end
    
    results.dur_low_prop = sum(cat_durations < input.low_threshold) ...
        / length(cat_durations);
    results.individual_dur_low_prop = res_low_prop;
end

% high shreshold
if isfield(input, 'high_threshold')
    res_high_prop = nan(length(chunks), 1);    
    for i = 1: length(chunks)
        durations_one = chunks{i};
        durations_one = durations_one(:,2) - durations_one(:,1);
        res_high_prop(i) = sum(durations_one > input.high_threshold) ...
            / length(durations_one);
    end
    
    results.dur_high_prop = sum(cat_durations > input.high_threshold) ...
        / length(cat_durations);
    results.individual_dur_high_prop = res_low_prop;
end
