function [results_final chunked_data] = cevent_query_patterns(query,data,relation)

%[results_final chunked_data] = cevent_query_miner(query,data,relation)
% This function is used for extract cevent patterns specified by the user
% input. 
% 
% For the details about the input and the output, please see
% txu_cevent_query_test.m script.
% 


% check required fields
if isfield(query, 'sub_list')
    sub_list = query.sub_list;
else
    error('Missing parameter: SUB_LIST!');
end

if ~isfield(query, 'grouping')
    query.grouping = 'subject';
end

% extract all the data
for dataidx = 1:length(data)
    data_one_args = data(dataidx);
    data_one_args.grouping = 'subject';
    
    % user can either input the variable name or data directly
    if isfield(data_one_args, 'var_name') && ~isempty(data_one_args.var_name)
        chunks_one = get_variable_by_grouping('sub', sub_list, ...
            data_one_args.var_name, data_one_args.grouping, data_one_args);
    elseif isfield(data_one_args, 'chunks') && ~isempty(data_one_args.chunks)
        chunks_one = data_one_args.chunks;
    end
    
    % if there is a duration constraint on the data
    if isfield(data_one_args, 'dur_range') && ~isempty(data_one_args.dur_range)
        for cidx = 1:length(chunks_one)
            chunk_one = chunks_one{cidx};
            if size(chunk_one, 1) > 0
                duration_one = chunk_one(:,2) - chunk_one(:,1);
                x_valid_dur = duration_one > data_one_args.dur_range(1,1) & ...
                    duration_one < data_one_args.dur_range(1,2);

                chunk_one = chunk_one(x_valid_dur, :);
            end
            chunks_one{cidx} = chunk_one;
        end
    end
    
    data(dataidx).chunks = chunks_one;
end

entire_data_list = 1:length(data);
processed_data_list = [];
length_all_chunks = length(data(dataidx).chunks);

