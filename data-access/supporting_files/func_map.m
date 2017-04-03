function results = func_map ( F, input )
%Basically a glorified FOREACH.
%   func_map(FUNCTION, ARRAY)
%       Applies FUNCTION to each row of ARRAY, returning
%       the results in an array with the same number of rows
%       as ARRAY, and as many columns as F returns.
%      
%   FUNCTION must return the same number of values for any input value.
%   FUNCTION should take one argument, which will be a one-row array
%   containing one row from the input ARRAY.

in_dims = size(input);

if length(input) < 1
    results = input;
    return
end

% For each row in INPUT...
for idx = 1:in_dims(1)
    results(idx, :) = F(input(idx, :));
end

    
