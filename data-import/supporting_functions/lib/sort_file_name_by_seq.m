function [sorted_list sorted_seq] = sort_file_name_by_seq(file_list, seq_pos_idx)
if ~exist('seq_pos_idx', 'var')
    seq_pos_idx = -1;
end

n = length(file_list);

% get file sequence No. 
seq = NaN(n, 1);
for i=1:n
    fname = file_list(i).name;
    
    s = regexp(fname, '[_.]', 'split');
    seq(i) = str2double(s{end + seq_pos_idx});
end

[sorted_seq idx] = sort(seq);
sorted_list = file_list(idx);

end
 