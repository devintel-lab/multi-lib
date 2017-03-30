function demo_draw_cross_correlation_plots(option)
%% Summary
% Calculates cross correlation between two category variables (cevent or
% cstream)
%% Required Arguments
% subexpIDs : array of subject IDs or experiment IDs
% var1 : string name of cevent variable
% var2 : string name of cevent variable
% range_sec : [t1 t2] specifying the lag window range, example [-5 5]
% directory : full or relative path to the directory where results are saved
% nametag : a short, unique string to help name the files

switch option
    
    case 1
        subexpIDs = 72;
        var1 = 'cevent_eye_roi_child';
        var2 = 'cevent_eye_roi_parent';
        range_sec = [-10 10];
        directory = '/scratch/multimaster/demo_results/draw_cross_correlation_plots/case1/';
        nametag = 'ceye_peye';
        draw_cross_correlation_plots(subexpIDs, var1, var2, range_sec, directory, nametag);
        
    case 2
        subexpIDs = 72;
        var1 = 'cevent_eye_roi_child';
        var2 = 'cevent_eye_joint-attend_child-lead-moment_both';
        range_sec = [-10 10];
        directory = '/scratch/multimaster/demo_results/draw_cross_correlation_plots/case2/';
        nametag = 'ceye_JA-child-lead';
        draw_cross_correlation_plots(subexpIDs, var1, var2, range_sec, directory, nametag);
        
end