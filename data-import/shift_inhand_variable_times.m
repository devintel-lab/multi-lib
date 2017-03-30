function shift_inhand_variable_times(sid, agent, num_frames)
%% This script will modify the timing information for all the inhand  
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

% Variable name parts
inhand_list ={'obj1','obj2','obj3'};
hand_type = {'left','right'};

% Loop through variables and update each.
for j = 1 : size(inhand_list,2)  % 1-3
    
%     % Change VideoCoder Variables
%     for m = 1 : size(hand_type,2) % 1-3
%         
%         % Cstreams
%         temp_cstream_name = sprintf('cstream_%s_inhand_%s_%s',inhand_list{j}, agent, hand_type{m});
%         temp_cstream = get_variable(sid, temp_cstream_name);
%         new_cstream = cstream_time_shift(temp_cstream, time_diff);
%         record_variable(sid, temp_cstream_name, new_cstream)
%         
%         % Events
%         temp_event_name = sprintf('event_%s_inhand_%s_%s',inhand_list{j}, agent, hand_type{m});
%         temp_event = get_variable(sid, temp_event_name);
%         new_event = cevent_time_shift(temp_event, time_diff);
%         record_variable(sid, temp_event_name, new_event)
%         
%     end;     
    
    % Change combined cstreams and cevents from make_inhand.m
    % Cstreams
    temp_cstream_name = sprintf('cstream_inhand_%s_%s',inhand_list{j}, agent);
    temp_cstream = get_variable(sid, temp_cstream_name);
    new_cstream = cstream_time_shift(temp_cstream, time_diff);
    record_variable(sid, temp_cstream_name, new_cstream)

    % Events
    temp_event_name = sprintf('event_inhand_%s_%s',inhand_list{j}, agent);
    temp_event = get_variable(sid, temp_event_name);
    new_event = cevent_time_shift(temp_event, time_diff);
    record_variable(sid, temp_event_name, new_event)
    
end;

% Cevents
temp_cevent_name = sprintf('cevent_inhand_%s', agent);
temp_cevent = get_variable(sid, temp_cevent_name);
new_cevent = cevent_time_shift(temp_cevent, time_diff);
record_variable(sid, temp_cevent_name, new_cevent)




