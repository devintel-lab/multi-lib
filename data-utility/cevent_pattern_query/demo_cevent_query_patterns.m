% This is the example script for function: cevent_query_miner
% [results_final chunked_data] = cevent_query_miner(query,data,relation)
% The description is embeded between the codes

clear all;

exp_id = 70;
sub_list = list_subjects(exp_id);

%   query: a struct that includes the overall information about this query.
%       required fields:
%       sub_list: the subject list
%       grouping: the way how data should be extracted, for example, based
%       on subjects or based on trials. By default, it is set to 'subject'.
%       See GET_VARIABLE_BY_GROUPING.
query.sub_list = sub_list;
query.grouping = 'trial_cat'; 

%   data: a list of structs that contains the information of the cevent
%       variables. The cevent data that can be fed into the miner function
%       can be two forms: 1. variable name; 2. cell of cevents;
%   For example, if user specify the variable name of the cevent, the field
%   VAR_NAME needs to be set:
%       data(1).var_name = 'cevent_inhand_parent';
%     optional fields are:
%       merge_thresh: the parameter for merging cevents if two consecutive
%       cevents have the same cevent value and are close together (the gap 
%       between two cevents <= merge_thresh)
%       dur_range: the duration range of cevents.
%   If the user wants to specify the actual cevent data, then the field
%   CHUNKS must be set:
%       data(1).chunks = 
%           [26x3 double]    [37x3 double]    [17x3 double]    [35x3 double]
%     optional fields are: dur_range
data(1).var_name = 'cevent_inhand_parent';
data(1).merge_thresh = 0.2;
data(1).dur_range = [0.2 inf];

data(2).var_name = 'cevent_inhand_child';
data(2).merge_thresh = 0.2;
data(2).dur_range = [0.2 inf];

data(3).var_name = 'cevent_vision_dominant-obj_cam1_4';
data(3).merge_thresh = 0.2;
data(3).dur_range = [0.2 inf];

%   relation: a list of structs that contains the information of the actual
%   queries. User can define arbitrary number of relations on any two data
%   variable.
%   required fields:
%     data_list: 1*2 matrix, indicating the data chunk targets, the query 
%       defined by this relation will be performed on these two data.
%       For example: 
%       relation(1).data_list = [2 1];
%       The above code means that the query will be performed on data(2) 
%       and data(1), and data(2) will serve as base cevents for searching:
%       the function will go through every cevent in data(2) to search for 
%       a following cevent in data(1).
%     type: the relation type between two data chunks, the value can be set 
%       to 'following', 'leading', 'within', 'overlap'. 
%     whence_list: indicating the relationship is between the start or end 
%       time point of the two cevents.
%     interval: the interval limit on the relationship.
%     roi_list: if user want to extract patterns with specified cevent 
%       values, this field needs to be set.
%       For example: 
%       relation(1).roi_list = [1 2 3 4 5];
%       Then the function will extract event pairs with the same cevent value,
%       but the cevent value has to be in the list of [1 2 3 4 5];
%       relation(1).roi_list = {[1] [2 3]; [2] [1 3]; [3] [1 2]};
%       Then the function will extract event pairs with the following
%       cevent value pairs: [1 2], [1 3], [2 1], [2 3], [3 1], [3 2];
%     mapping_arg: this field can only be set when TYPE is 'following', 
%       'leading' or 'within'.
%       it is usually the case that within an interval, there 
%       are more than one pair that will meet the criteria, so user has to 
%       specify that whether only the nearest pair is extracted or all the 
%       pairs can be considered as candidates. 
%       The value can be 'many2many', 'many2one', 'one2one'.
%     overlap_arg: this field can only be set when TYPE is 'overlap'.
%       The value can be: 
%           start: cevents that overlap with the onsets of base cevents 
%               (starts before base cevent, ends before base cevent);
%           startend: cevents that overlap with the onsets and the offsets 
%               of base cevents (starts before base cevent, ends after base cevent);
%           within: cevents that start later than onset and ends earlier
%               than the offsets of base cevents.
%           end: cevents that overlap with the offsets of base cevents;
%           all: all the overlapping cevents;
%           equal: identical overlapping cevents (starts at the same time, 
%               ends at the same time) 
%     Please see functions
%       CEVENT_GET_FOLLOWING_CEVENTS, CEVENT_GET_LEADING_CEVENTS,
%       CEVENTS_GET_CEVENTS_WITHIN_INTERVAL, CEVENT_GET_OVERLAP_CEVENTS
%     For further information.
relation(1).data_list = [1 2]; % ORDER MATTERS data_list(1) means the base events and data_list(2) means the search events
relation(1).type = 'following'; %'following', 'leading' or 'overlap'
relation(1).mapping_arg = 'many2many';
relation(1).whence_list = {'start'; 'start'};
relation(1).interval = [0 5];
relation(1).roi_list = [1 2 3 4 5];

