function numbers = list_missing_trials( subject_id )
%If trials are missing from a subject, say which ones
%
%   list_missing_trials( subject_id )
%       If any trials have been marked as bad/missing in a subject's
%       _info.txt file, then return their indices.  Otherwise, return [].
%
% Trials can be marked as "bad" for various reasons---fussy children, bad
% data collection, etc.  Sometimes they're also there for obscure reasons
% like a script expects 4 trials but there were only 2 in an experiment.  
%
% Bad trials are marked by putting "-1,-1" as the frame numbers of the
% trial in the _info.txt file of the subject. The multi-lib tools such as
% get_timing and get_trial_times are made to ignore those trials, since
% it's not obvious that this can happen.  If you need to know that the
% second trial returned by get_trial_times was actually trial 3, this
% function can help you.
%
% If the info file looks like:
%     12,345
%     567,890
%     -1,-1
%     1234,4567
%
% Then list_missing_trials(...) will return:
%     3
%
%
% Another way to get this information is to call 
%     get_timing(subject_id, 'include_missing')
% which will leave the -1,-1's in the trial list.
% 

timing = get_timing(subject_id, 'include_missing');
numbers = find(any(timing.trials == -1, 2));
if isempty(numbers)
    numbers = [];
end

