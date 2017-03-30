function [p] = cstream_proportion_matching(data, value)
% Finds the proportion of times when the value of the cstream is the given
% value.
%
% USAGE:
% cstream_proportion_matching(CSTREAM_DATA, VALUE)
%
% Does a simple calculation based on the number of samples with and without
% the given value.  That means that if there are intervals with no samples,
% they won't be taken into account at all.
%

if isempty(data)
    p = NaN; % 0 / 0 is NaN
    return
end

index = find(data(:,2) == value);
p = size(index,1)/size(data,1);

