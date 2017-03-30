function cstream = event2cstream_v2(event, timeseries, value)

%Make sure events are in order
event = sortrows(event, [1 2]);

cstream = cat(2, timeseries, zeros(numel(timeseries), 1));
for e = 1: size(event, 1)
    start = event(e,1);
    final = event(e,2);
    [~, is] = min(abs(cstream - start));
    [~, ifinal] = min(abs(cstream - final));
    cstream(is:ifinal, 2) = value;
end


end