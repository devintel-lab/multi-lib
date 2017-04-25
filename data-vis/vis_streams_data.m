function h = vis_streams_data(celldata, window_times, streamlabels, args)
% each element of celldata is a cstream or cevent data
% {cev1, cev2, cev3}
% the element can also be another cell, B, where B{1} is cev or cstream and B{2} is a colorset
% {cev1, {cev2, colormap}, cev3}
% this is useful if you want one of the cevents to have a unique colormap, such as when we have a continuous stream converted to cevent

if ischar(celldata)
    switch celldata
        case 'demo1'
            sub = 7206;
            celldata = {get_variable(sub, 'cstream_eye_roi_child'), get_variable(sub, 'cevent_eye_roi_parent')};
%             window_times = get_variable(sub, 'cevent_trials');
            window_times = [];
            streamlabels = {'ceye', 'peye'};
    end
end

if ~exist('args', 'var')
    args = struct();
end

if ~isfield(args, 'titlelabel')
    args.titlelabel = [];
end

if ~isfield(args, 'colors')
    args.colors = set_colors([]);
end

if ~isfield(args, 'draw_edge')
    args.draw_edge = 1;
end

if ~isfield(args, 'isCont')
    args.isCont = 0;
end

if ~exist('streamlabels', 'var') || isempty(streamlabels)
    for c = 1:numel(celldata)
        streamlabels{1,c} = sprintf('%d', c);
    end
end

if ~exist('window_times', 'var')
    window_times = [];
end

streamlabels = cellfun(@(a) strrep(a, '_', '\_'), streamlabels, 'un', 0);
streamlabels = streamlabels(end:-1:1);
celldata = celldata(end:-1:1);

space = 0.03;
height = 1;
bottom = 0;

numdata = numel(celldata);

for d = 1:numel(celldata)
    cevorcst = celldata{d};
    if ~isstruct(cevorcst)
        if size(cevorcst,2) == 2
            cev = cstream2cevent(cevorcst);
        else
            cev = cevorcst;
        end
        celldata{d} = cev;
    end
end

if isempty(window_times) % create trials, 120 seconds each, starting from earliest timestamp in the data 
    begin_times = zeros(1,numel(celldata));
    end_times = begin_times;
    for c = 1:numel(celldata)
        if ~isempty(celldata{c})
            begin_times(c) = celldata{c}(1,1);
            end_times(c) = celldata{c}(end,2);
        else
            begin_times(c) = Inf;
            end_times(c) = -Inf;
        end
    end
    begin_time = min(begin_times);
    end_time = max(end_times);
    numtrials = ceil((end_time - begin_time)/120);
    window_times_list = begin_time:120:(begin_time+numtrials*120);
    window_times(:,1) = window_times_list(1:end-1);
    window_times(:,2) = window_times_list(2:end);
end

numplots = size(window_times,1);

h = figure('visible', 'on', 'position', [50 100 1280 720]);
axh = cell(numplots,1);
for n = 1:numplots
    axh{n,1} = axes();
    axh{n,1}.Position = [0.05, 0.75-.24*(n-1), 0.92, 0.21];
    ylim([0, numdata + numdata*space]);
    xlim([window_times(n,1) window_times(n,2)]);
    if n == 1
        if ~isempty(args.titlelabel)
            title(strrep(args.titlelabel, '_', '\_'));
        end
    end
end

label_pos = [];
cont_colormap = [];
for d = 1:numel(celldata)
    this_args = args;
    cev = celldata{d}; % cevent or cstream
    if ~isempty(cev)
        if isstruct(cev) && ~isempty(cev.data)
            this_args = cev.args;
            cev = cev.data;
        end
        if this_args.isCont
            cellcev = cont_extract_ranges(cev, window_times);
        else
            cellcev = event_extract_ranges(cev, window_times);
        end
        for c = 1:numel(cellcev)
            axes(axh{c});
            cevpart = cellcev{c};
            if ~isempty(cevpart)
                if this_args.isCont
                    cm_size = size(cont_colormap, 1);
                    cont_colormap = cat(1, cont_colormap, this_args.colors);
                    im = imagesc('CData', cevpart(:,2)'+cm_size, 'XData', cevpart(:,1), 'YData', bottom+.5);
                    im.CDataMapping = 'direct';
                else
                    for i = 1:size(cevpart, 1)
                        tmp = cevpart(i,:);
                        width = tmp(2) - tmp(1);
                        if width > 0
                            r = rectangle('Position', [tmp(1), bottom, width, 1], 'facecolor', this_args.colors(tmp(3),:), 'edgecolor', 'none');
                            if this_args.draw_edge
                                set(r, 'edgecolor', 'black', 'linewidth', 0.5);
                            end
                        end
                    end
                end
            end
        end
    end
    
    label_pos = cat(2, label_pos, bottom + height/2);
    bottom = bottom + 1 + space;

end
colormap(cont_colormap);
for n = 1:numplots
    axes(axh{n});
    set(gca, 'ytick', label_pos);
    set(gca, 'yticklabel', streamlabels);
    set(gca, 'ticklength', [0 0])
end
p = pan(h);
p.Motion = 'horizontal';
z = zoom(h);
z.Motion = 'horizontal';

end