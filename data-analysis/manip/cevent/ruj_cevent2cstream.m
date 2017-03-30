function cstream = cevent2cstream(event, times, default)
% Convert event to cstream given a range of time
% cstream = event2cstream(event, times)
% Output is a binary in the cstream form.  The input event is assumed to be
% sorted and not overlapped.
% The input TIMES should be a MATLAB range expression, for instance
% 1:0.1:35.  Or it could be any sorted list of timestamps.

if ~exist('default', 'var')
    default = 0;
end

if size(event, 2) == 2
    event(:, 3) = 1;
end


% change to account for empty events
if size(event,1) == 0
    event_count = 0;
    start = 0;
    stop=0;
else
    event_count = 1;
    start = event(1,1);
    stop = event(1,2);
end

total = length(times);
cstream = zeros(total,2);
cstream(:,1) = times;
cstream(:,2) = default;
total_event = size(event, 1);

% For each time
for i = 1:total
    time = times(i);
    
    % if this time is past the stop of the event, search for a new event.
    while(time >= stop && event_count < total_event)
        event_count = event_count + 1;
        start = event(event_count ,1);
        stop = event(event_count ,2);
    end

    % Check if before event
    if(time < start)
        cstream(i,2) = 0;
    elseif (time < stop) % not before.  During?
        cstream(i,2) = event(event_count, 3);
    else % Not before or during.  After.
        % This should only happen when we've run out of events.
        assert(event_count == total_event);
        % The rest of the variable should be zeros, which it already is.
        % We're done!
        break
    end
end
end
