function expanded = event_expand(events, bounds)
% extends the end of each event to the beginning of the next one
%
% event_expand(events)
%
% event_expand(events, bounds)
%
% The first form sets the end of each event to the beginning time of the
% next event, creating a continuous stream of events with no breaks.
%
% The second form does the same, but with the given bounds.  The bounds are
% boundaries across which the events are not expanded.  It's almost like
% applying (events AND bounds), but if an event was going to be expanded to
% be on both sides of the bounds, it will instead stop at the beginning of
% the bounds.
%
% The end time of the last event becomes Inf unless you supply bounds.
%

inv_bounds = event_NOT(bounds, [-Inf Inf]);

if nargin > 1
    % make bounds big enough to be added to events
    inv_bounds(:, 3:size(events, 2)) = NaN;

    [with_bounds, orig_indices] = sortrows(vertcat(events, inv_bounds));
    fake_rows = orig_indices > size(events, 1);
    
    work = with_bounds;
else
    work = events;
end

% event end times come from beginning times of subsequent events
new_end_times = vertcat(work(2:end, 1), Inf);
work(:, 2) = new_end_times;

% possibly restrict the result to be within the bounds.
if nargin > 1
    work = work(~ fake_rows, :);
end

expanded = work;
