clear all;

%% getting data
sub_id = 3204;
sub_list = sub_id;
input.sub_list = sub_list;

var_name_list = {
    'cevent_speech_naming_local-id';
    'cevent_eye_roi_child';
    'cevent_eye_roi_parent';
%     'cevent_inhand_child';
%     'cevent_inhand_parent'
    };

input.grouping = 'cevent';
input.cevent_name = 'cevent_speech_naming_local-id';
input.cevent_values = [1];
input.whence = 'start';
input.interval = [-5 5];

%%

title = 'var from top to down: ';

data = {};

for vidx = 1:length(var_name_list)

% vidx = 1;
input.var_name = var_name_list{vidx};
[chunks_one, extra_one] = get_variable_by_grouping('sub', sub_list, input.var_name, input.grouping, input);

data(:, vidx) = chunks_one;
title = [title '  ' no_underline(input.var_name) ';'];
end

% pause

colormap = { ...
    [0 0 1]; ... % blue
    [0 1 0]; ... % green
    [1 0 0]; ... % red
    [1 0 1]; ... % pink
    [0.4 0.4 0.4]; ... % grey
    [0.4 0.4 0.4]; ... % grey
    [0.4 0.4 0.4]; ... % grey
    };

args.legend = {'blue object'; 'green object'; 'red object'; 'face'};
% args.row_text = {'trial 1'; 'trial 2'; 'trial 3'; 'trial 4'};
args.colormap = colormap;
args.ForceZero = 0;
args.ref_column = 1;
args.time_ref = extra_one.individual_ranges(:,1);
% args.ref_index = [1 2];
args.color_code = 'cevent_value';
% args.transparency = 0.3;
% args.stream_position = [1 2 3 4 5];
args.title = title;
args.vert_line = [0 5];
args.set_position = [50 50 1600 800];
% args.save_name = sprintf('%d_cevent_naming', sub_id);
visualize_cevent_patterns(data, args);