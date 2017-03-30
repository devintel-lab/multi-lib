function [ is_there ] = subject_dir_exists( subject_id )
%Returns true if the directory for the subj. exists.
%   Maybe some subjects have info in the subject_table file, but their
%   actual data are not present on the multiwork share.  If so, this
%   function will detect that the directory doesn't exist, and return
%   false.

subj_dir = get_subject_dir(subject_id);
is_there = exist(subj_dir, 'dir') == 7;


end
