function make_inhand_joint_state_holding(IDs)
if numel(num2str(IDs(1))) > 2
    subs = IDs;
else
    subs = list_subjects(IDs);
end

sub_list = subs;

for s = 1 : numel(sub_list)
    sub = sub_list(s);
    inhand_child = []; inhand_parent =[];
    
    inhand_child = cell2mat(get_variable_by_cevent(sub,'cevent_inhand_child', ...
                                              'cevent_inhand_joint-state_both',[3]));
    inhand_child = cevent_remove_small_segments(inhand_child,0.01);
    var_name = 'cevent_inhand_child-only_child';
    record_variable(sub, var_name, inhand_child);
    
    inhand_parent = cell2mat(get_variable_by_cevent(sub,'cevent_inhand_parent', ...
                                              'cevent_inhand_joint-state_both',[2]));
    inhand_parent = cevent_remove_small_segments(inhand_parent,0.01);
    var_name = 'cevent_inhand_parent-only_parent';
    record_variable(sub, var_name, inhand_parent);

    
    inhand_child = cell2mat(get_variable_by_cevent(sub,'cevent_inhand_child', ...
                                              'cevent_inhand_joint-state_both',[4]));
    inhand_child = cevent_remove_small_segments(inhand_child,0.01);
    var_name = 'cevent_inhand_both-holding_child';
    record_variable(sub, var_name, inhand_child);

    
    inhand_parent = cell2mat(get_variable_by_cevent(sub,'cevent_inhand_parent', ...
                                              'cevent_inhand_joint-state_both',[4]));
    inhand_parent = cevent_remove_small_segments(inhand_parent,0.01);
    
    var_name = 'cevent_inhand_both-holding_parent';
    record_variable(sub, var_name, inhand_parent);

    
    
end;
