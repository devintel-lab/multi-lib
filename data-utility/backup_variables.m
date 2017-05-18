function backup_variables(IDs, vars)

if isempty(IDs)
    IDs = list_experiments();
end

[subs,~,subpaths] = cIDs(IDs, 0);

%check
if ~iscell(vars)
    vars = {vars};
end

for s = 1:numel(subs)
    cl = clock();
    backupfolder = fullfile(subpaths{s}, 'extra_p', sprintf('archive_%d-%d-%d', cl(2), cl(3), cl(1)));
    backupfoldermade = 0;
    for v = 1:numel(vars)
        varfn = fullfile(subpaths{s}, 'derived', [vars{v} '.mat']);
        if exist(varfn, 'file')
            if ~backupfoldermade
                if ~exist(backupfolder, 'dir')
                    mkdir(backupfolder);
                end
                backupfoldermade = 1;
            end
            to_save = fullfile(backupfolder, [vars{v} '.mat']);
            i = 1;
            while exist(to_save, 'file')
                to_save = fullfile(backupfolder, sprintf('%s(%d).mat', vars{v}, i));
                i = i + 1;
            end
            fprintf('saving file: %s\n', to_save);
            copyfile(varfn, to_save);
        end
    end
end