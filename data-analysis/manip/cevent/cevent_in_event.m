function [newCevent] =  cevent_in_event(cevent, event)
% cevent_in_event finds the shared moments between cevent and event
% and generate a new cevent that contains only segments that are in both cevent
% and event. 
% Usage:
%  cevent_in_event(cevent, event)
%
% If the EVENT has overlapping instances, the output may include more
% than one copy of parts of the CEVENT.
%

chunks = event_extract_ranges(cevent, event);

newCevent = vertcat(chunks{:});
