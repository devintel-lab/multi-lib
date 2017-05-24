function rename_variables(IDs, old_var_list, new_var_list)
% Overview: Rename variables from the derived folders on multiwork. Please use with caution.
% e.g. rename_variables(72, {'cevent_eye_roi_child_test'}, {'cevent_eye_roi_child_test2'})
% This will create a new variable, 'cevent_eye_roi_child_test2', the same contents of 'cevent_eye_roi_child_test', and then delete 'cevent_eye_roi_child_test'.
% Required:
%   IDs : array of experiments or subjects.
%   old_var_list : cell array of strings, representing the files to be renamed;
%   new_var_list : cell array of strings, representing the new file names.
% This function will not allow you to rename core variables unless you are authorized to do so.

old = old_var_list;
new = new_var_list;
[subs,~,subpaths] = cIDs(IDs);

%check
if ~iscell(old)
    old = {old};
end
if exist('new', 'var') && ~isempty(new)
    if ~iscell(new)
        new = {new};
    end
    if numel(old) ~= numel(new)
        error('old and new must have same number of names');
    end
end
request_IU_username();
user = getenv('IU_username');
to_delete = {};
for s = 1:numel(subs)
    for o = 1:numel(old)
        oldfn = fullfile(subpaths{s}, [old{o} '.mat']);
        newfn = fullfile(subpaths{s}, [new{o} '.mat']);
        if ~is_core_member(user)
            if is_core_variable(old{o})
                warning('%s is a core variable, you must be authorized to rename this variable', old{o});
                continue;
            end
            if is_core_variable(new{o})
                warning('%s is a core variable, you must be authorized to rename to this variable', new{o});
                continue;
            end
        end
        if exist(newfn, 'file')
            warning('%d : %s already exists, you cannot overwrite this variable. You will need to use delete_variables first to remove them.', subs(s), new{o});
            continue;
        end
        if exist(oldfn, 'file')
            load(oldfn);
            to_delete = cat(1, to_delete, old(o));
            sdata.variable = new{o};
            fprintf('saving file: %s\n', newfn);
            save(newfn, 'sdata');
        end
    end
end
if ~isempty(to_delete)
    fprintf('==== Rename complete. Removing old variables ====\n');
    delete_variables(subs, to_delete);
end
end
