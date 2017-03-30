function make_synched_attention(IDs)
% calculate synched attention: rois in the two streams are exactly same
if numel(num2str(IDs(1))) > 2
    subs = IDs;
else
    subs = list_subjects(IDs);
end
var_list = {'cstream_eye_roi_child','cstream_eye_roi_parent'}; 
sub_list = subs;

for i = 1 : numel(sub_list)
    sub_id = sub_list(i);
    if has_all_variables(sub_id, var_list)
        x1 = get_variable(sub_id, var_list{1});
        x2 = get_variable(sub_id, var_list{2});
        
        all_data = align_streams(x1(:,1), {x1,x2});
        
        new_data = zeros(size(x1));
        
        new_data(:,1) = x1(:,1);
        
        index1 = find(all_data(:,1) == all_data(:,2));
        index2 = find(all_data(:,1) ~= 0);
        index = intersect(index1,index2);
        size(index)
        new_data(index,2) = x1(index,2);
        size(x1)
        
        
        file_name1 = sprintf('cstream_eye_synched-attend_both');
        file_name2 = sprintf('cevent_eye_synched-attend_both');
        record_variable(sub_id,file_name1,new_data);
        new_data2 = cstream2cevent(new_data);
        record_variable(sub_id,file_name2,new_data2);
    end
end;


