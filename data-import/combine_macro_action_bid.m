function combine_macro_action_bid(IDs)
subs = cIDs(IDs);

for s = 1:numel(subs)
    data = [];
    for o = 1:3
        varname = sprintf('cstream_macro_direct_action-bid_obj%d_parent', o);
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
        record_variable(subs(s), 'cstream_macro_direct_action-bid_obj-all_parent', final);
        cev = cstream2cevent(final);
        record_variable(subs(s), 'cevent_macro_direct_action-bid_obj-all_parent', cev);
    end
end
end