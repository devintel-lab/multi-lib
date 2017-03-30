function vis_cstreams(allcst, timebase, labels, colors, axh)

if ~exist('colors', 'var') || isempty(colors)
    colors = set_colors;
end

if ~iscell(allcst)
    allcst = {allcst};
end
if exist('labels', 'var') && ~isempty(labels)
    labels = labels(end:-1:1);
else
    labels = cell(1, numel(allcst));
    for l = 1:numel(allcst)
        labels{1,l} = num2str(l);
    end
end
allcst = allcst(end:-1:1);

bottom = 0;
space = 0.03;
earliesttime = Inf;
latesttime = -Inf;
if ~exist('axh', 'var') || isempty(axh)
    h = figure('visible' ,'on');
    axh = axes;
    set(h, 'position', [100 100 1440 360]);
    set(axh, 'position', [.05 .25 .9 .5]);
end
for c = 1:numel(allcst)
    cst = allcst{c};
    if ~isempty(cst)
        if size(cst, 2) == 1
            if exist('timebase', 'var') && ~isempty(timebase)
                cst = cat(2, timebase(:,1), cst);
            else
                cst = cat(2, (1:length(cst))', cst);
            end
        end
        
        if size(cst,2) == 2
            cev = cstream2cevent(cst);
        else
            cev = cst;
        end
        
        if ~isempty(cev)
            for i = 1:size(cev, 1)
                tmp = cev(i,:);
                width = tmp(2) - tmp(1);
                if width > 0
                    rectangle('Position', [tmp(1), bottom, width, 1], 'facecolor', colors(tmp(3),:), 'edgecolor', 'black', 'linewidth', 0.5);
                end
            end
            
            earliesttime = min([earliesttime, cev(1,1)]);
            latesttime = max([latesttime, cev(end,2)]);
        end
    end
    bottom = bottom + 1 + space;
end
bottom = bottom - space;
ylim([0 bottom]);
xlim([earliesttime latesttime]);

if exist('labels', 'var')
    labels = cellfun(@(a) strrep(a, '_', '\_'), labels, 'un', 0);
    set(axh, 'ytick', .5:1:numel(allcst));
    set(axh, 'yticklabel', labels);
end
end