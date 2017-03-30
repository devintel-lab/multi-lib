clear all;

exp_id = [32 34];

sub_list = list_subjects(exp_id);

% sub_list = 3203;

cevent_name_naming = 'cevent_speech_naming';

for sidx = 1:length(sub_list)
    sub_id = sub_list(sidx);
    
    cevent_naming = get_variable(sub_id, cevent_name_naming);
    cevent_score = cevent_naming(:,:);
    
    for cidx = 1:size(cevent_naming, 1)
        vocal_id_one = cevent_naming(cidx, 3);
        
        score_one = get_score_by_object_vocal_id(sub_id, vocal_id_one);
        cevent_score(cidx, 3) = score_one;
        
    end
    
    record_variable(sub_id, 'cevent_speech_naming_test-score', cevent_score);
end