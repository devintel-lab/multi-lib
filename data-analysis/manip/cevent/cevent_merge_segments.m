function [res] = cevent_merge_segments(cevent, maxGap)
% cevent_merge_segments merges intervals that have a small gap between them
%
% it takes a list of cevent/event instances in a cevent variable and return a new 
% list by merging those instances 1) temproally next to each other 2) with
% a small gap in between and 3) share the same category if it is a cevent. 
% 
% Input:
%   cevent: a cevent/event varible
%   maxGap: in seconds, the length of the longest gap to merge
% Outout:
%   A new cevent/event variable by merging instances with small gaps in between. 

n = 1;
res(n,:) = cevent(1,:);

if (size(cevent,2) == 3)
    isCevent = 1;
else 
    isCevent = 0; 
end;

% i: index in the input
% n: index in the result (increments more slowly than i)
for i = 2 : size(cevent,1)
    if (isCevent == 1)
        if (cevent(i,1) - cevent(i-1,2) <= maxGap) && (cevent(i-1,3) == cevent(i,3))
            res(n,2) = cevent(i,2);
        else
            n = n + 1;
            res(n,:) = cevent(i,:);
        end;
    else
        if (cevent(i,1) - cevent(i-1,2) <= maxGap)
            res(n,2) = cevent(i,2);
        else
            n = n + 1;
            res(n,:) = cevent(i,:);
        end;
    end;

end;
