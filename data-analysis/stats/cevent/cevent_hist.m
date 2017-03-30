function [hist] = cevent_hist(cevent)
% cevent_hist calculates the histogram of accumulated times of a cevent
% variable for each category in this variable
% Input:
%   cevent: a cevent variable with three columns
% Output:
%   hist: Nx3, the histgram of n categories, the list is sorted.
%       each row is formatted: [accumulated_time category proportion] 
%

list = sort(unique(cevent(:,3)));

for i = 1 : size(list,1)
    index = find(cevent(:,3) == list(i)); 
    hist(i,1) = sum(cevent(index,2) - cevent(index,1));
end;
hist(:,2) = list;
hist(:,3) = hist(:,1)/sum(hist(:,1));

   
