function event_sampled = cont_sampled_intervals(cont, max_gap, no_data_value, sample_duration)
%cont_sampled_intervals finds all intervals when data exists in given var.
% USAGE:
% cont_sampled_intervals(CONT_VAR)
%   Finds all time periods (no matter how small) during which data exists
%   in the given CONT_VAR.
%
% cont_sampled_intervals(CONT_VAR, MAX_GAP)
%   Same as cont_sampled_intervals(CONT_VAR), but will overlook MAX_GAP *
%   the sample interval worth of missing data without calling it a
%   discontinuity.  The default MAX_GAP is 1 sample.
%
% cont_sampled_intervals(CONT_VAR, MAX_GAP, NO_DATA_VALUE)
%   Finds all time periods during which data exists in the given CONT_VAR,
%   treating data equal to NO_DATA_VALUE as missing.
%
% cont_sampled_intervals(CONT_VAR, MAX_GAP, NO_DATA_VALUE, SAMPLE_DURATION)
%   Same as cont_sampled_intervals(CONT_VAR, NO_DATA_VALUE), but treats
%   SAMPLE_DURATION as the interval between samples that are contiguous.
%   Otherwise, the mode(diff(timestamps)) is treated as the sample
%   interval.
%

if nargin > 1
    gap = max_gap;
else
    gap = 1;
end

if nargin > 2
    missing = cont(:, 2:end) == no_data_value;
    data = cont(~ missing, :);
else
    data = cont;
end

if nargin > 3
    interval = sample_duration;
else
    interval = mode(diff(cont(:, 1)));
end

tol = interval * 0.0001;

times = data(:, 1);

% breaks contains the linear indices of the differences that are greater
% than interval+tol.  Since diff(x) has one fewer element than x, this is
% the linear index of the last contiguous value in the times array.
breaks = find(diff(times) > ((gap * interval) + tol));

% finds the *indices* of the time stamps of the event.
indices = zeros(length(breaks) + 1, 2);
last_bound = 0;
for I = 1:length(breaks)
    indices(I, 1) = last_bound + 1;
    indices(I, 2) = breaks(I);
    
    last_bound = breaks(I);
end
% Wrap up the loop: add the last interval
indices(end, 1) = last_bound + 1;
indices(end, 2) = length(times);


% Event intervals are half-open intervals
out(:, 1) = times(indices(:, 1));
out(:, 2) = times(indices(:, 2)) + interval - tol;


event_sampled = out;