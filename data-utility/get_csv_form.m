function out = get_csv_form(csv, columns, subexpID)

data = get_csv_data_v2(csv);

log = ismember(data(:,1), list_subjects());

if ~all(log)
    warning('first column of csv may not have subject IDs');
end

usubs = unique(data(:,1));
ranges = cell(numel(usubs), 1);
for u = 1:numel(usubs)
    log = data(:,1) == usubs(u);
    if exist('columns', 'var') && ~isempty(columns)
        ranges{u,1} = data(log, columns);
    else
        ranges{u,1} = data(log, :);
    end
end

if exist('subexpID', 'var')
    subs = cIDs(subexpID);
    
    log = ismember(usubs, subs);
    
    usubs = usubs(log);
    ranges = ranges(log);
end

out.sub_list = usubs;
out.ranges = ranges;

end