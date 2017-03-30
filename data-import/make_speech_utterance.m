function make_speech_utterance(IDs)
subs = cIDs(IDs);

stim = fullfile(get_multidir_root, 'stimulus_table.txt');
fid = fopen(stim, 'r');
if fid > 0
    data = textscan(fid, '%d %d %d %s %s %d %s %d','Headerlines', 1, 'delimiter', ',', 'EmptyValue', -Inf);
else
    error('file did no open correctly');
end
fclose(fid);

for s = 1:numel(subs)
    log = data{1} == sub2exp(subs(s));
    expwords = data{8}(log);
    wordids = data{2}(log);
    if ~isempty(expwords)
        if has_variable(subs(s), 'speech_trans')
            sdata = get_variable(subs(s), 'speech_trans');
            bt = (arrayfun(@(a) a.bt, sdata.speech.uts))';
            et = (arrayfun(@(a) a.et, sdata.speech.uts))';
            words = (arrayfun(@(a) a.words, sdata.speech.uts, 'un', 0))';
            gt = get_timing(subs(s));
            both = [bt et];
            both = both + gt.speechTime;
            both(:,3) = 4;
            for w = 1:numel(words)
                this = words{w};
                int = intersect(this, expwords);
                if ~isempty(int)
                    firstint = int(1);
                    idx = find(expwords == firstint, 1, 'first');
                    both(w,3) = wordids(idx);
                end
            end
            both = sortrows(both, [1 2 3]);
            record_variable(subs(s), 'cevent_speech_utterance', both);
%             vis_streams(subs(s), {'cevent_speech_naming_local-id', 'cevent_speech_utterance'}, {'local-id', 'uts'}, [], 4);
        end
    end
end
end
