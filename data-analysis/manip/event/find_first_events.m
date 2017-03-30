function firsts = find_first_events(events, padding)
%Find the first link in chains of overlapping events
% Given an event with overlapping intervals, finds those intervals that
% start with a time stamp that is not inside another interval.
%
% USAGE:
% find_first_events(EVENTS):
%   Find first links in chains of events.
% 
% find_first_events(EVENTS, PADDING):
%   Find first links in chains of events that don't necessarily overlap:
%   PADDING is added to the end of each interval, before using it in
%   calculations about whether a time is in that interval.  PADDING can be
%   positive (meaning there must be extra space between events) or negative
%   (meaning the last portion of an event is not significant).
%
% also safe for cevents!
%

if nargin < 2
    padding = 0;
end

% We'll go through each event, sorted by event start time.  Every event is
% added to the excludes list, and if another event starts during an
% interval on the excludes list, it is not put in the FIRSTS output array.
events = sortrows(events);
firsts = zeros(0, size(events, 2)); % handle cevents
excludes = zeros(0, 2);

for I = 1:length(events)
    start = events(I, 1);
    within_excludes = (excludes(:, 1) <= start) & (start < excludes(:, 2));
    
    % if it's ok, add it to the output list.
    if ~ any(within_excludes)
        firsts(end + 1, :) = events(I, :);
    end
    
    % update excludes list.
    % input is sorted by start time, so we only need to keep around any
    % excludes that haven't ended yet.
    excludes = excludes(within_excludes, :);
    
    % Always add the current event to the excludes list.  PADDING is added
    % here.
    excludes(end + 1, :) = events(I, 1:2) + [0 padding];
end

