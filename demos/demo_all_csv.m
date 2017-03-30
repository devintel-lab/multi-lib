%% README
% This is a demo script that shows how to use the draw_corr_csv function as
% well as some other related functions
% primary contact: sbf@umail.iu.edu


%% draw_corr_csv info
% [fig, data] = draw_corr_csv(csv1, column1, csv2, column2, IDs)
% Required: csv1, column1, csv2, column2
% Optional: IDs
%
% csv1 and csv2 are .csv filenames
%
% column1 and column2 are the two data columns to access
% typical columns in csv files under multiwork/data_vis/
% [subject data age]
% [1 2 3] are the corresponding column numbers
%
% IDs can be a list of subjects or a list of experiments
% if IDs is not specified, it gets all available subjects
%
% fig is the output figure
% data is the output matrix

%% Supporting Functions


%% list_files 
% this function lists csv files in multiwork/data_vis/correlation/ that match substring input
% not required to use the draw_corr_csv function, but a nice utility to get
% csv file names
list_files(); % will list all csv files in directory
% OR
list_files('cstream inhand child age prop') % will list all files with those substrings


%% get_csv_data
% this function gets data from a csv file

% The only requirement is a valid csv file name
data = get_csv_data('cevent_inhand-eye_child-child_freq_vs_age.csv');

% Optionally, you can specify a subject list or experiment list
data = get_csv_data('cevent_inhand-eye_child-child_freq_vs_age.csv', [], [43 32]);

% Lastly, you can also specify which columns of data you want
data = get_csv_data('cevent_inhand-eye_child-child_freq_vs_age.csv', 2, [43 44]);

% data is a structure with these fields:
% sub_list
% data
% log - logical array indicating which input subjects were actually in the
% csv file
% headers - returns top row of csv file

%% group_csv_data #1
% this function gets data from csv, but grouped together based on input
% group mapping

csv = 'cstream_inhand_right-hand_obj-all_parent_prop_vs_age.csv';
grouping = [1 2 2 3]; % this means the data for 4301 will be in group1, 4302 and 4303 will be in group2, and 4304 in group3
IDs = [4301 4302 4303 4304];
cdata = group_csv_data(csv, grouping, IDs);

%% group_csv_data #2
csv = 'cstream_inhand_right-hand_obj-all_parent_prop_vs_age.csv';
grouping = '/ein/multiwork/data_vis/grouping_example.csv'; % this is a csv with a list of some subjects in exp 43 in column 1 and the grouping categories in column 2
IDs = 43; % this is a list of all subjects in 43 -- the script will just take the overlap between these subjects and the subjects indicated in the grouping column1
cdata = group_csv_data(csv, grouping, IDs);

%% draw_csv_group
% this function will draw a correlation plot but will group data into bins
% according to grouping input

csv_base = 'cevent_eye_joint-attend_both_freq_vs_age.csv';
csv_group = '/ein/multiwork/data_vis/mcdi_example.csv';
draw_csv_group(csv_base, csv_group);

%% draw_correlation_plots with target object

clear;
yvar = 'cstream_eye_roi_child';
ymeasure = 'individual_prop';
yargs.cevent_name = 'cevent_speech_naming_local-id';
yargs.cevent_values = 1:3;
yargs.sub_list = cIDs(43);
yargs.label_matrix = [
    1 2 2 3;
    2 1 2 3;
    2 2 1 3;]; % on-targets will become 1 and off-targets will become 2, face looks become 3
yargs.directory = '.';
targ = {'on', 'off', 'face'};
for y = 1:3
    yargs.filename = sprintf('testing_%s', targ{y});
    yargs.categories = y;
    draw_correlation_plots(yvar, 'individual_prop', yargs);
end
for y = 1:3
    imshow('testing_%s_prop_vs_age.png', targ{y});
end


%% Main Function


%% basic draw_corr_csv
csv1 = 'cevent_inhand-eye_child-parent_mean_dur_vs_age.csv';
csv2 = 'cont_vision_size_obj#_parent_mean_vs_age.csv';
col1 = 2;
col2 = 2;
[fig,data] = draw_corr_csv(csv1, col1, csv2, col2);

%% basic with subject list

csv1 = 'cevent_inhand-eye_child-parent_mean_dur_vs_age.csv';
csv2 = 'cont_vision_size_obj#_parent_mean_vs_age.csv';
col1 = 2;
col2 = 2;
subs = [4303 4305 3401 3402];
[fig,data] = draw_corr_csv(csv1, col1, csv2, col2, subs);

%% many-to-many or many-to-one pairing
csv1 = {
    'cevent_inhand-eye_child-parent_mean_dur_vs_age.csv';
    'cstream_inhand_right-hand_obj-all_child_prop_vs_age.csv'
    'cstream_inhand_right-hand_obj-all_parent_freq_vs_age.csv'
    'cstream_inhand_right-hand_obj-all_parent_mean_dur_vs_age.csv'
    'cstream_inhand_right-hand_obj-all_parent_prop_vs_age.csv'};
col1 = {2 2 2 2 2}; % one column is specified per element in csv1
csv2 = {'cevent_eye_joint-attend_both_prop_vs_age.csv'};
col2 = {[2 3]}; % pair multiple columns in a set of brackets

% in this example, the column 2 data in each csv file specified in "csv1"
% will be correlated with column 2 and then column 3 data in the variable
% specified

for c1 = 1:numel(csv1)
    for c2 = 1:numel(csv2)
        tmp1 = col1{c1};
        tmp2 = col2{c2};
        for t1 = 1:numel(tmp1)
	  for t2 = 1 : numel(tmp2)
            [fig,data] = draw_corr_csv(csv1{c1}, tmp1(t1), csv2{c2}, tmp2(t2));
            set(fig, 'name', 'tmp')
            pause;
            if ~isempty(findobj('type', 'figure', 'name', 'tmp'))
                close(fig) %will close each figure after view, comment to keep each open
            end
	  end;
        end
        
    end
end

%% csv not in /ein/multiwork/correlation directory
csv1 = {
    '/ein/multiwork/data_vis/spatial_naming.csv'};
col1 = {[2 3 4 5 6 7]}; % one column is specified per element in csv1
csv2 = {'cevent_speech_naming_local-id_prop_vs_age.csv'};
col2 = {[2 3]}; % pair multiple columns in a set of brackets

%using the same csv file, column 2 will be correlated with both column 3
%and column 4, so two figures will appear

for c1 = 1:numel(csv1)
    for c2 = 1:numel(csv2)
        tmp1 = col1{c1};
        tmp2 = col2{c2};
        for t1 = 1:numel(tmp1)
            for t2 = 1:numel(tmp2)
                [fig,data] = draw_corr_csv(csv1{c1}, tmp1(t1), csv2{c2}, tmp2(t2));
                set(fig, 'name', 'tmp')
                pause;
                if ~isempty(findobj('type', 'figure', 'name', 'tmp'))
                    close(fig) %will close each figure after view, comment to keep each open
                end
            end
        end
        
    end
end

