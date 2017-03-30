function [ times ] = get_trial_times( subject_id, trial_values)
%GET_TRIAL_TIMES Returns trial information in seconds
%   USAGE:
%   get_trial_times(SUBJECT_ID, TRIAL_VALUES)
%       Figures out the time stamps for the given subject, returning them
%       in an Nx2 array, with each row containing the start and stop times
%       for that trial.
%       Sometimes there were multiple trials for one subject, by specifying
%       the value of TRIAL_VALUES, user can only output the selected trials
%       for the subject, instead of all trials.
%
%   For now, this function looks up the subject's trial info in frames, and
%   then uses the frame_num2time function to convert each time stamp.  This
%   means that it relies on the timing information to be accurate.
%
%   Some trials are listed in the _info.txt file as starting and ending at
%   -1 frames, indicating that they are invalid.  These trials are filtered
%   out by get_timing(), and are NOT returned by this function (changed Jan
%   13 2011). See also: LIST_MISSING_TRIALS

times = arrayfun(@(fnum) frame_num2time(fnum, subject_id), ...
    get_trials(subject_id));

if nargin > 1
    times = times(trial_values, :);
end

end