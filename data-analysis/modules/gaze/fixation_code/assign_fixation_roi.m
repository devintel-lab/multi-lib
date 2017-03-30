function fix_roi = get_fixation_roi(time, fix_time, fix_durations, cstream_roi)

% This function assign a roi value to each fixation from cstream_roi.
% Majority vote approach is adopted when there are multiple roi in one
% fixation.
% 
% Inputs:
%   time:           time stamps from raw data cont_x, cont_y
%	fix_time:       onset time stamp of each fixation, n by 1
%   fix_durations:  duration of each fixation
%   cstream_roi:    cstream of roi data from human coding
% 
% Outputs:
%   fix_roi:        roi for each fixation, n by 1
% 

roi = align_streams(time, {cstream_roi});
fix_mask = zeros(length(time),1);
fix_indexes = nan(size(fix_time,1),2);

for tidx = 1:size(fix_time,1)
    start_time = fix_time(tidx);
    end_time = start_time + fix_durations(tidx);
    x_mask = time <= end_time & time >= start_time;
    x_find = find(x_mask);
    fix_mask = fix_mask | x_mask;
    fix_indexes(tidx,1) = x_find(1);
    fix_indexes(tidx,2) = x_find(end);
end


fix_roi = zeros(size(fix_indexes,1),1);
roi(~fix_mask) = 0;

roi_nan_x = isnan(roi);
roi(roi_nan_x) = 0;

for i = 1:size(fix_indexes, 1)
%     i = 4;
    start_idx = fix_indexes(i,1);
    end_idx = fix_indexes(i,2);

    fix_roi_one = roi(start_idx:end_idx);
    
    fix_is_zero_x = fix_roi_one == 0;
        
    if sum(fix_is_zero_x)
        temp_I = find(fix_is_zero_x);                

        if temp_I(1) ~= 1
            fix_roi_one(fix_is_zero_x) = fix_roi_one(temp_I(1)-1);
        elseif temp_I(end) < length(fix_is_zero_x)
            fix_roi_one(fix_is_zero_x) = fix_roi_one(temp_I(end)+1);
        else
            if start_idx ~= 1
                fix_roi_one(fix_is_zero_x) = roi(start_idx-1);
            end
        end
    end
    
    fix_unique_one = unique(fix_roi_one);
    
    % is consistant
    if size(fix_unique_one) == 1
        fix_roi(i) = fix_unique_one(1);
    else
            
        fix_uniqiue_num = nan(1,length(fix_unique_one));
            
        for j = 1:length(fix_unique_one)
            temp = fix_unique_one(j);
            fix_uniqiue_num(j) = sum(fix_roi_one==temp);
        end
        
        temp1 = fix_uniqiue_num(1);
        isequal = (fix_uniqiue_num == temp1);
        if sum(isequal) == length(fix_uniqiue_num)
            fix_roi(i) = fix_roi_one(1);
        else           
            [max_temp max_idx] = max(fix_uniqiue_num);
            fix_roi(i) = fix_unique_one(max_idx);
        end

    end
    
%     if length(fix_unique_one) > 1
%         disp([time(start_idx) time(end_idx)]);
%         fix_roi(i)
%         disp('**************************************')
%         pause;
%     end
end