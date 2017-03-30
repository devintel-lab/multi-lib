function [ trials ] = get_trials( subject_id , param)
%Finds the frame numbers of the starts and ends of the trials
%   get_trials(SUBJECT_ID)
%       Convenience function, equivalent to x = get_timing(subject_id);
%       x.trials.
%
%   get_trials(SUBJECT_ID, 'include_missing')
%       Same as above, but if there are any trials marked as "missing" or
%       "bad" in the _info.txt file (with -1 as the start and end frame),
%       include those lines in the output.  Normally these lines are
%       filtered out because they are not useful unless you really care
%       about trial numbers.  See also list_missing_trials.
%
% Not all subjects in the same experiment necessarily have the same number
% of trials due to fussy kids and bad data.  See also: LIST_MISSING_TRIALS




if ( exist('param', 'var') && strcmp(param, 'include_missing') )
    timing = get_timing(subject_id, param);
else
    timing = get_timing(subject_id);
end

trials = timing.trials;

end


