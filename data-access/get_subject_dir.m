function dir_name = get_subject_dir(subject_id)
% gets the directory holding the subject's data, given its subject id.
%   get_subject_dir(SUBJECT_ID)
%       Constructs the name of the directory where the subject's data
%       should live.
%
%   This directory name is returned without a trailing file separator (like
%   / or \).

multidir = get_multidir_root();

% find the subject info for the given subject_id
table = read_subject_table();
subj_info = func_filter(@(subj) subj(1) == subject_id, table);

if length(subj_info) < 1
    error('No such subject (%d) exists in the subject_table.txt file!', subject_id);
end

% format the subject info into a filename.
% use 'fullfile' instead of 'sprintf' so that the function can run well under windows system 
dir_name = fullfile(multidir, ['experiment_' num2str(subj_info(1,2))], ...
    'included', ['__' num2str(subj_info(1,3)) '_' num2str(subj_info(1,4), '%04d')]);
% dir_name = sprintf(...
%     ['%s' filesep filesep 'experiment_%d' filesep filesep 'included' filesep filesep '__%d_%04d'], ...
%     multidir,                 subj_info(1,2:4) );       
 
