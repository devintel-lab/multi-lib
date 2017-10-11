function recover_variables(IDs, var_list)
% Overview: recover variables from the archive to derived folders on multiwork. Please use with caution.
% e.g. recover_variables(7006, 'cevent_test_ja_both') will find the newest
%   archived version of this variable under /extra_p, and move it to
%   derived. Error will occur if the variable still exist under /derived
%   folder and user cannot overwrite the existing variable with an archived
%   copy.
% Required:
%   IDs : array of experiments or subjects.
%   var_list : cell array of strings, representing the files to remove.

subs = cIDs(IDs);

if ~iscell(var_list)
    var_list = {var_list};
end

fprintf('subjects:\n');
disp(subs)
fprintf('variables:\n')
disp(var_list)
x = input('You will recover the above variables from archive to derived folder, continue? (y/n) : ', 's');
if strcmp(x, 'y')
    request_IU_username();
    user = getenv('IU_username');
    for sidx = 1 : numel(subs)
        sub_id = subs(sidx);
        dir_subject = get_subject_dir(sub_id);
        dir_archive = dir(fullfile(dir_subject, 'extra_p', 'archive_*'));
        [~, idx_sort] = sort([dir_archive.datenum]);
        num_archive = length(idx_sort);
            
        for vidx = 1:length(var_list)
            varname_one = var_list{vidx};
            
            if is_core_variable(varname_one)
                if ~is_core_member(user)
                    warning('Not authorized to remove variable, please contact Chen');
                    continue;
                end
            end
            
            dest_file = fullfile(dir_subject, 'derived', [varname_one '.mat']);
            if exist(dest_file, 'file')
                error('Variable %s still exist for subject %d, no need to recover', varname_one, sub_id);
            end
            
            for arcidx = 1:num_archive
                dir_one = dir_archive(num_archive-arcidx+1).name;
                source_file = fullfile(dir_subject, 'extra_p', dir_one, [varname_one '.mat']);
                
                if exist(source_file, 'file')
                    fprintf(['Found back-up file %s for subject %d under archive %s, ' ...
                        'now recovering it to derived.\n'], varname_one, sub_id, dir_one);
                    movefile(source_file, dest_file, 'f');
                end
            end
        end
    end
end