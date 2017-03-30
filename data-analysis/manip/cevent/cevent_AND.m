function AND = cevent_AND(cevent, event)
if isempty(cevent) || isempty(event)
    AND = [];
    return
end

event = event_OR(event, event); % remove overlaps, merge perfectly adjascent sections

chunks = event_extract_ranges(cevent, event);

AND = vertcat(chunks{:});
