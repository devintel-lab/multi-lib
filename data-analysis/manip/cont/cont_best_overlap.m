function [score, shift] = cont_best_overlap(cont1, cont2, window)
%cont_best_overlap attempts to align one cont value to the other
%   USAGE:
%   [score, shift] = cont_best_overlap(cont1, cont2, window_size)
%
% cont_best_overlap tries to find the
% best overall time shift to make these two stream overlap.  this function
% takes only two cont streams that have the same size and sampling rate. 
%
% The 'best' overlap is judged by subtracting one stream from the other, and
% the alignment with the minimal distance is chosen as the best one.
%
%
% Input: two cont  
%        window specifies the max temporal shift since we don't want to get
%        unrealistic warping in time
% Output: overall overlapped score, and the temporal shift for cont2 to
% best match cont1. 
%
%

% cont1 and cont2 have the same size? 
if (size(cont1) ~= size(cont2))
    fprintf(1,'two inputs should have the same size\n');
    score=0; shift = 0; 
    return;
end;

% first check whether cont1 and cont2 have the fixed and same
% sampling rate
% there is a numerical resolution problem in matlab, has to use a small
% number to compare two numerical values are the same or not 
rate = cont1(2,1) - cont1(1,1); 
if (isempty(find(diff(cont1(:,1))- rate >= 0.0005)) == 0)
    fprintf(1,'cont1 sampling timestamps are not fixed\n');
    score=0; shift = 0; 
    return;
end;
if (isempty(find(diff(cont2(:,1))- rate >= 0.0005)) == 0)
    fprintf(1,'cont2 sampling timestamps are not fixed\n');
    score=0; shift = 0; 
    return;
end;

% calculate the moving window size 
n = round(window/rate);
window = rate * n; 
    
n = 0; 
for i = -window : rate: window 
    n  = n + 1;
    
    % shift cont2 by i 
    cont3 = cont_time_shift(cont2, i);
    
    % pairwise comparison 
    res(n,1) = sum(abs(cont3(:,2) - cont1(:,2)));
    res(n,2) = i; 
end;
res
[score index] = min(res(:,1));
shift = res(index,2); 







