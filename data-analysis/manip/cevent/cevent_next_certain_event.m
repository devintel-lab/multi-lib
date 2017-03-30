function  [a_cevent]= cevent_next_certain_event(time,event_type, cevent, inside_ok);
% cevent_next_certain_event(time,event_type, cevent, inside_ok);
% give a timestamp, find a next single event in a cevent/event that
% matches with a certain event type. 
% inside_ok: 1 will return the "current" event if TIME is inside an event,
%               otherwise will return the next event
%            0 no overlap
%
a_cevent = [];
% find the one in the middle 
if inside_ok == 1 
    [list] = find((cevent(:,2) >= time) & (cevent(:,1) <= time));
    if ~isempty(list) && (cevent(list(end),3) == event_type)
        a_cevent = cevent(list(end),:);
        return;
    end;
end;

% else find the one after 
[list] = find(cevent(:,1) >= time);
next_list = sortrows(cevent(list,:),1);
next_index = find(next_list(:,3) == event_type);
if ~isempty(next_index)
    a_cevent = next_list(next_index(1),:);
end;





