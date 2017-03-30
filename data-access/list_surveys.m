function available = list_surveys(exp)
%LIST_SURVEYS List the survey data available for an experiment
%
% list_surveys(EXP)
%   Searches the survey data directory for the given experiment EXP, and
%   lists all the tab-separated-values (.tsv) files, which contain survey
%   data.
%
% This is basically a convenient way of saying:
%
% dir(fullfile(get_survey_dir(experiment), '*.tsv'))
%
% See also: get_survey_dir, load_survey

survey_dir = get_survey_dir(exp);

surveys = dir(fullfile(survey_dir, '*.tsv'));
survey_names = {surveys.name};

available = cell(size(survey_names));
for I = 1:length(survey_names)
    [path name ext] = fileparts(survey_names{I});
    available{I} = name;
end
