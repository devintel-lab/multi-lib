function newList = merge_small_fix(data, fix1, minDist, minDur)

% This function merge small fixations from second step based on spatial 
% information. if distance between centers of two consecutive fixations
% is <= minDist, then these fixations will be merged into one.
% 
% Inputs:   
%	data:       [time cont_eye_x cont_eye_y velocity], Nx4
%   fix1:       start and end indexes for fixation from second step
%   minDur:     minimun duration for fixation.
%   minDist:    small fixations will be merged if if they are
%               close enough spatially (distance between centers of
%               fixations <= minDist)
% 
% Outputs:
%   newList:   a list of onset and offset indexes for each fixation,
%              n*2

if isempty(fix1)
    error('No fixation found!')
end

fix3 = fix1;

% calculate the center of each segment
for i = 1 : size(fix3,1)
    fix3(i,3) = mean(data(fix3(i,1):fix3(i,2),2)); % mean x
    fix3(i,4) = mean(data(fix3(i,1):fix3(i,2),3)); % mean y
end;

% merge if needed
nFix2 = 1;
fix2(nFix2,:) = fix3(1,:);
for i = 2 : size(fix3,1)
    distance = sqrt((fix3(i,3) - fix2(nFix2,3))^2 + (fix3(i,4) - fix2(nFix2,4))^2);
    if ((distance > minDist) || (fix3(i,1)-fix2(nFix2,2) > 4) || ...
            (sum(sum(isnan(data(fix2(nFix2,2):fix3(i,1),2:3))) > 0))) % do not merge if there is nan
        nFix2 = nFix2 + 1;
        fix2(nFix2,:) = fix3(i,:);
    else
        fix2(nFix2,2) = fix3(i,2);%this does the actual merging if they are close enough
    end;

end;

% remove the fixation that is shorter than the minimum duration
newList = [];
for i = 1:(size(fix2,1))
    if (data(fix2(i,2),1) - data(fix2(i,1),1)) > minDur
        newList = [newList; fix2(i,1), fix2(i,2)];
    end
end
