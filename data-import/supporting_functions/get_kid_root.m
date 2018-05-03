function root = get_kid_root(kidID, expID)
% This function get the preprocessing raw data path with experiment ID and
% kidID number

root = fullfile(get_temp_backus_root, sprintf('experiment_%02d', expID), 'included');
dnames = dir(fullfile(root, sprintf('*%d', kidID)));
foldernames = {dnames(:).name};
root = fullfile(root, foldernames{1});

end