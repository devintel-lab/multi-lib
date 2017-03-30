
function [score, shift] = cstream_best_overlap(cstream1, cstream2, window)

% this function attempts to align one cstream to the other and finds the
% best overall time shift. 
%
%
% Input: two cstreams 
%        window specifies the max temporal shift since we don't want to get
%        unrealistic warping in time
% Output: overall overlapped score, and the temporal shift for cstream2 to
% best match cstream1. 
%
%

% cstream1 and cstream2 have the same size? 
if (size(cstream1) ~= size(cstream2))
    fprintf(1,'two inputs should have the same size\n');
    score=0; shift = 0; 
    return;
end;

% first check whether cstream1 and cstream2 have the fixed and same
% sampling rate
% there is a numerical resolution problem in matlab, has to use a small
% number to compare two numerical values are the same or not 
rate = cstream1(2,1) - cstream1(1,1); 
if (isempty(find(diff(cstream1(:,1))- rate >= 0.0005)) == 0)
    fprintf(1,'cstream1 sampling timestamps are not fixed\n');
    score=0; shift = 0; 
    return;
end;
if (isempty(find(diff(cstream2(:,1))- rate >= 0.0005)) == 0)
    fprintf(1,'cstream2 sampling timestamps are not fixed\n');
    score=0; shift = 0; 
    return;
end;


% calculate the moving window size 
n = round(window/rate);
window = rate * n; 
data{1} = cstream1;
    
n = 0; 
for i = -window : rate: window 
     n  = n + 1;
    % shift cstream2 by i 
    cstream3 = cstream_time_shift(cstream2, i);
    data{2} = cstream3;
    cstream4 = cstream_shared(data,1);
    res(n,1) = size(find(cstream4(:,2) ~= 0),1);
    res(n,2) = i; 
end;
[score index] = max(res(:,1));
score = score/size(cstream1,1); 
shift = res(index,2); 







