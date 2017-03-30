function [matrix condi_p_row, condi_p_col] = cstream_bigram_matrix(cstream, flag_draw)
% cstream_bigram_matrix   Generate a bigram matrix of the input cstream. 
%                         Bigram is two consecutive symbols in the given cstream.
%
% matrix = cstream_bigram_matrix(cstream);
%
% [matrix condi_p_row condi_p_col] = cstream_bigram_matrix(cstream);
%
% [matrix condi_p_row condi_p_col] = cstream_bigram_matrix(cstream, flag_draw);
% 
% cstream:     n*2 matrix; thr first column is time stamp and the seond column
%              is category data.
% flag_draw:   ture - draw the figures of three output matrix; 
%              false - don't draw them.
% matrix:      Each element in the bigram matrix is the count of corresponding brigram.
%              For example, if matrix(3,7) = 14, the bigram, '37', appears 14 tims in the given cstream.
% condi_p_row: the conditional probablity, p(X2|X1), where X1X2 is bigram in
%              cstream and X1 appears right before X2.
% condi_p_col: the conditional probablity, p(X1|X2), where X1X2 is bigram in
%              cstream and X1 appears right before X2.
% 

% check for special cases
if isempty(cstream)
    matrix = {};
    condi_p_row = {};
    condi_p_col = {};
    return;
end

if ~exist('flag_draw','var')
    flag_draw = false;
end

data = cstream(:,2);

if min(data) < 0
    error('cstream should not contain value that is less than 0');
end

% calculate bigram frequency matrix from data ( cstream(:,2) )
matrix = get_bigram_matrix(data);

% calculate conditonal probability from bigram frequency matrix
[condi_p_row condi_p_col] = get_condi_p(matrix);

% draw figures;
if flag_draw
    draw_matrix(matrix, 'bigram frequency');
    draw_matrix(condi_p_row, 'conditional probability for each row');
    draw_matrix(condi_p_col, 'conditional probability for each column');
end

end % function cstream_bigram_matrix

% calculate bigram frequency matrix from data
function matrix = get_bigram_matrix(data)
cnum = max(data);
matrix = zeros(cnum, cnum);
for i=2:length(data)
    if data(i-1) > 0 && data(i) >0   % 0 means no data or we don't care about it.
        matrix(data(i-1),data(i)) = matrix(data(i-1),data(i)) + 1;
    end
end
end

% calculate conditonal probability from bigram frequency matrix
function [condi_p_row condi_p_col] = get_condi_p(matrix)
row_sum = sum(matrix, 2);
col_sum = sum(matrix, 1);
[row_num col_num] = size(matrix);

condi_p_row = matrix ./ repmat(row_sum,1,col_num);
condi_p_col = matrix ./ repmat(col_sum,row_num,1);
end

% draw figure for a matrix
function draw_matrix(matrix, map_title)
figure;
imshow(matrix);
title(map_title);
end
