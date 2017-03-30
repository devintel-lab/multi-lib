function res = event_OR(event1, event2)
%event_OR   Return the union set of two event data
%   res = event_OR(event1, event2);
%
res = event1;

for i = 1:event_number(event2) % for each time interval in event2 
    res = add_interval(res, event2(i,:));
end 


%time_interval_OR  Return the union of two time intrvals
% 
function ti_OR = time_interval_OR(ti1, ti2)
if check_intersection(ti1, ti2)
    ti_OR = [min([ti1(1) ti2(1)]), max([ti1(2) ti2(2)])];
else
    if ti1(1) < ti2(1)
        ti_OR = [ti1; ti2];
    else
        ti_OR = [ti2; ti1];
    end
end


% Add the interval to the event (series of intervals)
function new_event = add_interval(event, interval)
if isempty(event)
    new_event = interval;
    return;
end

for i = 1:event_number(event)  % for each time interval in event
    ti = event(i,:); % the i-th time interval of the event
    if check_intersection(interval, ti)
        new_interval = time_interval_OR(interval, ti); % compute union of two interval
        new_event = update_event(event, i, new_interval);  % replace ti1 with new_interval in res   
        break;
    elseif interval(2) < ti(1)
        new_event = [event(1:i-1,:); interval; event(i:event_number(event),:)];  % insert
        break;
    elseif i == event_number(event)     % if it is the last one
        new_event = [event; interval];  % insert at the end
        break;
    end
end
    
%Put the interval to i-th position of the event, and then
%check if this interval intersect with those interval at the right of it 
function new_event = update_event(event, i, interval)
merge_num = 0;
n = event_number(event);
for j=i+1:n
    ti = event(j,:);
    if check_intersection(interval,ti)
        interval = time_interval_OR(interval,ti);
        merge_num = merge_num+1;
    else
        break;
    end
end
event(i,:) = interval;

if i+merge_num+1 > n
    new_event = event(1:i,:);
else
    new_event = [event(1:i,:); event(i+merge_num+1:n,:)];
end


% check if two time intervals intersect with each other
function flag = check_intersection(ti1, ti2)
flag = ~(ti1(2)<ti2(1) || ti2(2)<ti1(1));
