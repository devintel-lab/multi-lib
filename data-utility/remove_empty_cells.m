function full = no_empty(cell_array)
% no_empty removes any elements of a cell array that are empty.
%
% The output is an Nx1 cell matrix, no matter what dimensions the input
% matrix are.  Sorry.

empty = cellfun(@isempty, cell_array);

full = { cell_array{~ empty} }';

