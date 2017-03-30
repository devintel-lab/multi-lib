function [velocity] = calVelocity(txy)

% This function calculate velocities based on cont_eye_x and cont_eye_y.
% 
% Inputs:   
%	txy:	[time cont_eye_x cont_eye_y], N by 3
% 
% Outputs:
%   velocity:   velocity at each point in txy, N by 1


completionnum = size(txy,1);
velocity = nan(completionnum, 1);

for i = 2:completionnum
    velocity(i) = (sqrt(((txy(i,2) - txy(i-1,2))^2) + ...
        ((txy(i,3) - txy(i-1,3))^2))/(txy(i,1) - txy(i-1,1))); % calculates distance
    if (txy(i,1) - txy(i-1,1)) > 2
        velocity(i) = NaN;
    end
end