function chunks = get_variable_by_cevent( subject_list, var_name, cevent_name, values, whence, interval )
%Returns the chunks of variable data that fall within an event
%   USAGE:
%   get_variable_by_cevent(SUBJECT_LIST, VARIABLE_NAME, CEVENT_NAME, VALUES)
%       Retrieves the variables specified by VARIBLE_NAME and CEVENT_NAME
%       from each subject in SUBJECT_LIST.  Finds all the event instances
%       in the cevent that have a value in VALUES, and, for each one,
%       extracts the range of data from the VARIABLE that falls within the
%       duration of the event.  Returns the results in a cell array.
%
%
%   get_variable_by_cevent(SUBJECT_LIST, VARIABLE_NAME, CEVENT_NAME,
%           VALUES, WHENCE, INTERVAL)
%       Same as above, but selects some time relative to the start or end
%       of the cevent, rather than the duration of the cevent itself.  For
%       instance, to get the 5 seconds before the start of the cevent,
%       WHENCE should be 'start' and INTERVAL should be [-5 0].  WHENCE can
%       also be 'end'.
%
%   SUBJECT_LIST is a list of subject IDs.  See also: LIST_SUBJECTS,
%   FIND_SUBJECTS
%
%   VARIABLE_NAME is the name of a variable, which should be present in the
%   subject directory of each subject in SUBJECT_LIST (if not, an error
%   will be thrown). This function correctly handles all the standard data
%   types in mult-lib.
%
%   CEVENT_NAME is the name of a cevent variable, which should also be
%   present in each subject's directory.
%
%   VALUES is a list of the values of events in CEVENT_NAME that you're
%   interested in.  For instance, if you're looking at speech data but
%   you're only interested in when a parent uses word number 22.  If you
%   don't care what the value is, use GET_VARIABLE_BY_EVENT instead, since
%   it doesn't have this parameter.  This selecting of events is done using
%   the CEVENT_CATEGORY_EQUALS function.
%
%   See also: LIST_VARIABLES, LIST_SUBJECTS, GET_VARIABLE_BY_EVENT,
%   CEVENT_CATEGORY_EQUALS

if nargin < 4
    error('Not enough input arguments.  See help get_variable_by_cevent.');
end

var_data_by_subject = get_variable_by_subject(subject_list, var_name);

cevent_data_by_subject = get_variable_by_subject(subject_list, cevent_name);

limited_cevent_data_by_subject = cellfun(...
    @(cevent_data) cevent_category_equals(cevent_data, values), ...
    cevent_data_by_subject, ...
    'UniformOutput', 0);

if nargin > 4
    modified_cevent_data = cellfun(...
        @(cevent) cevent_relative_intervals(cevent, whence, interval), ...
        limited_cevent_data_by_subject, 'UniformOutput', 0);
else
    modified_cevent_data = limited_cevent_data_by_subject;
end

% the type of the variable data:  event, cevent, cont, cstream
data_type = get_data_type(var_name);


% Apply extract_ranges to each subject's data set.
chunks_by_subject = cellfun( ...
    @(var_data, evt_data) extract_ranges(var_data, data_type, evt_data),...
    var_data_by_subject, modified_cevent_data, ...
    'UniformOutput', 0);

% Flatten the cell array to one level (event) rather than two (subject,
% event).
chunks = vertcat(chunks_by_subject{:});

end
