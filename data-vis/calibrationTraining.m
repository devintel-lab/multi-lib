% =========================================================================
%                           CALIBRATION TRAINING
%    PLOT THE POINT SPREAD OVER XY COORDINATES AND OVER SESSION TIME FOR
%                          MULTIPLE EXPERIMENTERS
% 
%                    Original: Julia Yurkovic, June 2019
% =========================================================================

% This script requires cbrewer library

clc
close all
clear

% == Set experimenters, subject, set, and # of passes =====================
%calibs = {'Julia','Sara','Dian','Daniel'};
calibs = {'Dian'};
sub = '1539';
set = '1';
passes = [1,2,3];

% == Pre-set a variable to collect all timestamps from the data
allTimeVals = [];

% == Loop through passes
for currPass = 1:length(passes)
    
    pass = passes(currPass);
    
    % Loop through calibrators
    for currCalib = 1:length(calibs)
        
        calib = calibs{currCalib};
        
        % == Load text files
        % Set to my own personal computer folder
        % All Yarbus files have been converted to .rtf using TextWrangler
        % File name structure: Julia_1501_set1_pass1.rtf
        fid = fopen(strcat(...
            'Z:\dianzhi\',...%'/Users/juliayurkovic/Desktop/calibrationTraining/',sub,...
            filesep(),calib,'_',sub,'_set','1_pass',num2str(pass),'.rtf'),'r');
        % Read all data as a string
        txt_data = textscan(fid, '%s', 'Delimiter', '\n');
        txt_data = txt_data{1};
        clear fid
        
        % == Find line numbers of all time values in text file
        % The text files have lines that say 'timeValue' - find these
        findTimeVals = find(cellfun(@sum,strfind(txt_data,'timeValue'))>0);
        % The line number below timeValue has the actual numeric --> add 1
        findTimeVals = findTimeVals + 1;
        
        % == Find line numbers of all x-coordinates
        findXscene = find(cellfun(@sum,strfind(txt_data,'xScene'))>0);
        findXscene = findXscene + 1;
        
        % == Find line numbers for all y-coordinates
        findYscene = find(cellfun(@sum,strfind(txt_data,'yScene'))>0);
        findYscene = findYscene + 1;
        
        % == Loop through time values
        for i = 1:length(findTimeVals)
%=============================Commented====================================
% Instead of using onset and offset, use regexp (regular expression)
% function to parse the numbers in a string. The oroginal code couldn't 
% work on windows. This change can make the script more robust by allowing 
% it to read data on different operating systems - DZ
            % == Find actual time at each time value line
            % .rtf file has consistent format:
            % \cf5 <integer>\cf3 61900\cf5 </integer>\cf3 \
            % Find spaces (need 2nd)            
%             onset = strfind(txt_data{findTimeVals(i)},' ');
            % Find '\cf5'            
%             offset = strfind(txt_data{findTimeVals(i)},'\cf5');            
            % Pull number between onset and offset, convert str to num
            % RE "/(100/30)" in line 74: The time values output by Yarbus
            % do not directly correspond to frame numbers. Most are ~33.33
            % frames different (so timeValue 1000 would roughly be frame
            % 30). There are some frames where this is not the case, but 
            % this is the best Icould do for now.
%             data{currPass,currCalib}(i,1) = ...
%                 str2num(txt_data{findTimeVals(i)}...
%                 (onset(2)+1:offset(2)-1))/(100/3);
            tmpcell = regexp(txt_data{findTimeVals(i)}, '\d*', 'match');
            data{currPass,currCalib}(i,1) = str2num(tmpcell{1}) / (100/3);
            % Store all time values
            allTimeVals = [allTimeVals;data{currPass,currCalib}(i,1)];
%             clear onset offset 
            clear tmpcell
            
            % == Find value for x scene
