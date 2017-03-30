function newCevent = cevent_time_expand(cevent, before, after)
%cevent_time_expend expands segments in a cevent before or after. 
% 
%   cevent_time_expand(cevent, before, after)
%   Input: cevent (can be cevent or event)
%          before and after: the time to add to the start and end of each event
%
%   Output: a newCevent 
%
%  this function is useful for the measures that we may want to expand a special event, eg.
%  naming events, looking for something before and after that. 
%

newCevent(:,1) = cevent(:, 1) - before;
newCevent(:,2) = cevent(:, 2) + after; 

if (size(cevent,2) == 3)
    newCevent(:,3) = cevent(:,3); 
end; 

