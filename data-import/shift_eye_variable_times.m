function shift_eye_variable_times(sid, agent, num_frames)
%% This script will modify the timing information for all the eye  
% variables for either the child or parent. This should be used after syncing  
% the cameras by adding or subtracting a set number of frames from a camera's
% frame sequence.
%
% sid:
%   The subject id number for matlab.
%
% agent: 
%   'parent' or 'child' 
%
% num_frames:
%   The number of frames that were shifted in the extracted frames to sync
%   camera's 5 and 6.  This can be a positive or negative number.
%
%

% Convert the frame difference between the camera's to a time difference in
% seconds to change the variables by.
time_diff = num_frames / 29.97;


roi_list ={'obj1','obj2','obj3','head'};
   
% Change VideoCoder Variables
for j = 1 : size(roi_list,2)
    
    % Cstreams
    temp_cstream_name = sprintf('cstream_eye_roi_%s_%s', roi_list{j}, agent)
    temp_cstream = get_variable(sid, temp_cstream_name);
    new_cstream = cstream_time_shift(temp_cstream, time_diff);
    record_variable(sid, temp_cstream_name, new_cstream)

    % Events
    temp_event_name = sprintf('event_eye_roi_%s_%s', roi_list{j}, agent)
    temp_event = get_variable(sid, temp_event_name);
    new_event = cevent_time_shift(temp_event, time_diff);
    record_variable(sid, temp_event_name, new_event)
    
end;

% Change combined cstreams and cevents from make_inhand.m
% Extra Cstream
temp_cstream_name = sprintf('cstream_eye_roi_%s', agent)
temp_cstream = get_variable(sid, temp_cstream_name);
new_cstream = cstream_time_shift(temp_cstream, time_diff);
record_variable(sid, temp_cstream_name, new_cstream)
    
% Cont's
temp_cont_x_name = sprintf('cont_eye_x_%s', agent)
temp_cont_y_name = sprintf('cont_eye_y_%s', agent)

temp_cont_x = get_variable(sid, temp_cont_x_name);
temp_cont_y = get_variable(sid, temp_cont_y_name);

new_cont_x = cont_time_shift(temp_cont_x, time_diff);
new_cont_y = cont_time_shift(temp_cont_y, time_diff);

record_variable(sid, temp_cont_x_name, new_cont_x)
record_variable(sid, temp_cont_y_name, new_cont_y)

% Cont2's
temp_cont2_name = sprintf('cont2_eye_xy_%s', agent)
temp_cont2 = get_variable(sid, temp_cont2_name);

new_times = temp_cont2(:,1) + time_diff;
new_cont2 = [new_times temp_cont2(:,2:3)];
record_variable(sid, temp_cont2_name, new_cont2)

% Cevents
temp_cevent_name = sprintf('cevent_eye_roi_%s', agent)
temp_cevent = get_variable(sid, temp_cevent_name);
new_cevent = cevent_time_shift(temp_cevent, time_diff);
record_variable(sid, temp_cevent_name, new_cevent)