%             onset = strfind(txt_data{findXscene(i)},' ');
%             offset = strfind(txt_data{findXscene(i)},'\cf5');
%             data{currPass,currCalib}(i,2) = ...
%                 str2num(txt_data{findXscene(i)}(onset(2)+1:offset(2)-1));
%             clear onset offset 
            tmpcell = regexp(txt_data{findXscene(i)}, '[\d|.]*', 'match');
            data{currPass,currCalib}(i,2) = str2num(tmpcell{1});
            clear tmpcell
            
            % == Find value for y scene
%             onset = strfind(txt_data{findYscene(i)},' ');
%             offset = strfind(txt_data{findYscene(i)},'\cf5');
%             data{currPass,currCalib}(i,3) = ...
%                 str2num(txt_data{findYscene(i)}(onset(2)+1:offset(2)-1));
%             clear onset offset 
            tmpcell = regexp(txt_data{findYscene(i)}, '[\d|.]*', 'match');
            data{currPass,currCalib}(i,3) = str2num(tmpcell{1});
            clear tmpcell
            
        end
        
        clear txt_data calib findTimeVals findXscene findYscene
        
    end
    
    clear pass
    
end

clear currCalib currPass i

% ========================================================================= 
% At this point, you will have a cell structure labeled 'data' where each
% ROW is a different pass and each COLUMN is a different experimenter
% ========================================================================= 

% == Get colors equal to number passes (+1 because yellow is weird)
% I use this cool toolbox called cbrewer that has really nice color maps -
% I know that we don't have this in the lab or need it, so this will have
% to be re-worked to fit our personal needs
[toyColors] = cbrewer('div', 'Spectral',size(data,1)+1);
toyColors = toyColors * .95;

% == Open figure to full-screen
figure('units','normalized','outerposition',[0 0 1 1],'color','white');

% == PLOT X-Y COORDINATES FOR ALL CALIBRATION POINTS ======================
% == Plot each pass for each individual 
% == Loop through passes
for currPass = 1:size(data,1)
    
    % == Loop through calibrators
    for currCalib = 1:size(data,2)
        
        % == Open subplot
        % Subplot where rows are passes and columns are calibrators
        % Use sub2ind to find the index for row by column
        subplot(size(data,1)+1,size(data,2)+1,sub2ind([size(data,2)+1,...
            size(data,1)+1],currCalib,currPass))
        
        % == If there is data for the current pass/calibrator combo
        % Right now I have a sloppy work-around where I create a blank rtf
        % file if I don't have a pass from someone
        if ~isempty(data{currPass,currCalib})
            
            % == Plot data
            s = scatter(data{currPass,currCalib}(:,2),...
                data{currPass,currCalib}(:,3));
            s.MarkerEdgeColor = toyColors(currPass,:);
            s.MarkerFaceColor = toyColors(currPass,:);
            s.MarkerFaceAlpha = 0.5;
            s.SizeData = 70;
            hold on
            
            % == Plot euclidean center
            s = scatter(nanmean(data{currPass,currCalib}(:,2)),...
                nanmean(data{currPass,currCalib}(:,3)));
            s.Marker = 'square';
            s.SizeData = 70;
            s.MarkerEdgeColor = 'black';
            s.MarkerFaceColor = 'black';
            s.MarkerFaceAlpha = 0.5;
        end
        
        % == Axes
        ax = gca;
        ax.XLim = [0 640]; ax.XTick = [0:(640/4):640];
        ax.XAxisLocation = 'top';
        ax.YLim = [0 480]; ax.YTick = [0:(480/4):480];
        % Reverse y axis direction to match on-screen x-y coordinates
        ax.YDir = 'reverse';
        ax.Box = 'on';
        ax.FontName = 'Verdana';
        
        % == X label on top of each pass for each calibrator
        if currPass == 1
            xlabel(calibs{currCalib})
            ax.XLabel.FontWeight = 'bold';
        end
        
        % == Y label on side of each calibrator for each pass
        if currCalib == 1
            ylabel(strcat('Pass ',num2str(passes(currPass))))
            ax.YLabel.FontWeight = 'bold';
        end
        
    end
