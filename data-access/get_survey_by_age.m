function matches = get_survey_by_age(exps, survey, age_interval, varargin)
%GET_SURVEY_BY_AGE Find survey measurements that fall within an age range
%
% get_survey_by_age(EXPERIMENTS, SURVEY_NAME, AGE_INTERVAL)
%   Loads the data in SURVEY_NAME for the given EXPERIMENTS.  Finds a
%   column that starts with 'age', and selects only the rows of the survey
%   data where the 'age' column falls within AGE_INTERVAL.
%
% AGE_INTERVAL is a two-element array, [lower_bound, upper_bound].  To be
% included, a measurement must take place within the closed interval
% defined by the bounds.  If more than one measurement of the same subject
% took place within the bounds, the one closest to the center of the bounds
% is selected.
%   


% todo: argument for setting age column if it's not determined
% automatically, argument for saying what columns should be selected, ...
%
% argument for selecting *all* within the interval, not just the "best" one
p = inputParser;
p.addRequired('exps');
p.addRequired('survey', @ischar);
p.addRequired('age_interval', @(x) numel(x) == 2 && isnumeric(x));
p.parse(exps, survey, age_interval, varargin{:});

survey_data = load_survey(exps, survey);

% Find the "age" column --- whatever column starts with the letters 'age'
var_names = get(survey_data, 'VarNames');
age_var = guess_age_var(var_names);

% Start choosing measurements
matches = survey_data(survey_data.(age_var) >= age_interval(1) ...
    & survey_data.(age_var) <= age_interval(2), :);

% Eliminate duplicates by choosing the "best" one: the one with the age
% closest to the center of the interval
interval_center = mean(age_interval);
to_keep = false(size(matches.subject));
all_subjects = unique(matches.subject);
for S = 1:length(all_subjects);
    subject = all_subjects(S);
    indices = find(matches.subject == subject);
    
    if length(indices) == 1
        to_keep(indices) = true;
        % no duplicates to mess with
        continue
    end
    
    ages = matches.(age_var)(indices);
    [m, idx] = min(abs(ages - interval_center));
    
    to_keep(indices(idx)) = true;
    % the rest are assumed to be deleted, since to_keep starts all false
end


matches = matches(to_keep, :);



end


function age_var = guess_age_var(var_names)
looks_like_age = cellfun(@(name) strncmpi(name, 'age', 3), var_names);
if ~ any(looks_like_age)
    disp(var_names);
    error('get_survey_by_age:no_age_var', ['Can''t find any columns ' ...
        'that appear to tell the age.  Try using the AgeVar argument.']);
elseif sum(looks_like_age) > 1
    disp(var_names{looks_like_age});
    error('get_survey_by_age:more_age_vars', ...
        'Found more than one variable in the survey that seems to be age');
end
age_var = var_names{looks_like_age};
end