function demo_extract_pairs_multiwork(option)
%% Overview
% Finds moments from two cevents that match a specified temporal relation
% 
% Will loop through all events in cev1 and find those events in cev2 that
% match the temporal relation given in the threshold parameter. These
% matches (or pairs) are output in a resulting CSV file.
% author: sbf@umail.iu.edu
%% Required Arguments
% subexpIDs
%         -- integer array, list of subjects or experiments
% cev1
%         -- string, cevent variable name
% cev2
%         -- string, cevent variable name
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
        %% pair inhand and eye from child, with one temporal constraint
        
        cev1 = 'cevent_inhand_child'; % [on1 off1]
        cev2 = 'cevent_eye_roi_child'; % [on2 off2]
        subexpIDs = [7106 7107 7108]; % can be a list of subjects or a list of experiments
        timing_relation = 'less(on1, on2, 2)'; % this means on1 must be less than on2, 
        % and the their difference is LESS than 2 seconds.
        mapping = [
            1 1; % pair categories 1 and 1
            2 2; % pair categories 2 and 2
            3 3; % pair categories 3 and 3
            1 4; % pair categories 1 and 4
            2 4; % ...
            3 4;]; 
        args.pairtype = [1 1 1 2 2 2]; % one number per row in mapping. In this
        % case, when the categories match, it is type 1. If it matches with
        % face, it is type 2.
        savefilename = '/multi-lib/user_output/extract_pairs_multiwork/case1/example1.csv';
        extract_pairs_multiwork(subexpIDs, cev1, cev2, timing_relation, mapping, savefilename, args)
        
    case 2
        %% use more than one temporal constraint
        
        cev1 = 'cevent_inhand_child'; % [on1 off1]
        cev2 = 'cevent_eye_roi_child'; % [on2 off2]
        subexpIDs = [7106 7107 7108]; % can be a list of subjects or a list of experiments
        timing_relation = 'less(on1, on2, 2) & less(off2, off1, 3)';
        % Timing_relations can be strung together using '&' or '|'. This example has two temporal
        % constraints -- on1 must be less than on2, and the their difference is
        % less than 2 seconds. Also, off1 must be greater than off2, and their
        % difference must be less than 3 seconds. Note, the threshold
        % amount, 2 and 3, are upper bounds always. Meaning, the difference
        % of the preceeding timestamps must be LESS than the threshold
        % amount. '&' means only events that have both temporal conditions
        % will be accepted.
        mapping = [
            1 1; % pair categories 1 and 1
            2 2; % pair categories 2 and 2
            3 3; % pair categories 3 and 3
            1 4; % pair categories 1 and 4
            2 4; % ...
            3 4;]; 
        args.pairtype = [1 1 1 2 2 2]; % one number per row in mapping. In this
        % case, when the categories match, it is type 1. If it matches with
        % face, it is type 2.
        savefilename = '/multi-lib/user_output/extract_pairs_multiwork/case2/example2.csv';
        extract_pairs_multiwork(subexpIDs, cev1, cev2, timing_relation, mapping, savefilename, args)
        
        
    case 3
        %% threshold amount is optional
        
        cev1 = 'cevent_inhand_child'; % [on1 off1]
        cev2 = 'cevent_eye_roi_child'; % [on2 off2]
        subexpIDs = [7106 7107 7108]; % can be a list of subjects or a list of experiments
        timing_relation = 'less(on1, on2, 2) & less(off2,off1)';
        % on1 must be less than on2, with a difference of 2. Also, off1 must be
        % greater than off2, by any margin. There is no upper bound.
        mapping = [
            1 1; % pair categories 1 and 1
            2 2; % pair categories 2 and 2
            3 3; % pair categories 3 and 3
            1 4; % pair categories 1 and 4
            2 4; % ...
            3 4;]; 
        args.pairtype = [1 1 1 2 2 2]; % one number per row in mapping. In this
        % case, when the categories match, it is type 1. If it matches with
        % face, it is type 2.
        savefilename = '/multi-lib/user_output/extract_pairs_multiwork/case3/example3.csv';
        extract_pairs_multiwork(subexpIDs, cev1, cev2, timing_relation, mapping, savefilename, args)
        
        
    case 4
        %% control for many to many mapping
        
        % e.g. event # 10 in cev1 is paired with event # 12, 13, 14 in cev2
        % the index columns in the output file would look like
        % 10, 12
        % 10, 13
        % 10, 14
        % use first_n_cev1 to only grab the first pairing, leaving the
        % others out
        
        cev1 = 'cevent_inhand_child'; % [on1 off1]
        cev2 = 'cevent_eye_roi_child'; % [on2 off2]
        subexpIDs = [7106 7107 7108]; % can be a list of subjects or a list of experiments
        timing_relation = 'less(on1, on2, 5)';
        % on1 must be less than on2, with a difference of 5.
        mapping = [
            1 1; % pair categories 1 and 1
            2 2; % pair categories 2 and 2
            3 3; % pair categories 3 and 3
            1 4; % pair categories 1 and 4
            2 4; % ...
            3 4;]; 
        args.pairtype = [1 1 1 2 2 2]; % one number per row in mapping. In this
        % case, when the categories match, it is type 1. If it matches with
        % face, it is type 2.
        
        % in case of duplicate events, filter everything except the first n
        % events in cev1
        args.first_n_cev1 = 1; % only grab the first cev1 that is paired
        args.first_n_cev2 = 1; % only grab the first cev2 that is paired
        
        % can also specify args.last_n_cev1 and last_n_cev2 to grab the
        % last events that are paired. These can be combined with
        % args.first_n_cev1 and args.first_n_cev2 to grab the first and the
        % last events in the pairings
        
        savefilename = '/multi-lib/user_output/extract_pairs_multiwork/case4/example4.csv';
        extract_pairs_multiwork(subexpIDs, cev1, cev2, timing_relation, mapping, savefilename, args)
        
end
end