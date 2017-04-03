function filtered = func_filter ( F, input )
%Return rows of INPUT where F returns true
%   func_filter(FUNCTION, ARRAY)
%       Run FUNCTION on each row of ARRAY, returning all rows where
%       FUNCTION returns true.
%
%   Similar to the SCHEME function FILTER, func_filter runs F (which could
%   be an anonymous function) on each row of the array INPUT.  If F returns
%   a true value, that row of INPUT is copied to the output.  If not, it is
%   skipped.
%
%   The row of INPUT is passed to F as a one-row array with as many columns
%   as there are in INPUT.
%
%   If no rows are selected, returns the empty array [].
%
%   Example:
%   >> x = [1; 2; 3; 4; 5; 6];
%   >> func_filter(@isprime, x)
%   ans =
%        2
%        3
%        5

in_dims = size(input);

filtered = zeros(0, in_dims(2));
empty = filtered;

% For each row in INPUT...
filtidx = 1;
for idx = 1:in_dims(1)
    if F(input(idx, :))
       filtered(filtidx, :) = input(idx, :);
       filtidx = filtidx + 1;
    end
end

% if none were found, make the result 0x0 rather than 0xN.
if size(filtered) == size(empty)
    filtered = [];
end

    
