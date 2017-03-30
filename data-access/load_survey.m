function survey_data = load_survey(exps, survey_name)
%LOAD_SURVEY Find info describing experiment subjects
%
% load_survey(EXPS, SURVEY_NAME)
%   For each experiment listed in EXPS, loads the survey named by
%   SURVEY_NAME, returning a dataset array with the requested information.
%
% Many experiments have been augmented with extra data about each subject,
% such as the age and gender of the subjects, their scores on developmental
% tests such as the MCDI, and other data.  To see which data sets are
% availble for a particular experiment, use list_surveys(experiment).
%
% Some surveys, such as 'basic', include exactly one row for each subject.
% Others, like 'mcdi', may have zero, one, or more than one entry for a
% subject.  You can use num_survey_measurements to find this number.
%
% It's definitely worth reading the documentation about dataset arrays, and
% playing with the returned array.
%
% See also: dataset, list_surveys, get_survey_by_age,
% num_survey_measurements
%

survey_data = [];

for E = 1:numel(exps)
    exp = exps(E);
    survey_filename = fullfile( ...
        get_survey_dir(exp), ...
        [survey_name '.tsv']);

    survey_data = vertcat(survey_data, dataset('File', survey_filename));
end
