function results = cstream_cal_stats(chunks, input, is_temporal_only, is_cal_cevent_stats)
%CSTREAM_CAL_STATS Report various stypes of statistics of cstream type data 
%chunks according to user input.
% 
% INPUT: 
%   CHUNKS: a cell of data. See also GET_VARIABLE,
%   GET_VARIABLE_BY_GROUPING, GET_VARIABLE_BY_SUBJECT,
%   GET_VARIABLE_BY_TRIAL, GET_VARIABLE_BY_EVENT, GET_VARIABLE_BY_CEVENT.
%   INPUT: (optional parameter) a struct that specifies the types of
%   statistics user wants to calculate. Optional fields are: var_name,
%   grouping, categories, nodata_marker, whence, interval.
%       grouping: the grouping method of data chunks, see 
%       GET_VARIABLE_BY_GROUPING;
%       categories: categories existing in the data chunks;
%       nodata_marker: which category value will be considered as non-data
%       in generating transition matrix;
%       trans_max_gap: the maximum timing gap that is allowed for two
%       cevents to be considered as consecutive events in generating
%       transition matrix;
%       whence: value 'start' or 'end', indicating whether the chunks of
%       data were extracted based on onset/offser of a certain types of
%       events/cevents.
%       interval: used with the parameter WHENCE, indicating the starting 
%       time and ending time when chunks were extracted based on
%       events/cevents.
% 
% OUTPUT:
%   RESULTS: a struct containing all the statistics. Also, individual
%   statistic within every chunk of data will be reported.
% 
% EXAMPLE:
%     exp_id = 18;
%     sub_list = list_subjects(exp_id);
%     input.sub_list = sub_list;
% 
%     input.var_name = 'cstream_cam1_dominant_obj';
%     input.grouping = 'cevent';
%     input.cevent_name = 'cevent_inhand_child';
%     input.cevent_values = 1;
%     input.whence = 'start';
%     input.interval = [-2 0];
%     input.nodata_marker = 0;
% 
%     chunks = get_variable_by_grouping('sub', input.sub_list, input.var_name, ...
%         input.grouping, input);
% 
%     results = cstream_cal_stats(chunks, input);
% Example results:
% results = 
% 
%                 categories: [0 1 2 3 4 5]
%                       prop: 0.1987
%                prop_by_cat: [0.8013 0.0884 0.0094 0.0413 0.0245 0.0352]
%            individual_prop: [155x1 double]
%     individual_prop_by_cat: [155x6 double]
%              temporal_time: [20x1 double]
%             temporal_probs: [20x5 double]
%            temporal_chunks: [20x155 double]
%             temporal_count: [20x5 double]
%               trans_matrix: [5x5 double]
%               CEVENT_STATS: '----------convert to cevents from here-----------'
%               cevent_stats: [1x1 struct]
% 
%   See also: GET_VARIABLE_BY_GROUPING
% 
% For more example, go to: 
% https://einstein.psych.indiana.edu/trac/browser/projects/txu_remodule/txu_test_stats_cstream.m

% check fileds in 'input'
if ~exist('input', 'var')
    % this line of code is just to prevent from generating errors when
    % script checks whether a certain field exists.
    input.none_filed = 'No information here';
end

if ~exist('is_temporal_only', 'var')
    % by default, is_temporal_only is set to be false
    is_temporal_only = 0;
end

if ~exist('is_cal_cevent_stats', 'var')
    % by default, is_temporal_only is set to be false
    is_cal_cevent_stats = 0;
end

% if isfield(input, 'var_name')
%     if ~strcmp(get_data_type(input.var_name), 'cstream')
%         error('Error! This function can only accept CSTREAM data type');
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

cat_chunks = cat(1,chunks{:});
% max_category = nanmax(cat_chunks(:,2));

if isfield(input, 'categories')
    categories = input.categories;
    results.categories = categories;
else
    categories = unique(cat_chunks(:,2))';
    if isfield(input, 'nodata_marker')
        categories = categories(~ismember(categories,input.nodata_marker));
    end
    results.categories = categories;
end

