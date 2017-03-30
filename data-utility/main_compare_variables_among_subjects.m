function [] =  main_compare_variables_among_subjects(subject_list, data_types, module_name, all_variables_list, dir_name, is_verbose, args)
%
% this function performs data validation by checking several properties
% of the four data types. It goes through all the variables one by one
% and generate a report which will be saved in  a set of report files.
% 
% INPUT
%  subject_list     subject ID list
%  data_types       list of data structure, four types of data types are
%                   supported: 'cont', 'cevent', 'cstream', 'event'
%  module_name      a string of module name, e.g., 'motion', it is used to  
%                   specify which module you are interested in. Default is 
%                   all modules if you doesn't provide this parameter or it is empty.
%  all_variables_list: optional parameter, the list of variables to be
%                   extracted, it can be a cell of variable names, or a csv file 
%                   containing the list of variable names.
%  dir_name         a string indicates where to save the results file.
%                   Default is current directory.
%  is_verbose       whether detailed progress will be displayed in console.
%
% Example:   
%   sub_list = list_subjects(14);
%   data_types = {'event','cont','cevent','cstream'}; 
%   module_name = ''; % it can be 'motion', 'vision', 'inhand' and etc.
%   % all_variable_list = {}; % empty means that list all the variables for
%                             % the subject list; it can also be:
%   % all_variable_list = 'var_names.csv'; 
%   all_variable_list = {'cevent_inhand_child'}; 
% 
%	dir_name = '/ein/scratch/Zeth/variable_check';
%   is_verbose = 1;  % 1 -- display progress; 0 - mute
%
%   main_compare_variables_among_subjects(sub_list, data_types, module_name, dir_name, is_verbose)
% 
%   ...
%   checking done for variable event_motion_rot_head_moving_child
%   checking done for variable event_motion_rot_head_moving_parent
%   checking done for data type event, results saved in /ein/scratch/Zeth/variable_check/exp14_compare_variables_event.csv

if nargin < 2
    help main_compare_variables_among_subject
    error('You should provide subject list and data structure list.');
end

% if nargin < 3
%     module_name = '';
% end

if nargin<3 || isempty(module_name)
    %all module
    module_name = '_';
else
    %add '_' to the start and end of module_name if necessary
   if module_name(1) ~= '_'
       module_name = ['_' module_name];
   end
   if module_name(end) ~= '_'
       module_name = [module_name '_'];
   end
end
    
if nargin < 4
    all_variables_list = list_complete_variables(subject_list, data_types, module_name);
else
    if isempty(all_variables_list)
        all_variables_list = list_complete_variables(subject_list, data_types, module_name);
    else
        all_variables_list = list_variables_by_module(all_variables_list, module_name, data_types);
    end
end

if nargin < 5 || isempty(dir_name)
    %if user doesn't give directory name, use the current directory
    dir_name=cd;
end

if ~exist('is_verbose', 'var')
    is_verbose = false;
elseif isstruct(is_verbose)
    args = is_verbose;
    is_verbose = false;
end

GROUPING = 'trial_cat';

if ~exist('args', 'var')
    args.grouping = GROUPING;
end

data_type_num = length(data_types);
exp_list = unique(round(subject_list/100));
subject_num = length(subject_list);

% %to find all varaibles of each data_type
% all_variables_list = cell(1, data_type_num);
% subject_num = numel(subject_list);
% for subject_index = 1 : subject_num
%     subject_id = subject_list(subject_index);
%     var_list = list_variables(subject_id); 
%     for var_index = 1 : numel(var_list)
%         var_name = var_list{var_index};
%         for data_type_index = 1 : data_type_num            
%             if strcmp(get_data_type(var_name), data_types{data_type_index}) ...
%                 && ~isempty(regexp(var_name, module_name, 'once'))
%                 found = 0;
%                 exist_var_list = all_variables_list{data_type_index};
%                 for index = 1 : numel(exist_var_list)
%                     if strcmp(var_name, exist_var_list{index}) == 1
%                         found = 1;
%                         break;
%                     end
%                 end
%                 if ~found
%                     all_variables_list{data_type_index} = [all_variables_list{data_type_index}; {var_name}];
%                     break;
%                 end
%             end
%         end
%     end
% end

