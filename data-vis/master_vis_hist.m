function master_vis_hist(subexpIDs, option)
% original version + error handling. Calls vis_hist_v2 (the modified one with error handling)
% added case 5, which generates the head to head distances histogram

vis_savepath = get_dir_vis();
directory = fullfile(vis_savepath, 'vis_hist');
flag_savefig = 1;

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
        for v = 1:numel(varnames)
            try
                varname = varnames{v};
                vis_hist_v2(subs, varname, edges, directory, varname, flag_savefig);
            catch ME
                disp(ME.message)
                disp('option: 1')
                continue
            end
        end
        
    case 2
        subs = unique(cIDs([subexpIDs, 12]));
        varnames = {
            'cont_motion_pos-speed_right-hand_child'
            'cont_motion_pos-speed_left-hand_child'
            'cont_motion_pos-speed_right-hand_parnet'
            'cont_motion_pos-speed_left-hand_parent'
            };
        edges = 0:50:500;
        for v = 1:numel(varnames)
            try
                varname = varnames{v};
                vis_hist_v2(subs, varname, edges, directory, varname, flag_savefig);
            catch ME
                disp(ME.message)
                disp('option: 2')
                continue
            end
        end
        
    case 3
        subs = unique(cIDs([subexpIDs, 12]));
        varnames = {
            'cont_motion_rot-speed_head_child'
            'cont_motion_rot-speed_head_parent'
            };
        edges = 0:25:255;
        for v = 1:numel(varnames)
            try
                varname = varnames{v};
                vis_hist_v2(subs, varname, edges, directory, varname, flag_savefig);
            catch ME
                disp(ME.message)
                disp('option: 3')
                continue
            end
        end
        
    case 4
        subs = unique(cIDs([subexpIDs, 12]));
        varnames = {
            'cont_vision_size_obj1_child'
            'cont_vision_size_obj1_parent'};
        edges = 0:1:10;
        for v = 1:numel(varnames)
            try
                varname = varnames{v};
                vis_hist_v2(subs, varname, edges, directory, varname, flag_savefig);
            catch ME
                disp(ME.message)
                disp('option: 4')
                continue
            end
        end
        
    case 5
        subs = cIDs(subexpIDs);
        varnames = {
            'cont_motion_dist_head-head_child-parent'};
        edges = 0:100:1500;
        for v = 1:numel(varnames)
            try
                varname = varnames{v};
                vis_hist_v2(subs, varname, edges, directory, varname, flag_savefig);
            catch ME
                disp(ME.message)
                disp('option: 5')
                continue
            end
        end
end
end