%% calculate statistics
if ~is_temporal_only
    % proportion
    x_prop_total = cat_chunks(:,2) > 0;
    results.prop = sum(x_prop_total,'omitnan')/length(x_prop_total);

    % proportions for each category
    res_proportions = zeros(1, length(categories));
    for cidx = 1:length(categories)
        x_prop_one = (cat_chunks(:,2) <= (categories(cidx)+eps)) & ...
            (cat_chunks(:,2) >= (categories(cidx)-eps));

        res_proportions(cidx) = sum(x_prop_one)/length(x_prop_one);
    end
    results.prop_by_cat = res_proportions/sum(res_proportions,'omitnan');

    % proportions for each individual chunk
    res_individual_prop_by_cat = zeros(length(chunks), length(categories));
    results.individual_prop = zeros(length(chunks), 1);
    for i = 1: length(chunks)
        chunk = chunks{i};
        if isempty(chunk)
            res_individual_prop_by_cat(i, :) = NaN;
        else
            for cidx = 1:length(categories)
                x_prop_one = (chunk(:,2) <= (categories(cidx)+eps)) & ...
                    (chunk(:,2) >= (categories(cidx)-eps));            
                res_individual_prop_by_cat(i, cidx) = ...
                    sum(x_prop_one)/length(x_prop_one);
            end
        end
        res_individual_prop_by_cat(i,:) = res_individual_prop_by_cat(i,:)/ ...
            sum(res_individual_prop_by_cat(i,:),'omitnan');

        if ~isempty(chunk)
            x_prop_total = chunk(:,2) > 0;
            results.individual_prop(i, 1) = sum(x_prop_total,'omitnan')/length(x_prop_total);
        else
            results.individual_prop(i, 1) = NaN;
        end
    end
    results.individual_prop_by_cat = res_individual_prop_by_cat;
end

% calculate temporal profile
% If is_temporal_only is set to be true then only this part will be excuted
is_cal_temporal = 0;
offset = 0;
chunks_len = cellfun(@(chunk) length(chunk), chunks, 'UniformOutput', 0);
% calculate temporal profile automatically if all the chunks have the same
% length
if length(unique(cell2mat(chunks_len))) == 1 && length(chunks) > 1
    is_cal_temporal = 1;
    time_base = chunks{1};
    time_base = time_base(:,1);
end

if length(grouping) > 4 && strcmp(grouping(end-4:end), 'event') && ...
    isfield(input, 'whence') && isfield(input, 'interval')
    is_cal_temporal = 1;
    offset = input.interval(1);
    chunks_len_temp = vertcat(chunks_len{:});
    [max_v max_idx] = max(chunks_len_temp);
    time_base = chunks{max_idx};
    time_base = time_base(:,1);
end
    
if is_cal_temporal
    % [adjusted_chunks adjusted_time_base] = ...
    %     adjust_before_align(chunks, input.whence, input.interval);
    % temporal_chunk = align_streams(adjusted_time_base, ...
    %     adjusted_chunks, 'ForceZero');
    % temporal_chunk = round(temporal_chunk);
    if isfield(input, 'sample_rate')
        time_base = 0:input.sample_rate:(input.interval(2)-input.interval(1)-0.01);
    end
    temporal_chunk = align_streams(time_base, chunks, 'ForceZero');
    
    if isfield(input, 'nodata_marker')
        [res_temporal res_temporal_count] = probabilities_of_values(...
            temporal_chunk, input.nodata_marker);
    else
        [res_temporal res_temporal_count] = probabilities_of_values(...
            temporal_chunk);
    end
    
    results.temporal_time = time_base - time_base(1) + offset;
    % results.temporal_time = adjusted_time_base;
    results.temporal_probs = res_temporal;
    results.temporal_chunk = temporal_chunk;
    results.temporal_count = res_temporal_count;
end

% disp(['For all the cevents statistics, please extract cevent data chunks,' ...
%     ' and call function cevent_cal_stats']);

if is_cal_cevent_stats
    % convert to cevents
%     cevent_chunks = cellfun(@(chunk_one) ...
%         cstream2cevent(chunk_one, input.sample_rate), ...
%         chunks, ...
%         'UniformOutput', false);
    cevent_chunks = cellfun(@(chunk_one) ...
        cstream2cevent(chunk_one), ...
        chunks, ...
        'UniformOutput', false);
    temp_input = input;
    if isfield(input, 'var_name')
        temp_input.var_name = ['cevent'  input.var_name((length('cstream')+1):end)];
    end
    cevent_stats = cevent_cal_stats(cevent_chunks, temp_input);
    if ~isempty(cevent_stats)
        results.trans_matrix = cevent_stats.trans_matrix;
        results.CEVENT_STATS = '----------convert to cevents from here-----------';
        results.cevent_stats = cevent_stats;
    else
        results = [];
    end
end

