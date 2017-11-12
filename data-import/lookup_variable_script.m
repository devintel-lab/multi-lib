function lookup_results = lookup_variable_script(lookup_param, lookup_string)
% This function searches for the script that generated the variable
% specified by the user.
% 
% USE CASE 1:
% >> lookup_results = lookup_variable_script('cont2_eye_xy_child')
% 
% lookup_results =
% 
%   2×4 cell array
% 
%     'Variable Name'         'Matlab Script'    'Repository Folder'    'Module'
%     'cont2_eye_xy_child'    'make_eye_xy'      'data-import'          'eye'   
% 
% User can also search for variables by a keyword or a module.
%
% USE CASE 2: search for relavant variables by keyword
% >> lookup_results = lookup_variable_script('search', 'dominant')
% 
% lookup_results =
% 
%   21×2 cell array
% 
%     'Variable Name'                                           'Matlab Script'              
%     'cont_vision_min-dist_obj-dominant_child'                 'create_dom_object_position' 
%     'cont_vision_min-dist_obj-dominant-2x_child'              'create_dom_object_position' 
%     ...
% 
% USE CASE 3: search for relavant variables by module. Current module list:
%   eye, inhand, vision, speech, motion, macro, inmouth, trial, audio
% >> lookup_results = lookup_variable_script('module', 'eye')
% 
% lookup_results =
% 
%   83×2 cell array
% 
%     'Variable Name'                                       'Matlab Script'                
%     'cont_eye_x_child'                                    'make_eye_xy'                  
%     'cont_eye_y_child'                                    'make_eye_xy'  
%     ...

expr_module = {
    'eye|gaze', 'eye';
    'inhand|hand', 'inhand';
    'vision', 'vision';
    'speech|naming', 'speech';
    'motion', 'motion';
    'macro', 'macro';
    'inmouth', 'inmouth';
    'trial', 'trial';
    'audio', 'audio';
    };
num_modules = size(expr_module, 1);
csvheader = {'Variable Name', 'Matlab Script', 'Repository Folder', 'Module'};

csvfilename = 'lookup_variable_script.csv';

if ~exist(csvfilename, 'file')
    error('File %s does not exist.', csvfilename);
end

fid = fopen(csvfilename);
csv_content = textscan(fid, '%s%s%s%s', 'delimiter',',','headerlines',1);
variable_list = csv_content{1};
script_list = csv_content{2};
folder_list = csv_content{3};
module_list = csv_content{4};
num_vars = size(variable_list, 1);

scripts_searched = unique(script_list);
lookup_results = csvheader(1:2);

if strcmpi(lookup_param, 'search')
    for vidx = 1:num_vars
        if ~isempty(strfind(variable_list{vidx}, lookup_string))
            lookup_results = [lookup_results; variable_list(vidx) script_list(vidx)];
        end
    end
elseif strcmpi(lookup_param, 'module')
    if ~ismember(lookup_string, expr_module(:, 2))
        errormsg = sprintf(['Module %s currently does not exist in our system.\n' ...
            'Currently, we have %d modules: %s.\nPlease try searching by keyword:\n'...
            '>> lookup_variable_script(''search'', ''dominant'')\n'], ...
            lookup_string, num_modules, strjoin(expr_module(:, 2), ', '));
        error(errormsg);
    end
    for vidx = 1:num_vars
        if ~isempty(strfind(module_list{vidx}, lookup_string))
            lookup_results = [lookup_results; variable_list(vidx) script_list(vidx)];
        end
    end
else
    for vidx = 1:num_vars
        if strcmpi(lookup_param, variable_list{vidx})
            lookup_results = [csvheader; variable_list(vidx) script_list(vidx) folder_list(vidx) module_list(vidx)];
            return
        end
    end
end
if size(lookup_results, 1) < 2
    fprintf('No result found, we have searched through these scripts:');
    display(scripts_searched);
    lookup_results = {};
end
