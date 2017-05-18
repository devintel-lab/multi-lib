function rename_variables(IDs, old, new)

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
