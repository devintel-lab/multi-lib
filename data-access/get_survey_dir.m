function survey_dir = get_survey_dir(exp)

survey_dir = fullfile(get_multidir_root, sprintf('experiment_%d', exp), ...
    'survey_data');
