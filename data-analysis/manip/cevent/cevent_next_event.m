function  [a_cevent]= cevent_next_event(time,cevent);
%
% give a timestamp, find a next single event in a cevent/event. 
%
a_cevent = [];
[list] = find(cevent(:,1)>time);
[temp index] =  min(cevent(list,1));
index2 = list(index);
if ~isempty(index2)
  a_cevent = cevent(index2,:);
end;
