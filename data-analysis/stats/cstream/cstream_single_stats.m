
% 
% stats of a cstream variable
%

function [results_all] = cstream_single_stats(input, sub_list2)

exp_ids = input.exp_ids;
var_name = input.var_name;
categories = input.categories; 
local_ids = input.local_ids;
num_valid_value = input.num_valid_value; 
max_gap_btw_event = input.max_gap_btw_event;
dur_hist_bin = input.dur_hist_bin;
% 1 by subjects, 2 by cevent with a certain event value; 3 by event
grouping = input.grouping; 
check_list{1} = var_name; 

if grouping == 3
    event_var_name = input.event_var_name;
    check_list = [check_list; event_var_name];
elseif grouping == 2
    cevent_var_name = input.cevent_var_name;
    cevent_value = input.cevent_value;
    check_list = [check_list; cevent_var_name];
end;

res_trans_mat=zeros(num_valid_value); % 
dur_data = [];
for j = 1 : size(categories,2);
    dur_data_by_value {j} = []; 
end;
for exp = 1: size(exp_ids,2)
    exp_id = exp_ids(exp);    
    sub_list= find_subjects(check_list, exp_id); 
    sub_list = intersect(sub_list,sub_list2); 
    res_hist = [];res_event_number = [];  res_event_dur =[]; res_event_dur_median ...
        =[]; num_instance = [];
    for i = 1 : size(sub_list,2)
        if grouping == 1
            [chunks] = get_variable_by_trial(sub_list(i), var_name);
        elseif grouping == 2
            [chunks] = get_variable_by_cevent(sub_list(i), var_name, cevent_var_name,cevent_value);
        elseif grouping == 3
            [chunks] = get_variable_by_event(sub_list(i), var_name, event_var_name);
        end;
        num_instance(i) = size(chunks,1);
        if ~isempty(chunks)
            cevent = [];
            for m = 1 : size(chunks,1)
                cevent = [ cevent; cstream2cevent(chunks{m},1)];
            end;
            
            cstream = cat(1, chunks{:});

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
                    sub_list(i)
                    event(index,:)
                    categories(j)
                end;
            end;
            for j = 1 : size(cevent,1)
                try
                    cevent(j,3) = local_ids(cevent(j,3)==categories);
                catch exception
                    fprintf(1,'there are categories values that are not in the category list %d\n', cevent(j,3));
                end;
            end;
            res_trans_mat = res_trans_mat + ...
                    cevent_transition_matrix(cevent,max_gap_btw_event, num_valid_value);
            % normalization 
            res_hist(i,:) = res_hist(i,:) ./sum(res_hist(i,:));
        end;
    end;


    % stats
    results.exp_id = exp_id;
    results.grouping = grouping;
    results.sub_list = sub_list;
    results.name = var_name;
    results.categories = categories;
    results.total_time = mean(res_hist);
    results.total_time_hist = res_hist;
    results.mean_duration = nanmean(res_event_dur,1);
    results.median_duration = nanmean(res_event_dur_median,1);
    hist_duration = histc(dur_data,dur_hist_bin)';
    results.hist_duration_bin = dur_hist_bin;
    results.hist_duration = hist_duration ./sum(hist_duration); 
    for j = 1 : size(categories,2)
        tmp =  histc(dur_data_by_value{j},dur_hist_bin)';
        results.hist_duration_by_value(j,:) = tmp ./sum(tmp);
    end;
  
    for m = 1 : size(num_instance,2)
        res_event_number(m,:) = res_event_number(m,:) ./num_instance(m);
    end;
    results.mean_number = nanmean(res_event_number,1);
    results.num_instance = num_instance;
    results.transition_matrix = res_trans_mat;
    if grouping == 3
        results.event_name = event_var_name;
    elseif grouping == 2
        results.cevent_var_name = cevent_var_name;
        results.cevent_value = cevent_value; 
    end;
    
    results_all(exp) = results;

end;




