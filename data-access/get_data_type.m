function data_type = get_data_type( variable_name )
%Finds the name of the data type of the given variable.
%   USAGE:
%   get_data_type(VARIABLE_NAME)
%       Takes the first part of VARIABLE_NAME, which is the data type
%       specifier, and returns it.
%
%   This is a simple process, since variable names all start with their
%   data type.  'event_object_inhand', for instance, is an 'event' type
%   variable.

underscore_indices = strfind(variable_name, '_');

if length(underscore_indices) < 1
    error('get_data_type:bad_name_format', ...
        ['The variable name ' variable_name ...
        ' doesn''t seem to have a data type in it']);
end

data_type = variable_name(1 : underscore_indices(1) - 1);

end