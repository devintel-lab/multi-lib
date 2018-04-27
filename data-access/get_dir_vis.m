function dir_vis = get_dir_vis()
% This function returns the visualization folder path. All scheduled
% visualizations should be saved under that directory.

multidir = get_multidir_root();
dir_vis = fullfile(multidir, 'data_vis_new');