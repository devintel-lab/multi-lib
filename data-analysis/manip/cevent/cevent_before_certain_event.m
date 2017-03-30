function  [a_cevent]= cevent_before_certain_event(time,event_type, cevent, flag);
%
% give a timestamp, find a previous single event in a cevent/event that
% matches with a certain event type. 
% flag: 1 -- count the overlapping event
%       0 -- do not count the overalapping one but the one happened
%       before but not overlapped with the current one. 
%
a_cevent = [];
if flag == 0
    [list] = find(cevent(:,2)<= time);
else
    [list] = find(cevent(:,1)<= time);
end;

before_list = sortrows(cevent(list,:),1);
before_list = flipud(before_list);

% find the one that matches
index = find(before_list(:,3) == event_type);
if ~isempty(index)
  a_cevent = before_list(index(1),:);
end;

