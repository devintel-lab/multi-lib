function master_vis_hist(option)

directory = fullfile(get_multidir_root, 'data_vis', 'vis_hist');

switch option
    case 1
        subexpIDs = cIDs('all');
        varnames = {
            'cevent_eye_roi_child'
            'cevent_eye_roi_parent'
            'cevent_eye_joint-attend_both'
            'cevent_eye_roi_sustained-1s_child'
            'cevent_eye_roi_sustained-3s_child'
            'cevent_inhand_child'
            'cevent_inhand_parent'
            'cevent_vision_size_obj-dominant_child'
            'cevent_vision_size_obj-dominant_parent'
            };
        
        edges = 0:.25:10;
        flag_savefig = 1;
        for v = 1:numel(varnames)
            varname = varnames{v};
            vis_hist(subexpIDs, varname, edges, directory, varname, flag_savefig);
        end
        
    case 2
        subexpIDs = cIDs('all');
        varnames = {
            'cont_motion_pos-speed_right-hand_child'
            'cont_motion_pos-speed_left-hand_child'
            'cont_motion_pos-speed_right-hand_parnet'
            'cont_motion_pos-speed_left-hand_parent'};
        edges = 0:50:500;
        flag_savefig = 1;
        for v = 1:numel(varnames)
            varname = varnames{v};
            vis_hist(subexpIDs, varname, edges, directory, varname, flag_savefig);
        end
        
    case 3
        subexpIDs = cIDs('all');
        varnames = {
            'cont_motion_rot-speed_head_child'
            'cont_motion_rot-speed_head_parent'
            };
        edges = 0:25:255;
        flag_savefig = 1;
        for v = 1:numel(varnames)
            varname = varnames{v};
            vis_hist(subexpIDs, varname, edges, directory, varname, flag_savefig);
        end
        
    case 4
        subexpIDs = cIDs('all');
        varnames = {
            'cont_vision_size_obj1_child'
            'cont_vision_size_obj1_parent'};
        edges = 0:1:10;
        flag_savefig = 1;
        for v = 1:numel(varnames)
            varname = varnames{v};
            vis_hist(subexpIDs, varname, edges, directory, varname, flag_savefig);
        end
end