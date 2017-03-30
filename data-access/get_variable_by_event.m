function chunks = get_variable_by_event( subject_list, var_name, event_name, whence, interval )
%Returns the chunks of variable data that fall within an event
%   USAGE:
%   get_variable_by_event(SUBJECT_LIST, VARIABLE_NAME, EVENT_NAME)
%       Retrieves the variables specified by VARIBLE_NAME and EVENT_NAME
%       from each subject in SUBJECT_LIST.  Then, for each EVENT, extracts
%       the range of data from the VARIABLE that falls within the duration
%       of the EVENT.  Returns the results in a cell array.
%
%   get_variable_by_event(SUBJECT_LIST, VARIABLE_NAME, EVENT_NAME,
%           WHENCE, INTERVAL)
%       Same as above, but selects some time relative to the start or end
%       of the event, rather than the duration of the cevent itself.  For
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
%   EVENT_NAME is the name of an event (or cevent) variable, which should
%   also be present in each subject's directory.
%
%   See also: LIST_VARIABLES, LIST_SUBJECTS, CEVENT_RELATIVE_INTERVALS

var_data_by_subject = get_variable_by_subject(subject_list, var_name);

event_data_by_subject = get_variable_by_subject(subject_list, event_name);

% If the user would like data centered around the start or end of the
% event, deal with that.
if exist('whence', 'var')
    if nargin ~= 5
        error('WHENCE argument requires INTERVAL argument');
    end
    
    event_data_by_subject = cellfun(...
        @(event) cevent_relative_intervals(event, whence, interval), ...
        event_data_by_subject, 'UniformOutput', 0);
end

% the type of the variable data:  event, cevent, cont, cstream
data_type = get_data_type(var_name);


% Apply extract_ranges to each subject's data set.
chunks_by_subject = cellfun( ...
    @(var_data, evt_data) extract_ranges(var_data, data_type, evt_data),...
    var_data_by_subject, event_data_by_subject, ...
    'UniformOutput', 0);

% Flatten the cell array to one level (event) rather than two (subject,
% event).
chunks = vertcat(chunks_by_subject{:});

end
