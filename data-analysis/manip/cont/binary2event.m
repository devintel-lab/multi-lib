function [ events ] = binary2event( binary )
%BINARY2EVENT Convert from a binary timeseries to events
% I think this is by Ikhyun?  -Thomas


%   binary is formatted:
% timestamp value
% timestamp value
% timestamp value

events = [];
event_index = 1;
binlength = length(binary);
old_state = 0;

for sample = 1:binlength(1)
    if old_state == 0 && binary(sample, 2) == 1
        events(event_index, 1) = binary(sample, 1);
    end
    if old_state == 1 && binary(sample, 2) == 0
        events(event_index, 2) = binary(sample, 1);
        event_index = event_index + 1;
    end
    old_state = binary(sample, 2);
end

if old_state == 1
    events(event_index, 2) = binary(end, 1);
end


end

