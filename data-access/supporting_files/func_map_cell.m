function results = func_map_cell ( F, input )
% Basically a glorified FOREACH, for a CELL array
%   func_map_cell(FUNCTION, CELL_ARRAY)
%       Applies FUNCTION to each row of CELL_ARRAY, returning
%       the results in a cell array with the same number of rows
%       as CELL_ARRAY, and as many columns as F returns.
%      
%   FUNCTION must return the same number of values for any input value.
%   FUNCTION should take one argument, which will be a one-row array
%   containing one row from the input ARRAY.

in_dims = size(input);

if in_dims(1) == 0
    results = input;
    return
end

% For each row in INPUT...
for idx = 1:in_dims(1)
    results{idx, :} = F(input{idx, :});
end

    
