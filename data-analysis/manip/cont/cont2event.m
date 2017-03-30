function event_data = cont2event(var_data, param)
% cont2event  Covert cont data to event data
%    USAGE:
%    bevent_data = cont2event(var_data, param)
%    Input: 
%      var_data: data of cont variable. 
%      param: parameter structure
%          param.threshold:
%          param.flag:  'above' or 'below'
%
%    Example: 
%    event_data = cont2event(cont_data, struct('threshold', 40, ...
%    'flag', 'above'); % to the event when the value of cont_data >
%    param.threshold
%
%    event_data = cont2event(cont_data, struct('threshold', 40,  ...
%    'flag', 'below'); % to the event when the value of cont_data <
%    param.threshold  
%
threshold = param.threshold;
flag = param.flag;
bin_data = var_data;

switch lower(flag)
    case 'above'
        bin_data(:,2) = var_data(:,2) > threshold;
    case 'below'
        bin_data(:,2) = var_data(:,2) < threshold;
end

event_data =  binary2event(bin_data);

