function l = has_all_variables(subID, varNames)        
if ~ischar(subID)
    subpath = [get_subject_dir(subID) filesep() 'derived' filesep()];
else
    subpath = subID;
end
l = false;
for v = 1:numel(varNames)
    fn = [subpath varNames{v} '.mat'];
    if ~exist(fn, 'file')
        return
    end
end
l = true;

end