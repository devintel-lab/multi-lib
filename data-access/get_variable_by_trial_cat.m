function rez = get_variable_by_trial_cat(subid, var, trialcol)

if ~exist('trialcol', 'var')
    trialcol = 0;
end

if has_variable(subid, var)
    rez = get_variable_by_trial(subid, var);
    if trialcol
        for r = 1:numel(rez)
            tt = get_variable(subid, 'cevent_trials');
            rez{r}(:,end+1) = tt(r,3);
        end
    end
    rez = vertcat(rez{:});
else
    rez = [];
end

end