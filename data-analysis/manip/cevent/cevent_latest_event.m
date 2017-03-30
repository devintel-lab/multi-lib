function cevent_latest = cevent_latest_event(cevent)
%CEVENT_LATEST_EVENT
%
% cevent_latest_event(cevent_data)
%   If there are no overlapping events in cevent_data, returns it
%   unchanged.  If events overlap, they are changed so there is no overlap,
%   and the event which starts latest is used as the 'current' one.

cevent_latest = [];

for R = 1:size(cevent, 1)
    row = cevent(R, :);
    
    cevent_latest = event_setdiff(cevent_latest, row);
    cevent_latest(end+1, :) = row;
    
    % the set difference can re-order things
    cevent_latest = sortrows(cevent_latest);
end

