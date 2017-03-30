function chunks = event_extract_ranges(event_data, ranges)
%Extracts the subset of event_data that is in each range
%   USAGE:
%   event_extract_ranges(EVENT_DATA, RANGES)
%       Goes through each of the RANGES, and for each one, finds the
%       portion of the EVENT_DATA that lies within the range.  Each slice
%       of the EVENT_DATA is returned in a cell of a cell array.
%
%   EVENT_DATA may be binary event or categorical event (cevent) data.
%
%   RANGES is actually the same format as a binary event, just a list of
%   ranges, one per row.
%
%   Some cells of the return value may be empty, if no events exist in that
%   range.


chunks = cell(size(ranges, 1), 1);

for range_idx = 1:size(ranges, 1)
    range = ranges(range_idx, :); % range(1) is start, range(2) is end
    
    chunks{range_idx} = get_event_in_scope(event_data, range);
    
end

end