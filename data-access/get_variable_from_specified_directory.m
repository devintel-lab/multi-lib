function [ var_data ] = get_variable_from_specified_directory( subj_id, sub_directory, varname )
%Get the data associated with the variable for the subject from specified
%sub directory in this subject's folder
%   get_variable_from_specified_directory(SUBJECT_ID, SUB_DIRECTORY,VARIBLE_NAME)
%       Finds the path of the variable using get_variable_path, then loads
%       the contents of the variable file, returning just the data portion.
%
%   By convention, the data array is one of the data types used by the
%   visualization program: event, cevent, cstream, or cont.
%

    if nargin < 3 || isempty(subj_id) || isempty(sub_directory) || isempty(varname)
       error('You must specify subject ID, subdirectory and variable name'); 
    end

    var_dir = [get_subject_dir(subj_id) filesep() sub_directory];
    if exist(var_dir, 'dir')==0
        error(['The directory ' var_dir ' is not existed']);
    end
    filename = [var_dir filesep() varname '.mat'];

    if ~ exist(filename, 'file')
        error('Requested variable doesn''t exist! %d / %s \n(No such file: ''%s'')', ...
            subj_id, varname, filename);
    end

    try
        contents = load(filename);
        var_data = contents.sdata.data;
    catch OrigEx
        informative = MException('get_variable:bad_format', ...
            'Problem accessing %d / %s (%s)', ...
            subj_id, varname, filename);
        informative = informative.addCause(OrigEx);
        throw(informative);
    end
end
