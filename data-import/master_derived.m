function exceptions = master_derived(IDs, modules)
%IDs are an array of IDs
%modules can be:
% all - includes trial, inhand, roi, xy, motion, misc
% trial
% inhand
% roi
% xy
% motion
% misc
% vis - must be ran separately
% vision - must be ran separately
% speech - must be ran separately
% learned - must be ran separately

subs = cIDs(IDs);

if ~exist('modules', 'var') || isempty(modules)
    modules = 'all';
else
    if ~iscell(modules)
        modules = strsplit(modules);
    end
end

vis_list = [1 3 4 5];
exceptions = {};
e = 1;
for s = 1:numel(subs)
    joint_pass = 1; %if stays 1, will run joint_eye_inhand script
    
    obj_list = [1:get_num_obj(subs(s))];
    
    %% trial
    if sum(ismember(modules, {'trial', 'all'})) > 0
        fprintf('\nProcessing trial for %d\n', subs(s));
        try
        read_trial_info(subs(s));
        make_trials_vars(subs(s));
        catch ME
            exceptions(e,1:3) = {subs(s) ME.stack(2,1).name ME.message};
            e = e + 1;
        end
    end
    
    
    %% inhand
    if sum(ismember(modules, {'inhand', 'all'})) > 0
        fprintf('\nProcessing inhand for %d\n', subs(s));
        pause(1);
        try
            main_make_inhand(subs(s), obj_list);
            make_joint_inhand_both(subs(s));
            make_both_inhand(subs(s));
            make_inhand_number_of_objects(subs(s), obj_list);
            make_inhand_joint_state(subs(s));
            make_inhand_joint_state_holding(subs(s));
        catch ME
            exceptions(e,1:3) = {subs(s) ME.stack(2,1).name ME.message};
            e = e + 1;
            joint_pass = 0;
        end
    end
    
    %% eye roi
    if sum(ismember(modules, {'roi', 'all'})) > 0
        fprintf('\nProcessing roi for %d\n', subs(s));
        pause(1);
        try
            make_eye_roi(subs(s), obj_list);
            master_make_sustained(subs(s), [7,8]);
            make_synched_attention(subs(s));
            make_eye_joint_state(subs(s), obj_list);
            make_joint_attention(subs(s)); % calls get_variable_by_trial
        catch ME
            joint_pass = 0;
            exceptions(e,1:3) = {subs(s) ME.stack(2,1).name ME.message};
            e = e + 1;
        end
    end
    
    %% inhand_roi
    if sum(ismember(modules, {'inhand', 'roi', 'all'})) > 0
        fprintf('\nProcessing inhand_roi for %d\n', subs(s));
        pause(1);
        if joint_pass
            make_joint_eye_inhand(subs(s), [1 2]);
            master_make_sustained(subs(s), [3,4]);
        end
    end
    
    %% motion
    if sum(ismember(modules, {'motion', 'all'})) > 0
        fprintf('\nProcessing motion for %d\n', subs(s));
        pause(1);
        run_motion_all(subs(s));
    end
    
    %% inhand_motion
    if sum(ismember(modules, {'motion', 'inhand', 'all'})) > 0
        fprintf('\nProcessing motion and inhand for %d\n', subs(s));
        pause(1);
%         make_inhand_activity(subs(s));
    end
    
    %% xy
    if sum(ismember(modules, {'xy', 'all'})) > 0
        fprintf('\nProcessing xy for %d\n', subs(s));
        pause(1);
        make_eye_xy(subs(s), [1 2]);
        make_gaze_to_center(subs(s), [1 2]);
    end
    
    %% vision
    if sum(ismember(modules, {'vision'})) > 0
        fprintf('\nProcessing vision for %d\n', subs(s));
        pause(1);
        try
            findAndReplaceBlueFrames(subs(s));
            make_vision_variables(subs(s), obj_list);
            create_dom_vars(subs(s), [2/3 1/2], [3 5], obj_list); %2/3 is for 2x-, 3 is big and 5 is dominant
            master_make_sustained(subs(s), [1,2,5,6]);
            make_vision_inhand_big_held(subs(s), 'big', obj_list);
            make_vision_inhand_big_held(subs(s), 'dominant', obj_list);
            make_vision_joint_obj_size_dist(subs(s));
%             create_dom_object_position(subs(s));
%             make_select_one_from_many(subs(s), [1 2]);
        catch ME
            exceptions(e,1:3) = {subs(s) ME.stack(2,1).name ME.message};
            e = e + 1;
        end
    end
    
    %% vision_inhand
    if sum(ismember(modules, {'vision', 'inhand', 'all'})) > 0
        try
            make_vision_inhand_big_held(subs(s), 'big', obj_list);
            make_vision_inhand_big_held(subs(s), 'dominant', obj_list);
        catch ME
            exceptions(e,1:3) = {subs(s) ME.stack(2,1).name ME.message};
            e = e + 1;
        end
    end

    %% speech
    if sum(ismember(modules, {'speech'})) > 0
        fprintf('\nProcessing speech for %d\n', subs(s));
        pause(1);
        make_naming_local_id(subs(s));
        make_speech_utterance(subs(s)); 
    %     import_macro_speech_coding;
    %     make_cevent_naming_score;
    end
    
    %% misc
    if sum(ismember(modules, {'misc', 'all'})) > 0
        fprintf('\nProcessing misc for %d\n', subs(s));
        pause(1);
        make_audio_mat(subs(s));
    end
    
    %% vis
    if sum(ismember(modules, {'vis'})) > 0
        fprintf('\nProcessing vis for %d\n', subs(s));
        pause(1);
        master_data_vis(subs(s), vis_list);
    end
    
    %% learned
    if sum(ismember(modules, {'learned'})) > 0
        fprintf('\nProcessing learned for %d\n', subs(s));
        pause(1);
        generate_learning_score_variables(sub2exp(subs(s)), subs(s));
    end
    
end
if isempty(exceptions)
    exceptions = 'No exceptions';
end
end