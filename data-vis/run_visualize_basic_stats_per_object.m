function run_visualize_basic_stats_per_object(subexpIDs)
% original scripts + error handling around each subject's visualization
vars = {
    'cevent_eye_roi_child'
    'cevent_eye_roi_parent'
    'cevent_inhand_child'
    'cevent_inhand_parent'
    'cevent_eye_joint-attend_both'
    'cevent_speech_naming_local-id'};
labels = vars;

vis_savepath = get_dir_vis();
root = fullfile(vis_savepath,'objects_stats');

[~,table] = cIDs(subexpIDs);
exps = unique(table(:,2));
for e = 1:numel(exps)
    exp_root = fullfile(root, sprintf('%d', exps(e)));
    if ~exist(exp_root, 'dir')
        mkdir(exp_root);
    end
    for v = 1:numel(vars)
        varname = vars{v};
        try
            visualize_basic_stats_per_object(exps(e), varname, fullfile(exp_root, labels{v}));
        catch ME
            disp(ME.message)
        end
    end
end
end