function vis_streams_multiwork(subexpIDs, vars, streamlabels, directory, args)
% see demo_vis_streams_multiwork for documentation
if ischar(subexpIDs) && ~isempty(strfind(subexpIDs, 'demo'))
    switch subexpIDs
        case 'demo1'
            subexpIDs = [7206, 7207];
            vars = {'cstream_eye_roi_child', 'cstream_eye_roi_parent'};
            directory = '/desktop/vis_streams_multiwork';
            streamlabels = {'ceye', 'peye'};
    end
end

if ~exist('args', 'var') || isempty(args)
    args = struct();
end

if ~isfield(args, 'draw_edge')
    args.draw_edge = 1;
end

if ~isfield(args, 'colors')
    args.colors = [];
end

[subs,subtable,subpaths] = cIDs(subexpIDs);

for s = 1:numel(subs)
    filenames = cell(numel(vars), 1);
    for v = 1:numel(vars)
        if ischar(vars{v})
            filenames{v,1} = fullfile(subpaths{s}, [vars{v} '.mat']);
        else
            filenames{v,1} = vars{v};
        end
    end
    if isfield(args, 'window_times_variable')
        window_times_file = fullfile(subpaths{s}, [args.window_times_variable '.mat']);
    elseif ismember(subtable(s,2), [12])
        window_times_file = [];
    else
        window_times_file = fullfile(subpaths{s}, 'cevent_trials.mat');
    end
    flag_dir = 1;
    if exist('directory', 'var') && ~isempty(directory)
        if exist(directory, 'dir')
            savefilename = fullfile(directory, sprintf('%d.png', subs(s)));
        else
            error('%s does not exist', directory);
        end
    else
        savefilename = [];
        flag_dir = 0;
    end
    
    args.titlelabel = sprintf('%d', subs(s));
    h = vis_streams_files(filenames, window_times_file, savefilename, streamlabels, args);
    if flag_dir
        close(h);
    end
end
end