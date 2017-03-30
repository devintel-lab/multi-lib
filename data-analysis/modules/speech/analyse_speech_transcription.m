function [individual, collected] = analyse_speech_transcription(subjects)
all_utterances = [];
for S = 1:numel(subjects)
    sid = subjects(S);
    utterances = read_speech_transcription(sid);
    individual(S) = do_analysis(utterances);
    all_utterances = [all_utterances utterances];
end

collected = combine(individual);
end

function results = do_analysis(utterances)

all_words = { utterances(:).words };
word_counts = cellfun(@numel, all_words);
all_starts = [ utterances(:).start ]';
all_ends = [ utterances(:).end ]';
event_speaking = [all_starts all_ends];
durations = diff(event_speaking, 1, 2);

event_between = event_NOT(event_speaking, [-Inf Inf]);
event_between = event_between(2:end-1, :);
durations_between = diff(event_between, 1, 2);

all_possible_objects = list_object_vocab_ids();

% Very global things
results.num_utterances = numel(all_starts);
results.vocab_size = numel(unique(vertcat(all_words{:})));
results.num_tokens = numel(vertcat(all_words{:}));

% Numbers of words
results.mean_num_words = mean(word_counts);
results.median_num_words = median(word_counts);
results.iqr_num_words = iqr(word_counts);
results.std_num_words = std(word_counts);

results.num_one_word_phrases = sum(word_counts == 1);


% Utterance durations (time)
results.mean_duration = mean(durations);
results.median_duration = median(durations);
results.iqr_duration = iqr(durations);
results.std_duration = std(durations);


% durations between utterances
results.median_pause = median(durations_between);
results.mean_pause = mean(durations_between);


% Objects / no objects
has_object = cellfun(@(words) any(ismember(all_possible_objects, words)), all_words);
results.num_naming_events = sum(has_object);
results.num_non_naming_events = numel(all_words) - results.num_naming_events;
results.num_just_object_name = sum(has_object & (word_counts == 1));

token_list = vertcat(all_words{:});
[word_counts word_ids] = hist(token_list, unique(token_list));
results.word_hist = [word_counts' word_ids];


end


function results = combine(indis)

results.median_num_utterances = median([indis(:).num_utterances]);
results.mean_num_utterances = mean([indis(:).num_utterances]);

results.median_vocab_size = median([indis(:).vocab_size]);

results.mean_vocab_size = mean([indis(:).vocab_size]);

results.median_num_tokens = median([indis(:).num_tokens]);

results.mean_num_tokens = mean([indis(:).num_tokens]);

results.median_num_one_word_phrases = median([indis(:).num_one_word_phrases]);

results.mean_num_one_word_phrases = mean([indis(:).num_one_word_phrases]);

results.median_num_naming_events = median([indis(:).num_naming_events]);

results.mean_num_naming_events = mean([indis(:).num_naming_events]);

results.median_num_non_naming_events = median([indis(:).num_non_naming_events]);

results.mean_num_non_naming_events = mean([indis(:).num_non_naming_events]);

results.median_num_just_object_name = median([indis(:).num_just_object_name]);

results.mean_num_just_object_name = mean([indis(:).num_just_object_name]);

results.mean_of_means_duration = mean([indis(:).mean_duration]);

results.mean_of_means_num_words = mean([indis(:).mean_num_words]);

results.mean_of_means_pause = mean([indis(:).mean_pause]);

% results.median_ASDF = median([indis(:).ASDF]);

results.grand_hist = combine_hists({ indis(:).word_hist });

end
