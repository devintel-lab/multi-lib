function tmp = cevent2cstreamtb(cev, tb)
tmp = tb(:,1);
tmp(:,2) = 0;

if ~isempty(cev)
    ucat = unique(cev(:,3));
    for c = 1:length(ucat)
        log = mark_ranges(tmp, cev(cev(:,3)==ucat(c),:));
        tmp(log,2) = ucat(c);
    end
end
end