relation(2).data_list = [2 3];
relation(2).type = 'overlap'; %'following', 'leading' or 'overlap'
relation(2).whence_list = {'start'; 'start'};
relation(2).overlap_arg = 'all';
relation(2).roi_list = [1 2 3 4 5];

relation(3).data_list = [1 3];
relation(3).type = 'following'; %'following', 'leading' or 'overlap'
relation(3).mapping_arg = 'many2many';
relation(3).whence_list = {'start'; 'start'};
relation(3).interval = [0 5];

%   query: a struct that includes the overall information about this query.
%   optional fields for input query, only set when user want to extract continue
%   variables based on the ranges of the cevent query results:
%     chunking_var_name: the list of cont variable names;
%     chunking_ref_column: the time ranges that will be used to extract 
%       continue variables. [1 2] means that the ranges are set using first column from 
%       the cevent query results as the onset of events, and the second column as the 
%       offset of event ranges.
%     chunking_whence & chunking_interval: parameters that are used to produce
%       user specified intervals based on the the event ranges that were extracted based
%       on chunking_ref_column. The value of chunking_whence can be 'start'/'end'/'startend'.
% query.chunking_var_name = {'cont_vision_size_obj1_child'; ...
%     'cont_vision_size_obj2_child'; ...
%     'cont_vision_size_obj3_child'; ...
%     'cont_vision_size_obj4_child'; ...
%     'cont_vision_size_obj5_child'};
% query.chunking_ref_column = [1 2];
% query.chunking_whence = 'startend';
% query.chunking_interval = [-1 5];

% Call the actual function:
% Output:
%   results_final: contains the query result that meets all the
%   requirements that were defined by the user in the RELATION structure.
%   It is a list of cells, one cell for each subject or trial;
%   For example:
%   results_final = 
%     [ 4x9 double]
%     [ 6x9 double]
%     [ 0x9 double]
%     [ 3x9 double]
%     [10x9 double]
%     [ 5x9 double]
%     [ 4x9 double]
%     [ 1x9 double]
%     [ 3x9 double]
%     [ 5x9 double]
%     [ 0x9 double]
%     [ 4x9 double]
%     [ 6x9 double]
%   chunked_data: this will only has value when the field 'chunking_var_name'
%   of QUERY is set. It will be a matrix of cells, the number of row will
%   be equal to the number of subjects or trials, the number of columns
%   will be equal to the list of continue variables that were set by the
%   user.
%   For example:
% chunked_data = 
%     { 4x1 cell}    { 4x1 cell}    { 4x1 cell}    { 4x1 cell}    { 4x1 cell}
%     { 6x1 cell}    { 6x1 cell}    { 6x1 cell}    { 6x1 cell}    { 6x1 cell}
%              {}             {}             {}             {}             {}
%     { 3x1 cell}    { 3x1 cell}    { 3x1 cell}    { 3x1 cell}    { 3x1 cell}
%     {10x1 cell}    {10x1 cell}    {10x1 cell}    {10x1 cell}    {10x1 cell}
%     { 5x1 cell}    { 5x1 cell}    { 5x1 cell}    { 5x1 cell}    { 5x1 cell}
%     { 4x1 cell}    { 4x1 cell}    { 4x1 cell}    { 4x1 cell}    { 4x1 cell}
%     { 1x1 cell}    { 1x1 cell}    { 1x1 cell}    { 1x1 cell}    { 1x1 cell}
%     { 3x1 cell}    { 3x1 cell}    { 3x1 cell}    { 3x1 cell}    { 3x1 cell}
%     { 5x1 cell}    { 5x1 cell}    { 5x1 cell}    { 5x1 cell}    { 5x1 cell}
%              {}             {}             {}             {}             {}
%     { 4x1 cell}    { 4x1 cell}    { 4x1 cell}    { 4x1 cell}    { 4x1 cell}
%     { 6x1 cell}    { 6x1 cell}    { 6x1 cell}    { 6x1 cell}    { 6x1 cell}
% [results_final chunked_data] = cevent_query_patterns(query, data, relation);
results_final = cevent_query_patterns(query, data, relation);

