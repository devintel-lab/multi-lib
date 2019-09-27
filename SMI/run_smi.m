function run_smi(subIDs)
% this function makes use of the master_smi
% you can enter a list of subject IDs or the experiment number
% the program will generate data files for each subject using the "all" flag
sub_list = list_subjects()
exp_list = list_experiments()
if numel(subIDs)==1 & ismember(subIDs, exp_list)
    subjects = list_subjects(subIDs)
    for i=subjects
        master_smi(i, 'all')
    end
elseif isa(subIDs, 'double') & numel(subIDs)>=1
    for i=subIDs
        master_smi(i, 'all')
    end
else
    disp([-] The input data should be an experimentID, a subjectID or a list of subjectIDs)
end
disp('Warning: This function will be depricated in the future')
end
