%   This script demonstrates the functionality of the function
%   'generate_toy_heatmaps.m'. -- The function generates spatial heatmaps
%   of the toy objects, conditioned on the cevent CEVENT_VAR:
%   -   Images are saved under
%       /ein/multiwork/experiment_XX/included/data_vis/FOLDER/
%   -   A .mat file with the raw heatmap data is saved at the same place
%   -   One image and one .mat file is saved for every subject-pair, e.g.:
%       '3213_cevent_inhand_child_childview.png'
%       '3213_cevent_inhand_child_childview.mat'
%   -   Once executed, the function prints out a progress status, listing
%       how many (and which) subjects will be processed, as well as a
%       progress bar for each subject.
%
%   PARAMETERS:
%
%   -   CEVENT_VAR: string of the cevent to condition the heatmaps on. For
%       example, if the CEVENT_VAR is 'cevent_inhand_child', the final
%       image will show two heatmaps: one for the objects that were in the
%       child's hands (target) and one for the objects that were NOT in the
%       child's hand for the corresponding frames (distractor). WARNING:
%       CEVENT_VAR is a required parameter and needs to be a valid CEVENT
%       string.
%
%   -   SUBJECT: string saying either 'child' (default) or 'parent' -- This
%       parameter determines whether the heatmaps are from the child's or 
%       the parent's point of view. This does not have to be the same
%       participant as in the CEVENT variable. For example, one can
%       visualize heatmaps conditioned on 'cevent_inhand_child' from the
%       parent's point of view.
%
%   -   FOLDER: name of folder to save results to:
%		/ein/multiwork/experiment_XX/included/data_vis/FOLDER/
%
%   -   EXP_LIST: list of experiments (i.e. 32) to run. The function will
%       automatically find all subjects for which both the CEVENT and the
%       toy map data exits -- default: all experiments

clear all;

%% modify parameters below
CEVENT_VAR = 'cevent_inhand_child'; % required variable
SUBJECT = 'child';                  % optional (default: 'child')
FOLDER = 'heatmap_4';				% optional (default: 'heatmap_1')
EXP_LIST = [34];                    % otional (default: all experiments)

generate_toy_heatmaps(CEVENT_VAR, SUBJECT, FOLDER, EXP_LIST);