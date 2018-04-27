function master_vis_hist(subexpIDs, option)

vis_savepath = get_dir_vis();
directory = fullfile(vis_savepath, 'vis_hist');

switch option
    case 1
        subs = cIDs(subexpIDs);
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
            vis_hist(subs, varname, edges, directory, varname, flag_savefig);
        end
        
    case 2
        subs = cIDs({subexpIDs, 12});
        varnames = {
            'cont_motion_pos-speed_right-hand_child'
            'cont_motion_pos-speed_left-hand_child'
            'cont_motion_pos-speed_right-hand_parnet'
            'cont_motion_pos-speed_left-hand_parent'};
        edges = 0:50:500;
        flag_savefig = 1;
        for v = 1:numel(varnames)
            varname = varnames{v};
            vis_hist(subs, varname, edges, directory, varname, flag_savefig);
        end
        
        
    case 3
        subs = cIDs({subexpIDs, 12});
        varnames = {
            'cont_motion_rot-speed_head_child'
            'cont_motion_rot-speed_head_parent'
            };
        edges = 0:25:255;
        flag_savefig = 1;
        for v = 1:numel(varnames)
            varname = varnames{v};
            vis_hist(subs, varname, edges, directory, varname, flag_savefig);
        end
        
    case 4
        subs = cIDs({subexpIDs, 12});
        varnames = {
            'cont_vision_size_obj1_child'
            'cont_vision_size_obj1_parent'};
        edges = 0:1:10;
        flag_savefig = 1;
        for v = 1:numel(varnames)
            varname = varnames{v};
            vis_hist(subs, varname, edges, directory, varname, flag_savefig);
        end
        
end