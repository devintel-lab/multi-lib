function all_chunks = extract_ranges( all_data, data_type, all_ranges )
%Extract chunks from data, delegating based on data type
%   USAGE:
%   extract_ranges(DATA, DATA_TYPE, RANGES)
%       For each range in RANGES, extracts that range of of data from DATA.
%       All the ranges of data are returned in a cell array.  DATA is
%       assumed to be of the type specified by DATA_TYPE.
%
%   DATA can be in any of the standard formats in multi-lib: cont, event,
%   cstream, cevent.
%
%   DATA_TYPE specifies the format of DATA, so that the function can
%   determine how to split the data.  It should be one of the strings
%   'cont', 'cont2', 'cstream', 'event', or 'cevent'.
%
%   RANGES is an Nx2 matrix, with each row specifying a time range.  This
%   is the same format as the 'event' data type, or the trial info returned
%   by get_trial_times().
%
%   The return value is a vertical cell array, with a portion of DATA in
%   each cell.  If DATA_TYPE is cont or cstream, the cells contain exact
%   copies of pieces of DATA.  If DATA_TYPE is event or cevent, then each
%   cell contains the intersection of the events with one range.
%
%   See also: GET_TRIAL_TIMES, CELLFUN
%
all_chunks = {};

if ~ iscell(all_data)
    all_data = {all_data};
end

ranges_by_chunk = matchArgumentSize(all_data, all_ranges);

for C = 1:numel(all_data)
    data = all_data{C};
    ranges = ranges_by_chunk{C};

    if regexp(data_type, '^(cont|cstream)\d*')
        chunks = cont_extract_ranges(data, ranges);
    elseif regexp(data_type, '^c?event')
        chunks = event_extract_ranges(data, ranges);
    else
        error('extract_ranges:unknown_type', ...
            ['Unknown data type ' data_type]);
    end

    all_chunks = [ all_chunks; chunks ];
end

end

function matchedArgument = matchArgumentSize(desired, realArgument)
% matchArgumentSize(desired, realArgument)
% Returns a cell array of arguments with the same size as
% DESIRED, so then you can loop through desired and the
% arguments together.
%
% if realArgument is not a cell array, it duplicates it once
% for each element in desired.
%
% if realArgument is a cell array, it makes sure it's the same
% size as DESIRED.
if ~ iscell(realArgument)
    matchedArgument = repmat({ realArgument }, size(desired));
else
    if ~ isequal(size(desired), size(realArgument))
        error('Argument must be non-cell, or cell with same size as other arguments');
    end
    matchedArgument = realArgument;
end
end
