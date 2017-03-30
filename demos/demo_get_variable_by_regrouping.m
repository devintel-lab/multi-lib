clear all

% This is a script for demonstrating how to use the function 
% get_variable_by_regrouping

DEMO_ID = 1; % see below for more detailed comments on all the demo cases

if DEMO_ID == 1
%% test case 1: cstream variables regrouped by cevents
    % Group 1: to get the proportion of frames that the child was also holding
    % the target object when they were looking at the target object
    % Group 2: to get the proportion of frames that the child was holding
    % non-target/other objects when they were looking at the target object
	exp_list = 71;

    % Each cstream variable matches with one ROI in corresponding order.
    % They will be assigned to that categorical value regardless of their
    % original ROI values.
    input.var_name = {'cstream_inhand_obj1_child', ...
        'cstream_inhand_obj2_child', 'cstream_inhand_obj3_child'};
	input.var_category = [1 2 3];
    
    % To be chunked by cevents, the field of cevent_category must be
    % specified.
	input.cevent_name = 'cevent_eye_roi_child';
	input.cevent_category = [1 2 3];
    
    % Extract cstream data within cevents as specified, then 
    % individual stats will be calculated based on one chunk per subject.
	input.grouping = 'subcevent_cat';
    
    % Add another layer of checking, so that every subject has all the
    % desired variables
	input.sub_list = find_subjects({input.var_name{:} input.cevent_name}, exp_list);

    % Each row corresponding to a cstream value in input.var_category 
    % Each column corresponding to a cevent value in input.var_category
    input.groupid_matrix = ...
        [1 2 2;
         2 1 2;
         2 2 1];
     
    % Use can specified the fields of whence and interval to get chunks
    % with the same length (for generate temporal profiles)
    % WARNING: it is better to use the following scrip for this purpose:
    % 	multi-lib/data-analysis/prob_profile/demo_generate_temporal_profile_by_cevent.m
    % input.whence = 'start';
    % input.interval = [-2 0];
    % input.grouping = 'cevent';
%      
    extracted_data = get_variable_by_regrouping(input)
    % Output extracted_data will be like this:
    % extracted_data = 
    % 
    % 1x2 struct array with fields:
    % 
    %     regroup_label_id
    %     chunks_count
    %     chunks
    %     sub_list
    %     dur_list
    %     
    % NOTE:!!!!
    % The cstream value in the data chunks are converted to group ids based
    % on whether at that time point, which group the cstream value belongs
    % to.
    
    groupid_matrix_list = unique(input.groupid_matrix);
    for lmlidx = 1:length(groupid_matrix_list)
        stats_results(lmlidx) = cstream_cal_stats(extracted_data(lmlidx).chunks);
    end
    stats_results(1)
    stats_results(2)
    % If no further information was specified for calcuating the statistics
    % of the extracted data chunks, the result will contain these fields by
    % default:
    % 
    % ans = 
    % 
    %                 categories: [0 1]
    %                       prop: 0.5054
    %                prop_by_cat: [0.4946 0.5054]
    %            individual_prop: [25x1 double]
    %     individual_prop_by_cat: [25x2 double]
    % 
    % 
    % ans = 
    % 
    %                 categories: [0 2]
    %                       prop: 0.3141
    %                prop_by_cat: [0.6859 0.3141]
    %            individual_prop: [25x1 double]
    %     individual_prop_by_cat: [25x2 double]

elseif DEMO_ID == 2
%% test case 2: continue variables regrouped by cevents
    % Group 1: to get the target object size when this target object was 
    % held by the child: the size of object 1 when the child was holding
    % object 1;
    % Group 2: to get all the non target object size values when these 
    % objects were not held by the child: the size of all other (2-3) objects
    % when the child was holding object 1.
    exp_list = 71;
    
    % Each continue data stream is assigned into groups by ROI value list in 
    % in input.var_category with corresponding order.
    input.var_name = {'cont_vision_size_obj1_child', ...
        'cont_vision_size_obj2_child','cont_vision_size_obj3_child'};
    input.var_category = [1 2 3];
 
    % To be chunked by cevents, the field of cevent_category must be
    % specified.
    input.cevent_name = 'cevent_inhand_child';
    input.cevent_category = [1 2 3];
    
    % Extract continue data within cevents as specified, then 
    % individual stats will be calculated based on one chunk per subject.
    input.grouping = 'subcevent_cat';
    
    % Add another layer of checking, so that every subject has all the
    % desired variables
	input.sub_list = find_subjects({input.var_name{:} input.cevent_name}, exp_list);

    % Each row corresponding to each cont variable
    % Each column corresponding to a cevent value 
    input.groupid_matrix = ...
        [1 2 2;
         2 1 2;
         2 2 1];
    
    % Use can specified the fields of whence and interval to get chunks
    % with the same length (for generate temporal profiles)
    % WARNING: it is better to use the following scrip for this purpose:
    % 	multi-lib/data-analysis/prob_profile/demo_generate_temporal_profile_by_cevent.m
    % input.whence = 'start';
    % input.interval = [-2 0];
    % input.grouping = 'cevent';

    extracted_data = get_variable_by_regrouping(input)
    % Output extracted_data will be like this:
    % extracted_data =  
    % 
    % 1x2 struct array with fields:
    % 
    %     regroup_label_id
    %     chunks_count
    %     chunks
    %     sub_list
    %     dur_list
    % The number of structs in the output is determined by how many groups
    % are specified in the field of 'input.groupid_matrix'
    
    groupid_matrix_list = unique(input.groupid_matrix);
    for lmlidx = 1:length(groupid_matrix_list)
        stats_results(lmlidx) = cont_cal_stats(extracted_data(lmlidx).chunks);
    end
    stats_results(1)
    stats_results(2)
    % If no further information was specified for calcuating the statistics
    % of the extracted data chunks, the result will contain four fields by
    % ans = 
    % 
    %                  mean: 3.2068
    %       individual_mean: [25x1 double]
    %                   std: 4.3139
    %        individual_std: [25x1 double]
    %                median: 1.6823
    %     individual_median: [25x1 double]
    %                   min: 0
    %        individual_min: [25x1 double]
    %                   max: 70.0104
    %        individual_max: [25x1 double]
    %                nonnan: 1
    %     individual_nonnan: [25x1 double]
    %                  hist: [1x10 double]
    %             hist_bins: [3.5005 10.5016 17.5026 24.5036 31.5047 38.5057 45.5068 52.5078 59.5089 66.5099]
    %       individual_hist: [25x10 double]
    % 
    % ans = 
    % 
    %                  mean: 2.1221
    %       individual_mean: [25x1 double]
    %                   std: 1.7705
    %        individual_std: [25x1 double]
    %                median: 1.8750
    %     individual_median: [25x1 double]
    %                   min: 0
    %        individual_min: [25x1 double]
    %                   max: 47.8770
    %        individual_max: [25x1 double]
    %                nonnan: 1
    %     individual_nonnan: [25x1 double]
    %                  hist: [0.9285 0.0687 0.0020 4.5489e-04 2.4494e-04 6.9983e-05 3.8879e-05 3.8879e-06 0 7.7759e-06]
    %             hist_bins: [2.3938 7.1815 11.9692 16.7569 21.5446 26.3323 31.1200 35.9077 40.6954 45.4831]
    %       individual_hist: [25x10 double]

