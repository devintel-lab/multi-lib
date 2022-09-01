function results = get_variable_by_regrouping(input)
%GET_VARIABLE_BY_REGROUPING Get only the valid portion of a variable's data
%according to different grouping method and parameters. 
% 
% For very detailed example and explanation of how to set the parameters,
% please go to:
% http://einstein.psych.indiana.edu/visual/multi-lib/data-access/demo_get_variable_by_regrouping.m
% 
% when the input variable contains more than 1 variable name (of same type)
% the output chunks will be containing processed data of regrouped chunks
% 
% 
% written by Linger Xu, txu@indiana.edu, Apr. 2012
%
% last update: June 20th, 2014


ROI_OFFSET = 100;

% get sub_list according to user input
if isfield(input, 'exp_list')
    sub_list = [];
    for expidx = 1:length(input.exp_list)
        sub_list = [sub_list; list_subjects(input.exp_list(expidx))];
    end
elseif isfield(input, 'sub_list')
    sub_list = input.sub_list;
else
    error('Either exp_list or sub_list should be specified.');
end

if isempty(sub_list)
    error('The subect list is empty.');
end

% if the variable to be extracted are continue variables or event
% variables, the name input should be a cell - a list of variable names
if ~iscell(input.var_name)
    extracted_var_type = get_data_type(input.var_name);
%     if ~(strcmp(tmp_var_type, 'cstream') || strcmp(tmp_var_type, 'cevent'))
%         error('Invalid input: VAR_NAME');
%     end
else
    extracted_var_type = get_data_type(input.var_name{1});
%     if ~(strcmp(tmp_var_type, 'cont') || strcmp(tmp_var_type, 'event'))
%         error('Invalid input: VAR_NAME');
%     end
end

% create local vars specified by input
var_name = input.var_name;
groupid_matrix = input.groupid_matrix;
groupid_matrix_list = unique(groupid_matrix);
% cevent_category = input.cevent_category;
if ~isfield(input, 'var_category')
    error(['Under all situations, the field ' ...
        'VAR_CATEGORY must be specified.']);
