% This script will import the responsiveness macro coding for experiments.  The
% coding was done in an excel file called [Subj_ID]_Macro.xlsx which was
% then saved as tab delimited text files called general.txt and naming.txt
% located in the subjects speech_transcription_p folders. This will merely
% read in the text files and save them as cevents in the derived folder for
% each subject in the experiment.

% Experiment ID
exp_id = 17;

% Final Variable names:
final_var_name = 'cevent_macro_response_parent';


%Comment out one of the following:

    % To run all the subjects us this line:
    subjs = list_subjects(exp_id);
    % To run particular subjects, use this line:
%     subjs = [1402];  
        

for i = 1 : size(subjs,1)
    
    sid = subjs(i)   % Printing sid.    
    sid_dir = get_subject_dir(sid);
    
    % Load the text files.
    resp_coding = load(sprintf('%s/extra_p/responsiveness.csv', sid_dir));
    
    record_variable(sid, final_var_name, resp_coding); 
    
end;