elseif DEMO_ID == 3 
%% test case 3: continue variables regrouped by events
    % Group 1: to get the target object size when this target object was 
    % held by the child: the size of object 1 when the child was holding
    % object 1;
    % Group 2: to get all the non target object size values when these 
    % objects were not held by the child: the size of all other (2-5) objects
    % when the child was holding object 1.
	exp_list = 70;
    
    % Each continue data stream is assigned into groups by ROI value list in 
    % in input.var_category with corresponding order.
    input.var_name = {'cont_vision_size_obj1_child', ...
        'cont_vision_size_obj2_child','cont_vision_size_obj3_child'};
    input.var_category = [1 2 3];
        
    % No event category is required, the event variables will be grouped 
    % according to their input order
    input.event_name = {'event_inhand_left-obj1_child', 'event_inhand_left-obj2_child', ...
        'event_inhand_left-obj3_child', 'event_inhand_right-obj1_child', 'event_inhand_right-obj2_child', ...
        'event_inhand_right-obj3_child'};

    % Extract continue data within cevents as specified, then 
    % individual stats will be calculated based on one chunk per subject.
    input.grouping = 'subevent_cat';
    
    % Add another layer of checking, so that every subject has all the
    % desired variables
	input.sub_list = find_subjects([input.var_name input.event_name], exp_list);

    % Each row corresponding to a cont variable
    % Each column corresponding to a event variable
    input.groupid_matrix = ...
        [1 2 2 1 2 2;
         2 1 2 2 1 2;
         2 2 1 2 2 1];     

    extracted_data = get_variable_by_regrouping(input)
    % Output extracted_data will be like this:
    % extracted_data = 
    % 
    % 1x2 struct array with fields:
    % 
    %     regroup_label_id
    %     chunks_count
    %     chunks
    %     sub_list
    %     dur_list
    % The number of structs in the output is determined by how many groups
    % are specified in the field of 'input.groupid_matrix'
    
    
    groupid_matrix_list = unique(input.groupid_matrix);
    for lmlidx = 1:length(groupid_matrix_list)
        stats_results(lmlidx) = cont_cal_stats(extracted_data(lmlidx).chunks);
    end
    stats_results(1)
    stats_results(2)
    % If no further information was specified for calcuating the statistics
    % of the extracted data chunks, the result will contain four fields by
    % ans = 
    % 
    %                  mean: 2.9742
    %       individual_mean: [33x1 double]
    %                   std: 4.2264
    %        individual_std: [33x1 double]
    %                median: 1.0130
    %     individual_median: [33x1 double]
    %                   min: 0
    %        individual_min: [33x1 double]
    %                   max: 61.8047
    %        individual_max: [33x1 double]
    %                nonnan: 1
    %     individual_nonnan: [33x1 double]
    %                  hist: [1x10 double]
    %             hist_bins: [3.0902 9.2707 15.4512 21.6316 27.8121 33.9926 40.1730 46.3535 52.5340 58.7145]
    %       individual_hist: [33x10 double]
    % 
    % 
    % ans = 
    % 
    %                  mean: 2.3287
    %       individual_mean: [33x1 double]
    %                   std: 2.3151
    %        individual_std: [33x1 double]
    %                median: 2.0781
    %     individual_median: [33x1 double]
    %                   min: 0
    %        individual_min: [33x1 double]
    %                   max: 78.4648
    %        individual_max: [33x1 double]
    %                nonnan: 1
    %     individual_nonnan: [33x1 double]
    %                  hist: [1x10 double]
    %             hist_bins: [3.9232 11.7697 19.6162 27.4627 35.3092 43.1557 51.0021 58.8486 66.6951 74.5416]
    %       individual_hist: [33x10 double]
end