else
    var_category = input.var_category;
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if iscell(input.var_name)
    if isfield(input, 'grouping')
        grouping = input.grouping;
        if ~strcmp(grouping, 'subcevent_cat')
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 error(['Currently, only when the grouping is subcevent_cat, ' ...
%                     'this function works and thoroughly tested. It will be updated.']);
        end
    else
        grouping = 'subcevent_cat';
        input.grouping = grouping;
    end
    
    if strcmp(grouping, 'subcevent_cat') || strcmp(grouping, 'subevent_cat')
        for lmlidx = 1:length(groupid_matrix_list)
            results(lmlidx).regroup_label_id = groupid_matrix_list(lmlidx);
            results(lmlidx).chunks_count = 0;
            results(lmlidx).chunks = cell(length(sub_list), 1);
            results(lmlidx).sub_list = sub_list;
            results(lmlidx).dur_list = zeros(length(sub_list), 1);
        end
    elseif strcmp(grouping, 'trialcevent_cat') || strcmp(grouping, 'trialevent_cat')
        for lmlidx = 1:length(groupid_matrix_list)
            results(lmlidx).regroup_label_id = groupid_matrix_list(lmlidx);
            results(lmlidx).chunks_count = 0;
            results(lmlidx).chunks = [];
            results(lmlidx).sub_list = [];
            results(lmlidx).dur_list = [];
        end
    elseif strcmp(grouping, 'cevent') || strcmp(grouping, 'event') ...
            || strcmp(grouping, 'trialcevent') || strcmp(grouping, 'trialevent')
        for lmlidx = 1:length(groupid_matrix_list)
            results(lmlidx).regroup_label_id = groupid_matrix_list(lmlidx);
            results(lmlidx).chunks_count = 0;
            results(lmlidx).chunks = [];
            results(lmlidx).sub_list = [];
            results(lmlidx).dur_list = [];
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if isfield(input, 'cevent_name')
        if ~isfield(input, 'cevent_category')
            error(['When data are regrouped by cevents, the field ' ...
                'CEVENT_CATEGORY must be specified.']);
        end
        
        extracted_var_len = 2;
        if strcmp(extracted_var_type, 'cevent')
            extracted_var_len = 3;
        end
        regroup_op_idx = [extracted_var_len extracted_var_len*2];
        
        if isfield(input, 'regroup_op')
            regroup_op = input.regroup_op; % it can be 'OR', 'AND', 'CAT', or 'AVG'
            
            if (~strcmp(regroup_op, 'CAT')) && (strcmp(extracted_var_type, 'event') || strcmp(extracted_var_type, 'cevent'))
                error('For event/cevent variable, regrouping operation can only be CAT - concatenation');
            end
        else
            if strcmp(extracted_var_type, 'cstream')
                regroup_op = 'OR';
            elseif strcmp(extracted_var_type, 'cont')
                regroup_op = 'AVG';
            elseif strcmp(extracted_var_type, 'event')
                regroup_op = 'CAT';
            elseif strcmp(extracted_var_type, 'cevent')
                regroup_op = 'CAT';
            end
        end
        
        cevent_category = input.cevent_category;
        
        cevent_name = input.cevent_name;

        for ceventidx = 1 : length(cevent_category)
            input.cevent_values = cevent_category(ceventidx);
            chunks_list = cell(length(var_name), 1);
            chunk_sub_list = cell(length(var_name), 1);
            chunk_dur_list = cell(length(var_name), 1);
            
            for contidx = 1:length(var_name)
                [chunks_one, extra_one] = get_variable_by_grouping('sub', sub_list, ...
                    var_name{contidx}, grouping, input);
                if strcmp(extracted_var_type, 'cstream')
                    chunks_one_new = cellfun( ...
                        @(chunk_one) ...
                        cstream_reassign_categories(chunk_one, {},(groupid_matrix(contidx, ceventidx))+ROI_OFFSET), ...
                        chunks_one, ...
                        'UniformOutput', 0);
                    chunks_one = chunks_one_new;
                    
                    chunks_one_cat = vertcat(chunks_one_new{:});
                    roi_checking = unique(chunks_one_cat(:,2));
                    if length(roi_checking) > 2
                        error('cstream roi are not reassigned!');
                    end
                elseif strcmp(extracted_var_type, 'cevent')
                    chunks_one_new = cellfun( ...
                        @(chunk_one) ...
                        cevent_reassign_categories(chunk_one, {},(groupid_matrix(contidx, ceventidx))+ROI_OFFSET), ...
                        chunks_one, ...
                        'UniformOutput', 0);
                    chunks_one = chunks_one_new;

                    chunks_one_cat = vertcat(chunks_one_new{:});
                    roi_checking = unique(chunks_one_cat(:,3));
                    if length(roi_checking) > 2
                        error('cevent roi are not reassigned!');
                    end
                end
                chunks_list{contidx} = chunks_one;
                chunk_sub_list{contidx} = extra_one.sub_list;
                chunk_dur_list{contidx} = extra_one.individual_range_dur;
            end

            label_column = groupid_matrix(:, ceventidx);
            label_column_list = unique(label_column);
            for lidx = 1:length(label_column_list)
                label_one = label_column_list(lidx);
