function h = vis_streams_files(stream_files, window_times_file, savefilename, streamlabels, args)%, titlelabel, colors, draw_edge, numheaders, columns)
% see demo_vis_streams_files for documentation
if ischar(stream_files) && ~isempty(strfind(stream_files, 'demo'))
    switch stream_files
        case 'demo1'
            [~,~,subpath] = cIDs(7206);
            stream_files = {fullfile(subpath{1}, 'cstream_eye_roi_child.mat'), fullfile(subpath{1}, 'cstream_eye_roi_parent.mat')};
            window_times_file = fullfile(subpath{1}, 'cevent_trials.mat');
            savefilename = '/desktop/vis_stream_files_demo1.png';
            streamlabels = {'ceye', 'peye'};
    end
end

if ~exist('args', 'var') || isempty(args)
    args = struct();
end

if ~isfield(args, 'colors')
    args.colors = [];
end

if ~isfield(args, 'draw_edge')
    args.draw_edge = 1;
end

if ~isfield(args, 'stream_files_numheaders')
    args.stream_files_numheaders = zeros(1, numel(stream_files));
end

if ~isfield(args, 'window_times_file_numheaders')
    args.window_times_file_numheaders = 0;
end

if ~isfield(args, 'stream_files_columns')
    args.stream_files_columns = cell(1,numel(stream_files));
end

if ~isfield(args, 'window_times_file_columns')
    args.window_times_file_columns = [];
end

if ~isfield(args, 'titlelabel')
    args.titlelabel = [];
end

alldata = cell(numel(stream_files),1);

args.colors = set_colors(args.colors);

for f = 1:numel(stream_files)
    alldata{f} = load_data_from_file(stream_files{f}, args.stream_files_numheaders(f), args.stream_files_columns{f});
end

if ischar(window_times_file)
    window_times = load_data_from_file(window_times_file, args.window_times_file_numheaders, args.window_times_file_columns);
else
    window_times = window_times_file;
end

h = vis_streams_data(alldata, window_times, streamlabels, args);

if exist('savefilename', 'var') && ~isempty(savefilename)
    export_fig(h, savefilename, '-png', '-a1', '-nocrop');
end
end