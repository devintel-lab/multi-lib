function [out, headers] = get_csv_data_v2(csv, columns, IDs)
% e.g.
% csv = '/bell/multiwork/data_vis/correlation/cevent_inhand-eye_child-child_prop_vs_age.csv';
% get_csv_data_v2(csv, [1 2 3], [3203, 3204]);
%
% csv: full or relative path to .csv file
% (optional) columns: array containing list of columns from which to grab data
% (optional) IDs: array of subject IDs or experiment IDs. If provided, only
% a subset of the data will return, matching the provided subject list.
%
% The order of the returned data is based on the order within the csv file, not
% the order of the IDs input. Meaning, IDs = [3202 3201] may return 3201,
% 3202 if this is ordering within the csv file.
%
% This function assumes the csv follows a certain format. The first column should
% be a list of subjects. If not, it will ignore the IDs input and just
% output all of the data for the columns. The csv can contain header lines, but
% each header line must begin with a #
% e.g.
% #subject, proportion roi, age
%
% This function assumes a proper csv, meaning, there must be equal number
% of commas in each row, including the header lines.
%

root = fullfile(get_multidir_root, 'data_vis', 'correlation');
if exist(fullfile(root, csv), 'file')
    csv = fullfile(root, csv);
end 

[headers, i] = get_csv_headers(csv);

data = dlmread(csv, ',', i-1, 0);

if exist('columns', 'var') && ~isempty(columns)
    out = data(:, columns);
    headers = cellfun(@(a) strsplit(strrep(a, ',',', '), ','), headers, 'un', 0);
    headers = cellfun(@(a) a(:,columns), headers, 'un', 0);
    headers = cellfun(@(a) strjoin(a, ','), headers, 'un', 0);
else
    out = data;
end

if exist('IDs', 'var')
    if all(ismember(data(:,1), list_subjects()))
        [list,~,~] = intersect_order(data(:,1), cIDs(IDs));
        log = ismember(data(:,1), list);
        out = out(log,:);
    end
end

end