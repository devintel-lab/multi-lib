function [ var_data ] = get_variable( subj_id, varname, force , source_dir)
%Get the data associated with the variable for the subject
%   get_variable(SUBJECT_ID, VARIBLE_NAME)
%       Finds the path of the variable using get_variable_path, then loads
%       the contents of the variable file, returning just the data portion.
%
%   By convention, the data array is one of the data types used by the
%   visualization program: event, cevent, cstream, or cont.
%
%   For a list of the variables available for a particular subject, try
%   list_variables(SUBJECT_ID).  To search for a subject with a particular
%   variable, try find_subjects({VARIABLE, VARIABLE}).
if nargin < 3 || isempty(force)
    force = false;
end

if ischar(subj_id)
    filename = [subj_id varname '.mat'];
else
    if nargin < 4
        filename = get_variable_path(subj_id, varname);
    else
        filename = get_variable_path(subj_id, varname, source_dir);
    end
end

var_data = [];

if ~exist(filename, 'file')
    if ~force
        error('Requested variable doesn''t exist! %d / %s \n(No such file: ''%s'')', ...
            subj_id, varname, filename);
    end
else
    try
        contents = load(filename);
        if isfield(contents, 'sdata') && isfield(contents.sdata, 'data')
            var_data = contents.sdata.data;
        else
            var_data = contents;
        end
    catch OrigEx
        informative = MException('get_variable:bad_format', ...
            'Problem accessing %d / %s (%s)', ...
            subj_id, varname, filename);
        informative = informative.addCause(OrigEx);
        throw(informative);
    end
end
