function dom = cont_dominant(variables, rel_prop, min_val)
% calculate which cont. variable is dominant in the group
%
% Usage:
% cont_dominant(VARIABLES, REL_PROP, MIN_VAL)
%       For each sample in the continuous variables contained in the cell
%       array VARIABLES, finds out whether one of the variables is
%       dominant.  The return value is a cstream variable containing the
%       index of the dominant one if there is one, or 0 otherwise, for each
%       sample.
%
% VARIABLES is a cell array containing some continuous variables.  They
% must be the same length, and they should have the same time stamps.
%
% To calculate which var is dominant at a given time, we find the variable
% with the maximum value.  If that value is >= MIN_VAL, fine.  We then take
% the sum of all the values at that time, and the maximum value divided by
% the sum must be greater than REL_PROP.  So, to be considered dominant,
% one value must be "big enough" and also be "enough bigger than the
% others".
%
%


% reform the data into an easy to deal with form.
% "values" contains only the value column, from each cont. variable, in the
% same order they came in.
all_together = horzcat(variables{:});
values = all_together(:, 2:2:end);

which_dom = zeros(size(values, 1), 1);

for idx = 1:size(values, 1)
    row = values(idx, :);
    [big_val big_idx] = max(row);
    total = sum(row);
    if (big_val >= min_val) && (big_val / total >= rel_prop)
        which_dom(idx) = big_idx;
    end
    % if not, which_dom(idx) stays 0.
end

dom = horzcat(all_together(:, 1), which_dom);
