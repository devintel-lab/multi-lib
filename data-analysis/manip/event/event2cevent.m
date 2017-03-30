function cevent = event2cevent(event)
% event2cevent: Convert (binary) event data to category event data
%               All the event will be consider as category 1. 
%   USAGE: cevent = event2cevent(event)
%
% See also: EVENTS2CEVENT, CEVENT2EVENTS
cevent = event;
cevent(:,3) = 1;