function [fix_x, fix_y, fix_time, fix_durations] = ...
    VelocityAndDistanceThresholdFixations(data, xmax, ymax, xmin, ymin, sample_rate, highThresh, lowThresh, minDist, minDur)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fixation finding algorithm based on velocity and spatial information
% 3 steps:
%   (1):	Divide cont_eye_x/y into big fixations based on velocity
%           highThresh, minimum fixation duration >= minDur
%   (2):    Divide big fixations from (1) into small fixations based on
%           velocity lowThresh
%   (3):    Merge small fixations from (2) based on spatial information. if
%           distance between centers of two consecutive fixations is <=
%           minDist, then these fixations will be merged into one, also
%           minimum fixation duration >= minDur
% 
%   (N is the length of cont_eye_x/y, n is the length of fixation events)
% 
% Inputs:   
%	data:   [time cont_eye_x cont_eye_y], Nx3
%   xmax, ymax: upper bounds for eye tracking data. Used for checking valid
%               eye tracking data. error will be reported if the proportion of 
%               valid eye tracking data is smaller than 90%
%   sample_rate: recording rate for eye tracking data
%
% Outputs: 
%   fix_x:          center x of each fixation, n*1
%   fix_y:          center y of each fixation, n*1
%   fix_times:      onset of each fixation, n*1
%   fix_durations:  duration of each fixation, n*1
% 
% Information about threshold parameters:
%   highThresh: this is the high velocity threshold for dividing cont_eye_x/y into 
%               big fixations as a first step
%   lowThresh:  this is the low velocity threshold for dividing big fixations from 
%               the first step into smaller fixations as a second step
%   minDur:     minimun duration for fixation. This parameter will be used in 
%               dividing cont values into big fixations and in the third step
%               where big fixations are merged if they are close enough
%   minDist:    this parameter is used in the third step where the program
%               will merge small fixations from the second step if they are
%               close enough spatially (distance between centers of
%               fixations <= minDist)
% 
% These parameters are fixed based on xmax, ymax, sample_rate from
% different eye tracking data. Fixed parameters are stored in file
% '_fixation_parameters'.
% 
% 
% original author: Chen Yu
% modified by: Tian Xu (txu@indiana.edu)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% setting the parameters for decomposing

% % read parameters from file
% FIX_PARAMS_FILE = 'data-import\fixation_code\_fixation_parameters';
% 
% % read parameters from the file
% fid = fopen(FIX_PARAMS_FILE);
% 
% highThresh_coeff = sscanf(fgetl(fid), 'highThresh_coeff %f');
% lowThresh_coeff = sscanf(fgetl(fid), 'lowThresh_coeff %f');
% minDist_coeff = sscanf(fgetl(fid), 'minDist_coeff %f');
% 
% fclose(fid);
% 
% highThresh_coeff = 0.0231;
% lowThresh_coeff = 0.001;
% minDist_coeff = 0.1;
% diagonal = sqrt(xmax^2+ymax^2);
% 
% % setting all the parameters
% highThresh = highThresh_coeff*diagonal/sample_rate;%200;
% minDur = 0.066;
% minDist = minDist_coeff*diagonal;
% lowThresh = lowThresh_coeff*diagonal/sample_rate;

% check validity of eye tracking data from cont_eye_x/y
% warning will be given if proportion of good eye tracking data is
% smaller than 90%
exList1 = data(:,2) <=xmax & data(:,2)>=xmin;
exList2 = data(:,3) <=ymax & data(:,3)>=ymin;
valid_list = exList1 & exList2;
if (sum(valid_list)/length(valid_list)<0.9)
    fprintf(1,'Warning: data are not perfect:%f!!\n', sum(valid_list)/length(valid_list));
end;

% remove the data with bad eye tracking
data = data(valid_list,:);

% calculate velocity
% data(:,4) = smooth_data(calVelocity(data),1);
data(:,4) = calVelocity(data);
allVelocities = data(:,4)';

% (1):  Divide cont_eye_x/y into big fixations based on velocity
%       highThresh, minimum fixation duration >= minDur
fix1 = findFix1(data, highThresh, minDur);
fix1 = [1 size(data,1)];
fix2 = fix1;


% (2):  Divide big fixations from (1) into small fixations based on
%       velocity lowThresh, minimum fixation duration >= minDur
nFix3 = 0;
for i = 1:size(fix2, 1)
    temp = decompose_big_fix(data, fix2(i,:), lowThresh, sample_rate);
    if (isempty(temp) == 0 )
        n = size(temp,1);
        fix3(nFix3+1: nFix3+n,:) = temp;
        nFix3 = nFix3 + n;
    end;
end


% (3):  Merge small fixations from (2) based on spatial information. if
%       distance between centers of two consecutive fixations is <=
%       minDist, then these fixations will be merged into one.

fix3 = merge_small_fix(data, fix3, minDist, minDur);
fix4 = fix3;

% calculate the centers
for i = 1 : size(fix3,1)
    fix4(i,3) = mean(data(fix3(i,1):fix3(i,2),2));
    fix4(i,4) = mean(data(fix3(i,1):fix3(i,2),3));
    if isnan(fix4(i,3)) || isnan(fix4(i,4))
        disp('Warning: nan fixation center');
        disp(fix4(i,:))
    end
end;


fix4(:,5) = data(fix4(:,1),1);
fix4(:,6) = data(fix4(:,2),1);

% fix3's columns are:
% 1 and 2: start and end indexes into original data matrix
% 3 and 4: center x and center y of the fixations in fix3
% 5 and 6: start and end timestamps of each fixation

% now assign the return parameters according to Dean's data structure
% converting to everyihng in one row
fix_x=fix4(:,3);
fix_y=fix4(:,4);
fix_time = fix4(:, 5);
fix_durations = (fix4(:,6)-fix4(:, 5));