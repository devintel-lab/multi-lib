function [wordStats]= cal_word_stats(speech)
% calculate some simple stats from the transcription
% such as: # of word, # of vocabulary, # of words per utterance
% this function can grow by adding more global/overall stats of the
% transcription 


nsent = size(speech,2);

n_wtotal = 0;
for i = 1 : nsent
    nsent1 = size(speech(i).words,2);
    for m = 1 : nsent1
        n_wtotal = n_wtotal + 1;
        wvoc (n_wtotal) = speech(i).words(m);
    end;
end;

fprintf(1,'------------------------------------------\n');
fprintf(1,'the total number of words:%3d\n', n_wtotal);
wvoc= unique(wvoc);
n_wvoc = size(wvoc,2);
fprintf(1,'the size of vocabulary:%3d\n', n_wvoc);
fprintf(1,'the average words per situation:%3.3f\n', n_wtotal/nsent);
fprintf(1,'------------------------------------------\n');

wordStats.total = n_wtotal;
wordStats.vocab = n_wvoc;
wordStats.nPerUtt = n_wtotal/nsent;
