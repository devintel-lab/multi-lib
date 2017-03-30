function res = event_AND(event1, event2)
%event_AND   Return the intersection of two event data
%
% Not safe for cevents!
% If you want that, try event_extract_ranges (returns events in a cell
% array, which is slightly different; use vertcat(chunks{:}) to get them
% back into one piece). 
% 

res = event_intersection(event1, event2); 
if res == 0
    res = [];
end

if ~isempty(res)
    res = res(res(:,1)~=res(:,2),:);  % delete empty intervals
end

if isempty(res)
    res = [];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the overlappaed parts between two events
% Input: Two events  
% :: consist of (event start time, event end time)
% Output: The overlapped parts
% Author: Seehyun Kim
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function overlapped_event_part = event_intersection(vec1,vec2)

index = 1; indexFirst = 1; indexSecond = 1;    
element = [];

while (indexFirst < (size(vec1,1)+1)) && (indexSecond < (size(vec2,1)+1))
    if (vec1(indexFirst,1) >= vec2(indexSecond,1)) && (vec1(indexFirst,1) <= vec2(indexSecond,2))
        if (vec1(indexFirst,2) >= vec2(indexSecond,1)) && (vec1(indexFirst,2) <= vec2(indexSecond,2))
            element(index,1) = vec1(indexFirst,1);
            element(index,2) = vec1(indexFirst,2);
            index = index + 1;
            indexFirst = indexFirst + 1;
        else
            element(index,1) = vec1(indexFirst,1);
            element(index,2) = vec2(indexSecond,2);
            index = index + 1;
            indexSecond = indexSecond + 1;
        end
    elseif (vec2(indexSecond,1) >= vec1(indexFirst,1)) && (vec2(indexSecond,1) <= vec1(indexFirst,2))
        if (vec2(indexSecond,2) >= vec1(indexFirst,1)) && (vec2(indexSecond,2) <= vec1(indexFirst,2))
            element(index,1) = vec2(indexSecond,1);
            element(index,2) = vec2(indexSecond,2);
            index = index + 1;
            indexSecond = indexSecond + 1;
        else
            element(index,1) = vec2(indexSecond,1);
            element(index,2) = vec1(indexFirst,2);
            index = index + 1;
            indexFirst = indexFirst + 1;
        end
    elseif vec1(indexFirst,1) > vec2(indexSecond,2)
        indexSecond = indexSecond + 1;
    else
        indexFirst = indexFirst + 1;
    end
end

if isempty(element) %|| element == 0
    overlapped_event_part = [];
else
    r = find(element(:,1) ~= element(:,2));
    overlapped_event_part = element(r,:);
end


