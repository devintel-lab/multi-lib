function [ subjects ] = list_subjects( experiments )
%Make a list of subjects that are in the given experiments
%   list_subjects()
%       Returns a list of all subject IDs.
%   list_subjects(EXPERIMENT_NUMBER)
%       Returns a list of all the subject IDs for subjects that are in the
%       given experiment.
%   list_subjects([EXPERIMENT_NUMBER, EXPERIMENT_NUMBER, ...])
%       Returns a list of all the subjects that are in any of the given
%       experiments.
%
%   The return value is a list of subject IDs, which are then usable in
%   functions like get_subject_dir().


if nargin() == 0   
    experiments = list_experiments(); 
end

matches = func_filter(@(subject) ismember(subject(2), experiments), read_subject_table());
    
subjects = matches(:, 1);
end