%% to calculate the statistics of the patterns
% stats_results = cevent_cal_stats(results_final(:,1));
% 

% pause

%% start plotting
plotting_example_id = 1;
% you need to vertcat the results before plotting, for example:
%   cevent_data: a 51 * 9 matrix, one row represents one pattern
%   cont_data: a 51 * 5 cells
% 
% For example:
% cevent_data = 
%    90.6000   93.1000    1.0000   92.2000  108.9000    1.0000   94.1000   94.4000    1.0000
%   303.9000  304.4000    3.0000  308.2000  310.8000    3.0000  308.8000  311.1000    3.0000
%   335.9000  341.4000    2.0000  340.5000  349.6000    2.0000  340.9000  344.4000    2.0000
%   350.4000  351.3000    2.0000  351.7000  354.0000    2.0000  350.8000  352.6000    2.0000
%    72.4000   81.1000    3.0000   73.4000   75.4000    3.0000   73.2000   74.0000    3.0000
%    72.4000   81.1000    3.0000   73.4000   75.4000    3.0000   74.2000   75.3000    3.0000
% 
% cont_data = 
%     [ 85x2 double]    [ 85x2 double]    [ 85x2 double]    [ 85x2 double]    [ 85x2 double]
%     [ 65x2 double]    [ 65x2 double]    [ 65x2 double]    [ 65x2 double]    [ 65x2 double]
%     [115x2 double]    [115x2 double]    [115x2 double]    [115x2 double]    [115x2 double]
%     [ 69x2 double]    [ 69x2 double]    [ 69x2 double]    [ 69x2 double]    [ 69x2 double]
%     [147x2 double]    [147x2 double]    [147x2 double]    [147x2 double]    [147x2 double]
%     [147x2 double]    [147x2 double]    [147x2 double]    [147x2 double]    [147x2 double]
% 
cevent_data = cell2mat(results_final);
if plotting_example_id ~= 1
    for cdi = 1:size(chunked_data, 2)
        cont_data{1,cdi} = vertcat(chunked_data{:,cdi});
    end
    cont_data = horzcat(cont_data{:});
end

% 
colormap = { ...
    [0 0 1]; ... % blue
    [0 1 0]; ... % green
    [1 0 0]; ... % red
    [1 1 0]; ... % yellow
    [1 0 1]; ... % pink
    }; 

