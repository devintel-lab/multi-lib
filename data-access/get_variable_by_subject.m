function subj_data = get_variable_by_subject( subject_list, var_name )
%get_variable_by_subject retrieves the given variable from several subjects
%   USAGE:
%   get_variable_by_subject(SUBJECT_LIST, VARIABLE_NAME)
%       Retrieves the variable specified by VARIABLE_NAME from the
%       directory of each subject in SUBJECT_LIST, and returns all the data
%       in a cell array, one subject's data per cell.
%
%   SUBJECT_LIST is an array of subject IDs.  See also: LIST_SUBJECTS,
%   FIND_SUBJECTS
%
%   VARIABLE_NAME is the name of a variable.
%
%   The return value is a vertical cell array with one subject's data per
%   cell, in the same order that the subjects were listed.  The data from
%   each subject will include time intervals that aren't inside trials of
%   the experiment; to get only trial data, by subject, use
%   GET_VARIABLE_BY_TRIAL in a loop (this might be improved later).
%
%   If one of the subjects does not have the requested variable, an
%   exception will be thrown.
%
%   See also: GET_VARIABLE_BY_TRIAL, FIND_SUBJECTS

% this variable contains the data from each subject, each in its own cell
subj_data = arrayfun(@(subject) get_variable(subject,   var_name), ...
    subject_list, ...
    'UniformOutput', 0);

% We mostly use vertical cell arrays:
subj_data = subj_data';

end
