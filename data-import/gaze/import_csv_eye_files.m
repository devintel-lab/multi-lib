function [child_eye_data, parent_eye_data, time_sub_folder, time_eye_csv_list] = import_csv_eye_files(sub_id)
% Imports the child_eye.csv and parent_eye.csv files and creates
% cont2_child_eye_xy and cont2_parent_eye_xy variables
%
sub_dir = get_subject_dir(sub_id);
csv_list = dir(fullfile(sub_dir, '*_eye.csv'));

% load under extra_p if not exist under sub_dir
if ~isempty(csv_list)
    child_eye_file = fullfile(sub_dir, 'child_eye.csv');
    parent_eye_file = fullfile(sub_dir, 'parent_eye.csv');
else
    csv_list = dir(fullfile(sub_dir, 'extra_p', '*_eye.csv'));
    child_eye_file = fullfile(sub_dir, 'extra_p', 'child_eye.csv');
    parent_eye_file = fullfile(sub_dir, 'extra_p', 'parent_eye.csv');
end

% report error if eye gaze file doesn't not exist under both directories
if ~exist(child_eye_file, 'file')
    fprintf('%d does not have child_eye csv file\n', sub_id);
    child_eye_data = [];
else
    child_eye_data = csvread(child_eye_file);
end
if ~exist(parent_eye_file, 'file')
    fprintf('%d does not have parent_eye csv file\n', sub_id);
    parent_eye_data = [];
else
    parent_eye_data = csvread(parent_eye_file);
end

sub_info = get_subject_info(sub_id);

% this paragraph of code calculate the max allowed date for the eye file to
% be generated, which is 10 month after the subject folder is generated
time_sub_folder = sub_info(3);
time_eye_csv_list = nan(1,2);
year_sub_folder = floor(time_sub_folder/10000);
time_modified_date_allow = time_sub_folder + 1000; % allow 10 month
month_modified_date_allow = time_modified_date_allow - year_sub_folder*10000;
date_modified_date_allow = mod(month_modified_date_allow, 100);
month_modified_date_allow = floor(month_modified_date_allow/100);
if month_modified_date_allow > 12
    time_modified_date_allow = (year_sub_folder+1)*10000 + ...
        mod(month_modified_date_allow, 12)*100 + date_modified_date_allow;
end

fprintf('For %d, the subject folder is generated on %d\n', sub_id, time_sub_folder);
for csvidx = 1:length(csv_list)
    tmpdate = csv_list(csvidx).date;
    time_eye_csv = year(tmpdate)*10000+month(tmpdate)*100+day(tmpdate);
    fprintf('-- the %s is last modified on %d\n', csv_list(csvidx).name, time_eye_csv);
    is_modified_correct_date = time_eye_csv <= time_modified_date_allow;
    if ~is_modified_correct_date
        fprintf('The last modified date of child_eye csv file is quite recently\n');
        is_proceed = input('Do you still want to proceed? (y/n)\n', 's');
        if lower(is_proceed(1)) == 'n'
            error('Exit function requested by user.');
        end
    end
    time_eye_csv_list(csvidx) = time_eye_csv;
end

end

function year_int = year(date_string)
% date_string has to be in the format of '27-Oct-2011 17:34:37'
separator_idx = strfind(date_string, '-');
year_int = str2double(date_string(separator_idx(2)+1:separator_idx(2)+4));
end

function month_int = month(date_string)
% date_string has to be in the format of '27-Oct-2011 17:34:37'
separator_idx = strfind(date_string, '-');
month_str = date_string(separator_idx(1)+1:separator_idx(1)+3);
month_int = -1;

switch month_str
    case 'Jan'
        month_int = 1;
    case 'Feb'
        month_int = 2;
    case 'Mar'
        month_int = 3;
    case 'Apr'
        month_int = 4;
    case 'May'
        month_int = 5;
    case 'Jun'
        month_int = 6;
    case 'Jul'
        month_int = 7;
    case 'Aug'
        month_int = 8;
    case 'Sep'
        month_int = 9;
    case 'Oct'
        month_int = 10;
    case 'Nov'
        month_int = 11;
    case 'Dec'
        month_int = 12;
    otherwise
        error('Invalid month string %s', month_str);
end

end


function data_int = day(date_string)
separator_idx = strfind(date_string, '-');
% date_string has to be in the format of '27-Oct-2011 17:34:37'
data_int = str2double(date_string(1:separator_idx(1)-1));
end
