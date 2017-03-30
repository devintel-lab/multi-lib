function demo_vis_streams_multiwork(option)
%% Overview
% Outputs matlab figures with visualized cevents/cstreams from multiwork
% experiments
% Works in batch mode by generating files for a list of subjects
% This function calls vis_streams_files, which is a more generalized form
% of input that can read .mat or .csv files, look at demo_vis_streams_files
% for more information
% author: sbf@umail.iu.edu
%% Require Arguments
% subexpIDs
%       -- integer array, list of subjects or experiments
% vars
%       -- cell array, list of variable names found in the derived folders
%          of multiwork subjects
% streamlabels
%       -- cell array, each cell is a short-hand label for the files in
%          stream_files.
%       -- e.g. for cstream_eye_roi_child, one can set the label to 'ceye'
% directory
%       -- full path or relative path to a directory where the figures will
%          be saved. Directory must exist prior to calling the function
%% Optional Arguments
% args.window_times_variable
%       -- string of a cevent variable name found in the derived folders of
%          multiwork subjects. This variable controls the time ranges
%          displayed in each subplot of the output figure. By default, this
%          is set to 'cevent_trials.mat', but this option allows users to
%          change to another variable.
% args.draw_edge
%       -- 1 or 0
%       -- if 1, will draw outline each rectangle with a dark border,
%          otherwise none
% args.colors
%       -- an Nx3 array indicating a set of colors to use for the plots
%       -- each row corresponds to the category value in the data streams
%       -- can also be a single number, which will prompt the user to
%          choose colors with a built in Matlab UI. See set_colors.m
%%
switch option
    case 1
        subexpIDs = [7106 7107 7108]; % can also be experiment list
        vars = {'cevent_eye_roi_child', 'cevent_eye_roi_parent', 'cevent_eye_joint-attend_both'};
        streamlabels = {'ceye', 'peye', 'ja'};
        directory = '/scratch/multimaster/demo_results/vis_streams_multiwork/case1';
        % note that directory = '.' will save in the current directory
        vis_streams_multiwork(subexpIDs, vars, streamlabels, directory);
        
    case 2
        % if you want to choose your own colors, set args.colors
        % parameter to 4 (or however many different categories you have)
        % a dialog box will appear that enables you to set the colors.
        subexpIDs = [7106 7107 7108];
        vars = {'cevent_eye_roi_child', 'cevent_eye_roi_parent', 'cevent_eye_joint-attend_both'};
        streamlabels = {'ceye', 'peye', 'ja'};
        directory = '/scratch/multimaster/demo_results/vis_streams_multiwork/case2';
        args.colors = 4;
        vis_streams_multiwork(subexpIDs, vars, streamlabels, directory, args);
        
    case 3
        % alternatively, args.colors can be an Nx3 matrix specifying the
        % colors to use
        % also, set args.draw_edge = 0 to disable the dark borders
        subexpIDs = [7106 7107 7108];
        vars = {'cevent_eye_roi_child', 'cevent_eye_roi_parent', 'cevent_eye_joint-attend_both'};
        streamlabels = {'ceye', 'peye', 'ja'};
        directory = '/scratch/multimaster/demo_results/vis_streams_multiwork/case3';
        args.colors = [
            1 .5 0; % orange
            1 1 0; % yellow
            0 1 1; % cyan
            .5 .5 .5 % gray
            ];
        args.draw_edge = 0;
        vis_streams_multiwork(subexpIDs, vars, streamlabels, directory, args);
        
    case 4
        % To view figures without saving the plots, set directory to be
        % empty
        subexpIDs = [7106 7107 7108]; % can also be experiment list
        vars = {'cevent_eye_roi_child', 'cevent_eye_roi_parent', 'cevent_eye_joint-attend_both'};
        streamlabels = {'ceye', 'peye', 'ja'};
        directory = '';
        % note that directory = '.' will save in the current directory
        vis_streams_multiwork(subexpIDs, vars, streamlabels, directory);
        
    case 5
        % Set args.window_times_variable to change the time ranges
        % displayed for each subplot in the output figure. If not specified, this
        % will be set to 'cevent_trials.mat'
        subexpIDs = [7206]; % can also be experiment list
        vars = {'cevent_eye_roi_child', 'cevent_eye_roi_parent', 'cevent_eye_joint-attend_both', 'cevent_trials'};
        args.window_times_variable = 'cevent_vis_streams_window'; % this variable was created just as an example
        streamlabels = {'ceye', 'peye', 'ja', 'trials'};
        directory = '';
        % note that directory = '.' will save in the current directory
        vis_streams_multiwork(subexpIDs, vars, streamlabels, directory, args);
        
end
end