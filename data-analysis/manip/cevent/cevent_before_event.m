function  [a_cevent]= cevent_before_event(time,cevent);
%
% give a timestamp, find a previous single event in a cevent/event. 
%
a_cevent = [];
[list] = find(cevent(:,2)<= time);
[temp index] =  max(cevent(list,1));
index2 = list(index);
if ~isempty(index2)
  a_cevent = cevent(index2,:);
end;
