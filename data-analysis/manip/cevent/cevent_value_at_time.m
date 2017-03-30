function values = cevent_value_at_time(cevent, timestamp)
% Returns 0 or more values that are valid at the given timestamp
%
% [values] =  cevent_value_at_time(cevent, timestamp)
%
% Looks in the given cevent for any events that contain the given
% timestamp.  Returns the values for each of those events, if there are
% any.
%

match = (cevent(:, 1) <= timestamp) & (cevent(:, 2) > timestamp);

values = cevent(match, 3);
