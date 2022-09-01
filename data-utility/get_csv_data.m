function out = get_csv_data(csv, columns, IDs)
% out = get_csv_data(csv, columns, IDs)
root = fullfile(get_multidir_root, 'data_vis', 'correlation');
if exist(fullfile(root, csv), 'file')
    csv = fullfile(root, csv);
end 

data = readmatrix(csv,NumHeaderLines=1);

if sum(ismember(data(:,1), list_subjects())) ~= length(data(:,1))
    sprintf('First column in %s is not subject list', csv);
    if exist('IDs', 'var') && ~isempty(IDs)
        error('IDs was specified, but first column in %s is not subject list', csv);
    end
end

if ~exist('IDs', 'var') || isempty(IDs)
    subs = cIDs('all');
else
    subs = cIDs(IDs);
end

if ~exist('columns', 'var') || isempty(columns)
%     if ~isempty(subs)
%         columns = 2:size(data,2);
%     else
%         columns = 1:size(data,2);
%     end
    columns = 1:size(data,2);
elseif strcmp(columns, 'all')
    columns = 1:size(data,2);
end

out.sub_list = subs;
if ~isempty(subs)
    [~,b,c] = intersect_order(data(:,1), subs);
    out.data = NaN(length(subs), length(columns));
    out.data(c,:) = data(b,columns);
    out.has_variable = c;
else
    out.data = data(:,columns);
end

out.data_headers = get_csv_headers(csv);
out = orderfields(out);

end