function [g, data] = draw_corr_csv(csv1, column1, csv2, column2, IDs)
% [g, data] = draw_corr_csv(csv1, column1, csv2, column2, IDs)
% e.g.
% column1 = 2; column2 = 2;
% csv1 = 'cevent_inhand-eye_child-parent_mean_dur_vs_age.csv';
% csv2 = 'cont_vision_size_obj#_parent_mean_vs_age.csv';
% IDs = [43 44];
if ~exist('IDs', 'var') || isempty(IDs)
    IDs = [];
end
data1 = get_csv_data(csv1, column1, IDs);
data2 = get_csv_data(csv2, column2, IDs);
subs1 = data1.sub_list;
subs2 = data2.sub_list;
header1 = get_csv_headers(csv1);
header2 = get_csv_headers(csv2);
g = figure;
if ~isempty(subs1) && ~isempty(subs2)
    [subs,b,c] = intersect_order(data1.sub_list, data2.sub_list);
    d1 = data1.data(b,:);
    d2 = data2.data(c,:);
    subexp = sub2exp(subs);
    gscatter(d2,d1,subexp,get_colors(unique(subexp)));
    for t = 1:numel(subs)
        text(d2(t,1), d1(t,1), num2str(subs(t)), 'FontSize', 8,...
            'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom')
    end
else
    d1 = data1.data;
    d2 = data2.data;
    scatter(d1,d2);
end
data = [d1 d2];

set(gcf,'position', [200 200 1000 800]);
legend('Location', 'northeastoutside');
xlabel(strrep(header2{column2},'_',' '), 'FontSize', 12);
ylabel(strrep(header1{column1},'_',' '), 'FontSize', 12);
% title(sprintf('%s vs %s', strrep(header1{column1},'_',' '),strrep(header2{column2},'_',' ')), 'FontSize', 12);
% set(gcf, 'name', sprintf('%s_%s', csv1, csv2));
if isequal(csv1, csv2)
    title(strrep(csv1, '_', ' '), 'Fontsize', 12);
else
    title(sprintf('%s vs %s', strrep(csv1, '_', ' '), strrep(csv2, '_', ' ')), 'FontSize', 12);
end
end