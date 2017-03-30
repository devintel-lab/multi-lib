function cev_res = cevent_longest_per_type(cevent)
% filters the cevent so only the longest instance per type is left
%
[events types] = cevent2events(cevent);

longests = cellfun(@event_longest, events, 'UniformOutput', 0);

cev_res = [vertcat(longests{:}) types];
