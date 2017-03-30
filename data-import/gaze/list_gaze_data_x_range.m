function x_range_limit = list_gaze_data_x_range(sub_id)
% This list is confirmed by mlelston@indiana.edu on Feb 6, 2013
% All subjects in this list, their eye gaze data from child and parent
% need to be rescaled from 640 to 720 to match up with the scene image
% sizes.
% 
% Thix x range limit means the x max value in the original csv files
% not the max value in the eye gaze variable

warning(['Thix x range limit means the x max value in the original csv files ' ...
    'not the max value in the eye gaze variable']);

sub_range_list = [
        3201	640
        3202	640
        3203	640
        3204	640
        3205	640
        3206	640
        3207	640
        3208	640
        3209	640
        3210	640
        3211	640
        3212	640
        3213	640
        3214	640
        3215	640
        3216	640
        3217	640
        3218	640
        3219	640
        3220	640
        3401	640
        3402	640
        3403	640
        3404	640
        3405	640
        3406	640
        3407	640
        3408	640
        3409	640
        3410	640
        3411	640
        3412	640
        3413	640
        3414	640
        3415	640
        3416	640
        3417	640
        3418	640
        3501	640
        3502	640
        3503	640
        3504	640
        3505	640
        3506	640
        3507	640
        3508	640
        3509	640
        3510	640
        3511	640
        3512	640];
    
x_range_limit = sub_range_list(sub_range_list(:,1) == sub_id, 2);