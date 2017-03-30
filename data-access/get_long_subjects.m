% [charlene, Aug 2014] 
% GET_LONG_SUBJECTS returns a list of multiLONG subjects that have data in that particular modality. 

% USAGE: 
%   get_long_subjects(DATA_TYPE, EXP_ID)

% INPUT: 
%   data_type (case insensitive): 
%       'Multi', 'MultiSleep', 'MCDI', 'Motor', 'Word', 'WordSleep', 'Book', 'SES', 'CBQ'. 
%   experiment (optional): 
%       70 (9 months), 71 (12 months), 72 (15 months), 73 (18 months), 74 (21 months), 75 (24 months)... 
%       Default return, if experiment input is not entered, is for all experiments. 

% Examples: 
%   get_long_subjects('multi') returns all multilong subjects that have 'multi' data
%   get_long_subjects('multi', 70) returns all multilong subjects in experiment 70 that have 'multi' data. 
%   get_long_subjects('multi', [70 71]) returns all multilong subjects in experiment 70 and 71 that have 'multi' data. 
%   get_long_subjects({'multi', 'word', 'mcdi'}) returns all multilong
%   subjects that have data in all three modalities. 

function out = get_long_subjects(data_type, experiment) 

% change directory, look for relevant csv file, and read in the data.
csv = fullfile(get_multidir_root, '\multilong_docs\multilong_master_subject_table.csv');
SubTableData = dlmread(csv, ',', 1, 0);

% match the file's column names to the input. find all the rows where there 
% is available data for that subject for that particular data type, 
% then lget the global and subject ids that correspond with each of them.
headers = get_csv_headers(csv);
findcolumns = ismember(lower(headers), lower(data_type));
columnNums = find(findcolumns(1,:) == 1); 
want = SubTableData(:,columnNums);
has_modality = all(want,2);
rows = find(has_modality == 1);
sublist = SubTableData(rows, [2,3]);

% default to subjects in all multiLONG experiments if no exp input is given
if ~exist('experiment', 'var') || isempty(experiment)
    experiment = [70 71 72 73 74 75]; % add additional experiments when applicable
end 

% otherwise, filter results based on experiment number entered.
log = ismember(sublist(:,1), experiment);
sublist = sublist(log, :);

% sublist is now in two columns - experiment id & global id. append them together. 
for i = 1:length(sublist)
    expid = sublist(i,1);
    longid = sublist(i,2);
    id = sprintf('%d%02d', expid, longid);
    id = str2num(id);
    out(i,1) = id;
end

