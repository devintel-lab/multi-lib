function master_data_vis(subexpIDs, option)

vis_savepath = get_dir_vis();

switch option
    case 1
        subs = cIDs({subexpIDs, [12]});
        for s = 1:numel(subs)
            try
                var_list = {
                    cont2scaled(subs(s), 'cont_vision_size_obj1_child', 5, 10, 50, [1 1 1], [0 0 1]);
                    cont2scaled(subs(s), 'cont_vision_size_obj2_child', 5, 10, 50, [1 1 1], [0 1 0]);
                    cont2scaled(subs(s), 'cont_vision_size_obj3_child', 5, 10, 50, [1 1 1], [1 0 0]);
                    'cevent_eye_roi_child';
                    'cevent_eye_roi_parent';
                    cont2scaled(subs(s), 'cont_vision_size_obj1_parent', 5, 10, 50, [1 1 1], [0 0 1]);
                    cont2scaled(subs(s), 'cont_vision_size_obj2_parent', 5, 10, 50, [1 1 1], [0 1 0]);
                    cont2scaled(subs(s), 'cont_vision_size_obj3_parent', 5, 10, 50, [1 1 1], [1 0 0]);
                    'cevent_speech_naming_local-id';
                    };
                
                stream_labels = {'child size 1', 'child size 2', 'child size 3', 'ceye', 'peye', 'parent size 1', 'parent size 2', 'parent size 3', 'speech'};
                vis_streams_multiwork(subs(s), var_list, stream_labels, fullfile(vis_savepath, 'cont_1'));
            catch ME
                format_error_message(ME, sprintf('%d', subs(s)));
                continue
            end
        end
        
    case 2
        subs = cIDs({subexpIDs, 12});
        stream_labels = {'child left pos', 'child right pos', 'child head pos', ...
            'parent head pos', 'parent left pos', 'parent right pos',...
            'child head rot', 'parent head rot'};
        colors = set_colors();
        for s = 1:numel(subs)
            try
                var_list = {
                    cont2scaled(subs(s), 'cont_motion_pos-speed_left-hand_child', 5, 150, 50, [1 1 1], colors(1,:));
                    cont2scaled(subs(s), 'cont_motion_pos-speed_right-hand_child', 5, 150, 50, [1 1 1], colors(2,:));
                    cont2scaled(subs(s), 'cont_motion_pos-speed_head_child', 5, 150, 50, [1 1 1], colors(3,:));
                    cont2scaled(subs(s), 'cont_motion_pos-speed_head_parent', 5, 150, 50, [1 1 1], colors(4,:));
                    cont2scaled(subs(s), 'cont_motion_pos-speed_left-hand_parent', 5, 150, 50, [1 1 1], colors(5,:));
                    cont2scaled(subs(s), 'cont_motion_pos-speed_right-hand_parent', 5, 150, 50, [1 1 1], colors(6,:));
                    cont2scaled(subs(s), 'cont_motion_rot-speed_head_child', 5, 150, 50, [1 1 1], colors(7,:));
                    cont2scaled(subs(s), 'cont_motion_rot-speed_head_parent', 5, 150, 50, [1 1 1], colors(8,:));
                    };
                vis_streams_multiwork(subs(s), var_list, stream_labels, fullfile(vis_savepath, 'cont_2'));
            catch ME
                format_error_message(ME, sprintf('%d', subs(s)));
                continue
            end
        end
        
        
    case 3
        subs = cIDs(subexpIDs);
        var_list = {
            'cevent_eye_roi_child';
            'cevent_eye_roi_parent';
            'cstream_inhand_left-hand_obj-all_child';
            'cstream_inhand_right-hand_obj-all_child';
            'cstream_inhand_left-hand_obj-all_parent';
            'cstream_inhand_right-hand_obj-all_parent';
            'cevent_eye_joint-attend_both';
            'cevent_eye_synched-attend_both';
            'cevent_vision_size_obj-dominant_child';
            'cevent_speech_utterance';
            };
        stream_labels = {'child eye', 'parent eye', 'child left', 'child right', ...
            'parent left', 'parent right', 'joint-attend', 'joint-synched', 'child dominant', 'naming'};
        vis_streams_multiwork(subs, var_list, stream_labels, fullfile(vis_savepath, 'cstream_1'));
        
        
    case 4
        subs = cIDs(subexpIDs);
        var_list = {
            'cevent_inhand-eye_child-child'
            'cevent_inhand-eye_parent-child'
            'cevent_inhand-eye_parent-parent'
            'cevent_inhand-eye_child-parent'
            'cevent_eye_joint-attend_both'
            'cevent_eye_synched-attend_both'
            'cevent_speech_utterance'
            };
        stream_labels = {'child-eye/child-hand', 'child-eye/parent-hand', ...
            'parent-eye/parent-hand', 'parent-eye/child-inhand', 'joint-attend',...
            'synched-attend', 'naming'};
        
        vis_streams_multiwork(subs, var_list, stream_labels, fullfile(vis_savepath, 'cstream_2'));
        
        
    case 5
        subs = cIDs(subexpIDs, 12);
        stream_labels = {'child eye', 'parent eye', 'sust JA', ...
            'child L-hand', 'child R-hand', 'parent L-hand', 'parent R-hand', ...
            'child size1', 'child size2', 'child size3', 'naming'};
        for s = 1:numel(subs)
            try
                var_list = {
                    'cevent_eye_roi_child';
                    'cevent_eye_roi_parent';
                    'cevent_eye_joint-attend_both';
                    'cstream_inhand_left-hand_obj-all_child';
                    'cstream_inhand_right-hand_obj-all_child';
                    'cstream_inhand_left-hand_obj-all_parent';
                    'cstream_inhand_right-hand_obj-all_parent';
                    cont2scaled(subs(s), 'cont_vision_size_obj1_child', 5, 10, 50, [1 1 1], [0 0 1]);
                    cont2scaled(subs(s), 'cont_vision_size_obj2_child', 5, 10, 50, [1 1 1], [0 1 0]);
                    cont2scaled(subs(s), 'cont_vision_size_obj3_child', 5, 10, 50, [1 1 1], [1 0 0]);
                    'cevent_speech_utterance';
                    };
                
                vis_streams_multiwork(subs(s), var_list, stream_labels, fullfile(vis_savepath, 'cstream_cont_1'));
            catch ME
                format_error_message(ME, sprintf('%d', subs(s)));
                continue
            end
        end
        
    case 6
        subs = cIDs(subexpIDs);
        var_list = {
            'cstream_inhand_left-hand_obj-all_child'
            'cstream_inhand_left-hand_obj-all_child'
            'cevent_eye_roi_child'
            'cevent_eye_joint-attend_child-lead_both'
            'cevent_eye_joint-attend_both'
            'cevent_eye_roi_parent'
            'cstream_inhand_left-hand_obj-all_parent'
            'cstream_inhand_right-hand_obj-all_parent'
            };
        stream_labels = {'chandleft', 'chandright', 'ceye', 'JA_c_lead', 'JA', 'peye', 'phandleft', 'phandright'};
        
        vis_streams_multiwork(subs, var_list, stream_labels, fullfile(vis_savepath, 'cstream_3'));
        
    case 7
        subs = cIDs(subexpIDs);
        var_list = {
            'cstream_inhand_left-hand_obj-all_child'
            'cstream_inhand_left-hand_obj-all_child'
            'cevent_eye_roi_child'
            'cevent_eye_joint-attend_parent-lead_both'
            'cevent_eye_joint-attend_both'
            'cevent_eye_roi_parent'
            'cstream_inhand_left-hand_obj-all_parent'
            'cstream_inhand_right-hand_obj-all_parent'
            };
        stream_labels = {'chandleft', 'chandright', 'ceye', 'JA_p_lead', 'JA', 'peye', 'phandleft', 'phandright'};
        
        vis_streams_multiwork(subs, var_list, stream_labels, fullfile(vis_savepath, 'cstream_4'));
end