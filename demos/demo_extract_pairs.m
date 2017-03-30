function demo_extract_pairs(option)
% demo script demonstrating how to extract pairs of events with specified
% temporal contraints.
% >>help extract_pairs    to show details of usage

%% cases
switch option
    case 1
        %% pair inhand and eye from child, with one temporal constraint
        
        cev1 = 'cevent_inhand_child'; % [on1 off1]
        cev2 = 'cevent_eye_roi_child'; % [on2 off2]
        subexpID = [7106 7107 7108]; % can be a list of subjects or a list of experiments
        threshold = 'less(on1, on2, 2)'; % this means on1 must be less than on2, 
        % and the their difference is less than 2 seconds.
        mapping = [
            1 1; % pair categories 1 and 1
            2 2; % pair categories 2 and 2
            3 3; % pair categories 3 and 3
            1 4; % pair categories 1 and 4
            2 4; % ...
            3 4;]; 
        pairtype = [1 1 1 2 2 2]; % one number per row in mapping. In this
        % case, when the categories match, it is type 1. If it matches with
        % face, it is type 2.
        filename = '/scratch/multimaster/demo_results/extract_pairs/example1.csv';
        extract_pairs(cev1, cev2, subexpID, threshold, mapping, pairtype, filename)
        
    case 2
        %% pair inhand and eye from child, with more than one temporal constraint
        
        cev1 = 'cevent_inhand_child'; % [on1 off1]
        cev2 = 'cevent_eye_roi_child'; % [on2 off2]
        subexpID = [7106 7107 7108]; % can be a list of subjects or a list of experiments
        threshold = 'less(on1, on2, 2) & less(off2, off1, 3)';
        % Thresholds can be strung together using '&' or '|'. This example has two temporal
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
        pairtype = [1 1 1 2 2 2]; % one number per row in mapping. In this
        % case, when the categories match, it is type 1. If it matches with
        % face, it is type 2.
        filename = '/scratch/multimaster/demo_results/extract_pairs/example2.csv';
        extract_pairs(cev1, cev2, subexpID, threshold, mapping, pairtype, filename)
        
        
    case 3
        %% threshold amount is optional
        
        cev1 = 'cevent_inhand_child'; % [on1 off1]
        cev2 = 'cevent_eye_roi_child'; % [on2 off2]
        subexpID = [7106 7107 7108]; % can be a list of subjects or a list of experiments
        threshold = 'less(on1, on2, 2) & less(off2,off1)';
        % on1 must be less than on2, with a difference of 2. Also, off1 must be
        % greater than off2, by any margin. There is no upper bound.
        mapping = [
            1 1; % pair categories 1 and 1
            2 2; % pair categories 2 and 2
            3 3; % pair categories 3 and 3
            1 4; % pair categories 1 and 4
            2 4; % ...
            3 4;]; 
        pairtype = [1 1 1 2 2 2]; % one number per row in mapping. In this
        % case, when the categories match, it is type 1. If it matches with
        % face, it is type 2.
        filename = '/scratch/multimaster/demo_results/extract_pairs/example3.csv';
        extract_pairs(cev1, cev2, subexpID, threshold, mapping, pairtype, filename)
        
        
    case 4
        %% cev1 and cev2 can be matrices
        
        cev1 = get_variable(4303, 'cevent_inhand_child');
        cev2 = get_variable(4303, 'cevent_inhand_parent');
        % user can then manipulate cev1 and cev2 if he wishes
        subexpID = 4303;
        threshold = 'more(on1, off1, 2) & less(off1, on2, .5)';
        mapping = [
            1 1;
            2 2;
            3 3];
        pairtype = []; % pairtype can be empty and will default to ones
        filename = '/scratch/multimaster/demo_results/extract_pairs/example4.csv';
        extract_pairs(cev1, cev2, subexpID, threshold, mapping, pairtype, filename); 
        
end