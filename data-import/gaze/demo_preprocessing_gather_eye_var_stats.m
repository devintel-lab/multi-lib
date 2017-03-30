clear all;

exp_id = 34;
agent = 'child';
% agent = 'child';

[sub_list_has_var, range_w, range_h] = preprocess_gather_eye_var_stats(exp_id, agent);
a = [sub_list_has_var range_h range_w]