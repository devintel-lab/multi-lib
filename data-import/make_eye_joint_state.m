function make_eye_joint_state(IDs, obj_list)
% calculate joint state of eyes 
% 1 jointly attending to the same object
% 2 parent face/child object
% 3 child face/parent object
% 4 mutual gaze
% 5 different objects
% 6 parent object/child somewhere else
% 7 child object/parent somewhere else
% 8 both somewhere else
% 9 parent face/child somewhere
% 10 child face/parent somewhere

if numel(num2str(IDs(1))) > 2
    subs = IDs;
else
    subs = list_subjects(IDs);
end

var_list = {'cstream_eye_roi_child','cstream_eye_roi_parent'}; 
sub_list = subs;
if ~exist('obj_list', 'var') || isempty(obj_list)
    obj_list = [1 2 3];
end
obj_roi_min = min(obj_list);
obj_roi_max = max(obj_list); 
face_roi = 4; 

for i = 1 : size(sub_list,1)
  sub_id = sub_list(i);
  
  new_data = [] ; 
  
  x1 = get_variable(sub_id, var_list{1});
  x2 = get_variable(sub_id, var_list{2});
  
  all_data = align_streams(x1(:,1), {x1,x2});
  
  new_data = zeros(size(x1));
  
  new_data(:,1) = x1(:,1);
  
  index = find(all_data(:,1) == 0 & all_data(:,2) == 0);
  new_data(index,2) = 8;
  
  index = find(all_data(:,1) == 0 & all_data(:,2) == face_roi);
  new_data(index,2) = 9;
  
  index = find(all_data(:,1) == face_roi & all_data(:,2) == 0);
  new_data(index,2) = 10;
  
  index = find(all_data(:,1) == face_roi & all_data(:,2) == face_roi);
  new_data(index,2) = 4;
  
  index = find(all_data(:,1) == face_roi & all_data(:,2)>=obj_roi_min & all_data(:,2) <= ...
                obj_roi_max);
  new_data(index,2) = 3;
    
  index = find(all_data(:,2) == face_roi & all_data(:,1)>=obj_roi_min & all_data(:,1) <=obj_roi_max);
  new_data(index,2) = 2;
  
  index = find(all_data(:,1) == 0 & all_data(:,2)>=obj_roi_min & all_data(:,2) <= ...
                obj_roi_max);
  new_data(index,2) = 6;
    
  index = find(all_data(:,2) == 0 & all_data(:,1)>=obj_roi_min & all_data(:,1) <= obj_roi_max);
  new_data(index,2) = 7;
  
  index = find(all_data(:,2) == all_data(:,1) & all_data(:,1)>=obj_roi_min & all_data(:,1) <= ...
                obj_roi_max);
  new_data(index,2) = 1;
  
  index = find(all_data(:,2)>=obj_roi_min & all_data(:,2) <= ...
                obj_roi_max & all_data(:,2) ~= all_data(:,1) & all_data(:,1)>=obj_roi_min & all_data(:,1) <= ...
                obj_roi_max);
  new_data(index,2) = 5;
  
  
  file_name1 = sprintf('cstream_eye_joint-state_both');
  file_name2 = sprintf('cevent_eye_joint-state_both');
  record_variable(sub_id,file_name1,new_data);
  new_data2 = cstream2cevent(new_data);
  record_variable(sub_id,file_name2,new_data2);
end;


