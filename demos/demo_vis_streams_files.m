function demo_vis_streams_files(option)
%% Overview
% Outputs matlab figures with visualized behaviors from files
% Supports both cevent or cstream type data formats
% Input is a list of file names (relative or absolute)
% Files can be .mat files with sdata.data structure
% Or, files can be comma delimited text files
% In the case of text files, one should specify how many header rows exist
% Also, one can specify which columns (2 for cstream, 3 for cevent) to grab
% from the text file.
%% Required Arguments
% stream_files
%       -- cell array, each cell is the full path or relative path to a
%          .mat or .csv file
%       -- data can either be cstream or cevent format
%       -- if .mat, data should be saved under sdata.data structure, like
%          in multiwork format
%       -- for .csv files, one can specify the number of headers and
%          columns, see the optional arguments below
% window_times_file
%       -- timing information indicating how to split the data into
%          subplots for optimal viewing
%       -- data is Nx2 matrix, onsets and offets. Each row splits the data
%          and displays the partial data on a subplot.
%       -- this can either be a .mat or .csv file
%       -- alternatively, the input can be an Nx2 matrix, if the timing is not
%          in a file
%       -- if left empty, the default behavior will split the data into 2
%          minute chunks
% savefilename
%       -- full path or relative path of where to save the .png figure
% streamlabels
%       -- cell array, each cell is a short-hand label for the files in
%          stream_files.
%       -- e.g. for cstream_eye_roi_child, one can set the label to 'ceye'
%% Optional Arguments
% args.titlelabel
%       -- a string indicating the title of the plot
% args.stream_files_numheaders
%       -- integer array, one number for each filename, indicating how many
%          headers are in that file
%       -- e.g. [1 1 2] for three files
% args.stream_files_columns
%       -- cell array, one cell for each filename, indicating which columns
%          to grab from the .csv file
%       -- e.g. {[3 4 5], [6 7 8], []} for three files
%          [3 4 5] is for the first file, etc.
%       -- if empty, just grab all columns
% args.window_times_file_numheaders
%       -- same format as args.stream_files_numheaders
% args.window_times_file_columns
%       -- 1x3 integer array indicating which
%          columns to grab from the .csv file
%       -- e.g. [2 3 4]
% args.draw_edge
%       -- 1 or 0
%       -- if 1, will draw outline each rectangle with a dark border,
%          otherwise none
% args.colors
%       -- an Nx3 array indicating a set of colors to use for the plots
%       -- each row corresponds to the category value in the data streams
%       -- can also be a single number, which will prompt the user to
%          choose colors with a built in Matlab UI. See set_colors.m
%%
switch option
    
    case 1
        % basic usage, assuming data is stored in files without headers,
        % and data is the first 2 or 3 colums of the file
        stream_files = {
            '/scratch/multimaster/demo_results/vis_streams_files/case1/cevent_data1.csv'
            '/scratch/multimaster/demo_results/vis_streams_files/case1/cevent_data2.csv'
            '/scratch/multimaster/demo_results/vis_streams_files/case1/cevent_data3.csv'
            };
        window_times_file = '/scratch/multimaster/demo_results/vis_streams_files/case1/window_times.csv';
        savefilename = '/scratch/multimaster/demo_results/vis_streams_files/case1/case1.png';
        streamlabels = {'ceye', 'peye', 'ja'};
        
        vis_streams_files(stream_files, window_times_file, savefilename, streamlabels);
        
    case 2
        % csv has headers, or the data is not in the first 2 or 3 columns
        % you can also mismatch .mat and .csv files in input list
        % the stream_files can come from different directories as well
        stream_files = {
            '/scratch/multimaster/demo_results/vis_streams_files/case2/cevent_data1.csv'
            '/scratch/multimaster/demo_results/vis_streams_files/case2/cevent_data2.csv'
            '/bell/multiwork/experiment_72/included/__20141001_16579/derived/cevent_eye_joint-attend_both.mat'
            };
        window_times_file = '/scratch/multimaster/demo_results/vis_streams_files/case2/window_times.csv';
        savefilename = '/scratch/multimaster/demo_results/vis_streams_files/case2/case2.png';
        streamlabels = {'ceye', 'peye', 'ja'};
        
        args.stream_files_numheaders = [2 1 1];
        args.stream_files_columns = {[2 3 4], [1 2 3], [1 2 3]};
        args.titlelabel = '7206_data';
        args.window_times_file_numheaders = 1;
        args.window_times_file_columns = [1 2];
        
        vis_streams_files(stream_files, window_times_file, savefilename, streamlabels, args);
end
end