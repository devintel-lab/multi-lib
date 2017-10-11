% This is a demo script for showing how to use different functions on
% variable operation:
%   - how to get variable in folders other than /derived, for example,
%       /extra_p
%   - how to backup variables for safety purpose
%   - how to delete variables (remove unwanted variables from /derived to
%       extra_p for archiving)
%   - how to recover variables (find the most recent archived copy and move
%       it back to /derived)

clearvars;

%%%%%%%%%%%%%%%%%% Get Extra Variable %%%%%%%%%%%%%%%%%%
sub_id = 7006; % user can input a list of subjects or experiments
varname = 'cont_motion_x_head_child';
force_fetch = false; % meaning if this variable does not exist, you will get an error, not an empty matrix
source_dir = 'extra_p';
extra_var = get_variable(sub_id, varname, force_fetch , source_dir);

%%%%%%%%%%%%%%%%%% Variable Back Up %%%%%%%%%%%%%%%%%%
% Function backup_variables will create back up copies of the variable file
% and place them under folder: /extra_p/archive_-MM-DD-YYYY (MM-DD-YYYY is current year month and date)
vars_backup = {'cevent_eye_roi_child', 'cevent_eye_roi_parent'};
backup_variables(sub_id, vars_backup);

%%%%%%%%%%%%%%%%%% Delete Variable %%%%%%%%%%%%%%%%%%
% Function delete_variables will remove the list of variables from /derive folder and create a back-up copy of them
% by using function backup_variables
vars_delete = {'cevent_test_ja_both'};
delete_variables(sub_id, vars_delete);

%%%%%%%%%%%%%%%%%% Recover Deleted Variable %%%%%%%%%%%%%%%%%%
vars_recover = {'cevent_test_ja_both'};
recover_variables(sub_id, vars_recover)