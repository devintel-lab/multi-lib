function delete_variables(IDs, var_list)
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