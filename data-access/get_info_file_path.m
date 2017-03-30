function [ pathname ] = get_info_file_path( subject_id )
%Finds the path of the ...info.mat file for that subject
%   get_info_file_path(SUBJECT_ID)
%       Returns the pathname where the timing info file __DATE_KIDID.mat
%       should be stored for that subject.
%
%   For a list of subject_ids, try read_subject_table().

subject_dir = get_subject_dir(subject_id);

table = get_subject_info(subject_id);
file = sprintf('__%08d_%04d_info.mat', table(3), table(4));

pathname = [subject_dir filesep() file];

end
