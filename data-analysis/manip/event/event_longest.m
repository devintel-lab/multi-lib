function ev = event_longest(event)
% returns one instance of the event, whichever is longest
%
% if there's a tie, returns the first one.
%
% >> event_longest([1 5; 10 20])
% ans = 10 20
% >> event_longest([])
% ans = []
% >> event_longest([10 20; 30 40])
% ans = 10 20
% 


if isempty(event)
    ev = event;
    return;
end

[length, index] = max(diff(event, [], 2));

ev = event(index, :);

    