end

% == Plot Euclidean centers for all experimenters at each pass
% == Loop through passes
for currPass = 1:size(data,1)
    
    % == Open subplot
    % Subplot where rows are passes and columns are calibrators
    % Use sub2ind to find the index for row by column
    subplot(size(data,1)+1,size(data,2)+1,sub2ind([size(data,2)+1,...
        size(data,1)+1],size(data,2)+1,currPass))
    
    % == Loop through calibrators
    for currCalib = 1:size(data,2)
        if ~isempty(data{currPass,currCalib})
            
            % == Plot euclidean center
            s = scatter(nanmean(data{currPass,currCalib}(:,2)),nanmean(data{currPass,currCalib}(:,3)));
            s.Marker = 'square';
            s.SizeData = 70;
            s.MarkerEdgeColor = 'black';
            s.MarkerFaceColor = 'black';
            s.MarkerFaceAlpha = 0.5;
            hold on
        end
        
        % == Axes
        ax = gca;
        ax.XLim = [0 640]; ax.XTick = [0:(640/4):640];
        ax.XAxisLocation = 'top';
        ax.YLim = [0 480]; ax.YTick = [0:(480/4):480];
        ax.YDir = 'reverse';
        ax.Box = 'on';
        ax.FontName = 'Verdana';
        
        % == Label x axis
        if currPass == 1
            xlabel('All Calibrators')
            ax.XLabel.FontWeight = 'bold';
        end
        
    end
    
end

% == Plot Euclidean centers for all passes at each calibrator
% == Loop through calibrators
for currCalib = 1:size(data,2)
    
    % == Open subplot
    % Subplot where rows are passes and columns are calibrators
    % Use sub2ind to find the index for row by column
    subplot(size(data,1)+1,size(data,2)+1,sub2ind([size(data,2)+1,...
        size(data,1)+1],currCalib,size(data,1)+1))
    
    % == Loop through passes
    for currPass = 1:size(data,1)
        
        if ~isempty(data{currPass,currCalib})
            
            % == Plot euclidean center
            s = scatter(nanmean(data{currPass,currCalib}(:,2)),...
                nanmean(data{currPass,currCalib}(:,3)));
            s.Marker = 'square';
            s.SizeData = 70;
            s.MarkerEdgeColor = toyColors(currPass,:);
            s.MarkerFaceColor = toyColors(currPass,:);
            s.MarkerFaceAlpha = 0.5;
            hold on
        end
        
        % == Axes
        ax = gca;
        ax.XLim = [0 640]; ax.XTick = [0:(640/4):640];
        ax.XAxisLocation = 'top';
        ax.YLim = [0 480]; ax.YTick = [0:(480/4):480];
        ax.YDir = 'reverse';
        ax.Box = 'on';
        ax.FontName = 'Verdana';
        
        % == Label y axis
        if currCalib == 1
            ylabel('All Passes')
            ax.YLabel.FontWeight = 'bold';
        end
        
    end
    
end

% == Plot Euclidean centers for all calibrators and all passes
% == Open subplot
subplot(size(data,1)+1,size(data,2)+1,sub2ind([size(data,2)+1,...
    size(data,1)+1],size(data,2)+1,size(data,1)+1))

% ==Loop through calibrators
for currCalib = 1:size(data,2)
    
    % == Loop through passes
    for currPass = 1:size(data,1)
        
        if ~isempty(data{currPass,currCalib})
            
            % == Plot euclidean center
            s = scatter(nanmean(data{currPass,currCalib}(:,2)),...
                nanmean(data{currPass,currCalib}(:,3)));
            s.Marker = 'square';
            s.SizeData = 70;
            s.MarkerEdgeColor = toyColors(currPass,:);
            s.MarkerFaceColor = toyColors(currPass,:);
            s.MarkerFaceAlpha = 0.5;
            hold on
        end
        
        % == Axes
        ax = gca;
        ax.XLim = [0 640]; ax.XTick = [0:(640/4):640];
        ax.XAxisLocation = 'top';
        ax.YLim = [0 480]; ax.YTick = [0:(480/4):480];
        ax.YDir = 'reverse';
        ax.Box = 'on';
        ax.FontName = 'Verdana';
        
    end
