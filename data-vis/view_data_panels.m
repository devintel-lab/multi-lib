function view_data_panels(data_column, panel_width, hist_edges, filename)
% data_column is a Nx1 matrix
% panel_width is a constant, e.g. 5000 meaning each panel will display 5000
% datapoints
% hist_edges is used to bin data for histogram, e.g. [0:.1:1]
% Each bin includes the left edge, but does not include the right edge, except for the last bin which includes both edges.
% It also appears to truncate data, meaning, if values are greater than the
% last bin edge, those data points are not included. To include these, add
% Inf as the last bin edge. e.g. [0:.1:1 Inf]

%% DEMO
% r = rand(1000,1);
% panel_width = 200;
% hist_edges = [0:.05:1];
% filename = 'sin_of_rand.png';
% view_data_panels(r,panel_width,hist_edges,filename);
%%
numpanels = ceil(length(data_column)/panel_width);
figure();
set(gcf, 'position', [100 100 1280 720]);
currange = [1 1+panel_width];
for i = 1:numpanels
    subplot(numpanels, 1, i);
    ending = min([currange(2),length(data_column)]);
    idx = currange(1):ending;
    data = data_column(idx);
    plot(idx, data);
    xlim(currange);
    currange = currange+panel_width;
end

if ~isempty(filename)
    export_fig(gcf,filename);
    close(gcf);
end

% figure();
% histogram(data, hist_edges);
% fn = strsplit(filename, '.');
% if ~isempty(filename)
%     export_fig(gcf,sprintf('%s_hist.%s', fn{1}, fn{2}));
%     close(gcf);
% end

end