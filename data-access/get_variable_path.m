function [ complete_path ] = get_variable_path( subject_id, variable_name )
%convert SID and var name into a path, which might exist.
%   get_variable_path(SUBJECT_ID, VARIABLE_NAME)
%
%   Converts the information in the arguments into the pathname where this
%   variable file should live, assuming it exists.


% TODO: make variable_name optional, if not supplied, just give the
% directory where variables will live under this subject (..../derived)

var_dir = [get_subject_dir(subject_id) filesep() 'derived'];
   
if nargin == 2
    complete_path = [var_dir filesep() variable_name '.mat'];
else
    complete_path = var_dir;
end

end
