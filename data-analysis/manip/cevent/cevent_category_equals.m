function out = cevent_category_equals( cevent, categories )
%Makes a cevent variable with only some of the instances in the input cevent
%   USAGE:
%   cevent_category_equals(CEVENT, CATEGORIES)
%       Finds all the events in CEVENT that have their categories equal to
%       one of the numbers in CATEGORIES (which could be just a single
%       number), and returns a new cevent variable with only those instances.
%
%   CEVENT should be a cevent variable.
%
%   CATEGORIES should be a single integer, or a list of integers, which are
%   the categories in CEVENT that you want to preserve.
%
%   The return value is a single cevent variable.
%

out = cevent(ismember(cevent(:, 3), categories), :);

