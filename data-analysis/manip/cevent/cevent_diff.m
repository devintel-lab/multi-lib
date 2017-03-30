function [diffEvent] = cevent_diff(cevent1, cevent2)
% cevent_diff takes two cevents and find the moments in these two lists that have non-zero different category labels.
%
% 
% Warning: this is accomplished using a transformation to a cstream, so a cevent
% that has overlapping events will lose this overlapping data!  Also, the start
% and end times of the events may change by a small amount.
%
% Input: two cevents
% Output: DiffEvent: Nx4 [onset offset label_in_cevent1 label_in_cevent2]
%
%   this function will intersect two cevent variables to find shared moments that both have non-zero values 
% and extrast a new  list that contain only the moments they have different
% values 
%

% first find the shared cevent3 
cevent3 = cevent_shared(cevent1, cevent2); 

% convert cevent1 and cevent 3 into two streams 
timeInterval = 0.005; % this should be high enough 
startTime = 0; % default;
defaultValue = 0; 
cstream1 = cevent2cstream(cevent1, startTime, timeInterval, defaultValue);
cstream2 = cevent2cstream(cevent2, startTime, timeInterval, defaultValue);
cstream3 = cevent2cstream(cevent3, startTime, timeInterval, defaultValue);
[cstream1 cstream2] = cstream_equal_length(cstream1, cstream2);
[cstream1 cstream3] = cstream_equal_length(cstream1, cstream3);

% assigne all non-zero shared items to be zero
index3 = find(cstream3(:,2) ~= 0);
index1 = find(cstream1(:,2) == 0); 
index2 = find(cstream2(:,2) == 0); 
index = union(union(index1,index2), index3);
cstream1(index,2) = 0; 
cstream2(index,2) = 0; 

factor = ceil(log10(cstream1(:,2)));
cstream3 = cstream1; 
cstream3(:,3) = cstream1(:,2) + factor .* cstream2(:,2);
% convert it back to cevent
cevent3 = cstream2cevent(cstream3, 0); 
cevent3 = cevent_remove_small_segments(cevent3,0.03);

% go back to real category values. 
diffEvent = cevent3;
for i = 1 : size(diffEvent,1)
    index = find(cstream1(:,1) >= diffEvent(i,1));
    diffEvent(i,3) = cstream1(index(1),2);
    index = find(cstream2(:,1) >= diffEvent(i,1));
    diffEvent(i,4) = cstream2(index(1),2);
end;


