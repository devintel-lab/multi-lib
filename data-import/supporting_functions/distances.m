function distances = distances(A, B)
% distances calculates the distance between each pair of vectors.
%
% Usage:
% distances(A, B)
%   For each row in A, takes the corresponding row in B, and calculates the
%   Euclidean distance between the two vectors represented by the rows.  A
%   and B should have the same dimensions, or else B should have the same
%   number of columns in A and one row, in which case the distance from B
%   to each row of A is calculated.
%
% This is performed in a vectorized way, so it should be quite fast.
%

if size(A) == size(B)
    D = A - B;
else
    if size(B, 1) ~= 1
        error('The second arg must be the same size as the first, or have one row.');
    end
    D = bsxfun(@minus, A, B);
end
distances = sqrt(sum(D.*D, 2));
