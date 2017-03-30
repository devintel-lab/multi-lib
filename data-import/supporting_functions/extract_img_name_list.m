function [img_name_list seq] = extract_img_name_list(img_name_list, img_step, seq_pos_idx, min_img_seq, max_img_seq)
% This function will go through a list of file structures and extract image
% sequence number and sort it with increasing order.

if ~exist('img_step', 'var')
    img_step = 1;
end

if ~exist('seq_pos_idx', 'var')
    seq_pos_idx = -1;
end

n = length(img_name_list);

% get file sequence No. 
seq = NaN(n, 1);

for i=1:n
    fname = img_name_list(i).name;
    
    s = regexp(fname, '[_.]', 'split');
    seq(i) = str2double(s{end + seq_pos_idx});
end

[seq index] = sort(seq);
img_name_list = img_name_list(index);

if ~exist('max_img_seq', 'var')
    max_img_seq = max(seq);
end

if ~exist('min_img_seq', 'var')
    min_img_seq = min(seq);
end

index = ismember(seq, min_img_seq:img_step:max_img_seq);
seq = seq(index);
img_name_list = img_name_list(index);

end
