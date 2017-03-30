function out = shuffle_cstream(cstream)

cat0 = max(cstream(:,2))+1;
cstream(cstream(:,2)==0,2) = cat0;
cev = cstream2cevent(cstream);
log = cev(:,3) == cat0;
events = cev(~log,:);
nonevents = cev(log,:);

idxevents = randperm(size(events,1));
idxnonevents = randperm(size(nonevents,1));

newcev = zeros(size(cev,1),3);
newcev(log,:) = nonevents(idxnonevents,:);
newcev(~log,:) = events(idxevents,:);

durs = newcev(:,2) - newcev(:,1);
newcev(1,1) = cstream(1,1);
newcev(:,2) = newcev(1,1) + cumsum(durs);
newcev(2:end,1) = newcev(1:end-1,2);
newcev(:,2) = newcev(:,1) + durs;
newcev = newcev(~log,:);
out = cevent2cstreamtb(newcev, cstream);

end