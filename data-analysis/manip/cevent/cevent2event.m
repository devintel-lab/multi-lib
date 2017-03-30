function [event] = cevent2event(cevent, category_id)
% cevent2event converts a cevent to event.
%    if category_id is not specified, this function removes the category
% column, just keeping onset and offset timestamps of each segment.
%    when catgory_id is specified, the function extract the instances that
%    have the category id. 
%
% usage:
% cevent2event(CEVENT)
% cevent2event(CEVENT, category_id)
%
% Input: 
%    cevent:  a Nx3 cevent
%    category_id: (optional) a integer number    
% Output: a Nx2 event
%
% See also: CEVENT2EVENTS, EVENTS2CEVENT, EVENT2CEVENT, CEVENT_CATEGORY_EQUALS

if ~exist('category_id', 'var')
    event = cevent(:,[1,2]);
else
    [events id_list] = cevent2events(cevent);
    mask = (id_list == category_id);
    if ~any(mask)        
        event = [];
    else
        event = events{mask};
    end
end
