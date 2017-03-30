function make_cevent_naming_learned(subject)
%for each naming event, was that object learned by trial-time?
%

subj_info = get_subject_info(subject);
experiment = subj_info(2);

%
% get learning information
%
[all_subs obj_names all_learning] = read_testinfo_file(experiment);
learning_results = all_learning(all_subs == subject, :);

warning off read_object_table:unreliable

%
% The learning information is in terms of words ('zeebee', etc), but the
% naming events are in terms of vocabulary IDs.
%
% Find the correspondence between words and voc. IDs:
%
obj_vocab_ids = nan(size(obj_names));
for I = 1:numel(obj_names)
    candidates = read_object_table(obj_names{I}, 'by_object_name');
    matches = [ candidates(:).experiment_number ] == experiment;
    
    candidate_vocab_ids = [ candidates(matches).vocab_id ];
    just_one = unique(candidate_vocab_ids);
    if numel(just_one) ~= 1
        error('more than one possible vocab ID for an object!  argh!');
    end
    
    obj_vocab_ids(I) = just_one;
    
end

% Load the naming events
naming_event = get_variable(subject, 'cevent_naming_event');

% For each naming event, find out whether that word was learned.
naming_learned = naming_event(:, 1:2);
for I = 1:size(naming_event, 1)
    idx = obj_vocab_ids == naming_event(I, 3);
    naming_learned(I, 3) = learning_results(idx);
end

record_variable(subject, 'cevent_naming_learned', naming_learned);