for data_type_index = 1 : data_type_num
    data_type = data_types{data_type_index};
    listing = all_variables_list{:,data_type_index}; 
    
    if isempty(listing)
        fprintf('No %s type variables found.\n\n', data_type);
        continue
    end
    
    csv_cells_by_type = {};

    disp_sub_list = subject_list;

    if size(disp_sub_list, 1) < size(disp_sub_list, 2)
        disp_sub_list = disp_sub_list';
    end
    
    for var_index = 1 : numel(listing)
        variable_name = listing{var_index};
        
        has_variable_list = arrayfun(@(subject_id) ...
            has_variable(subject_id, variable_name), ...
            subject_list, ...
            'UniformOutput', false);
        has_variable_list = cell2mat(has_variable_list)';
        
        sub_list_valid = subject_list(has_variable_list);
        args.sub_list = sub_list_valid;
        
        if sum(has_variable_list) ~= subject_num
            is_missing_var = true;
        else
            is_missing_var = false;
        end
            
        chunks = get_variable_by_grouping('sub', ...
            sub_list_valid, variable_name, GROUPING);
        
        switch data_type 
            case 'cont'
                results = cont_cal_stats(chunks, args);
                
                individual_mean = results.individual_mean;
                individual_std = results.individual_std;
                individual_median = results.individual_median;
                individual_min = results.individual_min;
                individual_max = results.individual_max;
                individual_nonnan = results.individual_nonnan;
                individual_hist = results.individual_hist;
                
                individual_mean = round(individual_mean*100)/100;
                individual_std = round(individual_std*100)/100;
                individual_median = round(individual_median*100)/100;
                individual_min = round(individual_min*100)/100;
                individual_max = round(individual_max*100)/100;
                individual_nonnan = round(individual_nonnan*100)/100;
                individual_hist = round(individual_hist*100)/100;
%                 
%                 size(disp_sub_list(has_variable_list))
%                 size(individual_mean)
%                 size(individual_std)
%                 size(individual_median)
%                 size(individual_min)
%                 size(individual_max)
%                 size(individual_nonnan)
                
                data_mat = [...
                    disp_sub_list(has_variable_list) ...
                    individual_mean ...
                    individual_std ...
                    individual_median...
                    individual_min ...
                    individual_max ...
                    individual_nonnan];
                
                data_cell = cell(subject_num, ...
                    (size(data_mat, 2)+size(individual_hist,2)+1));
                
                if is_missing_var;
                    for tmpidx = 1:subject_num
                        data_cell{tmpidx, 1} = subject_list(tmpidx);
                        data_cell{tmpidx, 2} = 'no such variable exist for this subject';
                    end
                end
                
                data_cell(has_variable_list, 1:size(data_mat, 2)) ...
                    = num2cell(data_mat);
                data_cell(has_variable_list, size(data_mat, 2)+2:end) ...
                    = num2cell(individual_hist);

                csv_cell_by_var = cell(size(data_cell,1)+1, size(data_cell,2)+1);
                
                csv_cell_by_var(1, 1:size(data_mat, 2)+2) = {variable_name, ...
                    'sub_id', ...
                    'mean', 'std', 'median', 'min', 'max', 'nonnan', 'hist->'};
                for tmpi = 2:size(csv_cell_by_var, 1)
                    csv_cell_by_var{tmpi, 1} = variable_name;
                end
                csv_cell_by_var(1, size(data_mat, 2)+3:end) = ...
                    num2cell(results.hist_bins);
                csv_cell_by_var(2:end, 2:end) = data_cell;
                
            case  'cstream'
                results = cstream_cal_stats(chunks, args);
                
                individual_prop = results.individual_prop;
%                 individual_switches =
%                 results.cevent_stats.individual_switches_freq;
                cat_idx = find(results.categories);
                categories = results.categories(cat_idx);
                individual_prop_by_cat = results.individual_prop_by_cat(:, cat_idx);                
                
                individual_prop = round(individual_prop*100)/100;
