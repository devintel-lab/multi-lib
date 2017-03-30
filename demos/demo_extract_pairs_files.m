function demo_extract_pairs_files(option)
%% Overview
% Finds moments from two cevents that match a specified temporal relation
% 
% Will loop through all events in cev1 and find those events in cev2 that
% match the temporal relation given in the threshold parameter. These
% matches (or pairs) are output in a resulting CSV file.
% author: sbf@umail.iu.edu
%% Required Arguments
% filename1
%       -- string, the full path or relative path to a
%          .mat or .csv file
%       -- data can either be cstream or cevent format
%       -- if .mat, data should be saved under sdata.data structure, like
%          in multiwork format
%       -- for .csv files, one can specify the number of headers and
%          columns, see the optional arguments below
% filename2
%         -- see filename1
% timing_relation
%         -- string of characters that indicate the temporal relations
% 
%         on1 and off1 correspond to cev1 onset and offset, respectively.
%         on2 and off2 correspond to cev2 onset and offset, respectively.
% 
%         'more(A,B,T)' means A comes before B with a gap more than T seconds.
%         'less(A,B,T)' means A comes before B with a gap less than T seconds.
%         A and B are to be replaced with any combination of on1, off1, on2,
%         and off2. T is optional, and if it is not provided, will not
%         consider the gap between A and B.
% 
%         e.g.
%         timing_relation = 'more(on1, on2, 4)' means on1 must come before on2 in time,
%         with a gap of more than 4 seconds.
%         timing_relation = 'less(off2, on1, 2)' means off2 must come before on1 in time, with a
%         gap of less than 2 seconds.
% 
%         Note, you can chain multiple timing relations together using '&' or '|'. This
%         means AND and OR, respectively. Use parentheses to indicate
%         more complex timings.
%
%         e.g.  
%         timing_relation = 'more(on1, off1, 4) & less(on1, on2, 2)' means events in
%         cev1 must be greater than 4 seconds long, and must start at most
%         2 seconds before the events in cev2
% 
% mapping
%         -- Nx2 array that indicates which categories are to be matched
%            together.
% savefilename
%         -- string indicating where to save the CSV file. The folder
%            must exist.
%% Optional Arguments
% args.pairtype
%         -- single-dimension array of integers whose length matches the
%            length of 'mapping'. Allows user to tag each row in 'mapping' to a type.
% args.cevent_trials
%       -- string, the full path or relative path to a
%          .mat or .csv file
%       -- The timing information in this file is used to cut the data into
%          trials. Ultimately this ensures that events from one trial
%          cannot be paired with events from a second trial, even if the
%          temporal relation holds.
% args.files_numheaders
%       -- integer array of size 2, indicating how many
%          headers are in filename1 and filename2, respectively
%       -- e.g. [1 1] for means to skip 1 header file for both
% args.files_columns
%       -- cell array of size 2, one cell for each filename, indicating which columns
%          to grab from the .csv file
%       -- e.g. {[3 4 5], [6 7 8]} for the two filenames
%          [3 4 5] is for filename1, [6 7 8] is for filename2
%       -- if empty, just grab all columns
% args.cevent_trials_numheaders
%       -- integer array of size 2, indicating how many
%          headers are in filename1 and filename2, respectively
%       -- e.g. [1 1] for means to skip 1 header file for both
% args.cevent_trials_columns
%       -- 1x3 integer array indicating which columns
%          to grab from the .csv file
%       -- if empty, just grab all columns
%
% The following arguments control many to many mapping
% Consider the following many to many mapping from cev1 and cev2
% 10, 15
% 11, 15
% 11, 16
% 11, 17
% To force 1 to 1 mapping, set either first_n_cev1 or last_n_cev1 to 1
% args.first_n_cev1
%         -- integer indicating to only output first N pairings of cev 1
% args.first_n_cev2
%         -- integer indicating to only output first N pairings of cev 2
% args.last_n_cev1
%         -- integer indicating to only output last N pairings of cev 1
% args.last_n_cev2
%         -- integer indicating to only output last N pairings of cev 2

% Output is a CSV with each row respresenting a pair. The pairs can be
% many-to-many.
%
% Two additional CSV files (_cev1wo.csv and _cev2wo.csv) are generated indicating which cevents from cev1
% and cev2 were not paired.
%
% Only in-trial data will be considered, and cevents from one trial cannot
% be paired with cevents from another trial (even if the timing holds true).
%%

switch option
    case 1
        % basic usage
        filename1 = '/scratch/multimaster/demo_results/extract_pairs_files/case1/cevent_data1.csv';
        filename2 = '/scratch/multimaster/demo_results/extract_pairs_files/case1/cevent_data2.csv';
        timing_relation = 'more(on1, on2, 2) & less(on1, on2, 5)';
        mapping = [1 1; 2 2 ; 3 3; 1 4; 2 4; 3 4; 4 4; 4 1; 4 2; 4 3];
        savefilename = '/scratch/multimaster/demo_results/extract_pairs_files/case1/case1_pairs.csv';
        extract_pairs_files(filename1, filename2, timing_relation, mapping, savefilename);
        
    case 2
        % some of these may be option, see above for details
        
        filename1 = '/scratch/multimaster/demo_results/extract_pairs_files/case2/cevent_data1.csv';
        filename2 = '/scratch/multimaster/demo_results/extract_pairs_files/case2/cevent_data2.csv';
        args.cevent_trials = '/scratch/multimaster/demo_results/extract_pairs_files/case2/cevent_trials.csv';
        args.files_numheaders = [0 0]; % zero headers in filename1 and filename2
        args.files_columns = {[1 2 3], [1 2 3]}; % grab first 3 columns of filename1 and filename2
        args.cevent_trials_numheaders = 0;
        args.cevent_trials_columns = [1 2 3];
        timing_relation = 'more(on1, on2, 2) & less(on1, on2, 5)';
        mapping = [1 1; 2 2 ; 3 3; 1 4; 2 4; 3 4; 4 4; 4 1; 4 2; 4 3];
        args.pairtype = [1 1 1 2 2 2 4 3 3 3];
        % for duplicate events, only grab first 1 and last 1 to be paired
        args.first_n_cev1 = 1;
        args.first_n_cev2 = 1;
        args.last_n_cev1 = 1;
        args.last_n_cev2 = 1;
        savefilename = '/scratch/multimaster/demo_results/extract_pairs_files/case2/case2_pairs.csv';
        extract_pairs_files(filename1, filename2, timing_relation, mapping, savefilename, args);
end
end