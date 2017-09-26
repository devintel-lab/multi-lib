function copy2local(subexpIDs, filenames, source_dir, destination)
% This function will copy a list of files from specified subjects
% into one folder designated by the user, with subject ID added at the end
% of the file name, e.g. cevent_eye_roi_child_7002.mat
% 
% Demo:
%   subexpIDs = [70];
%   filenames = {'cevent_eye_roi_child.mat', 'cevent_eye_roi_parent.mat'};
%   source_dir = 'derived';
%   destination = 'mycopies';
%   copy2local(subexpIDs, filenames, source_dir, destination);

if ~exist(destination, 'dir')
    mkdir(destination);
    fprintf('Directory %s created.\n', destination);
end

sub_list = cIDs(subexpIDs);
num_subs = length(sub_list);
num_files = length(filenames);
num_copied = 0;

for sidx = 1:num_subs
    sub_id = sub_list(sidx);
    sub_str = int2str(sub_id);
    sub_dir = get_subject_dir(sub_id);
    
    if ~exist(fullfile(sub_dir, source_dir), 'dir')
        fprintf('Source directory %s does not exist for subject %d.\n', source_dir, sub_id);
        continue
    end
    
    for fidx = 1:num_files
        name_one = filenames{fidx};
        filesep_loc = strfind(name_one, '.');
        source_file = fullfile(sub_dir, source_dir, name_one);
        if ~exist(source_file, 'file')
            fprintf('File %s does not exist for subject %d under %s.\n', name_one, sub_id, source_dir);
            continue
        end
        
        dest_file = fullfile(destination, [name_one(1:(filesep_loc-1)) '_' sub_str name_one(filesep_loc:end)]);

        [is_succ, message_str] = copyfile(source_file, dest_file, 'f');
        if ~is_succ
            warning('Variable copy failed. Error: %s', message_str);
        else
            num_copied = num_copied + 1;
        end
    end
end

fprintf('%d files copied to directory %s.\n', num_copied, destination);