function [h, out] = draw_csv_group(csv, grouping, savepath, IDs, column)
% required: csv file name, and grouping file name or Nx2 matrix
% optional: IDs, otherwise it will get intersection of csv and grouping
% subject lists
% optional: savepath is directory of where to save file, otherwise will
% save to current directory
% optional: column specifies which column of the data to use, default is 2
%===============================================================
% example1
% csv_base = 'cevent_eye_joint-attend_both_freq_vs_age.csv';
% csv_group = '/ein/multiwork/data_vis/mcdi_example.csv';
% draw_csv_group(csv_base, csv_group);
% ==============================================================
% example2 -- csv_group can be a [subjID group] matrix
% csv_base = 'cevent_eye_joint-attend_both_freq_vs_age.csv';
% csv_group = [
% 3401 1;
% 4301 5;
% 2901 3;
% ];
% savepath = '/scratch/sbf/testwill';
% draw_csv_group(csv_base, csv_group, savepath);

format = 'png';
if ~exist('IDs', 'var') || isempty(IDs)
    IDs = cIDs([]);
end
if ~exist('savepath', 'var') || isempty(savepath)
    savepath = '';
else
    if ~exist(savepath, 'dir')
        mkdir(savepath);
    end
end
if ~exist('column', 'var') || isempty(column)
    column = 2;
end

data = group_csv_data(csv, grouping, IDs);
log = data.data_cat_isnan(:,column) == 0;

x_values = (1:numel(data.sub_list(log)))';

y_values = data.data_cat(log,column);


h = figure;

gscatter(x_values, y_values, data.grouping(log));

legend('location', 'northeastoutside');

subs = vertcat(data.gsub_list{:});
subs = subs(log);

for t = 1:numel(subs)
    text(x_values(t,1), y_values(t,1), num2str(subs(t)), 'FontSize', 8,...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom')
end

ylabel(strrep(data.data_headers{column}, '_', '\_'));

xlabel(['grouping: ' num2str(data.grouping_unique')]);

if ischar(grouping)
    title(sprintf('grouping file: %s', strrep(grouping, '_', '\_')));
else
    title(sprintf('grouping based on input matrix'));
end

set(h,'position', [200 200 1000 800]);

ff = getframe(h);
filename = fullfile(savepath, sprintf('%s.%s', strrep(data.data_headers{column}, ':', '--'), format));
imwrite(ff.cdata, filename, format); 

out.grouping = data.grouping(log);
out.y_values = y_values;
out.sub_list = subs;
out = orderfields(out);

end