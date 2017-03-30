function sd = event_setdiff(from, take)
%EVENT_SETDIFF subtract one event from another
%
% event_setdiff(FROM, TAKE)
%   From FROM, subtracts TAKE.
%
% Event_setdiff treats (c)events as sets of timestamps, and calculates a
% set difference between two of them.  So if some amount of time is in both
% FROM and TAKE, it will not be in the answer.
%
% Example:
% >> event_setdiff([1 10 1], [3 4])
% 
% ans =
% 
%      1     3     1
%      4    10     1


sd = cevent_AND(from, event_NOT(take, [-Inf, Inf]));
if ~ isempty(sd)
    to_delete = sd(:, 1) == sd(:, 2);
    sd = sd(~ to_delete, :);
end
