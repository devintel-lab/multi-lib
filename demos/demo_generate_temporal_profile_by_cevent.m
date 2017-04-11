clear all;

DEMO_ID = 3;

% The function will only generate data for subjects that have all the
% variables, and inform the user about the missing ones.
sub_list = list_subjects(70);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% demo case 1: get temporal profile of mean size of target vs non-target
%%% objects in the child's view, from 5 seconds before to 5 seconds after the
%%% onsets of parent's naming cevents.
if DEMO_ID == 1
    profile_input.sub_list = sub_list;
    profile_input.cevent_name = 'cevent_speech_naming_local-id';
    profile_input.whence = 'start';
    profile_input.interval = [-5 5];
    profile_input.sample_rate = 0.03334;

    profile_input.var_name = {'cont_vision_size_obj1_child', ...
        'cont_vision_size_obj2_child', 'cont_vision_size_obj3_child'};
    profile_input.var_category = [1 2 3];
    profile_input.cevent_category = [1 2 3];
    
    % Each row corresponding to each cont variable
    % Each column corresponding to one cevent value
    profile_input.groupid_matrix = ...
        [1 2 2;
         2 1 2;
         2 2 1];

    profile_data = temporal_profile_generate_by_cevent(profile_input);
    % The output will contain these fields:
    %     profile_data = 
    %              sub_list: [147x1 double]
    %              exp_list: [147x1 double]
    %               cevents: [147x3 double]
    %        cevent_trialid: [147x1 double]
    %     cevent_instanceid: [147x1 double]
    %     probs_mean_per_instance: [147x2 double]
    %         groupid_label: {'target'  'non-target'}
    %      profile_data_mat: {[147x300 double]  [147x300 double]}
    %           sample_rate: 0.0333
    %             time_base: [1x300 double]
    %           cevent_name: 'cevent_speech_naming_local-id'
    %              var_name: {1x3 cell}
    
    % Then the result can be plotted and saved
    temporal_profile_save_csv_plot(profile_data, '.')
    % temporal_profile_save_csv_plot(profile_data, save_dir)
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% demo case 2: get temporal probability profile of child looking at target vs non-target
%%% object named by the parent, from 5 seconds before to 5 seconds after of
%%% the onsets of parent's naming cevents.
elseif DEMO_ID == 2
    profile_input.sub_list = sub_list;
    profile_input.cevent_name = 'cevent_speech_naming_local-id';
    profile_input.whence = 'start';
    profile_input.interval = [-5 5];
    profile_input.sample_rate = 0.03334;

    profile_input.var_name = 'cstream_eye_roi_child';
    profile_input.var_category = [1 2 3 4];
    profile_input.cevent_category = [1 2 3];
    
    % Each row corresponding to a cstream value
    % Each column corresponding to a cevent value
    profile_input.groupid_matrix = ...
        [1 2 2;
         2 1 2;
         2 2 1;
         3 3 3];
    profile_input.groupid_label = {'target', 'non-target', 'face'};
   
    profile_data = temporal_profile_generate_by_cevent(profile_input);
    temporal_profile_save_csv_plot(profile_data, '.');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% demo case 3: get temporal probability profile of child holding target vs non-target
%%% object named by the parent, from 5 seconds before to 5 seconds after of
%%% the onsets of parent's naming cevents.
elseif DEMO_ID == 3
    profile_input.sub_list = sub_list;
    profile_input.cevent_name = 'cevent_speech_naming_local-id';
    profile_input.whence = 'start';
    profile_input.interval = [-5 5];
    profile_input.sample_rate = 0.03334;

    profile_input.var_category = [1 2 3];
    profile_input.cevent_category = [1 2 3];
    
    % Each row corresponding to a cstream value
    % Each column corresponding to a cevent value
    profile_input.groupid_matrix = ...
        [1 2 2;
         2 1 2;
         2 2 1];

    profile_input.var_name = 'cstream_inhand_left-hand_obj-all_child';
    profile_lefthand = temporal_profile_generate_by_cevent(profile_input);
    
    profile_input.var_name = 'cstream_inhand_right-hand_obj-all_child';
    profile_righthand = temporal_profile_generate_by_cevent(profile_input);
    
    % To get the probability of either the left or the right hand is
    % holding the object, function provides user the option to combine two
    % profile data using logical operators "or" "and"
    profile_data = temporal_profile_logical_operation(profile_lefthand, profile_righthand, 'or');
    temporal_profile_save_csv_plot(profile_data, '.');
end