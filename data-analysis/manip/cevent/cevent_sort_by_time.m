function results = cevent_sort_by_time(cevent_in, refer_column)
% Sorts the cevent according to a specified time column

if refer_column > 2
    error('Invalid REFER_COLUMN value!');
end

[temp_v temp_idx] = sort(cevent_in(:, refer_column));
results = cevent_in(temp_idx, :);