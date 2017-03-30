function log = mark_ranges(timecol, ranges)
timecol = timecol(:,1);
sr = mode(diff(timecol(1:10)));
ranges(:,2) = ranges(:,2) - sr;
ranges(:,1) = ranges(:,1) - 0.0001;
ranges(:,2) = ranges(:,2) + 0.0001;
logs = zeros(size(timecol, 1), size(ranges, 1));
for r = 1:size(ranges, 1);
    logs(:,r) = timecol >= ranges(r,1) & timecol <= ranges(r,2);
end
log = any(logs, 2);
end