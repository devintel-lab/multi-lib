function profile_result = temporal_profile_logical_operation(profile_data1, profile_data2, logical_op)

% profile_data1 = profile_lefthand;
% profile_data2 = profile_righthand;
% logical_op = 'or';

chunk1 = profile_data1.profile_data_mat;
chunk2 = profile_data2.profile_data_mat;
chunk_result = cell(size(chunk1));
num_groups = length(chunk_result);

profile_result = profile_data1;
profile_result.var_name = {profile_data1.var_name profile_data2.var_name};

probs_mean = nan(size(profile_data1.probs_mean_per_instance));

% groups = 
for gidx = 1:num_groups
    tmpmat1 = chunk1{gidx};
    tmpmat2 = chunk2{gidx};
    tmpmat_result = nan(size(tmpmat1));
    mask_nonnan = ~isnan(tmpmat1) & ~isnan(tmpmat2);
    if strcmpi(logical_op, 'or')
        tmpmat_result(mask_nonnan) = tmpmat1(mask_nonnan) | tmpmat2(mask_nonnan);
    elseif strcmpi(logical_op, 'and')
        tmpmat_result(mask_nonnan) = tmpmat1(mask_nonnan) & tmpmat2(mask_nonnan);
    end
    chunk_result{gidx} = tmpmat_result;
    
    num_valid_data = sum(~isnan(tmpmat_result), 2);
    num_matches = sum(tmpmat_result > 0 & tmpmat_result < 2, 2);
    probs_mean(:, gidx) = num_matches ./ num_valid_data;
end

profile_result.profile_data_mat = chunk_result;
profile_result.probs_mean_per_instance = probs_mean;
profile_result.logical_op = logical_op;