clear all;

DEMO_ID = 5;

min_data_length = 3000;
index_start = 5;
num_trials = 4;

time_window_list = [10 15 30];
step_size_list = [100 200 300 600];

psidx = 1;
prob_one = prob_succ_list(psidx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Have one leading stream
if DEMO_ID == 1
    gcause_mat = nan(length(time_window_list), length(step_size_list));
    
    num_channels = 2;
    data_mat = nan(num_channels, min_data_length, num_trials);

    for twidx = 1:length(time_window_list)
    window_one = time_window_list(twidx);

    for ssidx = 1:length(step_size_list)
    step_one = step_size_list(ssidx);

    for rgidx = 1:num_trials
        data_one = zeros(num_channels, min_data_length);

        main_index_list = randi([index_start step_one]):step_one:min_data_length;
        data_one(1, main_index_list) = 1;
        main_index = find(data_one(1, :));
        main_index = [1 main_index min_data_length];
        
        for lidx = 2:(length(main_index)-1)
                range_lead_start = max([main_index(lidx-1) main_index(lidx)-window_one]);
                index_lead = randi([range_lead_start main_index(lidx)]);
                data_one(2, index_lead) = 1;
        end
        data_mat(:, :, rgidx) = data_one;
    end
    
    [data_gcausal_mat, data_gcausal_fdr] = calculate_granger_causality(data_mat);
    gcause_mat(twidx, ssidx) = data_gcausal_mat(1, 2);

    end % end of step size list

    end % end of leading/following window size

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Have one following stream
elseif DEMO_ID == 2
    gcause_mat = nan(length(time_window_list), length(step_size_list));
    
    num_channels = 2;
    data_mat = nan(num_channels, min_data_length, num_trials);

    for twidx = 1:length(time_window_list)
    window_one = time_window_list(twidx);

    for ssidx = 1:length(step_size_list)
    step_one = step_size_list(ssidx);

    for rgidx = 1:num_trials
        data_one = zeros(num_channels, min_data_length);

        main_index_list = index_start:step_one:min_data_length;
        data_one(1, main_index_list) = 1;
        main_index = find(data_one(1, :));
        main_index = [1 main_index min_data_length];
        
        for lidx = 2:(length(main_index)-1)
            is_succ = randi([0 1000]) <= 1000 * prob_one;
            
            if is_succ
                range_follow_end = min([main_index(lidx+1) main_index(lidx)+window_one]);
                index_follow = randi([main_index(lidx) range_follow_end]);
                data_one(2, index_follow) = 1;
            end
        end
        data_mat(:, :, rgidx) = data_one;
    end
    
    [data_gcausal_mat, data_gcausal_fdr] = calculate_granger_causality(data_mat);
    gcause_mat(twidx, ssidx) = data_gcausal_mat(2, 1);

    end % end of step size list

    end % end of leading/following window size
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Have one following stream
elseif DEMO_ID == 3
    gcause_mat = nan(length(time_window_list), 2);
    gcausal_mat_list = cell(length(time_window_list), 1);
    
    num_channels = 3;
    data_mat = nan(num_channels, min_data_length, num_trials);

    for twidx = 1:length(time_window_list)
    window_one = time_window_list(twidx);

    step_one = 300;

    for rgidx = 1:num_trials
        data_one = zeros(num_channels, min_data_length);

        main_index_list = index_start:step_one:min_data_length;
        data_one(1, main_index_list) = 1;
        main_index = find(data_one(1, :));
        main_index = [1 main_index min_data_length];
        
        for lidx = 2:(length(main_index)-1)
            is_succ = randi([0 1000]) <= 1000 * prob_one;
            
            if is_succ
                range_lead_start = max([main_index(lidx-1)+1 main_index(lidx)-window_one]);
                index_lead = randi([range_lead_start main_index(lidx)-1]);
                data_one(2, index_lead) = 1;
            end
                
            is_succ = randi([0 1000]) <= 1000 * prob_one;
            if is_succ
                range_follow_end = min([main_index(lidx+1)-1 main_index(lidx)+window_one]);
                index_follow = randi([main_index(lidx)+1 range_follow_end]);
                data_one(3, index_follow) = 1;
            end
        end
        data_mat(:, :, rgidx) = data_one;
    end
    
    [data_gcausal_mat, data_gcausal_fdr] = calculate_granger_causality(data_mat);
    gcausal_mat_list{twidx} = data_gcausal_mat
    gcause_mat(twidx, 1) = data_gcausal_mat(1, 2);
    gcause_mat(twidx, 2) = data_gcausal_mat(3, 1);
    
    end % end of leading/following window size
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Have one leading stream
elseif DEMO_ID == 4
    gcause_mat = nan(length(time_window_list), 2);
    gcausal_mat_list = cell(length(time_window_list), 1);
    
    num_channels = 4;
    data_mat = nan(num_channels, min_data_length, num_trials);

    for twidx = 1:length(time_window_list)
    window_one = time_window_list(twidx);

    step_one = 300;

    for rgidx = 1:num_trials
        data_one = zeros(num_channels, min_data_length);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Add randomized
        main_index_list = index_start:step_one:min_data_length;
        data_one(1, main_index_list) = 1;

        main_index_list = (index_start+100):step_one:min_data_length;
        data_one(3, main_index_list) = 1;
        main_index1 = find(data_one(1, :));
        main_index3 = find(data_one(3, :));

        main_index1 = [1 main_index1 min_data_length];
        main_index3 = [1 main_index3 min_data_length];
        for lidx = 2:(length(main_index1)-1)
            range_lead_start = max([main_index1(lidx-1) main_index1(lidx)-window_one]);
            index_lead = randi([range_lead_start main_index1(lidx)]);
            data_one(2, index_lead) = 1;

            range_follow = min([main_index3(lidx+1) main_index3(lidx)+window_one]);
            index_follow = randi([main_index3(lidx) range_follow]);
            data_one(4, index_follow) = 1;
        end
        data_mat(:, :, rgidx) = data_one;
    end
    
    [data_gcausal_mat, data_gcausal_fdr] = calculate_granger_causality(data_mat);
    gcausal_mat_list{twidx} = data_gcausal_mat;
    gcause_mat(twidx, 1) = data_gcausal_mat(1, 2);
    gcause_mat(twidx, 2) = data_gcausal_mat(4, 3);
    
    end % end of leading/following window size
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5. Have two leading streams
elseif DEMO_ID == 5
    gcause_mat = nan(length(time_window_list), 2);
    gcausal_mat_list = cell(length(time_window_list), 1);
    
    twidx = 1;
    num_channels = 3;
    data_mat = nan(num_channels, min_data_length, num_trials);

    step_one = 200;

    for rgidx = 1:num_trials
        data_one = zeros(num_channels, min_data_length);

        main_index_list = index_start:step_one:min_data_length;
        data_one(1, main_index_list) = 1;
        main_index = find(data_one(1, :));
        main_index = [1 main_index min_data_length];
        
        for lidx = 2:(length(main_index)-1)
            is_succ = randi([0 1000]) <= 1000 * prob_one;
            
            if is_succ
                range_lead_start1 = max([main_index(lidx-1)+1 main_index(lidx)-20]);
                index_lead1 = randi([range_lead_start1 main_index(lidx)-1]);
                data_one(2, index_lead1) = 1;
            end
                
            is_succ = randi([0 1000]) <= 1000 * prob_one;
            if is_succ
                range_lead_start2 = max([main_index(lidx-1)+1 main_index(lidx)-40]);
                index_lead2 = randi([range_lead_start2 main_index(lidx)-1]);
                data_one(3, index_lead2) = 1;
            end
        end
        data_mat(:, :, rgidx) = data_one;
    end
    
    [data_gcausal_mat, data_gcausal_fdr] = calculate_granger_causality(data_mat);
    gcausal_mat_list{twidx} = data_gcausal_mat;
    gcause_mat(twidx, 1) = data_gcausal_mat(1, 2);
    gcause_mat(twidx, 2) = data_gcausal_mat(3, 1);
    
    gcausal_mat_list{twidx}
    
end