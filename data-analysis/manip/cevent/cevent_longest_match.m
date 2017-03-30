function [dur] = cevent_longest_match(data, target)
% return the longest event in a cevent list that matches the category target
% If used without target, return the long duration among any categories
% usage: cevent_longest_match(data, target)

  
if (nargin == 2)
  index = find(data(:,3) == target);
else
  index = [1:size(data,1)];
end;

if isempty(index)
  dur = 0;
else
  length = data(index,2) - data(index,1);
  dur = max(length);
end;

