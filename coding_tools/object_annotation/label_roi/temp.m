% INHAND_DATA = INHAND_DATA

% is_coded = [INHAND_DATA(:).is_coded] == 1;
% index = 1:length(find(is_coded));
% time = (index-1) * 1/30 + 30;
% inhand = [INHAND_DATA(is_coded).INHAND];
% cstream = [time' inhand'];



% function subject_id = get_subject_id_from_folder(folder)
folder = '__20151021_17157';
tempy = strsplit(folder, '_');
s_date = str2num(tempy{2});
s_id = str2num(tempy{3});
table = read_subject_table();
s_r = find(table(:,3) == s_date & table(:,4) == s_id);
if isempty(s_r)
	error('Cannot find subject id in subject table');
else
	subject_id = table(s_r, 1)
end