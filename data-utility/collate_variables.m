function collate_variables(destination, subjects, variables)
%Copy variables so they're organized by name, then subject: varname/123.mat
%
% USAGE:
%   collate_variables(DESTINATION, SUBJECTS)
%       Creates a directory structure under the directory DESTINATION, with
%       one directory for each variable that exists for any of the
%       SUBJECTS.  Each variable
%       <subject>/derived/<var_type>_<var_name>.mat is then copied to
%       DESTINATION/<var_name>/<var_type>_<subject>.mat
%
%   collate_variables(DESTINATION, SUBJECTS, VARIABLES)
%       Same as above, but only copies the variables that you list in
%       VARIABLES, a cell array of strings.
% 

if ~ exist('variables', 'var')
    % Collect the names of all the variables we'll need
    vars_per_subject = arrayfun(@list_variables, subjects, 'UniformOutput', 0);
    all_variables = unique(vertcat(vars_per_subject{:}));
else
    if ischar(variables)
        variables = {variables};
    end
    all_variables = variables;
end

% start copying things!
for V = 1:numel(all_variables)
    var_name = all_variables{V};
    var_dir = fullfile(destination, var_name);
    
    if ~exist(var_dir, 'dir')
        mkdir(var_dir);
    end
    
    fprintf('Collecting %s', var_name);
    for S = 1:numel(subjects)
        subject = subjects(S);
        
        if ~ has_variable(subject, var_name)
            continue
        end
        
        data_type = get_data_type(var_name);
        dest_file = fullfile(var_dir, ...
            sprintf('%s_%d.mat', data_type, subject));
        
        %copyfile(get_variable_path(subject, var_name), dest_file);
        var_data = get_variable(subject, var_name);
        sdata.data = var_data;
        sdata.variable = sprintf('%s_%d',var_name,subject);
        sdata.info.timestamp = datestr(now);
        sdata.info.subject = subject;
        sdata.info.path = var_dir;

        save(dest_file, 'sdata');
        
        fprintf('.');
    end
    
    fprintf('\n');
end

