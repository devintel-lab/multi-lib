function is_core = is_core_variable(variable_name)

var_list = scantext(fullfile(get_multidir_root(), 'core_variable_list.txt'), '', 0, '%s');
var_list = var_list{1};

is_core = ismember(variable_name, var_list);

end