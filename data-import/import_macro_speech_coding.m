% This script will import the speech type macro coding for experiments.  The
% coding was done in an excel file called [Subj_ID]_Macro.xlsx which was
% then saved as tab delimited text files called general.txt and naming.txt
% located in the subjects speech_transcription_p folders. This will merely
% read in the text files and save them as cevents in the derived folder for
% each subject in the experiment.

% Experiment ID
exp_id = 14;

% Final Variable names:
% general_var_name = 'cevent_speech_speech-type_parent';
naming_var_name = 'cevent_speech_naming-type_parent';


%Comment out one of the following:

    % To run all the subjects us this line:
    subjs = list_subjects(exp_id);
    % To run particular subjects, use this line:
%     subjs = [3218:3219]';
subjs = [3503 3509 3510 3513 3514 3516 3517 3414];
subjs = 1412;
    


for i = 1 : numel(subjs);
    
    sid = subjs(i)   % Printing sid.    
    sid_dir = get_subject_dir(sid);
    
    % Load the text files.
%     general_data = load(sprintf('%s/speech_transcription_p/general.txt', sid_dir));
    naming_data = load(sprintf('%s/speech_transcription_p/naming.txt', sid_dir));
    
    % Find the speech sync and update the timing from the coding.
    times = get_trial_times(sid); 
    offset = get_timing(sid); 
    
%     general_data(:,1:2) = general_data(:,1:2) + offset.speechTime; 
    naming_data(:,1:2) = naming_data(:,1:2) + offset.speechTime; 
    
    size(naming_data)   % Check Size before filtering
    
    % Load the data that is within the trial times as a new variable and
    % save it.
%     new_general_data = cevent_in_event(general_data, times);
    new_naming_data = cevent_in_event(naming_data, times);
    
%     size(new_general_data)   % Check size after filtering to just the trial times.
    
%     record_variable(sid, general_var_name, new_general_data); 
    record_variable(sid, naming_var_name, new_naming_data); 
    
end;