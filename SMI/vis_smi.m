function vis_smi(subID, flag)

if ~exist('flag', 'var')
    flag = 'standard';
end
path = [get_subject_dir(subID) filesep() 'derived' filesep()];
switch flag
    case 'standard'
        stream_files = {[path 'cevent_eye_roi_child.mat']
                        [path 'cevent_eye_roi_fixation_child.mat']
                        [path 'cevent_trials.mat']};
        streamlabels = {'eye', 'fix', 'trials'};
    case 'all'
        stream_files = {
            [path 'cevent_eye_roi_child.mat']
            [path 'cevent_eye_roi_fixation_child.mat']
            [path 'cstream_eye_roi_saccade_child.mat']
            [path 'cstream_eye_roi_blink_child.mat']
            [path 'cstream_eye_roi_undefined_child.mat']
            [path 'cstream_eye_roi_missing_child.mat']
            [path 'cevent_trials.mat']
            };
        streamlabels = {'eye','fixation', 'saccade', 'blink', 'undefined', 'missing', 'trials'};
    otherwise
        disp('[-] Not a valid flag')
        disp('    Flag can be one of the following:')
        disp('        - all')
        disp('        - standard')
        return
end
window_times_file = [get_subject_dir(subID) filesep() 'extra_p' filesep() 'time.csv'];
savefilename = [path 'SMI.png'];
vis_streams_files(stream_files, window_times_file, savefilename, streamlabels);
disp('[+] The subject is successfully visualized')
end

