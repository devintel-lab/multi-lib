function [utterances] = read_speech_transcription(sid)
% Analyse a speech transcription file


speech_dir = fullfile(get_subject_dir(sid), 'speech_transcription_p');
speech_entry = dir(fullfile(speech_dir, 'speech_*_out.txt'));
speech_path = fullfile(speech_dir, speech_entry.name);


speech_file = fopen(speech_path);

utterances = [];
L = 0;

while (1)
    line = fgetl(speech_file); L = L + 1;
    if line == -1
        break
    end
    
    fields = sscanf(line, '%f');
    
    
    utterances(L).start = fields(1);
    utterances(L).end = fields(2);
    utterances(L).words = fields(3:end);
end
        

