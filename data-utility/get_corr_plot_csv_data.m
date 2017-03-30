function out = get_corr_plot_csv_data(csvfilename, subexpIDs, columns)
% opens and readers data from .csv file
%
% csvfilename : path to csv file, relative to
% /bell/multiwork/data_vis/correlation directory
%
% (optional) subexpIDs : array of subject IDs or experiment IDs. If provided, only
% a subset of the data will return, matching the provided subject list. The
% returned data matrix will be ordered based on this subject list input,
% not the order that the subjects appear in the csv file.
%
% (optional) columns: array containing list of columns from which to grab data
%
% This function assumes the csv follows a certain format. The first column should
% be a list of subjects. If not, it will ignore the IDs input and just
% output all of the data for the given columns. The csv should contain a single
% header line.
% e.g.
% #subject, proportion roi, age
% 3201, .5, 23
%
% This function assumes a proper csv, meaning, there must be equal number
% of commas in each row, including the header lines.

csv = fullfile(get_multidir_root, 'data_vis', 'correlation', csvfilename);
if exist(csv, 'file')
    try
        data = dlmread(csv, ',', 1, 0);
    catch ME
        error('%s does not have the correct format. There should be a single header line and all data should be numerical.', csv);
    end
    
    if exist('columns', 'var') && ~isempty(columns)
        out = data(:, columns);
    else
        out = data;
    end
    
    if exist('subexpIDs', 'var')
        if all(ismember(data(:,1), list_subjects()))
            [~,idx,~] = intersect_order(data(:,1), cIDs(subexpIDs));
            out = out(idx,:);
        end
    end
else
    error('%s does not exist in %s', csvfilename, fullfile(get_multidir_root, 'data_vis', 'correlation'));
end

end