%                 label_one_idx = find(groupid_matrix_list == label_one);
                data_label_idx = find(label_column == label_one);
                
                if length(data_label_idx) > 1
                    chunk_tmp = cell(1,length(data_label_idx));
                    chunk_dur_tmp = cell(1,length(data_label_idx));
                    chunk_sub_tmp = cell(1,length(data_label_idx));
                    for dlidx = 1:length(data_label_idx)
                        chunk_tmp{dlidx} = chunks_list{data_label_idx(dlidx)};
                        chunk_dur_tmp{dlidx} = chunk_dur_list{data_label_idx(dlidx)};
                        chunk_sub_tmp{dlidx} = chunk_sub_list{data_label_idx(dlidx)};
                    end
                    chunk_tmp = horzcat(chunk_tmp{:});
                    chunk_tmp_new = cell(size(chunk_tmp, 1), 1); 
                    
                    switch regroup_op
                        case 'CAT'
                            for tmpci = 1:size(chunk_tmp, 1)
                                chunk_tmp_new{tmpci,1} = vertcat(chunk_tmp{tmpci, :});
                            end
                        case 'OR'
                            for tmpci = 1:size(chunk_tmp, 1)
                                tmp_one = horzcat(chunk_tmp{tmpci, :});
                                if ~isempty(tmp_one)
                                    chunk_tmp_new{tmpci,1} = [tmp_one(:,1) max(tmp_one(:,regroup_op_idx), [], 2,'omitnan')];
                                end
                            end
                        case 'AVG'
                            for tmpci = 1:size(chunk_tmp, 1)
                                tmp_one = horzcat(chunk_tmp{tmpci, :});
                                if ~isempty(tmp_one)
                                    chunk_tmp_new{tmpci,1} = [tmp_one(:,1) mean(tmp_one(:,regroup_op_idx), 2,'omitnan')];
                                end
                            end
                        case 'SUM'
                            for tmpci = 1:size(chunk_tmp, 1)
                                tmp_one = horzcat(chunk_tmp{tmpci, :});
                                if ~isempty(tmp_one)
                                    chunk_tmp_new{tmpci,1} = [tmp_one(:,1) sum(tmp_one(:,regroup_op_idx), 2,'omitnan')];
                                end
                            end
                        case 'AND'
                            for tmpci = 1:size(chunk_tmp, 1)
                                tmp_one = horzcat(chunk_tmp{tmpci, :});
                                if ~isempty(tmp_one)
                                    chunk_tmp_new{tmpci,1} = [tmp_one(:,1) min(tmp_one(:,regroup_op_idx), [], 2,'omitnan')];
                                end
                            end
                        otherwise
                            error('Invalid regroup operation!');
                    end
                        
                    chunk_dur_tmp = chunk_dur_tmp{1};
                    chunk_sub_tmp = chunk_sub_tmp{1};
                    chunk_tmp = chunk_tmp_new;
                else
                    chunk_tmp = chunks_list{data_label_idx};
                    chunk_dur_tmp = chunk_dur_list{data_label_idx};
                    chunk_sub_tmp = chunk_sub_list{data_label_idx};
                end
                

                if strcmp(grouping, 'subcevent_cat')
                    chunks_new = results(label_one).chunks;
                    chunks_dur_new = results(label_one).dur_list;

                    for sidx = 1:size(chunk_tmp, 1)
                        chunks_new{sidx, 1} = ...
                            vertcat(chunks_new{sidx, 1}, chunk_tmp{sidx});
                        chunks_dur_new(sidx, 1) = ...
                            chunk_dur_tmp(sidx) + chunks_dur_new(sidx);
                    end
                    results(label_one).chunks = chunks_new;
                    results(label_one).dur_list = chunks_dur_new;
                elseif strcmp(grouping, 'trialcevent_cat')
                    chunks_new = results(label_one).chunks;
                    chunks_dur_new = results(label_one).dur_list;

                    for sidx = 1:size(chunk_tmp, 1)
                        chunks_new{sidx, 1} = ...
                            vertcat(chunks_new{sidx, 1}, chunk_tmp{sidx});
                        chunks_dur_new(sidx, 1) = ...
                            chunk_dur_tmp(sidx) + chunks_dur_new(sidx);
                    end
                    results(label_one).chunks = chunks_new;
                    results(label_one).dur_list = chunks_dur_new;
                elseif strcmp(grouping, 'cevent')
                    chunk_count_one = length(chunk_tmp);
                    results(label_one).chunks = ...
                        [results(label_one).chunks; chunk_tmp];
                    results(label_one).sub_list = ...
                        [results(label_one).sub_list; chunk_sub_tmp];
                    results(label_one).dur_list = ...
                        [results(label_one).dur_list; chunk_dur_tmp];
                end
            end
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    elseif isfield(input, 'event_name')
        event_name = input.event_name;

        if isfield(input, 'grouping')
            grouping = input.grouping;
            if ~strcmp(grouping, 'subevent_cat')
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                error(['Currently, only when the grouping is subcevent_cat, ' ...
                    'this function works and thoroughly tested. It will be updated.']);
            end
        else
            grouping = 'subevent_cat';
            input.grouping = grouping;
        end
    
        if strcmp(grouping, 'subevent_cat')
            for lmlidx = 1:length(groupid_matrix_list)
                results(lmlidx).sub_list = sub_list;
            end
        end
        
        for contidx = 1:length(var_name)
            label_row = groupid_matrix(contidx,:);
            label_row_list = unique(label_row);
            
            for lidx = 1:length(label_row_list)
                label_one = label_row_list(lidx);
