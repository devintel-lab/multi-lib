%% This is a script to convert the speech coding files into cevent format.


subjs = [2918:2924];
    
for s = 1:length(subjs)
    
    sid = subjs(s);
    subj_info = get_subject_info(sid);
    kid_id = subj_info(4);
    subj_dir = get_subject_dir(sid);
    speech_dir = [subj_dir '/speech_transcription_p/'];
    in_file = sprintf('%sraw_speech_%d.txt', speech_dir, kid_id);
    out_file = sprintf('%sspeech_%d.txt', speech_dir, kid_id);
    command = sprintf('python srt2speechtxt.py %s %s', in_file, out_file);
    
    system(command)
    
end


