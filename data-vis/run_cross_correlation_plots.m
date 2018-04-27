function run_cross_correlation_plots(subexpIDs)
subs = cIDs(subexpIDs);
vis_savepath = get_dir_vis();

vars = {
    'cevent_speech_naming_local-id'
    'cstream_eye_roi_child'
    'cstream_eye_roi_parent'
    'cstream_motion-inhand_either-hand_active_child'
    'cstream_motion-inhand_either-hand_active_parent'
    'cstream_eye_roi_sustained-3s_child'
    'cstream_eye_joint-attend_both'
    };

nametags = {'naming', 'child_roi', 'parent_roi', 'child_active', 'parent_active', 'sus_roi_3s', 'joint-attend'};

combinations = nchoosek(1:numel(vars), 2);

for c = 1:size(combinations,1)
    try
        c1 = combinations(c,1);
        c2 = combinations(c,2);
        outputfolder = fullfile(vis_savepath, 'cross_correlation');
        outputfilename = [nametags{c1}, '_', nametags{c2}];
        draw_cross_correlation_plots(subs, vars{c1}, vars{c2}, [-10 10], outputfolder, outputfilename);
    catch ME
        continue;
    end
end