function extended = cont_pad_with_nans(realdata)
% Fill in gaps in cont or cstream data using NaN
%
% Conservatively evaluates a cont or cstream variable.  If it contains gaps
% that are longer than a tolerance times the sampling period of the
% variable, it fills in that gap with NaNs.
%
%
% >> cont_test = [1 10; 2 20; 3 30; 4 40; 5 50; 6 60; 7 70; 8 80];
% >> cont_pad_with_nans(cont_test)
% ans =
%   1 10
%   2 20
%   3 30
%   4 40
%   5 50
%   6 60
%   7 70
%   8 80
% >> cont_pad_with_nans(cont_test([1 2 3 5 6], :))
% ans =
%   1 10
%   2 20
%   3 30
%   4 NaN
%   5 50
%   6 60
%
%
% >> cont_pad_with_nans([cont_test; 9.5 95])
% Warning: Strange gap length ***
%
% >> cont_pad_with_nans(cont_test([1 3 4 6 7 8], :))
% ans =
%   1 10
%   2 NaN
%   3 30
%   4 40
%   5 NaN
%   6 60
%   7 70
%   8 80
%
%

%
tolerance = 0.1;

period = median(diff(realdata(:, 1)));

gap_starts = find(diff(realdata(:, 1)) > (1+tolerance) * period);

extended = realdata;

amount_filled = 0;

for G = 1:length(gap_starts)
    gap_start = gap_starts(G);
    output_gap_start = gap_start + amount_filled;
    gap_length = diff(realdata(gap_start:gap_start+1, 1));
    gap_num_periods = gap_length / period;
    gap_num_whole_periods = round(gap_num_periods);
    if abs(gap_num_whole_periods - gap_num_periods) > tolerance
        warning('cont_pad_with_nans:irregular_sampling', ...
            'Strange gap length of %f: %f times period (%f)', ...
            gap_length, gap_num_periods, period);
    end
    
    % imagine you count from 1 to 3 skipping 2.  Then period is 1, you miss
    % two periods, but you only need to add one new entry
    num_fillers = gap_num_whole_periods - 1; 
    
    filler = realdata(gap_start, 1) + (1:num_fillers)' * period;
    filler(:, 2) = NaN;
    extended = [extended(1:output_gap_start, :); ...
        filler; ...
        extended(output_gap_start+1:end, :)];
    amount_filled = amount_filled + num_fillers;
end

