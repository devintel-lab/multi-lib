function test = make_vision_joint_obj_size_dist(IDs)
%finds moments when child and parent are both looking at the largest object
%in both views as well as most centered object in both views
%subexpID is list of experiments or subjects

subs = cIDs(IDs);

%keep the order of these names
variable_list = {'cont_vision_size' 'cont_vision_min-dist'};
rec_var_names = {'cstream_vision_joint-obj-size_both' 'cstream_vision_joint-obj-dist_both'};

%all data goes into test structure that will be returned by function
test = cell(1,numel(subs)*numel(variable_list));
for s = 1:numel(subs)
    for v = 1: numel(variable_list)
        all_data_c = [];
        all_data_p = [];
        for o = 1:5
            varname_c = sprintf('%s_obj%d_child', variable_list{v}, o);
            varname_p = sprintf('%s_obj%d_parent', variable_list{v}, o);
            if has_variable(subs(s), varname_c) && has_variable(subs(s), varname_p)
                data_c = get_variable(subs(s), varname_c);
                data_p = get_variable(subs(s), varname_p);
                %check cstream alignment
                if size(data_c, 1) ~= size(data_p, 1)
                    %convert to cevent then back to cstream
                    p_cev = cstream2cevent(data_p);
                    data_p = cevent2cstream_v2(p_cev, 1, [1 2], data_c(:,1));
                end
                if o == 1
                    all_data_c = data_c;
                    all_data_p = data_p;
                else
                    all_data_c = cat(2, all_data_c, data_c(:,2));
                    all_data_p = cat(2, all_data_p, data_p(:,2));
                end
            end
        end
        if ~isempty(all_data_c) && ~isempty(all_data_p)
            if ~isempty(strfind(varname_c, 'min'))
                [~, index_c] = min(all_data_c(:,2:end), [], 2);
                [~, index_p] = min(all_data_p(:,2:end), [], 2);
            else
                [~, index_c] = max(all_data_c(:,2:end), [], 2);
                [~, index_p] = max(all_data_p(:,2:end), [], 2);
            end
            log = sum(all_data_c(:,2:end),2) == 0;
            index_c(log) = 0;
            log = sum(all_data_p(:,2:end),2) == 0;
            index_p(log) = 0;
            combined = [index_c index_p]; %tests cstream alignment, error if not aligned
            same = index_c ~= index_p;
            combined(same,1) = 0;
            log = index_c == 0;
            combined(log,1) = 0;
            recdata = [all_data_c(:,1) combined(:,1)];
            test{(s-1)*numel(variable_list) + v} = recdata;
            recname = rec_var_names{v};
            record_variable(subs(s), recname, recdata);
            %convert to cevent
            recdata = cstream2cevent(recdata);
            recname = strrep(recname, 'cstream', 'cevent');
            record_variable(subs(s), recname, recdata);
        end
    end
end
end