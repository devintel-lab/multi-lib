function [ has_it ] = has_variable( subj_id, var_name )
%Returns true if the variable file exists in that subj's dir.
%   has_variable(SUBJECT_ID, VARIABLE_NAME)
%
%   Searches the derived/ subdirectory of the subject data associated with
%   the given numerical subject ID, and sees if a MATLAB file containing
%   the given variable exists.  If so, returns 1, if not, returns 0.

variable_file = get_variable_path(subj_id, var_name);

has_it = exist(variable_file, 'file') == 2;

end
