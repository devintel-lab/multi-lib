
vars = {'cont_eye_x_child', 'cont_eye_y_child', 'cont_eye_x_parent', 'cont_eye_y_parent'};
subjs_list = list_subjects([29 32 34 35 36]);


subjs_list_full = find_subjects(vars, [29 32 34 35 36]);

num_subjs = length(subjs_list);
num_subjs_full = length(subjs_list_full);

    
eye_x_child = get_variable_by_subject(subjs_list_full, vars{1});
eye_y_child = get_variable_by_subject(subjs_list_full, vars{2});
eye_x_parent = get_variable_by_subject(subjs_list_full, vars{3});
eye_y_parent = get_variable_by_subject(subjs_list_full, vars{4});
    



for i = 1:num_subjs_full
    
    temp_results = [subjs_list_full(i) eye_x_child{i}(1,:) eye_y_child{i}(1,:) ...
        eye_x_parent{i}(1,:) eye_y_parent{i}(1,:)];
    results(i,:) = temp_results;    
    
    
end

    
    
    