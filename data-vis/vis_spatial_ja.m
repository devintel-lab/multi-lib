function vis_spatial_ja(subexpIDs, numOfObj, saveDir, args, visFlag)
% Plots visualized bird-eye view position of both child and parent when they are having joint attention
%  
% subexpIDs : array of subject IDs or experiment IDs
% numOfObj: int. The number of objects in the experiment design
% saveDir: chars. The directory that the generaetd plots will be saved. if empty([]), the figures will not be saved
% visFlag: boolean. Whether the plots will be desplayed during the processing 
% args: a struct containing multiple fields that controls the details of the genreated images
%       args.xlim (args.ylim): 2-element array of doubles. The values will be used to define the boundaries of the x (or y) axis
%       args.xDir (args.yDir): chars. The direction of the x (or y) axis, can be one of: 'normal' or 'reverse'
%       args.lineWidth: double. Defines the line width of the plots
%       args.xydataCol: 2-element array of ints. The first element indicate which column of data in cont3_motion_pos_head 
%           should be used as the x (horizontal axis); the second element indicate which column of data in
%           cont3_motion_pos_head should be used as the y (vertical axis). E.g if you want to use the y column (column 3) as x
%           axis and x column (column 2)as y axis, then this field's value should be [3, 2]
%
%       args.dur2size_const: double. Controls how the duration should be converted to dot marker size. E.g. dur2size_const = n 
%           means that for a x sec JA, the marker size wil be calculated as x * n  

if nargin <= 4
    warning('[!] No visFlag input detected. Figures will not be displayed by defult')
    visFlag = false;
end

if ~exist('args', 'var') || nargin <= 3
    warning('[!] No args input detected. Initializing args with default configurations')
    args = [];
end

if nargin == 2
    warning('[!] No saveDir input detected. Figures will not be saved by defult')
    saveDir = [];
end

if nargin < 2
    error(['[-] This function takes at least 2 inputs: 1) subExpIDs; 2) number of objects in this experiment design.' +num2str(nargin) ' was detected'])
end

if ~isfield(args, 'xlim')
    warning('[!] No args.xlim detected. Using default configurations: args.xlim = [-1700, 2300]')
    args.xlim = [-1700, 2300];
end
if ~isfield(args, 'ylim')
    warning('[!] No args.ylim detected. Using default configurations: args.ylim = [-1700, 1700]')
    args.ylim = [-1700, 1700];
end
if ~isfield(args, 'xDir')
    warning("[!] No args.xDir detected. Using default configurations: args.xDir = 'reverse'")
    args.xDir = 'reverse';
end
if ~isfield(args, 'yDir')
    warning("[!] No args.yDir detected. Using default configurations: args.yDir = 'normal'")
    args.yDir = 'reverse';
end
if ~isfield(args, 'lineWidth')
    warning('[!] No args.lineWidth detected. Using default configurations: args.lineWidth = 2')
    args.lineWidth = 1;
end
if ~isfield(args, 'xydataCol')
    warning('[!] No args.xydataCol detected. Using default configurations: args.xydataCol = [3, 2]')
    args.xydataCol = [3, 2];
end
if ~isfield(args, 'dur2size_const')
    warning('[!] No args.dur2size_const detected. Using default configurations: args.dur2size_const = 3')
    args.dur2size_const = 3;
end
    
if visFlag
    set(0,'DefaultFigureVisible','on')
else
    set(0,'DefaultFigureVisible','off')
end

if saveDir
    if ~exist(saveDir, 'dir')
        warning(['[!] The entered saveDir ' saveDir ' does not exist'])
        npt = input('[UserInput] do you want to create the save folder automatically? (''y''/''n'')');
        while true
            if strcmp(npt, 'y') || strcmp(npt, 'Y')
                try
                    mkdir(saveDir)
                    disp(['[+] ' saveDir ' succesfully created'])
                    break
                catch e
                    error(['[-] Failed to create ' saveDir ':' newline e.message])
                end
            elseif strcmp(npt, 'n') || strcmp(npt, 'N')
                error('[-] Save folder not created')
            else
                npt = input("[UserInput] Not a valid input. Do you want to create the save folder automatically? (''y''/''n'')");
            end
        end
    end
