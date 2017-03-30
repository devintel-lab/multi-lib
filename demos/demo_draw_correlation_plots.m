function demo_draw_correlation_plots(option)
%% Summary 
% This function draws correlation plots for multiwork subjects. By default,
% X axis is age, and Y axis is a measure for a particular behavior (e.g.
% proportion looking time to ROI for child). The function creates three
% different .png files and one .csv file.
%% Required Arguments
%
switch option
    case 1
        % basic usage, cevent or cstream data
        varname = 'cevent_eye_roi_child';
        subexpIDs = [70 71 72 73 74 75];
        measures = {'prop', 'freq', 'mean_dur'};
        directory = '/scratch/multimaster/demo_results/draw_correlation_plots/case1/';
        nametag = 'eye_roi_child';
        draw_correlation_plots(subexpIDs, varname, measures, directory, nametag);
        
    case 2
        % continous measure, replace obj1 with obj# to get mean of all
        % objects
        varname = 'cont_vision_size_obj#_child';
        subexpIDs = [70 71 72 73 74 75];
        measures = {'mean'};
        directory = '/scratch/multimaster/demo_results/draw_correlation_plots/case2/';
        nametag = 'obj_size_child';
        draw_correlation_plots(subexpIDs, varname, measures, directory, nametag);
        
    case 3
        % get measure of target object during another specified event
        % e.g. prop child looking toward what parent names
        varname = 'cevent_eye_roi_child';
        subexpIDs = [70 71 72 73 74 75];
        args.cevent_name = 'cevent_speech_naming_local-id';
        args.cevent_values = 1:3;
        args.label_matrix = [1 2 2; 2 1 2; 2 2 1];
        args.labels = {'target'};
        measures = {'prop'};
        directory = '/scratch/multimaster/demo_results/draw_correlation_plots/case3/';
        nametag = 'eye_roi_child_target_during_naming';
        draw_correlation_plots(subexpIDs, varname, measures, directory, nametag, args);
        
end