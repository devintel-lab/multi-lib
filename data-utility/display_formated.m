function display_formated(data, len_decimal)
% This function will display a matrix of numbers in a formated way. The
% user can specify the number of decimal digits to display.

if nargin < 2
    len_decimal = 4;
end

[num_rows, num_cols] = size(data);

for ridx = 1:num_rows
    for cidx = 1:num_cols
        fprintf(['%.' int2str(len_decimal) 'f  '], data(ridx, cidx));
    end
    fprintf('\n');
end