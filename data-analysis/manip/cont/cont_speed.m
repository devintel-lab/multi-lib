function time_speed = cont_speed(position)
% cont_speed calculates the speed based on a continuous position.
%
%   USAGE:
%   cont_speed(POSITION)
%
%   The input can have more than one dimension of position: [t1 x1] or [t1
%   x1 y1] or [t1 x1 y1 z1] or whatever.
%
%   In the output, the value at time T is the speed in the interval leading
%   up to time T.
%
%   This function takes into account the time interval between subsequent
%   samples, it's not just the derivative of the values.  A division by 0
%   will result if subsequent samples have the same time stamp, remove
%   those cases before passing data to this function.
%
%   The speed for the first sample is defined to equal the speed for the
%   second sample, just so there's a value there.

[missing_last missing_first] = offset_pair(position);

dists = distances(missing_last(:, 2:end), missing_first(:, 2:end));

timedists = distances(missing_last(:, 1), missing_first(:, 1));

speed = dists ./ timedists;

speed = [speed(1); speed];

time_speed = horzcat(position(:, 1), speed);




function [missing_last missing_first] = offset_pair(A)
% offset_pair makes a pair of matrices, used for calculating derivative
%
% The first matrix is missing the last row of the input, and the second
% matrix is missing the first row of the input.  That means that they have
% the same number of rows, and each row in the pair can be compared to see
% the difference between subsequent rows in the input matrix.

missing_last = A(1:end-1, :);
missing_first = A(2:end, :);


function distances = distances(A, B)
% distances calculates the distance between each pair of vectors.
%
% Usage:
% distances(A, B)
%   For each row in A, takes the corresponding row in B, and calculates the
%   Euclidean distance between the two vectors represented by the rows.  A
%   and B should have the same dimensions.
%
% This is performed in a vectorized way, so it should be quite fast.
%


D = A - B;
distances = sqrt(sum(D.*D, 2));
