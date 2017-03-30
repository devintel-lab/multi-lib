function [indices] = find_event_indices(events, timestamps)
% Given some events and some time stamps, find which event contains each stamp
% USAGE:
%   find_event_indices(EVENTS, TIMESTAMPS)
%
% What's returned is the index in the events list, i.e. the row number, for
% each time stamp.
%
% If there are no matches, returns 0 for that timestamp.  
% There is more than one match, returns the index of the LAST match.
%
%

indices = zeros(length(timestamps),1);

for i = 1 : length(timestamps)
  for j = 1 : size(events,1)
    if (timestamps(i)>= events(j,1)) && (timestamps(i) <=events(j,2))
      indices(i) = j;
    end;
    
  end;
end;


