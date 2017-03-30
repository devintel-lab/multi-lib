function res = event_NOT(event_data, time_period)
% event_NOT:  Return the complement of given event, within the bounds of time_period
%   USAGE: cevent = event2cevent(event_data,time_period)
%   Example: cevent = event2cevent(event_data, [minTime maxTime]);
% 
minTime = time_period(1);
maxTime = time_period(2);
res = event_complement(event_data, minTime, maxTime);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get a complementary event 
% Input: event (timestamps), min time value for the timestamp, max time value for the timestamp
% Output: a complementaty event 
% Author: Seehyun Kim
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function complimented_event = event_complement(vec1, minTime, maxTime)

% minTime = vec1(1,2);
% maxTime = vec1(size(vec1,1),2);
eventTime = [];

finding_initial_begin = true;
finding_begin = true;
index = 1; indexFirst = 1;

while indexFirst < size(vec1,1)+1
    if finding_initial_begin
        if vec1(indexFirst,2) < minTime
            indexFirst = indexFirst + 1;
        elseif vec1(indexFirst,1) < minTime
            if vec1(indexFirst,2) >= maxTime
                return;
            end
            eventTime(index,1) = vec1(indexFirst,2);
            indexFirst = indexFirst + 1;
            finding_initial_begin = false; finding_begin = false;
        else
            eventTime(index,1) = minTime;
            finding_initial_begin = false; finding_begin = false;
        end
    else
        if finding_begin
            if vec1(indexFirst,2) >= maxTime
                break;
            end
            eventTime(index,1) = vec1(indexFirst,2);
            indexFirst = indexFirst + 1;
            finding_begin = false;
        else
            if vec1(indexFirst,1) > maxTime
                break;
            end
            eventTime(index,2) = vec1(indexFirst,1);
            index = index + 1;
            finding_begin = true;
        end
    end
end

if finding_initial_begin
    eventTime(index,1) = minTime;
    eventTime(index,2) = maxTime;
    index = index + 1;
elseif finding_begin == false
    eventTime(index,2) = maxTime;
    index = index + 1;
end

if isempty(eventTime)
    eventData = [];
else
    eventData = zeros(index-1,2);
    for i = 1:index-1
        eventData(i,1) = eventTime(i,1);
        eventData(i,2) = eventTime(i,2);
    end
end

if isempty(eventData)
    complimented_event = [];
else
    r = find(eventData(:,1) ~= eventData(:,2));
    complimented_event = eventData(r,:);
end