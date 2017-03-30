function [ timing ] = get_timing( subject_id, param )
%Get information on the start times of different sensors
%   get_timing(SUBJECT_ID)
%       Given a subject ID, reads the ...info.mat file in that subject's
%       directory, and returns the contents.
%
%   get_timing(SUBJECT_ID, 'include_missing')
%       Same as above, but if there are any trials marked as "missing" or
%       "bad" in the _info.txt file (with -1 as the start and end frame),
%       include those lines in the output.  Normally these lines are
%       filtered out because they are not useful unless you really care
%       about trial numbers.  See also list_missing_trials.
%
%   This is a structure with the following fields:
%   - trials: [n x 2 double] - the start and end FRAME NUMBER of each trial
%   - speechRate: (usually 44100) - the sample rate of the speech recording
%   - speechTime: the second (down to the millisecond) when speech
%   recording began
%   - camRate: the number of frames per second of video data
%   - camTime: (usually 30) - the second at which video recording began
%   - motionTime: the second (down to the millisecond) when position-sensor
%   recording began.
%
%   These time stamps are used to synchronize measurements from the
%   different kinds of sensors used to record each experiment.  They're
%   mainly useful when dealing with raw data, since derived data should
%   have its own timestamp associated with each data point.

info_file_path = get_info_file_path(subject_id);
contents = load(info_file_path);

timing = contents.trialInfo;


% remove any missing trials unless they say not to
if ~( exist('param', 'var') && strcmp(param, 'include_missing') )
    missing = timing.trials == -1;
    skip = any(missing, 2);
    timing.trials = timing.trials(~ skip, :);
end

