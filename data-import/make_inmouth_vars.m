function make_inmouth_vars(IDs)

subs = cIDs(IDs);

for s = 1:numel(subs)
    data = [];
    for o = 1:3
        varname = sprintf('cstream_inmouth_obj%d_child', o);
        if has_variable(subs(s), varname)
            tmp = get_variable(subs(s), varname);
            if isempty(data)
                data = tmp;
            else
                data = [data tmp(:,2)];
            end
        end
    end
    if ~isempty(data)
        cat = sum(data(:,2:end), 2);
        if max(cat) > 3
            error('max greater than 3');
        end
        final = [data(:,1) cat];
        record_variable(subs(s), 'cstream_inmouth_obj-all_child', final);
        cev = cstream2cevent(final);
        record_variable(subs(s), 'cevent_inmouth_obj-all_child', cev);
    end
    
    data2 = [];
    for i = 1:3
        varnames = {'cstream_inmouth_parent_child'; 'cstream_inmouth_self_child'; 'cstream_inmouth_other_child'};
        if has_variable(subs(s), varnames{i})
            tmp2 = get_variable(subs(s), varnames{i});
            if isempty(data2)
                data2 = tmp2;
            else
                data2 = [data2 tmp2(:,2)];
            end
        end
    end
        
    if ~isempty(data2)
        cat = sum(data2(:,2:end), 2);
        if max(cat) > 6
            error('max greater than 6');
        end
        final = [data2(:,1) cat];
        record_variable(subs(s), 'cstream_inmouth_other-all_child', final);
        cev = cstream2cevent(final);
        record_variable(subs(s), 'cevent_inmouth_other-all_child', cev);
    end
    
    data3 = [];
    for v = 1:6
        varnames2 = {'cstream_inmouth_obj1_child'; 'cstream_inmouth_obj2_child'; 'cstream_inmouth_obj3_child'; 'cstream_inmouth_self_child'; 'cstream_inmouth_parent_child'; 'cstream_inmouth_other_child'};
        if has_variable(subs(s), varnames2{v})
            tmp3 = get_variable(subs(s), varnames2{v});
            if isempty(data3)
                data3 = tmp3;
            else
                data3 = [data3 tmp3(:,2)];
            end
        end
    end
        
    if ~isempty(data3)
        cat = sum(data3(:,2:end), 2);
        if max(cat) > 6
            error('max greater than 6');
        end
        final = [data3(:,1) cat];
        record_variable(subs(s), 'cstream_inmouth_all_child', final);
        cev = cstream2cevent(final);
        record_variable(subs(s), 'cevent_inmouth_all_child', cev);
    end
        
end
