
%
% stats of a single cevent variable
%

clear results;

% need a configuration file to specify all the parameters 
% e.g.
%var_single_cevent_head;

res_trans_mat=zeros(num_valid_value); % 
dur_data = [];
for j = 1 : size(categories,2);
    dur_data_by_value {j} = []; 
end;

for i = 1 : size(sub_list,1)
    if grouping == 1
        [chunks] = get_variable_by_trial(sub_list(i), var_name);
    elseif grouping == 2
        [chunks] = get_variable_by_cevent(sub_list(i), var_name, cevent_var_name,cevent_value);
    elseif grouping == 3
        [chunks] = get_variable_by_event(sub_list(i), var_name, event_var_name);
    end;
    if ~isempty(chunks)
        
        cevent = cat(1, chunks{:});
        if isempty(strfind(var_name,'cevent'))
            cevent = event2cevent(cevent);
        end;
        cstream = cevent2cstream(cevent,30, 0.1);
        
        for j = 1 : size(categories,2)
            res_hist(i,j) = size(find(cstream(:,2) == categories(j)),1);
            event =  cevent(cevent(:,3)==categories(j),1:2);
            res_event_number(i,j) = nanmean(size(event,1));
            res_event_dur(i,j) = nanmean(event(:,2)-event(:,1));
            res_event_dur_median(i,j) = nanmedian(event(:,2)-event(:,1));
            dur_data = [ dur_data; event(:,2) - event(:,1)];
            dur_data_by_value{j} = [dur_data_by_value{j}; event(:,2) - ...
                                event(:,1)];
            
            index = find((event(:,2)-event(:,1))>20);
            if ~isempty(index)
                sub_list(i);
                event(index,:);
            end;
        end;
    
        % change categories into local ids. 
        new_cevent = cevent;
        for j = 1 : size(cevent,1)
            try
                if (sum(cevent(j,3) == categories) > 0)
                    new_cevent(j,3) = local_ids(cevent(j,3)==categories);
                else
                    new_cevent(j,3) = local_ids(1);
                end;
            catch exception
                fprintf(1,['there are categories values that are not in ' ...
                           'the category list']);
            end;
        end;
        
        res_trans_mat = res_trans_mat + ...
            cevent_transition_matrix(new_cevent,max_gap_btw_event, num_valid_value);
        % normalization 
        res_hist(i,:) = res_hist(i,:) ./sum(res_hist(i,:));
    end;
end;


% stats
results.exp_id = exp_id;
results.grouping = grouping; 
results.name = var_name;
results.categories = categories;
results.total_time = nanmean(res_hist);
results.mean_duration = nanmean(res_event_dur);
results.median_duration = nanmean(res_event_dur_median);
hist_duration = histc(dur_data,dur_hist_bin)';
results.hist_duration_bin = dur_hist_bin;
results.hist_duration = hist_duration ./sum(hist_duration); 
for j = 1 : size(categories,2)
    tmp =  histc(dur_data_by_value{j},dur_hist_bin)';
    results.hist_duration_by_value(j,:) = tmp ./sum(tmp);
end;

results.mean_number = nanmean(res_event_number);
results.transition_matrix = res_trans_mat;




