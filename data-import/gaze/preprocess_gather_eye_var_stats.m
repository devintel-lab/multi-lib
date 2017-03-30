function [sub_list_has_var, range_w, range_h] = preprocess_gather_eye_var_stats(exp_id, agent)

sub_list = list_subjects(exp_id);

var_name_eye_x = ['cont_eye_x_' agent];
var_name_eye_y = ['cont_eye_y_' agent];
var_name_eye_xy = ['cont2_eye_xy_' agent];
has_all_eye_vars = false(length(sub_list), 1);

var_data_eye_x = cell(length(sub_list), 1);
var_data_eye_y = cell(length(sub_list), 1);
is_xy2_match_xy = false(length(sub_list), 1);

for sidx = 1:length(sub_list)
% sidx = 2;
    sub_id = sub_list(sidx);
    
    has_all_vars = true;
    
    if ~has_variable(sub_id, var_name_eye_x)
        has_all_vars = false;
        fprintf('\n%s does not exist for sub %d\n', var_name_eye_x, sub_id);
    end
    
    if ~has_variable(sub_id, var_name_eye_y)
        has_all_vars = false;
        fprintf('\n%s does not exist for sub %d\n', var_name_eye_y, sub_id);
    end
    
    if ~has_variable(sub_id, var_name_eye_xy)
        has_all_vars = false;
        fprintf('\n%s does not exist for sub %d\n', var_name_eye_xy, sub_id);
    end
    
    if has_all_vars
        has_all_eye_vars(sidx) = true;
        
        data_x_one = get_variable(sub_id, var_name_eye_x);
        data_y_one = get_variable(sub_id, var_name_eye_y);
        data_xy_one = get_variable(sub_id, var_name_eye_xy);

    %     is_match_one = true;

        mask_match_x = data_x_one(:,2) == data_xy_one(:,2);
        mask_match_y = data_y_one(:,2) == data_xy_one(:,3);
        is_match_x = (sum(mask_match_x) + sum(isnan(data_x_one(:,2) ))) == length(mask_match_x);
        is_match_y = (sum(mask_match_y) + sum(isnan(data_y_one(:,2) ))) == length(mask_match_y);
        if is_match_x && is_match_y
            is_xy2_match_xy(sidx) = true;
        else
            fprintf('\neye xy data doesnot match x y data sub %d\n', sub_id);
        end
        
        if max(data_x_one(:,2)) <= 640
            fprintf('\ncont2_eye_x <= 640 %d\n', sub_id);
        end

        var_data_eye_x{sidx} = data_x_one;
        var_data_eye_y{sidx} = data_y_one;
    end
end

var_data_eye_x = var_data_eye_x(has_all_eye_vars);
var_data_eye_y = var_data_eye_y(has_all_eye_vars);

results_x = cont_cal_stats(var_data_eye_x);
results_y = cont_cal_stats(var_data_eye_y);

sub_list_has_var = sub_list(has_all_eye_vars);
range_w = [results_x.individual_min results_x.individual_max];
range_h = [results_y.individual_min results_y.individual_max];
