function data = remove_loss_tracking(data,exList)

% This function remove eye tracking data that is out of range
% called by function VelocityAndDistanceThresholdFixations
% 
% Inputs:   
%	data:	[time cont_eye_x cont_eye_y], Nx3
%   exList: indexes for all the valid eye tracking data, N*1
% 
% Outputs:
%   data:   valid eye tracking data, [cont_eye_x cont_eye_y time], Nx3

n = size(data,1);
index = 0; 
for i = 1 : n
    if (ismember(i, exList) ~= 1)
        index = index+1;
        data1(index,:) = data(i,:);
    end;
end;
data = data1;