%                 label_one_idx = find(groupid_matrix_list == label_one);
                data_label_idx = find(label_row == label_one);

                for dlidx = 1:length(data_label_idx)                    
                    input_one = input;
                    input_one.var_name = input.var_name{contidx};
                    input_one.event_name = input.event_name{data_label_idx(dlidx)};
                    [chunks_one extra_one] = get_variable_by_grouping('sub', sub_list, ...
                        var_name{contidx}, grouping, input_one);
                    
                    if strcmp(extracted_var_type, 'cstream')
                        chunks_one_new = cellfun( ...
                            @(chunk_one) ...
                            cstream_reassign_categories(chunk_one, {},(groupid_matrix(contidx, ceventidx))+ROI_OFFSET), ...
                            chunks_one, ...
                            'UniformOutput', 0);
                        chunks_one = chunks_one_new;

                        chunks_one_cat = vertcat(chunks_one_new{:});
                        roi_checking = unique(chunks_one_cat(:,2));
                        if length(roi_checking) > 2
                            error('cstream roi are not reassigned!');
                        end
                    elseif strcmp(extracted_var_type, 'cevent')
                        chunks_one_new = cellfun( ...
                            @(chunk_one) ...
                            cevent_reassign_categories(chunk_one, {},(groupid_matrix(contidx, ceventidx))+ROI_OFFSET), ...
                            chunks_one, ...
                            'UniformOutput', 0);
                        chunks_one = chunks_one_new;

                        chunks_one_cat = vertcat(chunks_one_new{:});
                        roi_checking = unique(chunks_one_cat(:,3));
                        if length(roi_checking) > 2
                            error('cevent roi are not reassigned!');
                        end
                    end

                    if strcmp(grouping, 'subevent_cat')
                        tmp_length = results(label_one).chunks_count + 1;
                        results(label_one).chunks(:,tmp_length) = chunks_one;
                        results(label_one).chunks_count = tmp_length;
                        results(label_one).dur_list = ...
                            results(label_one).dur_list + extra_one.individual_range_dur;
                    elseif strcmp(grouping, 'event')
                        tmp_length = results(label_one).chunks_count + length(chunks_one);
                        results(label_one).chunks...
                            ((results(label_one).chunks_count+1):tmp_length,:) ...
                            = chunks_one;
                        results(label_one).chunks_count = tmp_length;
                    end
                end
            end
        end

        if strcmp(grouping, 'subevent_cat')
            for lmlidx = 1:length(groupid_matrix_list)
                tmp_chunks = results(lmlidx).chunks;
                tmp_chunks_new = {};

                for sidx = 1:size(tmp_chunks, 1)
                    tmp_chunks_new{sidx,1} = vertcat(tmp_chunks{sidx,:});
                end

                results(lmlidx).chunks = tmp_chunks_new;
            end
        end
    end    

%     for lmlidx = 1:length(groupid_matrix_list)
%         results(lmlidx) = rmfield(results(lmlidx), 'chunks_count');
%     end

    % reassign the roi values back to roi values
    if strcmp(extracted_var_type, 'cstream')
        for lmlidx = 1:length(groupid_matrix_list)
            chunks_new = results(lmlidx).chunks;
            for cnidx = 1:length(chunks_new)
                chunk_one_new = chunks_new{cnidx};

                label_one = groupid_matrix_list(lmlidx);
                chunk_one_new = ...
                    cstream_reassign_categories(chunk_one_new, {label_one+ROI_OFFSET}, {label_one});
                
                [Y I] = sort(chunk_one_new(:,1));
                chunk_one_new = chunk_one_new(I,:);
                results(lmlidx).chunks{cnidx} = chunk_one_new;
            end

        end
    elseif strcmp(extracted_var_type, 'cevent')
        for lmlidx = 1:length(groupid_matrix_list)
            chunks_new = results(lmlidx).chunks;
            for cnidx = 1:length(chunks_new)
                chunk_one_new = chunks_new{cnidx};

                label_one = groupid_matrix_list(lmlidx);
                chunk_one_new = ...
                    cevent_reassign_categories(chunk_one_new, {label_one+ROI_OFFSET}, {label_one});

                [Y I] = sort(chunk_one_new(:,1));
                chunk_one_new = chunk_one_new(I,:);
                results(lmlidx).chunks{cnidx} = chunk_one_new;
            end
        end
%     else
%         error('Invalid input: VAR_NAME. Please see example page.');
    end