% extract relations and apply the relations on to the data
for relationidx = 1:length(relation)
    relation_one = relation(relationidx);
    results_separate_one = cell(length_all_chunks, length(entire_data_list));
    
    relation_one_base_id = relation_one.data_list(1,1);
    relation_one_search_id = relation_one.data_list(1,2);
    is_base_processed = 1;
    is_search_processed = 1;
    
    % check if previous results include either the search data or the
    % search data, so that the new search can only be limited to the
    % previous existing results
    if ~ismember(relation_one_base_id, processed_data_list)
        processed_data_list = [processed_data_list; relation_one_base_id];
        is_base_processed = 0;
    end    
    if ~ismember(relation_one_search_id, processed_data_list)
        processed_data_list = [processed_data_list; relation_one_search_id];
        is_search_processed = 0;
    end    
    
    if is_base_processed || is_search_processed
        prev_result_chunks = results_separates{relationidx-1};
    end
    
    if length(relation_one.data_list) ~= 2
        error(['Currently, RELATION only refers to relationship between' ...
            'two chunks of data']);
    else
        if ~is_base_processed
            chunks_base = data(relation_one_base_id).chunks;
        else
            chunks_base = prev_result_chunks(:, relation_one_base_id)';
        end
            
        if ~is_search_processed
            chunks_search = data(relation_one_search_id).chunks;
        else
            chunks_search = prev_result_chunks(:, relation_one_search_id)';
        end
    end
    
    if isfield(relation_one, 'whence_list') && ~isempty(relation_one.whence_list)
        whence_base = relation_one.whence_list{1};
        whence_search = relation_one.whence_list{2};
        interval = relation_one.interval;
    end
    
    for chunkidx = 1:length(chunks_base)
        chunk_one_base = chunks_base{chunkidx};
        chunk_one_search = chunks_search{chunkidx};
        chunk_one_search = event_eliminate_repeat(chunk_one_search);
        
        if ~isfield(relation_one, 'mapping_arg') || isempty(relation_one.mapping_arg)
            mapping_arg = 'many2many';
        else
            mapping_arg = relation_one.mapping_arg;
        end
        
        % by default the relation will be set as 'within'
        if ~isfield(relation_one, 'type') || isempty(relation_one.type) ...
                || strcmp(relation_one.type, 'within')
            if isfield(relation_one, 'roi_list') && ~isempty(relation_one.roi_list)
                [mask_suc_base events_suc_base events_suc_search time_hist] = ...
                    cevent_get_cevents_within_interval(chunk_one_base, chunk_one_search, ...
                    whence_base, whence_search, interval, relation_one.roi_list, mapping_arg);
            else
                [mask_suc_base events_suc_base events_suc_search time_hist] = ...
                    cevent_get_cevents_within_interval(chunk_one_base, chunk_one_search, ...
                    whence_base, whence_search, interval, mapping_arg);
            end
           
        elseif strcmp(relation_one.type, 'following')
            if isfield(relation_one, 'roi_list') && ~isempty(relation_one.roi_list)
                [mask_suc_base events_suc_base events_suc_search time_hist] = ...
                    cevent_get_following_cevents(chunk_one_base, chunk_one_search, ...
                    whence_base, whence_search, interval, relation_one.roi_list, mapping_arg);
            else
                [mask_suc_base events_suc_base events_suc_search time_hist] = ...
                    cevent_get_following_cevents(chunk_one_base, chunk_one_search, ...
                    whence_base, whence_search, interval, mapping_arg);
            end
            
        % **the output for leading is special, the base and search are
        % backwards
        elseif strcmp(relation_one.type, 'leading')
            if isfield(relation_one, 'roi_list') && ~isempty(relation_one.roi_list)
                [mask_suc_base events_suc_search events_suc_base time_hist] = ...
                    cevent_get_leading_cevents(chunk_one_search, chunk_one_base, ...
                    whence_search, whence_base, interval, relation_one.roi_list, mapping_arg);
            else
                [mask_suc_base events_suc_search events_suc_base time_hist] = ...
                    cevent_get_leading_cevents(chunk_one_search, chunk_one_base, ...
                    whence_search, whence_base, interval, mapping_arg);
            end
            
        elseif strcmp(relation_one.type, 'overlap')
            if ~isfield(relation_one, 'overlap_arg') || isempty(relation_one.overlap_arg)
                overlap_arg = 'all';
            elseif isfield(relation_one, 'overlap_arg')
                overlap_arg = relation_one.overlap_arg;
            end
            
            if isfield(relation_one, 'roi_list') && ~isempty(relation_one.roi_list)
                [mask_suc_base events_suc_base events_suc_search] = ...
                    cevent_get_overlap_cevents(chunk_one_base, chunk_one_search, ...
                    relation_one.roi_list, overlap_arg);
            else
                [mask_suc_base events_suc_base events_suc_search] = ...
                    cevent_get_overlap_cevents(chunk_one_base, chunk_one_search, ...
                    overlap_arg);
            end
        end
        
        if ~strcmp(mapping_arg, 'many2many') && ~strcmp(relation_one.type, 'overlap')
            events_suc_search = mat2cell(events_suc_search, ones(1,size(events_suc_search,1)),[3]);
            
        end        
        
        if ~isempty(events_suc_search)
            cell_search_length_list = cellfun(@(data_one) ...
                size(data_one, 1), ...
                events_suc_search, ...
                'UniformOutput', false);
            cell_search_length_list = vertcat(cell_search_length_list{:});
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%% The algorithm here is first shrink and expand %%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if ~is_base_processed && ~is_search_processed % which means relationidx == 1
                events_suc_search = cell2mat(events_suc_search);
                events_suc_base = cevent_repmat(events_suc_base, cell_search_length_list);
                results_separate_one{chunkidx, relation_one_base_id} = events_suc_base;
                results_separate_one{chunkidx, relation_one_search_id} = ...
                    events_suc_search;

            % if base chunk is already been processed
            elseif is_base_processed && ~is_search_processed
                results_separate_one{chunkidx, relation_one_base_id} = ...
                    cevent_repmat(events_suc_base, cell_search_length_list);
                results_separate_one{chunkidx, relation_one_search_id} = ...
                    cell2mat(events_suc_search);

                unfiltered_data_list = setdiff(processed_data_list, ...
                    relation_one.data_list);

                % shrink and expand all in one
                for tmpudli = 1:length(unfiltered_data_list)
                    tmp_chunk_one = prev_result_chunks{chunkidx, unfiltered_data_list(tmpudli)};
                    tmp_chunk_one = cevent_repmat(...
                        tmp_chunk_one(mask_suc_base>0,:), cell_search_length_list);
                    results_separate_one{chunkidx, unfiltered_data_list(tmpudli)} = ...
                        tmp_chunk_one;
                end

            % if the search chunk is already been processed
            elseif ~is_base_processed && is_search_processed            
                search_orgn_chunk = chunks_search{chunkidx};
                events_suc_search = cell2mat(events_suc_search);
                events_suc_base = cevent_repmat(events_suc_base, cell_search_length_list);

                % first build the mask_suc_search
                mask_suc_search = false(size(search_orgn_chunk, 1), 1);
                for tmpmssi = 1:size(mask_suc_search, 1)
                    mask_suc_search(tmpmssi, 1) = ...
                        ismember(round(search_orgn_chunk(tmpmssi, 1)*10000)/10000, ...
                        round(events_suc_search(:,1)*10000)/10000);
                end            

                % then build the backward trace and expand
                events_suc_search_filtered = ...
                    prev_result_chunks{chunkidx,relation_one_search_id}(mask_suc_search>0,:);
                cell_events_suc_base = {};

                for tmpessfi = 1:size(events_suc_search_filtered, 1)
                    event_suc_search_filtered_one = events_suc_search_filtered(tmpessfi,:);

                    tmp_mask_one = ...
                        (event_suc_search_filtered_one(1,1) == events_suc_search(:,1) ...
                        & (event_suc_search_filtered_one(1,2) == events_suc_search(:,2)));
                    cell_events_suc_base{tmpessfi,1} = events_suc_base(tmp_mask_one,:);
                end

                cell_base_length_list = cellfun(@(data_one) ...
                    size(data_one, 1), ...
                    cell_events_suc_base, ...
                    'UniformOutput', false);
                cell_base_length_list = vertcat(cell_base_length_list{:});

                unfiltered_data_list = setdiff(processed_data_list, ...
                    relation_one_base_id);
                results_separate_one{chunkidx, relation_one_base_id} = ...
                        cell2mat(cell_events_suc_base);

                % shrink and expand
                for tmpudli = 1:length(unfiltered_data_list)
                    tmp_chunk_one = prev_result_chunks{chunkidx, unfiltered_data_list(tmpudli)};
                    tmp_chunk_one = cevent_repmat(...
                        tmp_chunk_one(mask_suc_search>0,:), cell_base_length_list);
                    results_separate_one{chunkidx, unfiltered_data_list(tmpudli)} = ...
                        tmp_chunk_one;
                end


            % if both base and search chunks are processed
            elseif is_base_processed && is_search_processed
                events_search_exist = ...
                    prev_result_chunks{chunkidx,relation_one_search_id};
                events_search_exist = events_search_exist(mask_suc_base>0,:);
                pattern_valid_mask = false(size(events_search_exist,1),1);
                
                for tmpssei = 1:size(events_search_exist,1)
                    tmp_event_one = events_search_exist(tmpssei,:);
                    pattern_valid_mask(tmpssei,1) = ...
                        ismember(tmp_event_one(1,1), events_suc_search{tmpssei,1}(:,1)) ...
                        && ismember(tmp_event_one(1,2), events_suc_search{tmpssei,1}(:,2));
                end
                                
                % shrink
                for tmppdli = 1:length(processed_data_list)
                    tmp_chunk_one = prev_result_chunks{chunkidx, processed_data_list(tmppdli)};
                    tmp_chunk_one = tmp_chunk_one(mask_suc_base>0,:);
                    tmp_chunk_one = tmp_chunk_one(pattern_valid_mask,:);
                    results_separate_one{chunkidx, processed_data_list(tmppdli)} = ...
                        tmp_chunk_one;
                end
            end
        else
            % shrink and expand
            for tmpudli = 1:length(processed_data_list)
                results_separate_one{chunkidx, processed_data_list(tmpudli)} = ...
                    zeros(0,3);
            end
        end
    end
    
    results_separates{relationidx} = results_separate_one;
