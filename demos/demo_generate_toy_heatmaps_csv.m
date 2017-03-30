%   This script demonstrates the functionality of the function
%   'generate_toy_heatmaps_csv.m'. -- The function generates spatial heatmaps
%   of the toy objects, conditioned on the cevent read from a CSV file
%   -   Images are saved under
%       /ein/multiwork/experiment_XX/included/data_vis/FOLDER/
%   -   A .mat file with the raw heatmap data is saved at the same place
%   -   One image and one .mat file is saved for every subject-pair, e.g.:
%       '3213_cevent_inhand_child_childview.png'
%       '3213_cevent_inhand_child_childview.mat'
%   -   Once executed, the function prints out a progress status, listing
%       how many (and which) subjects will be processed.
%
%   PARAMETERS:
%   -   SUBJECT: string saying either 'child' (default) or 'parent' --
%       determines whether the heatmaps are from the child's or the
%       parent's view
%
%   -   CSV_FILE: path the CSV file that cointains CEVENT-like data
%
%   -   COLS: columns of the CS that contian CEVENT (must be 
%       [subject_id onset offset category], default is 1:4
%
%   -   NUM_HEAD: number of lines in the CSV files with header info,
%       i.e. number of lines to skip (default: 2)
%
%   -   CEVENT_NAME: string that descibes the CEVENT (default: 'CSV_event')

clear all;

%% modify parameters below
SUBJECT = 'child';
FOLDER = 'heatmap_4';
CSV_FILE = 'demo.csv';
COLS = [1 2 3 4];			% optional
NUM_HEAD = 2;				% optional
CEVENT_NAME = 'CSV_event';	% optional

generate_toy_heatmaps_csv(SUBJECT, FOLDER, CSV_FILE, COLS, NUM_HEAD, CEVENT_NAME);