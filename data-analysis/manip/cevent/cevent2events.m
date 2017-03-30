function [events category_id] = cevent2events(cevent)
% cevent2events   Make a set of events data. Each is from a category of cevent data
%
% events = cevent2events(cevent);
%
% [events category_id] = cevent2events(cevent);
% 
% events:      cell array, in which each element is a event data converted from a category of cevent data
%
% category_id: M*1 vector, where M is the number of categories.  Each entry is the category ID of the corresponding event variable in EVENTS.
%
% See also: EVENTS2CEVENT, EVENT2CEVENT, CEVENT2EVENT,
% CEVENT_CATEGORY_EQUALS
%
if isempty(cevent)
    events = {};
    category_id = [];
    return;
end

category_id = sort(unique(cevent(:,3)));
cnum = length(category_id);
events = cell(cnum,1);

for i=1:cnum
    cid = category_id(i);
    events{i} = cevent(cevent(:,3)==cid,1:2); 
end

end
