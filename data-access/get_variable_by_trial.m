function [ chunks ] = get_variable_by_trial( subject_list, var_name, trial_values)
%GET_VARIABLE_BY_TRIAL Get only the valid portion of a variable's data
%   USAGE:
%   get_variable_by_trial(SUBJECT_LIST, VAR_NAME, TRIAL_VALUES)
%       For each subject ID in SUBJECT_LIST, retrieves the variable
%       specified by VAR_NAME, as well as the trial information for that
%       subject.  For each trial, finds the data in the variable that falls
%       within that interval, and puts it in one cell of a cell array.
%       Returns a cell array, with one trial of data per cell.
% 
%       Sometimes there were multiple trials for one subject, by specifying
%       the value of TRIAL_VALUES, user can only output the selected trials
%       for each subject, instead of all trials. The input value can be a 
%       single vector (the same value for all subject), or a cell of 
%       vectors (one vector per each subject).
%
%   SUBJECT_LIST is just an array of subject IDs.  See also: LIST_SUBJECTS,
%   FIND_SUBJECTS
%
%   VAR_NAME is the name of a variable.  It can be any of the standard
%   multi-lib variable types.
%
%   The return value is a cell array with one trial's worth of data per
%   cell.  If no data exists in a trial, for instance if it's an
%   invalid trial marked by start and end times of -1, some cells may
%   contain an empty array---but it might not be equal to [], use isempty()
%   to test for this.
%
%   See also: EXTRACT_RANGES, CELLFUN
%       

data_by_subject = get_variable_by_subject(subject_list, var_name);

if nargin == 2
    trials_by_subject = arrayfun(@(subj_id) get_trial_times(subj_id), ...
        subject_list, ...
        'UniformOutput', 0)';
else    
    if iscell(trial_values) && length(subject_list) ~= length(trial_values)
        error(['Length of argument ''trial_values'' should be either' ...
            ' one (same trial values for each subject), or the same ' ...
            'length as ''subject_list'' (one set per subject).']);
    end
    
    if iscell(trial_values)
        subject_list = num2cell(subject_list);
        
        trials_by_subject = cellfun( ...
        @(sub_id, t_values) get_trial_times(sub_id, t_values), ...
        subject_list, trial_values, ...
        'UniformOutput', 0)';
    else
        trials_by_subject = arrayfun(@(subj_id) ...
            get_trial_times(subj_id, trial_values), ...
            subject_list, ...
            'UniformOutput', 0)';
    end
end        

data_type = get_data_type(var_name);

chunked_data_by_subject = cellfun( ...
    @(data, trials) extract_ranges(data, data_type, trials), ...
    data_by_subject, ...
    trials_by_subject, ...
    'UniformOutput', 0);

chunks = vertcat(chunked_data_by_subject{:});
if isempty(chunks)
    % vertcat returns a scalar array if its input is empty
    chunks = {};
end

end
