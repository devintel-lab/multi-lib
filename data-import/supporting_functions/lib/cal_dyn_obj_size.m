function blob_dyn = cal_dyn_obj_size(obj_num, total_pix, prev_blob_cells, blob_cells) % blob_cells
% This function calculates object size changes between different frames.
% Called by the main_detect_object functions

blob_dyn = nan(1,obj_num+1);

for oidx = 2:(obj_num+1)
    tmp_prev_blob = prev_blob_cells{1, oidx};
    tmp_blob = blob_cells{1, oidx};
    
    tmp_xor = xor(tmp_prev_blob, tmp_blob);
    blob_dyn(oidx) = sum(sum(tmp_xor))/total_pix;
end    