else
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% if not cell start here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    results.regroup_id_list = groupid_matrix_list;
    
    if ~isfield(input, 'var_category')
        error(['When data are in the format of cstream or cevents, ' ...
                'the field VAR_CATEGORY must be specified.']);
    end
    var_category = input.var_category;
    
    if isfield(input, 'cevent_name')
        if isfield(input, 'grouping')
            grouping = input.grouping;
            if ~strcmp(grouping, 'subcevent_cat')
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 error(['Currently, only when the grouping is subcevent_cat, ' ...
%                     'this function works and thoroughly tested. It will be updated.']);
            end
        else
            grouping = 'subcevent_cat';
            input.grouping = grouping;
        end
        
        if strcmp(grouping, 'subcevent_cat')
            results.chunks = cell(length(sub_list), 1);
            results.sub_list = sub_list;
            results.dur_list = zeros(length(sub_list), 1);
        elseif strcmp(grouping, 'cevent')
            results.chunks = {};
            results.sub_list = [];
            results.dur_list = [];
            results.cevent_list = [];
        end
        
        if ~isfield(input, 'cevent_category')
            error(['When data are regrouped by cevents, the field ' ...
                'CEVENT_CATEGORY must be specified.']);
        end
        
        cevent_category = input.cevent_category;
        cevent_name = input.cevent_name;

        for ceventidx = 1 : length(cevent_category)
            input.cevent_values = cevent_category(ceventidx);

            [chunks_one, extra] = get_variable_by_grouping('sub', sub_list, ...
                var_name, grouping, input);
            if strcmp(grouping, 'cevent') && isempty(chunks_one)
            	continue
            end
            
            label_column = groupid_matrix(:, ceventidx);
            label_column_list = unique(label_column);
            
            for lidx = 1:length(label_column_list)
                label_one = label_column_list(lidx);
%                 label_one_idx = find(groupid_matrix_list == label_one);
                target_categories = var_category(label_column == label_one);
                
                if strcmp(extracted_var_type, 'cstream')
                    chunks_one_new = cellfun( ...
                        @(chunk_one) ...
                        cstream_reassign_categories(chunk_one, {target_categories}, {label_one+ROI_OFFSET}), ...
                        chunks_one, ...
                        'UniformOutput', 0);
                elseif strcmp(extracted_var_type, 'cevent')
                    chunks_one_new = cellfun( ...
                        @(chunk_one) ...
                        cevent_reassign_categories(chunk_one, {target_categories}, {label_one+ROI_OFFSET}), ...
                        chunks_one, ...
                        'UniformOutput', 0);
                else
                    error('Invalid input: VAR_NAME. Please see example page.');
                end
                
                chunks_one = chunks_one_new; 
            end
            chunks_dur_list = extra.individual_range_dur;
            cevent_list = extra.individual_cevent;
            
            if strcmp(grouping, 'subcevent_cat')
                chunks_new = results.chunks;
                chunks_dur_new = results.dur_list;
                
                for sidx = 1:size(chunks_one, 1)
                    chunks_new{sidx, 1} = ...
                        vertcat(chunks_new{sidx, 1}, chunks_one{sidx});
                    chunks_dur_new(sidx, 1) = ...
                        chunks_dur_new(sidx, 1)+chunks_dur_list(sidx, 1);
                end
                results.chunks = chunks_new;
                results.dur_list = chunks_dur_new;
            elseif strcmp(grouping, 'cevent')
                results.chunks = [results.chunks; chunks_one];
                results.sub_list = [results.sub_list; extra.sub_list];
                results.dur_list = [results.dur_list; extra.individual_range_dur];
                results.cevent_list = [results.cevent_list; cevent_list];
            end
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    elseif isfield(input, 'event_name') && false
        event_name = input.event_name;

        if isfield(input, 'grouping')
            grouping = input.grouping;
            if ~strcmp(grouping, 'subevent_cat')
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                error(['Currently, only when the grouping is subevent_cat, ' ...
                    'this function works and thoroughly tested. It will be updated.']);
            end
        else
            grouping = 'subevent_cat';
            input.grouping = grouping;
        end
        
        if strcmp(grouping, 'subcevent_cat')
            results.chunks = cell(length(sub_list), 1);
            results.sub_list = sub_list;
            results.dur_list = zeros(length(sub_list), 1);
        end
        
        for eventidx = 1 : length(event_name)
            input_one = input;
            input_one.event_name = event_name{eventidx};

            chunks_one = get_variable_by_grouping('sub', sub_list, ...
                var_name, grouping, input_one);
            
            label_column = groupid_matrix(:, ceventidx);
            label_column_list = unique(label_column);
            
            for lidx = 1:length(label_column_list)
                label_one = label_column_list(lidx);
