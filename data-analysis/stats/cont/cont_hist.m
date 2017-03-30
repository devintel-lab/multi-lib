function [N,X] = cont_hist(data, param, flag)
% Return the histogram of the cont data.
%   [N,X] = cont_hist(data, param, flag)
%   The meaning of N and X and the PARAM are same with that of the matlab function, hist.
%   flag: 
%      flag == 'separate', the histogram is calculated for each column of data separatedly
%      flag == 'whole',    the histogram is calculated for the whole set of data
% Examples:
%   N =  cont_hist(var);
%   [N, X] = cont_hist(var, [0 100 200 300 400]);
%   [N, X] = cont_hist(var, 20);
%   [N, X] = cont_hist(var, [0 100 200 300], 'whole');
%
% HIST's parameters are bin centers.  If it makes more sense to specify bin edges,
% see HISTC and CONT_HISTC.
%
% See also: HIST, CONT_HISTC, HISTC
%
if ~exist('flag', 'var')
    flag = 'separate';
end

if exist('param', 'var') && ~isempty(param)
    [N,X] = hist(data(:,2:end), param);
else
    [N,X] = hist(data(:,2:end));
end

if strcmp(flag, 'whole')
    N = sum(N,2);
elseif ~strcmp(flag, 'separate')
    error ['Wrong valude for parameter "flag" -- ', flag];
end

return;
