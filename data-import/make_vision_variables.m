function make_vision_variables(IDs, obj_list, agents)
%agents is optional and should be cell of strings. Default is {'child' 'parent'};

if numel(num2str(IDs(1))) > 2
    subs = IDs;
else
    subs = list_subjects(IDs);
end

if ~exist('agents', 'var') || isempty(agents)
    agents = {'child', 'parent'};
end

obj_num = max(obj_list);

seg_image_overwrite_flag = true;
is_record_vision_vars = true;
is_record_eye_vars = false;
seg_image_format = 'png';
for s = 1:numel(subs)
    sub_id = subs(s);
    for a = 1:numel(agents)
        agent_type = agents{a};
        if strcmp(agent_type, 'child')
            if ismember(sub2exp(sub_id), [14 16 17 18 23 28])
                target_cam = 'cam01';
            else
                target_cam = 'cam07';
            end
            dest_cam = 'cam01';
            
        elseif strcmp(agent_type, 'parent')
            if ismember(sub2exp(sub_id), [14 16 17 18 23 28])
                target_cam = 'cam02';
            else
                target_cam = 'cam08';
            end
            dest_cam = 'cam02';
        elseif strcmp(agent_type, 'topdown')
            target_cam = 'cam09';
            dest_cam = 'cam09';
        end
        
        obj_params = get_object_hsv_parameters(sub2exp(sub_id), sub_id);
        
        eye_var_name = ['cont2_eye_xy_' agent_type];
        if ~has_variable(sub_id, eye_var_name)
            fprintf('Subject %d does not have variable cont2_eye_xy_%s\n', sub_id, agent_type)
            is_record_eye_vars = false;
        end
        if obj_num == 5
            main_create_vision_vars_5(sub_id, target_cam, dest_cam, agent_type, obj_num, obj_params, is_record_vision_vars, is_record_eye_vars, seg_image_overwrite_flag, seg_image_format)
%             main_create_vision_eye_vars_5(sub_id, target_cam, dest_cam, agent_type, obj_num, obj_params, is_record_vision_vars, is_record_eye_vars, seg_image_overwrite_flag, seg_image_format);
        elseif obj_num == 3
            main_create_vision_eye_vars_3(sub_id, target_cam, dest_cam, agent_type, obj_num, obj_params, is_record_vision_vars, is_record_eye_vars, seg_image_overwrite_flag, seg_image_format);
        end
    end
end
end