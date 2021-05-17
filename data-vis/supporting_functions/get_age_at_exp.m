function [ageout, gendout, log, subjout] = get_age_at_exp_v2(IDs)
subs = cIDs(IDs);

expIDs = unique(sub2exp(subs));
log = arrayfun(@(A) exist(fullfile(get_multidir_root, sprintf('experiment_%d', A), 'survey_data', 'basic.tsv'), 'file') > 0, expIDs);
expIDs = expIDs(log);
if ~isempty(expIDs)
    surv_all = {};
    for i = 1:numel(expIDs)
        try
            surv = dataset2table(load_survey(expIDs(i), 'basic'));
            surv_all{end+1} = surv;
        catch ME
            warning(ME.message)
        end
    end
    
    subjects = [];
    gender = [];
    ages = [];
    
    for i = 1:numel(surv_all)
        surv = surv_all{i};
        subjects = [subjects; surv.subject];
        gender = [gender; surv.gender];
        ages = [ages; surv.age_at_experiment];
    end 
    
    [log,idx] = ismember(subs, subjects);
    gendout = gender(idx(idx~=0));
    ageout = ages(idx(idx~=0));
    subjout = subjects(idx(idx~=0));
else
    ageout = [];
    gendout = [];
    log = [];
    subjout = [];
end

end