end

for rsoi = 1:size(results_separate_one,1)
    results_final{rsoi,1} = cevent_pattern_eliminate_repeat(...
        cell2mat(results_separate_one(rsoi,:)));
end
% results_final = cell2mat(results_separate_one);
% results_final = cevent_pattern_eliminate_repeat(results_final);

if isfield(query, 'chunking_var_name')
    chunking_var_name = query.chunking_var_name;
    chunking_ref_column = query.chunking_ref_column;
    chunked_data = {};
    
    % check the validity of the ref column number
    LENGTH_CEVENT = 3;
    time_column_idx_list = sort...
        ([1:3:length(data)*LENGTH_CEVENT 2:3:length(data)*LENGTH_CEVENT]);
    if sum(~ismember(chunking_ref_column, time_column_idx_list)) > 0
        error('Invalid chunking_ref_column value!');
    end
         
        
    for rfi = 1:size(results_final,1)
        results_final_one = results_final{rfi, 1};
        sub_id = sub_list(rfi);
        for cvni = 1:length(chunking_var_name)
            chunking_var_name_one = chunking_var_name{cvni};
            if ~isempty(results_final_one)
                tmp_ranges = [results_final_one(:,chunking_ref_column(1,1)) ...
                    results_final_one(:,chunking_ref_column(1,2))];
                tmp_ranges = cevent_relative_intervals(...
                    tmp_ranges, query.chunking_whence, query.chunking_interval);

            % sum((tmp_ranges(:,2)-tmp_ranges(:,1))<0)
                tmp_var_data = get_variable(sub_id, chunking_var_name_one);
                tmp_var_data = extract_ranges(...
                    tmp_var_data, get_data_type(chunking_var_name_one), tmp_ranges);                
                chunked_data{rfi, cvni} = tmp_var_data;
            else
                chunked_data{rfi, cvni} = {};
            end
        end
    end
end
    