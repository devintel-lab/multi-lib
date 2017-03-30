function cevent = events2cevent(events, indices)
%EVENTS2CEVENT takes several events and combines them into a single cevent
%
% USAGE:
% events2cevent(EVENTS)
%   Each event in the cell array EVENTS becomes one category of events in
%   the final cevent.  The first event in EVENTS becomes number 1, the
%   second is number 2, etc.
%
% events2cevent(EVENTS, CATEGORIES)
%   Like events2cevent(EVENTS), but each entry in the array CATEGORIES is the
%   category label for the corresponding event in EVENTS.  Events can have
%   the same category.  All categories should be integers.
%
% Example: 
% >> events2cevent({[1 2; 3 4; 5 6], [2 3; 4 8; 10 20]}, [1 15])
% 
% ans =
% 
%      1     2     1
%      2     3    15
%      3     4     1
%      4     8    15
%      5     6     1
%     10    20    15
%
%
% See also: CEVENT2EVENTS

if nargin < 2
    indices = 1:length(events);
end


cevent = zeros(0, 3);

for I = 1:length(events)
    current = events{I};
    current(:, 3) = indices(I);
    cevent = vertcat(cevent, current);
end

cevent = sortrows(cevent);


