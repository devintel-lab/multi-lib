function [N,bin] = cont_histc(data, param, flag)
% Return the histogram of the cont data.
%   [N,bin] = cont_histc(data, param)
%   The meaning of N and bin and the PARAM are same with that of the matlab function, histc.
%   flag: 
%      flag == 'separate', the histogram is calculated for each column of data separatedly
%      flag == 'whole',    the histogram is calculated for the whole set of data
% Examples:
%   [N, bin] = cont_histc(var, [0 100 200 300 400]);
%   [N, bin] = cont_histc(var, [0 100 200 300], 'whole');
%
% See also: HISTC, CONT_HIST, HIST
%
if ~exist('flag', 'var')
    flag = 'separate';
end

if exist('param', 'var') 
    [N,bin] = histc(data(:,2:end), param);
else
    error 'HISTC requires bin edge parameters, unlike HIST.'
end

if strcmp(flag, 'whole')
    N = sum(N,2);
elseif ~strcmp(flag, 'separate')
    error ['Wrong valude for parameter "flag" -- ', flag];
end

return;