%                 label_one_idx = find(groupid_matrix_list == label_one);
                target_categories = var_category(label_column == label_one);
                
                if strcmp(extracted_var_type, 'cstream')
                    chunks_one_new = cellfun( ...
                        @(chunk_one) ...
                        cstream_reassign_categories(chunk_one, {target_categories}, {label_one}), ...
                        chunks_one, ...
                        'UniformOutput', 0);
                elseif strcmp(extracted_var_type, 'cevent')
                    chunks_one_new = cellfun( ...
                        @(chunk_one) ...
                        cevent_reassign_categories(chunk_one, {target_categories}, {label_one}), ...
                        chunks_one, ...
                        'UniformOutput', 0);
                else
                    error('Invalid input: VAR_NAME. Please see example page.');
                end
                
                chunks_one = chunks_one_new;                
            end
            
            if strcmp(grouping, 'subcevent_cat')
                chunks_new = results.chunks;
                for sidx = 1:size(chunks_one_new, 1)
                    chunks_new{sidx, 1} = ...
                        vertcat(chunks_new{sidx, 1}, chunks_one_new{sidx});
                end
                results.chunks = chunks_new;
            elseif strcmp(grouping, 'cevent')
                results.chunks = ...
                    vertcat(results.chunks, chunks_one_new{:});
            end
        end
        
        for contidx = 1:length(var_name)

            label_row = groupid_matrix(contidx,:);
            label_row_list = unique(label_row);
            for lidx = 1:length(label_row_list)
                label_one = label_row_list(lidx);
%                 label_one_idx = find(groupid_matrix_list == label_one);
                data_label_idx = find(label_row == label_one);

                for dlidx = 1:length(data_label_idx)                    
                    input_one = input;
                    input_one.var_name = input.var_name{contidx};
                    input_one.event_name = input.event_name{data_label_idx(dlidx)};
                    chunks_one = get_variable_by_grouping('sub', sub_list, ...
                        var_name{contidx}, grouping, input_one);

                    if strcmp(grouping, 'subevent_cat')
                        tmp_length = results(label_one).chunks_count + 1;
                        results(label_one).results(:,tmp_length) = chunks_one;
                        results(label_one).chunks_count = tmp_length;
                    elseif strcmp(grouping, 'event')
                        tmp_length = results(label_one).chunks_count + length(chunks_one);
                        results(label_one).chunks...
                            ((results(label_one).chunks_count+1):tmp_length,:) ...
                            = chunks_one;
                        results(label_one).chunks_count = tmp_length;
                    end
                end
            end
        end

        if strcmp(grouping, 'subevent_cat')
            for lmlidx = 1:length(groupid_matrix_list)
                tmp_chunks = results(lmlidx).chunks;
                tmp_chunks_new = {};

                for sidx = 1:size(tmp_chunks, 1)
                    tmp_chunks_new{sidx,1} = vertcat(tmp_chunks{sidx,:});
                end

                results(lmlidx).chunks = tmp_chunks_new;
            end
        end
    end
    
    % reassign the roi values back to roi values
    if strcmp(extracted_var_type, 'cstream')
        chunks_new = results.chunks;
        for cnidx = 1:length(chunks_new)
            chunk_one_new = chunks_new{cnidx};
            for lmlidx = 1:length(groupid_matrix_list)
                label_one = groupid_matrix_list(lmlidx);
                chunk_one_new = ...
                    cstream_reassign_categories(chunk_one_new, {label_one+ROI_OFFSET}, {label_one});
            end

            [Y I] = sort(chunk_one_new(:,1));
            chunk_one_new = chunk_one_new(I,:);
            results.chunks{cnidx} = chunk_one_new;
        end
    elseif strcmp(extracted_var_type, 'cevent')
        chunks_new = results.chunks;
        for cnidx = 1:length(chunks_new)
            chunk_one_new = chunks_new{cnidx};
            for lmlidx = 1:length(groupid_matrix_list)
                label_one = groupid_matrix_list(lmlidx);
                chunk_one_new = ...
                    cevent_reassign_categories(chunk_one_new, {label_one+ROI_OFFSET}, {label_one});
            end
            [Y I] = sort(chunk_one_new(:,1));
            chunk_one_new = chunk_one_new(I,:);
            results.chunks{cnidx} = chunk_one_new;
        end
    else
        error('Invalid input: VAR_NAME. Please see example page.');
    end
end

% results_output = results;