% 'MAX_ROWS':
%   The number of instances that will appear in one figure
args.MAX_ROWS = 30;
% 'legend'
args.legend = {data(1).var_name; data(2).var_name; data(3).var_name};
% User can specify the color code for each pattern. By default, the color
% will be extracted according to a rainbow color spectrum.
args.colormap = colormap;
% 'ForceZero' & 'ref_column':
%   The timing for cevents in each query is globally different, user can set
%   'ForceZero' to true and define a relative 0 for each pattern by setting
%   the field of 'ref_column' - which column in the pattern matrix is set to
%   be relative 0 time point. 
%   For example, for matrix
%   cevent_data = 
%    90.6000   93.1000    1.0000   92.2000  108.9000    1.0000   94.1000   94.4000    1.0000
%   303.9000  304.4000    3.0000  308.2000  310.8000    3.0000  308.8000  311.1000    3.0000
%   335.9000  341.4000    2.0000  340.5000  349.6000    2.0000  340.9000  344.4000    2.0000
%   350.4000  351.3000    2.0000  351.7000  354.0000    2.0000  350.8000  352.6000    2.0000
%    72.4000   81.1000    3.0000   73.4000   75.4000    3.0000   73.2000   74.0000    3.0000
%    72.4000   81.1000    3.0000   73.4000   75.4000    3.0000   74.2000   75.3000    3.0000
%   If args.ref_column = 2, then the matrix will become:
%   cevent_data = 
%    -2.5000         0    1.0000   -0.9000   15.8000    1.0000    1.0000    1.3000    1.0000
%    -0.5000         0    3.0000    3.8000    6.4000    3.0000    4.4000    6.7000    3.0000
%    -5.5000         0    2.0000   -0.9000    8.2000    2.0000   -0.5000    3.0000    2.0000
%    -0.9000         0    2.0000    0.4000    2.7000    2.0000   -0.5000    1.3000    2.0000
%    -8.7000         0    3.0000   -7.7000   -5.7000    3.0000   -7.9000   -7.1000    3.0000
%    -8.7000         0    3.0000   -7.7000   -5.7000    3.0000   -6.9000   -5.8000    3.0000
args.ForceZero = 1;
args.ref_column = 8;
% 'color_code':
%   User can set color for the cevent instances in patterns in two ways:
%   'cevent_type': all the cevents from the same variable source (the first 
%   three columns in the pattern matrix) will be getting the same color
%   disregard the cevent value.
%   'cevent_value': all the cevents with the same cevent value will be 
%   getting the same color, disregard the variable type.
args.color_code = 'cevent_type';
% 'transparency':
%   Sometimes, cevents will have overlaps, by setting the 'transparency'
%   field to a value smaller than 1 the overlapping segments will be shown
%   with a mixture of colors from the overlapping cevents.
% args.transparency = 0.5;
% 'stream_position':
%   In the pattern matrix, the first three column will be considered as
%   cevents from one variable source, and ...
%   When one pattern is consisting of multiple cevents, the field of 
%   STREAM_POSITION indicates the position that each cevent will be plotted
%   on.
%   For example, if 
%   args.stream_position = [1 1 1]
%   which means that in each pattern, there are three cevents, and all
%   three cevents will be plotted in the same y space.
%   and if 
%   args.stream_position = [1 2 3]
%   The space for plotting each pattern instance will be first devided into
%   three parts on y scale, and the first cevent will be plotted on the top
%   part, the second cevent will be plotted on the middle part, and the
%   third cevent will be plotted on the bottom part.
args.stream_position = [1 2 3];
% 'vert_line':
%   Setting this field allows you to draw red verticle lines on the plot.
args.vert_line = [0 5]; 
% 'save_name':
%   By setting this field, all the figures will be automatically closed 
%   and saved.
if plotting_example_id == 1
    args.save_name = 'pattern_plotting_example1';
    plot_temp_patterns(cevent_data, args);
end

% If user wants to have a figure side by side with the cevent pattern
% plotting figure for continue variables, these field can be set:
% 'legend'
cont_args.legend = {'obj1'; 'obj2'; 'obj3'; 'obj4'; 'obj5'};
% 'colormap': same as describe above
cont_args.colormap = colormap;
% 'vert_line': same as describe above
cont_args.vert_line = [0 5];
% 'target_value_ref_column':
%   This field indicates which continue variable should be plotted
%   according to cevent value column in the cevent pattern matrix.
%   If this field is not set, then all the continue variables will be
%   plotted.
if plotting_example_id == 2
    args.save_name = 'pattern_plotting_example2';
    plot_temp_patterns(cevent_data, args, cont_data, cont_args);
end

cont_args.target_value_ref_column = 3;
if plotting_example_id == 3
    args.save_name = 'pattern_plotting_example3';
    plot_temp_patterns(cevent_data, args, cont_data, cont_args);
end