end

subIDs = cIDs(subexpIDs);

predefined_colors = set_colors();

for sub = subIDs'
    disp(['[*] Processing subject ' num2str(sub) '...'])
    if ~has_all_variables(sub, {'cont3_motion_pos_head_child', 'cont3_motion_pos_head_parent', 'cevent_eye_joint-attend_both'})
        warning(['[-] subject ' num2str(sub) ' does not have all the necessary variables. Skipped'])
        continue
    end
    try
        figure
        hold on
        xlim(args.xlim)
        ylim(args.ylim)
        box('on')
        grid('on')
        set(gca, 'XDir',args.xDir)
        set(gca, 'YDir',args.yDir)
        plot(gca, -10000, -10000, 'Marker', 'o', 'MarkerSize', 10, 'MarkerEdgeColor', [0 0.4470 0.7410], 'LineWidth', args.lineWidth, 'DisplayName', 'child')
        plot(gca, -10000, -10000, 'Marker', 'o', 'MarkerSize', 10, 'MarkerEdgeColor', [0.8500 0.3250 0.0980], 'LineWidth', args.lineWidth, 'DisplayName', 'parent')
        legend('AutoUpdate', 'off')
        title(num2str(sub))

        ja = get_variable_by_trial_cat(sub, 'cevent_eye_joint-attend_both');
        c_head = get_variable_by_trial_cat(sub, 'cont3_motion_pos_head_child');
        p_head = get_variable_by_trial_cat(sub, 'cont3_motion_pos_head_parent');
        ja_duration = ja(:, 2) - ja(:, 1);
        ja_obj = ja(:, 3);

        ja_obj = ja_obj(ismember(ja_obj, 1:numOfObj));
        ja_duration = ja_duration(ismember(ja_obj, 1:numOfObj));
        ja = ja(ismember(ja_obj, 1:numOfObj), :);

        for i = 1:numel(ja_duration)
            current_ja_onset = ja(i, 1);
            current_ja_offset = ja(i, 2);
            a = find(abs(c_head(:, 1)-current_ja_onset) < 0.015);
            b = find(abs(c_head(:, 1)-current_ja_offset) < 0.015);
            plot(gca, [mean(c_head(a:b, args.xydataCol(1)),'omitnan') mean(p_head(a:b, args.xydataCol(1)),'omitnan')], [mean(c_head(a:b, args.xydataCol(2)),'omitnan') mean(p_head(a:b, args.xydataCol(2)),'omitnan')], ...
                'Color', predefined_colors(ja_obj(i), :), 'LineWidth', args.lineWidth)
            plot(gca, mean(c_head(a:b, args.xydataCol(1)),'omitnan'), mean(c_head(a:b, args.xydataCol(2)),'omitnan'), ...
                'Marker', 'o', 'MarkerSize', ja_duration(i)*args.dur2size_const, 'MarkerEdgeColor', [0 0.4470 0.7410], ...
                'MarkerFaceColor', predefined_colors(ja_obj(i), :), 'LineWidth', args.lineWidth)
            plot(gca, mean(p_head(a:b, args.xydataCol(1)),'omitnan'), mean(p_head(a:b, args.xydataCol(2)),'omitnan'), ...
                'Marker', 'o', 'MarkerSize', ja_duration(i)*args.dur2size_const, 'MarkerEdgeColor', [0.8500 0.3250 0.0980], ...
                'MarkerFaceColor', predefined_colors(ja_obj(i), :), 'LineWidth', args.lineWidth)
        end
        hold off
    catch e
        warning(['[-] Failed to generate the visualization for subject ' num2str(sub) ': ' newline e.message])
        continue
    end
    
    if saveDir
        try
            saveas(gcf, [saveDir filesep num2str(sub) '.png'])
        catch e
            warning(['[-] Failed to save thhe generated visualization to the path ' saveDir filesep num2str(sub) '.png: ' newline e.message])
            continue
        end
        if visFlag
            pause(1)
            continue
        end
        close gcf
    end
        
end

disp('[+] All the visualizations are done.')
if visFlag
    input('[UserInput] Press enter to close all figures ')
    close all
else
    set(0,'DefaultFigureVisible','on')
end
end

