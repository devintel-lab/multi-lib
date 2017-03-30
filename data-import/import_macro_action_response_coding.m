% This script will import the baby action/parent response macro coding for 
% experiments.  The coding was recorded in ELAN and copied to excel files 
% called child_activity, parent_response, which were then saved as a tab 
% delimited text files called child_activity and parent_response located 
% in the subjects extra_p folders.  The value number in child _activity 
% corresponds with the type of action displayed (bid=1, exploration=2, 
% vocalization=3, play=4, distracted=5. The value number in parent_response 
% corresponds with the type of parent response (affirmation=1, imitation=2,
% description=3, question=4, play prompt=5, exploratory prompt=6, 
% regaining attention=7, attend to needs=8, negative=9). This will merely 
% read in the text files and save them as cevents in the derived folder
% for each subject in the experiment.


%Comment out one of the following:

% To run all the subjects us this line:
% Experiment ID
% exp_id = 17;
% subjs = list_subjects(exp_id);

% To run particular subjects, use this line:
subjs = list_subjects(34);
subjs = [3413 3417];

% File names:
child_file_name = ['child_activity'];
parent_file_name = ['parent_response'];

for i = 1 : numel(subjs)
    
    sid = subjs(i)   % Printing sid.    
    sid_dir = get_subject_dir(sid);
    
    try    
    % Load the text files.
    child_data = load(sprintf('%s/extra_p/%s.txt', sid_dir, child_file_name));
    parent_data = load(sprintf('%s/extra_p/%s.txt', sid_dir, parent_file_name));
    catch ME
        disp(ME);
        disp(subjs(i));
        continue;
    end
    % Add 30 seconds to times
    child_data(:,1:2) = child_data(:,1:2) + 30;
    parent_data(:,1:2) = parent_data(:,1:2) + 30;
    
    timing = get_timing(sid);
    tt = timing.trials;
    bt = tt(1);
    et = tt(end);
    cr = timing.camRate;
    

    % Save the parent actions as a cevent and cstream
%     record_variable(sid, 'cevent_macro_action-response_parent', parent_data); 
    record_variable(sid, 'cevent_macro_action-response_all_parent', parent_data); 
    
    % We no longer want the cstream version of the parent action-response_all.
%     cstr_parent_data = cevent2cstream_v2(parent_data, 1/cr, [bt et]);
%     record_variable(sid, 'cstream_macro_action-response_parent', cstr_parent_data);  
%     record_variable(sid, 'cstream_macro_action-response_all_parent', cstr_parent_data); 
     
    % Save the child actions as a cevent and cstream, as well as 3 cstreams
    % breaking the overlapping cevent into Bids, Vocalizations, and Task
    % Engagement
%     record_variable(sid, 'cevent_macro_action-response_child', child_data); 
    record_variable(sid, 'cevent_macro_action-response_all_child', child_data); 
    
%     cstr_child_data = cevent2cstream_v2(child_data, 1/cr, [bt et]);
%     record_variable(sid, 'cstream_macro_action-response_child', cstr_child_data);  
%     record_variable(sid, 'cstream_macro_action-response_all_child', cstr_child_data); 
    
    % Create Bid subset
    bids = cevent_category_equals( child_data, [1] );
    cstr_bids_data = cevent2cstream_v2(bids, 1/cr, [bt et]);
%     record_variable(sid, 'cstream_macro_action-response_child(bids)', cstr_bids_data);  
    record_variable(sid, 'cstream_macro_action-response_bids_child', cstr_bids_data);  
    
    % Create Vocalization subset
    vocalizations = cevent_category_equals( child_data, [3] );
    cstr_vocalizations_data = cevent2cstream_v2(vocalizations, 1/cr, [bt et]);
%     record_variable(sid, 'cstream_macro_action-response_child(vocalizations)', cstr_vocalizations_data); 
    record_variable(sid, 'cstream_macro_action-response_vocal_child', cstr_vocalizations_data); 
    
    % Create Toy Manipulations subset
    task_engagement = cevent_category_equals( child_data, [2 4 5] );
    cstr_task_engagement_data = cevent2cstream_v2(task_engagement, 1/cr, [bt et]);
%     record_variable(sid, 'cstream_macro_action-response_child(task_engagement)', cstr_task_engagement_data); 
    record_variable(sid, 'cstream_macro_action-response_state_child', cstr_task_engagement_data);
    
end;