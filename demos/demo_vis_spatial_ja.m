function demo_vis_spatial_ja(option)
%% Summary 
% This function draws spatial_ja plots for multiwork subjects. By default,
% the function uses exp 15 motion data configurations and draw one
% spactial_ja plot for each subject.
%% Required Arguments
%
switch option
    case 1
        % basic usage, generate exp15 spatial_ja plot
        subexpIDs = [15];
        numOfObj = 10;
        saveDir = '/multi-lib/user_output/vis_spatial_ja/case1/';
        args = []; % if args == [], use the exp 15 birdeye view configuration 
        visFlag = true; % show the plot for each of the subject when runing the program
        vis_spatial_ja(subexpIDs, numOfObj, saveDir, args, visFlag);
    case 2
        % change some plot configurations for plotting exp15
        subexpIDs = [15];
        numOfObj = 10;
        saveDir = '/multi-lib/user_output/vis_spatial_ja/case2/';
        args = [];
        args.lineWidth = 2; % change the image line width to 2
        args.xlim = [-2000, 2000]; % change the image x lim
        args.ylim = [-2000, 2000]; % change the image y lim
        args.xDir = 'normal'; % set x axis direction to positive pointing right
        args.yDir = 'reverse'; % set y axis direction to positive pointing down
        args.dur2size_const = 2; % set the JA point size to be 2 * JA duration
        visFlag = true; % show the plot for each of the subject when runing the program
        vis_spatial_ja(subexpIDs, numOfObj, saveDir, args, visFlag);
    case 3
        % plot y data on x axis and x data on y axis when plotting exp15
        subexpIDs = [15];
        numOfObj = 10;
        saveDir = '/multi-lib/user_output/vis_spatial_ja/case3/';
        args = []; 
        args.xydataCol = [3, 2]; % the default values are [2, 3], which 
            % indicates that using column 2 in cont3_motion_pos_head as x 
            % data and using column 3 in cont3_motion_pos_head as y data.
        visFlag = true; % show the plot for each of the subject when runing the program
        vis_spatial_ja(subexpIDs, numOfObj, saveDir, args, visFlag);
end
        