function pairs = find_frequent_pairs(matrix, min_support)
% Find frequent pairs from the bigram matrix
%    Bigram is two consecutive symbols in the given cstream.
%
% pairs = find_frequent_pairs(matrix, min_support)
% 
% matrix: bigram matrix, usually calcuated from a cstream
%    Each element in the bigram matrix is the count of corresponding brigram.
%    For example, if matrix(i,j) = 14, category_id(i) = '7' and cagetory_id(j)
%    = '9', the bigram, '79', appears 14 tims in the cstream.
% min_support: the lowest value for the definion of "frequent"
%
% pairs: n*1 cell array, each cell stores row and column indexes of the frequent pairs
%
% See also: CSTREAM_BIGRAM_MATRIX
%
if isempty(matrix)
    pairs = {};
    return;
end

row_num = size(matrix,1);

% TODO: change s = find() call to [I, J] = find() call, to eliminate the
% loop at the end of the function.  FIND can return the subscripts instead
% of the linear indices.

s = find(matrix >= min_support); 
if s > 0
    pairs = cell(length(s),1);
else
    pairs = {};
end

for i = 1:length(s)
    pairs{i} = zeros(1,2);
    pairs{i}(1) = mod  ( s(i)-1, row_num) + 1;  % row idx
    pairs{i}(2) = floor((s(i)-1)/row_num) + 1;  % col idx
end

end
