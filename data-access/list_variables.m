function [tnames, subsdata] = list_variables(IDs, substring, intersectFLAG, fullpathsFLAG, trimFLAG)
% Lists all variables for an array of subjects or experiments.
% 
% substring : a character string that will filter variables accordingly
% 
%         e.g. list_variables(43, 'cevent inhand') will only return variables with
%         'cevent' and 'inhand' in the name.
% 
% intersectFLAG : if 1, the intersection of variables across all given subjects.
%           if 0, the union of variables across all given subjects.
% 
% examples:
%         list_variables([1401 1402], 'vision');
%         list_variables([32 34 39], 'cevent joint');
%         list_variables([3201 34], 'cont2');
%
% Author: sbf@umail.iu.edu

if ~exist('intersectFLAG', 'var') || isempty(intersectFLAG)
    intersectFLAG = 0;
end

if ~exist('fullpathsFLAG', 'var') || isempty(fullpathsFLAG)
    fullpathsFLAG = 0;
end

if ~exist('trimFLAG', 'var') || isempty(trimFLAG)
    trimFLAG = 1;
end

[subs, ~, paths] = cIDs(IDs);

subsdata = struct();
tnames = cell(size(paths,1), 1);
for t = 1:size(paths,1)
    tmp = paths{t,1};
    path = sprintf('%s*mat', tmp);
    files = dir(path);
    filenames = {files.name}';
    celltmp = cell(numel(filenames),1);
    if fullpathsFLAG
        for c = 1:numel(celltmp)
            celltmp{c} = [tmp filenames{c}];
        end
        filenames = celltmp;
    end
    tnames{t,1} = filenames;
end

subdata = tnames;
tnames = unique(vertcat(tnames{:}));

if exist('substring', 'var') && ~isempty(substring)
    substringparts = strsplit(substring, ' ');
    search = cellfun(@(a) cellfun(@isempty, strfind(tnames, a)) == 0, substringparts, 'un', 0);
    search = horzcat(search{:});
    search = all(search, 2);
    tnames = tnames(search);
end

tnames(cellfun(@isempty, tnames)) = [];

if intersectFLAG
    subdata = cellfun(@(a) intersect(tnames, a), subdata, 'un', 0);
end

subsdata.all = tnames;
subsdata.data = subdata;
subsdata.subs = subs;
if trimFLAG
    tnames = cellfun(@(a) a(1:end-4), tnames, 'un', 0);
end

end