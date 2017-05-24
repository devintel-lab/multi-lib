function [subs, parttable, paths] = cIDs(IDs, flagDerived)
% Will list subjects in a particular experiment
% IDs can be either expIDs or subIDs
% If IDs = {43, [4301, 4302]}, it will return all subjects in 43 except 4301
% and 4302
% parttable will return the rows in subject_table.txt on multiwork
% paths will return the full path to the derived folder of each subject
% if flagDerived is 1, adds 'derived' to subject root directory in paths output 

if iscell(IDs)
    without = IDs{2};
    IDs = IDs{1};
else
    without = [];
end

if ~exist('IDs', 'var') || isempty(IDs)
    error('Must specify subject list or experiment list');
end

if ischar(IDs) && strcmp(IDs, 'all')
    IDs = [12 14 17 29 32 34 35 39 41 43 44 49 70 71 72 73 74 75];
end

if ~exist('flagDerived', 'var') || isempty(flagDerived)
    flagDerived = 1;
end
    

table = read_subject_table();
log = table(:,2) > 9;
table = table(log,:);

subwithout = ismember(table(:,1), without);
expwithout = ismember(table(:,2), without);

% to retain correct ordering
parttable = cell(numel(IDs), 1);
for i = 1:numel(IDs)
    sublog = ismember(table(:,1), IDs(i));
    explog = ismember(table(:,2), IDs(i));
    log = (sublog | explog) & ~(subwithout | expwithout);
    parttable{i,1} = table(log,:);
end
parttable = vertcat(parttable{:});
% sublog = ismember(table(:,1), IDs);
% explog = ismember(table(:,2), IDs);
% subwithout = ismember(table(:,1), without);
% expwithout = ismember(table(:,2), without);
% log = (sublog | explog) & ~(subwithout | expwithout);
% 
% parttable = table(log, :);

subs = parttable(:,1);

% if ~isequal(subs, unique(subs))
%     error('subjects and experiments in subject_table.txt must be listed in ascending order, please notify sbf@umail.iu.edu');
% end

paths = cell(size(parttable,1), 1);
fs = filesep();
root = get_multidir_root;
if flagDerived
    derived = ['derived' fs];
else
    derived = '';
end
for t = 1:size(parttable,1)
    tmp = parttable(t,:);
    path = sprintf('%s%sexperiment_%d%sincluded%s__%d_%d%s%s%s', root, fs, tmp(2), fs, fs, tmp(3), tmp(4), fs, derived);
    paths{t,1} = path;
end

end