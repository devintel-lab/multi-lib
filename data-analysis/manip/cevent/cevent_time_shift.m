function newCevent = cevent_time_shift(cevent, offset)
%  cevent_time_shift shifts the whole cevent by an offset
% 
%   cevent_time_shift(cevent, offset)
%   Input: cevent (can be cevent or event and an offset in seconds; the offset can be both
%   positive (moving forward) or negative (moving backward). 
%
%   Output: a newCevent or event
%
%  this function is useful for the purpose of comparing two temporal event
%  sequences to see what is the best overall alignment between two.  
%

newCevent(:,1:2) = cevent(:, 1:2) + offset;
if (size(cevent,2) == 3)
    newCevent(:,3) = cevent(:,3); 
end; 

