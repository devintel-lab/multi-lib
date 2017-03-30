function newList = decompose_big_fix(data, fix1, lowThresh, sample_rate)

% This function decompose xy cont data into fixations according to velocity
% threshold. Also, each fixation lasts >= minDur
% 
% Inputs:   
%	data:       [time cont_eye_x cont_eye_y velocity], Nx4
%   fix1:       start index and end index for one big fixation from first step
%   lowThresh:	velocity threshold to decompose fixation.
% 
% Outputs:
%   newList:   a list of onset and offset indexes for each fixation,
%              n*2

% apply the low threshold with the minimum duration
fix3 = findFix1(data(fix1(1):fix1(2),:), lowThresh, sample_rate*2)+fix1(1)-1;

if isempty(fix3)
    newList = [];
else
    newList = fix3(:,1:2);
end
