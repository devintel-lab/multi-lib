function run_correlation_plots(subexpIDs, option)

subs = cIDs(subexpIDs);

directory = fullfile(get_multidir_root, 'data_vis_new', 'correlation');
cevmeasures = {'prop', 'mean_dur', 'freq'};
contmeasures = {'mean'};

switch option
    case 1
        yargs = [];
        yvars = {
            'cevent_eye_joint-attend_both'
            'cevent_eye_joint-attend_child-lead_both'
            'cevent_eye_joint-attend_parent-lead_both'
            'cevent_eye_joint-attend_parent-lead-moment_both'
            'cevent_eye_joint-attend_child-lead-moment_both'
            'cevent_eye_synched-attend_both'
            'cevent_eye_roi_child'
            'cevent_eye_roi_parent'
            'cevent_eye_roi_sustained-3s_child'
            'cevent_speech_naming_local-id'
            'cevent_inhand_both-hand_child'
            'cevent_inhand_child'
            'cevent_inhand-eye_parent-child'
            'cevent_inhand-eye_child-parent'
            'cevent_inhand-eye_child-child'
            'cevent_inhand-eye_parent-parent'
            'cstream_inhand_left-hand_obj-all_child'
            'cstream_inhand_right-hand_obj-all_child'
            'cstream_inhand_left-hand_obj-all_parent'
            'cstream_inhand_right-hand_obj-all_parent'
            'cevent_vision_size_obj-dominant_child'
            'cevent_vision_size_obj-dominant_parent'
            'cevent_vision_size_obj-big_child'
            'cevent_vision_size_obj-big_parent'
            'cevent_vision_size_obj-dominant-sustained-1s_child'
            'cevent_inhand-eye_sustained-1s_child-child'
            'cevent_inhand-eye_sustained-1s_child-parent'
            'cevent_inhand-eye_sustained-1s_parent-child'
            'cevent_inhand-eye_sustained-1s_parent-parent'
            'cevent_vision_size_obj-big_sustained-1s_child'
            'cevent_vision_size_obj-dominant_sustained-1s_child'
            'cevent_inhand-eye_sustained-3s_child-child'
            'cevent_inhand-eye_sustained-3s_child-parent'
            'cevent_inhand-eye_sustained-3s_parent-child'
            'cevent_inhand-eye_sustained-3s_parent-parent'
            'cevent_vision_size_obj-big_sustained-3s_child'
            'cevent_vision_size_obj-dominant_sustained-3s_child'
            'cevent_motion-inhand_either-hand_active_child'
            'cevent_motion-inhand_either-hand_active-parent'
            };
        for y = 1:numel(yvars)
            draw_correlation_plots(subs, yvars{y}, cevmeasures, directory, yvars{y}, yargs);
        end
        
        
    case 2
        yargs = [];
        yvars = {
            'cont_motion_pos-speed_head_child'
            'cont_motion_pos-speed_head_parent'
            'cont_vision_size_obj#_child'
            'cont_vision_size_obj#_parent'
            'cont_vision_min-dist_center-to-obj#_child'
            'cont_vision_min-dist_center-to-obj#_parent'
            'cont_eye-vision_min-dist_gaze-to-obj#_child'
            'cont_eye-vision_min-dist_gaze-to-obj#_parent'
            'cont_vision_mean-dist_center-to-obj#_child'
            'cont_vision_mean-dist_center-to-obj#_parent'
            'cont_eye-vision_mean-dist_gaze-to-obj#_child'
            'cont_eye-vision_mean-dist_gaze-to-obj#_parent'
            };
        for y = 1:numel(yvars)
            draw_correlation_plots(subs, yvars{y}, contmeasures, directory, yvars{y}, yargs);
        end
        
        
    case 3
        yargs = [];
        yvars = {
            'cevent_eye_roi_child'
            'cevent_eye_roi_parent'
            'cevent_eye_joint-attend_both'
            'cevent_eye_synched-attend_both'
            };
        nametags = {
            'cevent_eye_roi_child_face'
            'cevent_eye_roi_parent_face'
            'cevent_eye_joint-attend_both_mutual_gaze'
            'cevent_eye_synched-attend_both_mutual_gaze'
            };
        
        for y = 1:numel(yvars)
            yargs.categories = 4;
            draw_correlation_plots({subs, 12}, yvars{y}, cevmeasures, directory, nametags{y}, yargs);
            yargs.categories = 25;
            draw_correlation_plots(12, yvars{y}, cevmeasures, directory, [nametags{y} '_toyroom'], yargs);
        end
        
end