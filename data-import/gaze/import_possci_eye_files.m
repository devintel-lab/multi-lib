function import_possci_eye_files(sid, agents, frames)
% Imports the Positive Science text files and creates
% cont2_eye_xy, cont_eye_x, and cont_eye_y variables.
%
% sid = subject id
%
% agents = a cell array of agent types. Ex.  agents = {'child', 'parent'}.
% Note: The number of agents needs to be the same as the number of rows for
% the frames argument.
%
% frames = an array of [start_frame end_frame] that defines the start and
% end frame cut from the original video for the listed agents.  Each row
% corresponds to the index of the agents cell array.  Note: This needs to
% have the same number of rows as there are agents.
%
% Eye Files have 7 lines of header and 12 columns:
%        1                2            3              4           5    6
% recordFrameCount movieFrameCount frames/sec QTtime(h:m:s.msec) porX porY 
%    7      8      9           10          11        12
% pupilX pupilY cornealRefX cornealRefY diameterW diameterH
% 
% We only pull out the recordFrameCount, porX, and porY columns.
%
% Notes:  We assume that the frame rate is 29.97 fps, that the first
% frame that we extract is frame 0 in the cam##_frames_p folder, and that
% that frame corresponds to time = 30.0 seconds.


% Check that there are the same number of agents as there are frames.
num_agents = length(agents);
num_chunks = size(frames, 1);

if num_agents ~= num_chunks    
    error('The number of agents does not match the number of frame chunks.')
end

% 29.97 Frame rate assumption and starting time for frame 0 is 30.0 seconds.
rate = 1/29.97;
trial_start_time = 30;


% Get the subject directory information.
sub_dir = get_subject_dir(sid);
sub_info = get_subject_info(sid);
sub_number = sprintf('__%d_%d', sub_info(3), sub_info(4));

% Go through each agent and their corresponding frames.
for i = 1:num_agents
    
    agent = agents{i};
    chunk_frames = frames(i,:);
    num_frames = frames(i,2) - frames(i,1)+1;

    % Get the text file name.
    eye_file_path = sprintf('%s/extra_p/%s_%s_eye.txt', sub_dir, sub_number, agent);

    % Read the text file.
    fid = fopen(eye_file_path);
    eye_data = textscan(fid, '%d %d %f %s %f %f %f %f %f %f %f %f', 'Headerlines',7);
    fclose(fid);

    % Get the raw x and y coordinates.
    eye_xy_raw = [eye_data{1} eye_data{5} eye_data{6}];

    % Grab just the frames specified.
    eye_xy = double(eye_xy_raw(frames(i,1):frames(i,2), :));
    
    % Generate the new times.
    end_time = rate*num_frames + trial_start_time - rate;
    new_times = [30:rate:end_time]';
    eye_xy(:,1) = new_times(:);

    cont2_eye_x = eye_xy(:,1:2); 
    cont2_eye_y = [eye_xy(:,1) eye_xy(:,3)]; 
    
    % Save xy, x, and y cont vars
    record_variable(sid, sprintf('cont2_eye_xy_%s', agent), eye_xy);
    record_variable(sid, sprintf('cont_eye_x_%s', agent), cont2_eye_x);
    record_variable(sid, sprintf('cont_eye_y_%s', agent), cont2_eye_y);

end






