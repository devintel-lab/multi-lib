function [cevent] = cevent_shared(cevent1, cevent2)
% cevent_shared takes two cevent and find the shared segments
%
% Warning: this is accomplished using a transformation to a cstream, so a cevent
% that has overlapping events will lose this overlapping data!  Also, the start
% and end times of the events may change by a small amount.
%
%
% cevent_shared(cevent1, cevent2)
% Input: two cevents
% Output: a new event with shared moments of these two events
%
%   this function will intersect two cevent variables and extrast a new
%   list. Each event in the new list must 1) share the same category label;
%   2) shared temporal moments. 
%
%

% first convert two cevents into two cstreams
timeInterval = 0.01; % this should be high enough 
startTime = 0; % default;
defaultValue = 0; 
cstream1 = cevent2cstream(cevent1, startTime, timeInterval, defaultValue);
cstream2 = cevent2cstream(cevent2, startTime, timeInterval, defaultValue);

% find the shared moments between two cstreams
% these two need to have the same length
[cstream1 cstream2] = cstream_equal_length(cstream1, cstream2);
data{1} = cstream1; data{2} = cstream2;
p = 1; 
[cstream] = cstream_shared(data, p); 

% convert it back to cevent
cevent = cstream2cevent(cstream); 

