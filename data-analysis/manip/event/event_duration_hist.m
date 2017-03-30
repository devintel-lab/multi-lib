function [histogram bins] = event_duration_hist(event_var, bins, args)
% A histogram of the duration of the events in an event variable
%
%   USAGE:
%   [histogram bins] = event_duration_hist(event_var)
%       Returns the histogram or the durations, and a list of the bin
%       centers used in the calculation.
%
%   histogram = event_duration_hist(event_var, bins)
%       Returns the histogram created by using the numbers in BINS as bin
%       centers.
% 
%   histogram = event_duration_hist(event_var, bins, 'centers')
%       Returns the histogram created by using the numbers in BINS as bin
%       centers.
% 
%   histogram = event_duration_hist(event_var, bins, 'thresholds')
%       Returns the histogram created by using the numbers in BINS as bin
%       thresholds.
%
%   See also: HIST
    
durations = event_var(:, 2) - event_var(:, 1);

if nargin < 2
    [histogram bins] = hist(durations);
elseif nargin == 2
    [histogram bins] = hist(durations, bins);
else
    if strcmp(args, 'centers')
        [histogram bins] = hist(durations, bins);
    elseif strcmp(args, 'thresholds')
        histogram = zeros(1, length(bins));

        for i = 2:length(bins)
            lower = bins(i-1);
            upper = bins(i);
            x_within = durations >= lower & durations < upper;
            histogram(i-1) = sum(x_within);
        end

        x_within = durations >= upper;
        histogram(end) = sum(x_within);
    end
end
