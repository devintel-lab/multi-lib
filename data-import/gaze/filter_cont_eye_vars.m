function filter_cont_eye_vars(sid)
%% Filtering invalid eye datapoints.
% PosSci bounds: x=0-640 y=0-480
% LASA bounds: x=0-384 y=0-470
% This will take the cont2_eye_xy, cont_eye_x, and cont_eye_y and turn
% invalid datapoints into NaN values.

% Updated by txu@indiana.edu on Feb 6, 2013, add the step of rescaling
% old eye_xy data from [w=640 h=480] to [w=720, h=480]has been applied to 
% exp32, 34, 35 [3501-3512]
% mlelston@indiana.edu, subjects that generated after 3517, raw eye data 
% is already [w=720, h=480]

% get cont2_child_eye_xy and filter
if has_variable(sid, 'cont2_eye_xy_child')
    cont2_child_xy = get_variable(sid, 'cont2_eye_xy_child');

    % x bounds
    cont2_child_xy(cont2_child_xy(:,2) > 720, 2:3) = NaN;
    cont2_child_xy(cont2_child_xy(:,2) < 0, 2:3) = NaN;
            
    % y bounds
    cont2_child_xy(cont2_child_xy(:,3) > 480, 2:3) = NaN;
    cont2_child_xy(cont2_child_xy(:,3) < 0, 2:3) = NaN;

    % Save xy
    record_variable(sid, 'cont2_eye_xy_child', cont2_child_xy);
    % Save x
    cont_child_x = cont2_child_xy(:,1:2);
    record_variable(sid, 'cont_eye_x_child', cont_child_x);
    % Save y
    cont_child_y = [cont2_child_xy(:,1) cont2_child_xy(:,3)];
    record_variable(sid, 'cont_eye_y_child', cont_child_y);
else
    fprintf('\ncont2_eye_xy_child does not exist for sub %d\n', sid);
end

if has_variable(sid, 'cont2_eye_xy_parent')
    % get cont2_parent_eye_xy and filter
    cont2_parent_xy = get_variable(sid, 'cont2_eye_xy_parent');
  
    % x bounds
    cont2_parent_xy(cont2_parent_xy(:,2) > 720, 2:3) = NaN;
    cont2_parent_xy(cont2_parent_xy(:,2) < 0, 2:3) = NaN;
        
    % y bounds
    cont2_parent_xy(cont2_parent_xy(:,3) > 480, 2:3) = NaN;
    cont2_parent_xy(cont2_parent_xy(:,3) < 0, 2:3) = NaN;
        
    % Save xy
    record_variable(sid, 'cont2_eye_xy_parent', cont2_parent_xy);
    % Save x
    cont_parent_x = cont2_parent_xy(:,1:2);
    record_variable(sid, 'cont_eye_x_parent', cont_parent_x);
    % Save y
    cont_parent_y = [cont2_parent_xy(:,1) cont2_parent_xy(:,3)];
    record_variable(sid, 'cont_eye_y_parent', cont_parent_y);
else
    fprintf('\ncont2_eye_xy_parent does not exist for sub %d\n', sid);
end

