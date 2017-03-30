function make_joint_inhand_both(IDs)
subs = cIDs(IDs);

for s = 1:numel(subs)
    fprintf('%d\n', subs(s));
    try
    num_obj = get_num_obj(subs(s));
    lc = get_variable(subs(s), 'cstream_inhand_left-hand_obj-all_child');
    rc = get_variable(subs(s), 'cstream_inhand_right-hand_obj-all_child');
    lp = get_variable(subs(s), 'cstream_inhand_left-hand_obj-all_parent');
    rp = get_variable(subs(s), 'cstream_inhand_right-hand_obj-all_parent');

    all = [lc(:,2) rc(:,2) lp(:,2) rp(:,2)];
    final = cell(num_obj, 1);
    for o = 1:num_obj
        log = all == o;
        tmp = (log(:,1) | log(:,2)) & (log(:,3) | log(:,4));
        tmp_f = zeros(size(tmp));
        tmp_f(tmp) = o;
        final{o,1} = tmp_f;
    end
    
    final = horzcat(final{:});
    if max(sum(final>0, 2)) > 1
        warning('%d has overlapping events', subs(s));
        cevents = [];
        for o = 1:size(final,2)
            tmp = cstream2cevent([lc(:,1) final(:,o)]);
            cevents = [cevents;tmp];
        end
        cevents = sortrows(cevents, [1 2 3]);
        final = cevent2cstream_v2(cevents, [], [], lc(:,1));
    else
        final = [lc(:,1) sum(final,2)];
    end
    record_variable(subs(s), 'cstream_inhand_joint-holding_both', final);
    cev = cstream2cevent(final);
    record_variable(subs(s), 'cevent_inhand_joint-holding_both', cev);
    catch ME
        fprintf('%d, %s\n', subs(s), ME.message);
    end
end



end