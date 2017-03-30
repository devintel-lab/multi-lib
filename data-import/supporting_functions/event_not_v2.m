function out = event_not_v2(event_data, time_period)
%This version can handle events that have overlapping or duplicate events
%time_period is [onset offset]  
%Author: Seth Foster

%shorthand
e = event_data;
tp = time_period;

%check if e is empty
if isempty(e)
    out = [];
    return
end

%remove invalid events where t1 > t2
invalid = e(:,2) - e(:,1);
log = invalid <= 0;
e(log,:) = [];

%sort event data by first column in the case that it was not already sorted
ee = sortrows(e, [1 2]);

%switch columns and then shift 1st column down by one and fill in NaN
ee = [ee(:,2) ee(:,1)];
shiftee = [[NaN; ee(:,1)] [ee(:,2); NaN]];

%remove invalid events where t1 > t2

invalid = shiftee(:,2) - shiftee(:,1);
log = invalid <= 0;
shiftee(log,:) = [];

%determine where time_period fits into data

[~, i] = min(abs(shiftee(:,1) - tp(1)));
[~, i2] = min(abs(shiftee(:,2) - tp(2)));

shiftee(i-1,1) = tp(1);
shiftee(i2+1,2) = tp(2);

%remove invalid events where t1 > t2

invalid = shiftee(:,2) - shiftee(:,1);
log = invalid <= 0;
shiftee(log,:) = [];

out = shiftee;

end