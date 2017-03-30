function make_cevent_naming_learn_score(IDs)

subs = cIDs(IDs);


for s = 1:numel(subs)
    if has_variable(subs(s), 'cevent_speech_naming')
        % load naming data
        naming = get_variable(subs(s), 'cevent_speech_naming');
        % for each named object, find the score
        scores = arrayfun(@(a) get_score_by_object_vocal_id(subs(s), a), naming(:,3));
        % loop over possible scores, and group these scores together
        for o = 0:2
            log = scores == o;
            if ~isempty(naming(log,:))
                record_variable(subs(s), sprintf('cevent_speech_naming_learn-score-%d_parent', o), naming(log,:));
            end
        end
    end
    
end

end



