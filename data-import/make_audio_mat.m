function make_audio_mat(IDs)
% Converts speech_r/*.wav file into a matlab variable with the correct
% timing information based on _info.txt. This stream is compressed by a
% factor of 100 so that it can easily load into visualization programs.
subs = cIDs(IDs);

dsfactor = 100;
for s = 1:numel(subs);
    try
    path = get_subject_dir(subs(s));
    d = dir(fullfile(path, 'speech_r', '*.wav'));
    if isempty(d)
        d = dir(fullfile(path, 'speech_r', '*.mp3'));
    end
    path = fullfile(path, 'speech_r', d.name);
    [y,fs] = audioread(path);
    re = downsample(y(:,1), dsfactor);
    time = (0:size(re,1)-1)';
    time = time/fs*dsfactor;
    info = get_timing(subs(s));
    offset = info.speechTime;
    time = time + offset;
    all = [time re];
    %get just in trial portion
    tri = get_trial_times(subs(s));
    [~,idx1] = min(abs(all(:,1)-tri(1)));
    [~,idx2] = min(abs(all(:,1)-tri(end)));
    all = all(idx1:idx2,:);
    record_variable(subs(s), 'cont_audio_file', all);
    catch ME
        continue
    end
end