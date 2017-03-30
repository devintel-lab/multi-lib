function [ageout, gendout, log, subs] = get_age_at_exp(IDs)
subs = cIDs(IDs);

expIDs = unique(sub2exp(subs));
log = arrayfun(@(A) exist(fullfile(get_multidir_root, sprintf('experiment_%d', A), 'survey_data', 'basic.tsv'), 'file') > 0, expIDs);
expIDs = expIDs(log);
if ~isempty(expIDs)
    try
        surv = load_survey(expIDs, 'basic');
    catch ME
        error(ME.message)
    end
    
    subjects = surv.subject;
    gender = surv.gender;
    ages = surv.age_at_experiment;
    
    [log,idx] = ismember(subs, subjects);
    gendout = gender(idx(idx~=0));
    ageout = ages(idx(idx~=0));
else
    ageout = [];
    gendout = [];
    log = [];
end

end