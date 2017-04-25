function master_data_vis2(subexpIDs, option, args)
subs = cIDs(subexpIDs);
switch option
    
    case 1
        for s = 1:numel(subs)
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
            stream_labels = {'child 1-size', 'child 2-size', 'child 3-size', 'child eye', ...
                'parent eye', 'parent 1-size', 'parent 2-size', 'parent 3-size', 'naming'};
            vis_streams_multiwork(subs(s), var_list, stream_labels, fullfile(get_multidir_root(), 'data_vis', 'cont_1'));
        end
    case 2
        for s = 1:numel(subs)
            colors = set_colors();
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
            stream_labels = {'child left pos', 'child right pos', 'child head pos', ...
                'parent head pos', 'parent left pos', 'parent right pos',...
                'child head rot', 'parent head rot'};
            vis_streams_multiwork(subs(s), var_list, stream_labels, fullfile(get_multidir_root(), 'data_vis', 'cont_2'));
        end
        
    case 3
        
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
        vis_streams_multiwork(subs, var_list, stream_labels, fullfile(get_multidir_root(), 'data_vis', 'cstream_1'));
        
        
    case 4
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
        
        vis_streams_multiwork(subs, var_list, stream_labels, fullfile(get_multidir_root(), 'data_vis', 'cstream_2'));
    case 5
        for s = 1:numel(subs)
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
            stream_labels = {'child eye', 'parent eye', 'sust JA', ...
                'child L-hand', 'child R-hand', 'parent L-hand', 'parent R-hand', ...
                'child size1', 'child size2', 'child size3', 'naming'};
            vis_streams_multiwork(subs(s), var_list, stream_labels, fullfile(get_multidir_root(), 'data_vis', 'cstream_cont_1'));
        end
end
end