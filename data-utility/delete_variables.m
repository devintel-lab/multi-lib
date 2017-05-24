function delete_variables(IDs, var_list)
% Overview: remove variables from the derived folders on multiwork. Please use with caution.
% e.g. delete_variables(72, 'cevent_eye_roi_child_test') will remove that variable for each subject in 72 that has the file
% Required:
%   IDs : array of experiments or subjects.
%   var_list : cell array of strings, representing the files to remove.
% The function will first backup the variables into a folder on extra_p\, just in case one needs to restore the deleted variables.
% This function will not allow you to delete core variables unless you are authorized to do so.

subs = cIDs(IDs);

if ~iscell(var_list)
    var_list = {var_list};
end

fprintf('subjects:\n');
disp(subs)
fprintf('variables:\n')
disp(var_list)
x = input('You will delete the above variables, continue? (y/n) : ', 's');
if strcmp(x, 'y')
    request_IU_username();
    user = getenv('IU_username');
    for s = 1 : numel(subs)
        dirpart = get_subject_dir(subs(s));
        dir = [dirpart '/derived/'];
        for f = 1 : numel(var_list)
            if exist([dir var_list{f} '.mat'], 'file')
                fprintf('found file for subject %d\n', subs(s))
                if is_core_variable(var_list{f})
                    if ~is_core_member(user)
                        warning('Not authorized to remove variable, please contact Chen');
                        continue;
                    end
                end
                backup_variables(subs(s), var_list{f});
                delete([dir var_list{f} '.mat']);
            else
                fprintf('%s not found for subject %d\n', var_list{f}, subs(s));
            end
        end
    end
end