%                 individual_switches = round(individual_switches*100)/100;
                individual_prop_by_cat = round(individual_prop_by_cat*100)/100;
                
                data_mat = [...
                    disp_sub_list(has_variable_list) ...
                    individual_prop]; % individual_switches
                
                data_cell = cell(subject_num, ...
                    (size(data_mat, 2)+length(categories)+1));
                
                if is_missing_var;
                    for tmpidx = 1:subject_num
                        data_cell{tmpidx, 1} = subject_list(tmpidx);
                        data_cell{tmpidx, 2} = 'no such variable exist for this subject';
                    end
                end
                
                data_cell(has_variable_list, 1:size(data_mat, 2)) ...
                    = num2cell(data_mat);
                data_cell(has_variable_list, size(data_mat, 2)+2:end) ...
                    = num2cell(individual_prop_by_cat);

                csv_cell_by_var = cell(size(data_cell,1)+1, size(data_cell,2)+1);
                
                csv_cell_by_var(1, 1:size(data_mat, 2)+2) = {variable_name, ...
                    'sub_id', ...
                    'prop', 'prop by cat->'}; % 'switches freq', 
                for tmpi = 2:size(csv_cell_by_var, 1)
                    csv_cell_by_var{tmpi, 1} = variable_name;
                end
                csv_cell_by_var(1, size(data_mat, 2)+3:end) = ...
                    num2cell(categories);
                csv_cell_by_var(2:end, 2:end) = data_cell;
                
            case  'cevent'
                results = cevent_cal_stats(chunks, args);
                
                individual_number = results.individual_number;
                individual_median_dur = results.individual_median_dur;
                individual_mean_dur = results.individual_mean_dur;
                individual_std_dur = results.individual_std_dur;
                individual_switches = results.individual_switches_freq;
                
                individual_median_dur = round(individual_median_dur*100)/100;
                individual_mean_dur = round(individual_mean_dur*100)/100;
                individual_std_dur = round(individual_std_dur*100)/100;
                individual_switches = round(individual_switches*100)/100;
                
                cat_idx = find(results.categories);
                categories = results.categories(cat_idx);
                individual_number_by_cat = results.individual_number_by_cat(:, cat_idx);
                
                data_mat = [...
                    disp_sub_list(has_variable_list) ...
                    individual_number ...
                    individual_median_dur ...
                    individual_mean_dur ...
                    individual_std_dur ...
                    individual_switches];
                
                data_cell = cell(subject_num, ...
                    (size(data_mat, 2)+length(categories)+1));
                
                if is_missing_var;
                    for tmpidx = 1:subject_num
                        data_cell{tmpidx, 1} = subject_list(tmpidx);
                        data_cell{tmpidx, 2} = 'no such variable exist for this subject';
                    end
                end
                
                data_cell(has_variable_list, 1:size(data_mat, 2)) ...
                    = num2cell(data_mat);
                data_cell(has_variable_list, size(data_mat, 2)+2:end) ...
                    = num2cell(individual_number_by_cat);

                csv_cell_by_var = cell(size(data_cell,1)+1, size(data_cell,2)+1);
                
                csv_cell_by_var(1, 1:size(data_mat, 2)+2) = {variable_name, ...
                    'sub_id', ...
                    'num_cevents', 'median_dur', 'mean_dur', ...
                    'std_dur', 'switches freq', 'num by cat->'};
                for tmpi = 2:size(csv_cell_by_var, 1)
                    csv_cell_by_var{tmpi, 1} = variable_name;
                end
                csv_cell_by_var(1, size(data_mat, 2)+3:end) = ...
                    num2cell(categories);
                csv_cell_by_var(2:end, 2:end) = data_cell;
            case  'event'                
                results = event_cal_stats(chunks, args);
                
                individual_number = results.individual_number;
                individual_median_dur = results.individual_median_dur;
                individual_mean_dur = results.individual_mean_dur;
                individual_std_dur = results.individual_std_dur;
                
                individual_median_dur = round(individual_median_dur*100)/100;
                individual_mean_dur = round(individual_mean_dur*100)/100;
                individual_std_dur = round(individual_std_dur*100)/100;
                
                data_mat = [...
                    disp_sub_list(has_variable_list) ...
                    individual_number ...
                    individual_median_dur ...
                    individual_mean_dur ...
                    individual_std_dur];
                
                if is_missing_var
                    data_cell = cell(subject_num, size(data_mat, 2));
                    
                    for tmpidx = 1:subject_num
                        data_cell{tmpidx, 1} = subject_list(tmpidx);
                        data_cell{tmpidx, 2} = 'no such variable exist for this subject';
                    end
                    data_cell(has_variable_list, :) = num2cell(data_mat);
                else
                    data_cell = num2cell(data_mat);
                end

                csv_cell_by_var = cell(size(data_cell,1)+1, size(data_cell,2)+1);
                
                csv_cell_by_var(1, :) = {variable_name, ...
                    'sub_id', ...
                    'num_events', 'median_dur', 'mean_dur', 'std_dur'};
                for tmpi = 2:size(csv_cell_by_var, 1)
                    csv_cell_by_var{tmpi, 1} = variable_name;
                end
                csv_cell_by_var(2:end, 2:end) = data_cell;
            otherwise
                error('Invalid data type!');
        end
        
        if size(csv_cells_by_type, 2) == size(csv_cell_by_var, 2)
            csv_cells_by_type = vertcat(csv_cells_by_type, ...
                cell(1, size(csv_cell_by_var, 2)), csv_cell_by_var);
        else
            max_columns = max(size(csv_cells_by_type, 2), size(csv_cell_by_var, 2));
            max_rows = size(csv_cells_by_type, 1)+size(csv_cell_by_var, 1)+1;
            
            tmp_csv_cells = cell(max_rows, max_columns);
            tmp_csv_cells(1:size(csv_cells_by_type, 1), 1:size(csv_cells_by_type, 2))...
                = csv_cells_by_type;
            tmp_csv_cells(size(csv_cells_by_type, 1)+2:end, 1:size(csv_cell_by_var, 2))...
                = csv_cell_by_var;
            csv_cells_by_type = tmp_csv_cells;
            
            clear tmp_csv_cells;
        end
        
        if is_verbose
            fprintf('checking done for variable %s\n', variable_name);
        end
    end;
       
    tmp_clock = clock;
    tmp_clock_str = sprintf('%d-%d_%d_%d-%d', tmp_clock(2:3), tmp_clock(1), tmp_clock(4:5));
    
    file_name = sprintf('%s/exp%s_compare%svariables_%s_%s.csv', ...
        dir_name, num2str(exp_list'), module_name, data_type, tmp_clock_str);
    
    cell2csv(file_name, csv_cells_by_type);
    
    if is_verbose
        fprintf('checking done for data type %s, results saved in %s\n\n', ...
            data_type, file_name);
    end
end


