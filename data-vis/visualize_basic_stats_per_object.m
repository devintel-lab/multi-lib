function visualize_basic_stats_per_object(subexpIDs, varname, savefilename, args)
% subexpIDs - array of experiments IDs or subject IDs
% varname - string indicating
% args.colormap - type 'doc colormap' for more information, here are
% recommended options
%   'hot'
%   'gray'
%   'jet'

if ~exist('args', 'var') || isempty(args)
    args = struct();
end

if ~isfield(args, 'colormap') || isempty(args.colormap)
    args.colormap = 'gray';
end

if ~isfield(args, 'categories') || isempty(args.categories)
    args.categories = 1:4;
end

[subs, parttable] = cIDs(subexpIDs);

if ismember(12, parttable(:,2)) || ismember(58, parttable(:,2)) || ismember(59, parttable(:,2))
    args.categories = 1:25;
end

if ismember(15, parttable(:,2))
    args.categories = 1:11;
end

args.persubject = 1;

% adding the following lines to exclude problematic subjects
%==========start==========
new_subs = [];
for i = 1:numel(subs)
    try
        if has_variable(subs(i), varname)
            new_subs = [new_subs, subs(i)];
        end
    catch ME
        warning(['[-] subject ' num2str(subs(i)) ' does not have variable ' varname])
    end
end
subs = new_subs;
%========== end ==========

ex = extract_multi_measures(varname, subs, '', args);

measures = {'prop', 'mean_dur', 'freq'};
lenargs = length(args.categories);
index_on = 4:lenargs:lenargs*numel(measures);
index_off = index_on + lenargs - 1;
if ~isempty(ex)
    for m = 1:numel(measures)
        data = ex(:,(index_on(m):index_off(m)));
        subs = ex(:,1);
        rankeddata = sort(vertcat(data(:)));
        rankeddata(isnan(rankeddata)) = [];
        val_min = min(rankeddata);
        rankeddata(rankeddata==val_min) = [];
        idx_90 = floor(.9 * length(rankeddata));
        val_max = rankeddata(idx_90);
        
        if length(args.categories) > 5
            f = figure('position', [100 100 1280 720]);
        else
            f = figure('position', [100 100 320 1280]);
        end
        colormap(args.colormap)
        a = axes;
        
        im = imagesc(data, [val_min, val_max]);
        cb = colorbar;
        title(strrep(measures{m},'_','\_'));
        a.YTick = 1:length(subs);
        a.YTickLabel = subs;
        
        a.XTick = 1:length(args.categories);
        a.XTickLabel = args.categories;
        
        if exist('savefilename', 'var') && ~isempty(savefilename)
            export_fig(f, [savefilename '_' measures{m} '_unsorted.png'], '-png');
            headers = 'subid';
            for l = 1:size(data,2)
                headers = cat(2, headers, sprintf(',cat-%d', l));
            end
            write2csv([subs data], [savefilename '_', measures{m} '_unsorted.csv'], headers);
        end
        
        [data_sorted,I] = sort(data, 2, 'descend');
        im.CData = data_sorted;
        for r = 1:size(data_sorted,1)
            for c = 1:size(data_sorted,2)
                text(c,r,sprintf('%d',I(r,c)), 'color', 'r');
            end
        end
        
        if exist('savefilename', 'var') && ~isempty(savefilename)
            export_fig(f, [savefilename '_' measures{m} '_sorted.png'], '-png');
            close(f);
        end
    end
end
end