end

% == Save figure
% I use a toolbox/function thing called export_fig because I like it better
% This will need to be updated to be lab general
% Path is set to my own personal computer
export_fig(strcat('/Users/juliayurkovic/Desktop/calibrationTraining/',...
    sub,'/',sub,'_calibrationPoints_coords'))
close all

% == PLOT X-Y COORDINATES FOR ALL CALIBRATION POINTS ======================

% == Open figure to full-screen height and half-screen width
figure('units','normalized','outerposition',[0 0 0.5 1],'color','white');

% == Plot time for each calibration point for all calibrators and passes
% == Loop through coders
for currCalib = 1:size(data,2)
    
    % == Loop through passes
    for currPass = 1:size(data,1)
        
        % == Open subplot
        subplot(size(data,2)+1,1,currCalib)
        
        if ~isempty(data{currPass,currCalib})
            % == Plot data
            % Plot each timepoint (with the /(100/3) conversion) at y coord
            % 1 to make a timeline
            s = scatter(data{currPass,currCalib}(:,1),...
                ones(length(data{currPass,currCalib}(:,1)),1)*currPass);
            s.MarkerEdgeColor = toyColors(currPass,:);
            s.MarkerFaceColor = toyColors(currPass,:);
            s.MarkerFaceAlpha = 0.5;
            hold on
        end
        
        % == Axes
        ax = gca;
        % Set x limit to the latest timepoint that someone placed a point
        % This can probably be streamlined in a better way that doesn't
        % require keeping all timepoints for each calibrator and pass
        ax.XLim = [0 ceil(max(allTimeVals))];
        ax.XTick = [0:ceil(max(allTimeVals))/10:ceil(max(allTimeVals))];
        ax.YLim = [0 size(data,1)+1]; ax.YTick = [1:size(data,1)];
        ax.YDir = 'reverse';
        ax.Box = 'on';
        ax.FontName = 'Verdana';
        
        % == Set calibrator name
        title(calibs{currCalib})
        ax.Title.FontSize = ax.FontSize;
        
        % == Set y axis label
        ylabel('Pass')
        ax.YLabel.FontWeight = 'bold';
        
    end
end

% == Plot all times for calibration points for all calibrators and passes
% == Open subplot
subplot(size(data,2)+1,1,size(data,2)+1)

% == Loop through coders
for currCalib = 1:size(data,2)
    for currPass = 1:size(data,1)
               
        if ~isempty(data{currPass,currCalib})
            % == Plot data
            s = scatter(data{currPass,currCalib}(:,1),...
                ones(length(data{currPass,currCalib}(:,1)),1));
            s.MarkerEdgeColor = 'none';
            s.MarkerFaceColor = 'black';
            s.MarkerFaceAlpha = 0.5;
            hold on
        end
        
        % == Axes
        ax = gca;
        ax.XLim = [0 ceil(max(allTimeVals))];
        ax.XTick = [0:ceil(max(allTimeVals))/10:ceil(max(allTimeVals))];
        ax.YLim = [0 2]; ax.YTick = [1];
        ax.YDir = 'reverse';
        ax.Box = 'on';
        ax.FontName = 'Verdana';
        
        % == Set title
        title('All Calibrators')
        ax.Title.FontSize = ax.FontSize;
        
        % = Set axis labels
        ylabel('All Passes')
        ax.YLabel.FontWeight = 'bold';
        xlabel('Session Frame')
        ax.XLabel.FontWeight = 'bold';
        
    end
end

% == Save figure
export_fig(strcat('/Users/juliayurkovic/Desktop/calibrationTraining/',...
    sub,'/',sub,'_calibrationPoints_frameVals'))
close all
