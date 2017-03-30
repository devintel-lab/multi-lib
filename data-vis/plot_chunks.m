function plot_chunks( chunks )
%PLOT_CHUNKS plots each chunk in a separate graph in one plot window
%   USAGE:
%   plot_chunks(CHUNKS)
%       Plots the continuous or cevent data in each cell in CHUNKS.  Makes
%       a vertical array of plots.
%
%   This function might make it easier to examine the contents of some data
%   you're analyzing.
%
%   See also: CONT_EXTRACT_RANGES, GET_VARIABLE_BY_TRIALS



count = length(chunks);
for I=1:count
    chunk = chunks{I};
    subplot(count, 1, I), plot(chunk(:, 1), chunk(:, 2:end));
end

end
