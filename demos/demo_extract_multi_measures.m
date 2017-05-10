function demo_extract_multi_measures(option)
%% Summary
% This function outputs a .csv file containing basic statistics at a subject level or at the
% event level.
%% Required Arguments
% var_list
%       -- cell array, list of variable named found in the derived folders
%          of multiwork subjects
% subexpIDs
%       -- integer array, list of subjects or experiments
% filename
%       -- full path or relative path of where to save the .csv file
%% Optional Arguments
% The measures you specify control for the granularity of the output
% args.cevent_measures
%       -- cell array of strings, any of the following
%               'individual_prop_by_cat'      (default)
%               'individual_freq_by_cat'      (default)
%               'individual_mean_dur_by_cat'  (default)
%               'individual_median_dur_by_cat'
%               'individual_number_by_cat'
%
% args.cont_measures
%       -- cell array of strings, any of the following
%               'individual_mean'             (default)
%               'individual_median'           (default)
%               'individual_std'
%               'individual_min'
%               'individual_max'
%
% 
% Note: can remove the suffix '_by_cat' from the end of the measures to show get one aggregated statistic across all categories
%       -- e.g. 'individual_prop'
%
% args.persubject
%       -- If 1, statistics are aggregated across events and the output
%          contains one row per subject
% 
% args.cevent_name
%       -- string, cevent variable name -- Defines the windows of time to extract data from.
%          Meaning, for args.cevent_name = 'cevent_speech_utterance', each
%          variable in var_list will be cut to each utterance event.
%       -- In the output file, each row will contain statistics for one
%          event. Therefore, if subject 3201 has 30 utterance events, there will
%          be 30 rows for subject 3201 in the output file, with statistics during each utterance.
%       -- By default, this is set to 'cevent_trials'
% 
% args.cevent_values
%       -- array of integers, indicating the categories to include from the cevent in args.cevent_name
%       -- e.g., for args.cevent_name = 'cevent_eye_roi_child', then
%          args.cevent_values = [1 2 3 4];
%       -- must be specified if args.cevent_name is specified
% 
% args.label_matrix
%       -- NxM array, where N is number of unique categories in the variables indicated in var_list, and
%          M is the number of unique categories in args.cevent_name
%       -- This option will concatenate data based on target / others mapping. That is, the output will put all target values into column 1, and others into column 2.
%       -- e.g. if var_list = {'cevent_eye_roi_child'} and args.cevent_name = 'cevent_speech_naming_local-id'            
%       -- args.label_matrix = [1 2 2 3;   % naming object 1
%                               2 1 2 3;   % naming object 2
%                               2 2 1 3;]  % naming object 3
%                    ROI object 1 2 3 4
%       -- The values in the matrix refer to the columns of the output .csv results.
%       -- array(1,1) = 1, meaning when naming is object 1, and eye ROI is 1, then put the resulting statistic into column 1
%       -- array(2,1) = 2, meaning when naming is object 2, and eye ROI is 1, then put the resulting statistic into column 2
%       -- array(3,4) = 3, meaning when naming is object 3, and eye ROI is 4 (face), then put the resulting statistic into column 3
%       -- So in this example, whenever naming matches the ROI object, we put that statistic into the first column of the output .csv
% 
% args.label_names
%       -- cell array of strings, user-defined labels of the output columns after re-mapping based on args.label_matrix
%       -- e.g. {'target', 'others', 'face'}, for values 1, 2, and 3, respectively
% 
% args.whence
%       -- string, 'start', 'end', or 'startend'
%       -- this parameter, when combined with args.interval, allows you to shift the args.cevent_name window times by a certain amount. The shift can be respect to the start, end, or full event.
% args.interval
%       -- array of 2 numbers, [t1 t2], where t1 and t2 refer to the offset to apply in each args.cevent_name window times.
%       -- e.g., [-5 1] and whence = 'start', then we take the onset of each cevent and add -5 seconds to get new onset. Likewise, we add 1 second to onset to get new offset.
%       -- therefore, if the original event was [45 55], then
%          if args.whence = 'start', then new event is [40 46]
%          if args.whence = 'end', then new event is [50 56]
%          if args.whence = 'startend', then new event is [40 56]
%
% args.within_ranges
%       -- 1 or 0
%       -- if 0, then we get the complement of args.cevent_name, or event_NOT.
%       -- Note, there is not category, so it effectively turns it into an event based analysis. Therefore, not compatible with label_matrix

