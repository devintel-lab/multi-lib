function cdata = group_csv_data(csv, grouping, IDs)
% cdata = group_csv_data(csv, grouping, IDs);
%
% Required: csv, grouping, IDs
%
% This function gets data from a single csv file, but groups data based on
% the categorical values indicated in the grouping file or matrix
%
% Notes:
%
% csv and grouping are csv filenames
% csv and grouping filenames should be absolute path if not located in
% /ein/multiwork/data_vis/correlation/
%
% Alternatively, grouping can be an input matrix of size Nx1 or Nx2 -- if
% Nx2, then first column should be subject IDs
%
% IDs can be a subject list or a list of experiments
% If grouping is a Nx1 matrix, then length(grouping) == length(cIDs(IDs))
% must be true
%
% Examples:
% ======
% csv = 'cstream_inhand_right-hand_obj-all_parent_prop_vs_age.csv';
% grouping = [1 2 2 3];
% IDs = [4301 4302 4303 4304];
% ======
% csv = 'cstream_inhand_right-hand_obj-all_parent_prop_vs_age.csv';
% grouping = '/ein/multiwork/data_vis/grouping_example.csv';
% IDs = 43;

if ischar(grouping)
    gdata = get_csv_data(grouping, 2, IDs);
    subgroup = gdata.sub_list(gdata.has_variable);
    grouping = gdata.data(gdata.has_variable);
    sublog = gdata.has_variable;
else
    if min(size(grouping)) == 1
        if size(grouping, 2) > 1
            grouping = grouping';
        end
    end
    if size(grouping, 2) > 1
        subgroup = grouping(:,1);
        grouping = grouping(:,2:end);
    else
        subgroup = cIDs(IDs);
        if length(subgroup) ~= length(grouping)
            error('Grouping and sub_list from IDs must have equal length');
        end
    end
end

cdata = get_csv_data(csv,[], IDs);
data = cdata.data;
subdata = cdata.sub_list;
if exist('sublog', 'var')
    flog = sublog & cdata.has_variable;
else
    flog = cdata.has_variable;
end
[subs, idx, log] = intersect_order(subgroup, subdata);
grouping = grouping(idx,:);
data = data(log,:);
ugroup = unique(grouping);
final = cell(numel(ugroup), 1);
gsub_list = cell(numel(ugroup), 1);
data_isnan = cell(numel(ugroup), 1);
for u = 1:numel(final)
    final{u,1} = data(grouping == ugroup(u),:);
    gsub_list{u,1} = subs(grouping == ugroup(u),:);
    data_isnan{u,1} = isnan(data(grouping==ugroup(u),:));
end
data_cat = vertcat(final{:});
gsub_list_cat = vertcat(gsub_list{:});

cdata.data = final;
cdata.data_isnan = data_isnan;
cdata.data_cat = data_cat;
cdata.gsub_list = gsub_list;
cdata.sub_list = gsub_list_cat;
cdata.has_variable = flog;
cdata.grouping_unique = ugroup;
cdata.grouping = sort(grouping);
cdata.data_cat_isnan = isnan(data_cat);
if exist('gdata', 'var')
    cdata.grouping_headers = gdata.data_headers;
end
cdata = orderfields(cdata);
end