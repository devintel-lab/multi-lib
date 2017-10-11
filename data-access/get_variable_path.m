function [ complete_path ] = get_variable_path( subject_id, variable_name, source_dir)
%convert SID and var name into a path, which might exist.
%   get_variable_path(SUBJECT_ID, VARIABLE_NAME)
%
%   Converts the information in the arguments into the pathname where this
%   variable file should live, assuming it exists.


% TODO: make variable_name optional, if not supplied, just give the
% directory where variables will live under this subject (..../derived)
if nargin < 3
    source_dir = 'derived';
end

var_dir = [get_subject_dir(subject_id) filesep() source_dir];

if ~exist(var_dir, 'dir')
    error('Directory %s does not exist.', var_dir);
end
   
if nargin < 2
    complete_path = var_dir;
else
    complete_path = [var_dir filesep() variable_name '.mat'];
end
