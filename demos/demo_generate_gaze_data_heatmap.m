 clear all;

% Creates and save heatmaps similar to "generate_toy_heatmaps()", 
% but using eye gaze as the data source. Check "generate_toy_heatmaps()"
% for additional infos
%
% NOTE: Visualized eye gaze data is "normalized" on a per trial basis,
% meaning that the data is translated such that the mean of all gaze
% points of a trial is at the center.

% PARAMETERS

% - EXP_LIST:
%   List of subjects to run. Can be a list of experiments, e.g. [41 44]
%   or a list of subject IDs, e.g. 4301 4303
%
% - SUBJECT:
%   Can be either 'child' or 'parent' for either child view or parent view
%   or a list of subject IDs, e.g. 4301 4303
%
% - FOLDER:
%   Name of folder to save results to:
%   /ein/multiwork/experiment_XX/included/data_vis/FOLDER/
%
% - EVENT_VAR (optional):
%   Can be any CEVENT or EVENT variable. If this optional variable is given,
%   only eye gaze during events is visualized. Otherwise, all eye gaze is
%   visualized
%
% - NEGATE_VAR (optional):
%   Negate the event variable, i.e. consider all moments where the event is
%   not true
%
% - TARGET_RESOLUTION (optional):
%   Due to different cameras models the max. resolution/range of eye gaze 
%   varies accross subjects. This function scales all its visualization to
%   the same resolution, TARGET_RESOLUTION, to make them comparable. By 
%   default, this resolution is [480 640]. 


%% modify parameters below
EXP_LIST = [43];                                        % required parameter
SUBJECT = 'child';                                      % required parameter
FOLDER = 'heatmap_4';                                    % required parameter
EVENT_VAR = 'event_motion_pos_head_big-moving_child';    % optional parameter
NEGATE_VAR = false;    									% optional parameter
TARGET_RESOLUTION = [480 640];                          % optional parameter

generate_gaze_data_heatmap(EXP_LIST, SUBJECT, FOLDER, EVENT_VAR, NEGATE_VAR, TARGET_RESOLUTION)