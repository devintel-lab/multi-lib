function [newindexList] = findFix1(txy,thred, minDur)

% This function decompose xy cont data into fixations according to velocity
% threshold. Also, each fixation lasts >= minDur
% 
% Inputs:   
%	txy:	[time cont_eye_x cont_eye_y velocity], Nx4
%   thred:	velocity threshold for decomposing into fixations
%   minDur:	minimun duration for fixation.
% 
% Outputs:
%   newindexList:   a list of onset and offset indexes for each fixation,
%                   n*2
% 
%
% Original Author   : Chen Yu, Sean Matthews
%                       Indiana University 



isIn = 0;
nDur = 0;

%problem with this code- thred could be set so high (especially for the low
%threshold) that we never enter the first if statement below and then list
%gets undefined
%possible solution- we should always start assuming that each block is a
%fixation
for i = 1 : size(txy,1)
   % if ((txy(i,4) <= thred) && (isIn ==0)) %tom made change below
    if (((txy(i,4) <= thred) && (isIn ==0)) ) ||(i==1)
        nDur = nDur + 1;
        isIn = 1;
        list(nDur,1) = txy(i,1);
        indexList(nDur,1) = i; 
    %end;Tom changed this as well
    elseif (((txy(i,4) > thred) || (isnan(txy(i,4)))) && (isIn == 1)) 
        isIn = 0;
        list(nDur,2) = txy(i-1,1);
        indexList(nDur,2) = i-1; 
    end;
end;

% in case it is an open-end
if (isIn == 1)
   list(nDur,2) = txy(end,1);
   indexList(nDur,2) = size(txy,1);  
end;


% generates a list that only contains valid durations
newlist = [];
newindexList = [];
for i = 1:(size(list,1))
    if (list(i,2) - list(i,1)) > minDur
        newlist = [newlist; list(i,1), list(i,2)];
        newindexList = [newindexList; indexList(i,1), indexList(i,2)];
        
    end
end;


