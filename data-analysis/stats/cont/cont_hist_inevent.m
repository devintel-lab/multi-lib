function [N,X] = cont_hist_inevent(cont_data, event_data, param)
% Return the histogram of the cont data within given event.
%   [N,X] = cont_hist_inevent(cont_data, event_data)
%   The meanings of N and X are same with that of the MATLAB function
% HIST.
%
% See also: HIST
%
data_in_event = get_data_in_event(cont_data, event_data);
if exist('param', 'var')
    [N,X] = cont_hist(data_in_event, param);
else
    N = cont_hist(data_in_event);
end