switch option
    
    case 1
        %% basic usage -- each row will be one full trial
        
        % 'obj#' means the function will grab 'cont_vision_obj1_child',
        % 'cont_vision_obj2_child', and 'cont_vision_obj3_child'
        var_list = {'cevent_inhand_child', 'cevent_eye_roi_child', 'cont_vision_size_obj#_child'};
        subexpIDs = [32]; % this can also be a list of experiments
        filename = '/scratch/multimaster/demo_results/extract_multi_measures/example1.csv';
        args = [];
        extract_multi_measures(var_list, subexpIDs, filename, args);
        
    case 2
        %% same as above, with with args.persubject = 1 -- each row will be all trials concatenated together. args.persubject = 1 will work with any of examples in this demo
        
        var_list = {'cevent_inhand_child', 'cevent_eye_roi_child', 'cont_vision_size_obj#_child'};
        subexpIDs = [32]; % this can also be a list of experiments
        filename = '/scratch/multimaster/demo_results/extract_multi_measures/example2.csv';
        args.persubject = 1;
        extract_multi_measures(var_list, subexpIDs, filename, args);
        
    case 3
        %% get data at specific window by specifying args.cevent_name, args.cevent_values, args.label_matrix, and args.label_names -- each row will be one naming instance
        
        var_list = {'cevent_inhand_child', 'cevent_eye_roi_child', 'cont_vision_size_obj#_child'};
        subexpIDs = [32]; % this can also be a list of experiments
        filename = '/scratch/multimaster/demo_results/extract_multi_measures/example3.csv';
        args.cevent_name = 'cevent_speech_naming_local-id'; % these are the windows of time, or instances, from which data will be extracted and measured
        args.cevent_values = 1:3; % which categories in cevent_name you wish to use
        %% label_matrix explanation
        % -this is a 3 x 3 matrix, mapping the categories in the var_list
        % variables to those categories in the cevent_name variable.
        
        % -the numbers in the matrix indicate which groups we wish to put
        % data into. In the example below, there are groups 1 and 2, 1
        % being 'target' and 2 being 'other'
        
        % -columns correpond var_list categories, and rows correspond to
        % cevent_name categories.
        
        % -in the matrix below, the first row is 1 2 2. Since it's the
        % first row, this is when cevent_speech_naming_local-id is equal to
        % 1, in other words, when the parent names obj1. This means if the
        % child is touching obj1 while the obj1 is being name, this data
        % will be placed into category 1. When the child is touching obj2
        % while obj1 is being named, this data will be placed into category
        % 2. Likewise, when the child is touching obj3 while the obj1 is
        % begin named, the data will be placed into category 2.
        
        % -this effectively puts "target" data into category 1 and "other"
        % data into category 2
        args.label_matrix = [
            1 2 2; % naming obj1
            2 1 2; % naming obj2
            2 2 1]; %naming obj3
        
        % -we can now name those two categories as 'target' and 'other' -if
        % there are 2 distinct numbers in label_matrix, there should be 2
        % distinct names in label_names
        args.label_names = {'target'};%, 'other'};
        
        args.cevent_measures = 'individual_prop';
        args.cont_measures = 'individual_mean';
        % one can specify the measures they wish for each data type
        % individual_prop_by_cat will output data for each object
        % individual_prop will will average the data across objects
        
        extract_multi_measures(var_list, subexpIDs, filename, args);
        
        
    case 4
        %% if a subject is missing either the cevent_name, or the variable in var_list, it will fill the csv with NaN values
        
        var_list = {'cevent_inhand_child', 'cevent_eye_roi_does_not_exist', 'cont_vision_size_obj#_child'};
        subexpIDs = [32]; % this can also be a list of experiments
        filename = '/scratch/multimaster/demo_results/extract_multi_measures/example4.csv';
        args = [];
        extract_multi_measures(var_list, subexpIDs, filename, args);
        
    case 5
        %% if you want to include 'face' looks. Note that for variables that doesn't have a face category, it won't product results for 'face';
        
        % For example, cevent_inhand_child does not have a category 4,
        % therefore the function will process this variable as if the
        % label_matrix were 3x3, [1 2 2; 2 1 2; 2 2 1]. Also, the number of
        % names in label_names does not necessarily need to match the
        % number of distinct values in label_matrix. For example, if the
        % label_name = {'target' 'other'}, the function will simply not
        % process the face group (3), and it will not show up on the csv.
        % To put it this way, the function will only use what is given or
        % what is possible, and whatever is extra will be ignored.
        
        var_list = {'cevent_inhand_child', 'cevent_eye_roi_child', 'cont_vision_size_obj#_child', 'cevent_eye_joint-attend_both'};
        subexpIDs = [32]; % this can also be a list of experiments
        filename = '/scratch/multimaster/demo_results/extract_multi_measures/example5.csv';
        args.cevent_name = 'cevent_speech_naming_local-id';
        args.cevent_values = 1:3;
        args.label_matrix = [
            1 2 2 3;
            2 1 2 3;
            2 2 1 3];
        args.label_names = {'target', 'other', 'face'};
        extract_multi_measures(var_list, subexpIDs, filename, args);
        
    case 6
        %% use custom ranges based on 2 or 3 columns in a csv file
        
        csvdata = get_csv_form('/scratch/multimaster/demo_results/extract_pairs_multiwork/case1/example1.csv', [2 6]);
        subexpIDs = csvdata.sub_list;
        args.event_ranges = csvdata.ranges; % of if cevent, args.cevent_ranges
        var_list = {'cevent_inhand_child', 'cevent_eye_roi_child', 'cont_vision_size_obj#_child', 'cevent_eye_joint-attend_both'};
        filename = '/scratch/multimaster/demo_results/extract_multi_measures/example6.csv';
        extract_multi_measures(var_list, subexpIDs, filename, args);
        
    case 7
        %% use the within_ranges parameter. Specifying args.within_ranges = 0 will use in-between cevents as the base time windows. This may be useful for calculating baseline measures.
        
        var_list = {'cevent_inhand_child', 'cevent_eye_roi_child', 'cont_vision_size_obj#_child', 'cevent_eye_joint-attend_both'};
        subexpIDs = [32]; % this can also be a list of experiments
        filename = '/scratch/multimaster/demo_results/extract_multi_measures/example7.csv';
        args.cevent_name = 'cevent_speech_naming_local-id';
        args.cevent_values = 1:3;
        args.within_ranges = 0; % 1 is the default behavior, 0 is between ranges. Will get all non-naming moments.
        extract_multi_measures(var_list, subexpIDs, filename, args);
        
        
    case 8
        %% specify interval and whence parameters to shift your base cevent by a certain amount, and extract data during these shifted time windows. E.g. measure ROI 5 seconds before each inhand.
        
        var_list = {'cevent_eye_roi_child', 'cevent_eye_roi_parent'};
        subexpIDs = [32]; % this can also be a list of experiments
        filename = '/scratch/multimaster/demo_results/extract_multi_measures/example8.csv';
        args.whence = 'start'; % the point of reference, which is either the 'start' of the cevent (onset), or the 'end' of the cevent (offset)
        args.interval = [-5 0]; % the shift relative to the point of reference indicated in whence.
        % [-5 0] means 5 seconds before each event, up to the onset of that
        % event.
        % [-5 -1] means 5 seconds before each event, up to 1 second before
        % that event.
        % [-10 2] means 10 seconds before each event, up to 2 seconds AFTER
        % the start of the event.
        
        args.cevent_name = 'cevent_inhand_child';
        args.cevent_values = 1:3;
        extract_multi_measures(var_list, subexpIDs, filename, args);
        
    case 9
        %% to concatenate across 
        % default cevent measures are proportion, frequency, and mean duration
        % default cont measures are mean and median
        % specify specific measures for cevent and cont based measures
        
        var_list = {'cevent_eye_roi_child', 'cont_vision_size_obj#_child'};
        subexpIDs = [32]; % this can also be a list of experiments
        filename = '/scratch/multimaster/demo_results/extract_multi_measures/example9.csv';
        args.cevent_measures = {'individual_prop'};
        args.cont_measures = {'individual_mean'};
        extract_multi_measures(var_list, subexpIDs, filename, args);
end
end