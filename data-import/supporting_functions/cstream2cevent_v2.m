function cevents = cstream2cevent_v2(cstream, include_zero)
%all output cevents have durations > 0;
%e.g. the following where a cevent is only one frame will be excluded 
%t1 t2 cat
%5  5  3
%does not have max_gap parameter;
%
%robust to cstreams that are not continuous, such as concatenated cstreams that
%are only in-trial.
if ~exist('include_zero', 'var') || isempty(include_zero)
    include_zero = 0;
end

if isempty(cstream)
    cevents = [];
    return;
end

%make sure cstream data is in order
c = sortrows(cstream,1);

%turn all NaN values into zeros
c(isnan(c(:,2)), 2) = 0;

%find diff of second column to find points that change cat values
diffc = diff(c(:,2));
log = find(diffc ~= 0);
if isempty(log)
    log = [];
end
%find diff of first column to find dicontinuous time series
diffc = diff(c(:,1));
logfirst = find(diffc > 3*mode(diffc));
% logfirst = find(diffc > 0.1); %check for 0.1 second gap

%warn if the discontinuity is very small, which means the above line should
%read diffc > a*mode(diffc)), where a > 1
% if ~isempty(logfirst)
%     %warning('Warning: identified discontinuity in cstream, with a gap greater than two time steps');
%     margins = diffc(logfirst,1) - 3*mode(diffc);
%     if min(margins) < 3*mode(diffc)
%         warning('Warning: identified discontinuity, but it is less than one time step');
%     end
% end

%add logfirst to log
log = [log;logfirst];
log = unique(log); %do not want to double count log and logfirst in previous line
log = sort(log, 'ascend');
if isempty(log)
    log = 0;
end
%add idx 1
if ~isempty(log)
    if log == 0
        log1 = [];
    else
        log1 = log; %log1 is index into cstream for cevent offsets
    end
    log = log + 1;
    if log(1) ~= 1;
        log = [1;log]; %[1:log] is index into cstream for cevent onsets
    end
    
    
    cevents = zeros(numel(log), 3); %creates placeholder
    
    cevents(:,1) = cstream(log, 1); %assigns cevent onsets
    cevents(:,2) = [cstream(log1, 1); cstream(end,1)]; %assigns cevent offsets
    cevents(:,3) = cstream(log, 2);%assigns category values
    
    if ~include_zero
        log = cevents(:,3) == 0;
        cevents(log,:) = [];
    end
    
    %remove zero durations cevents
    dur = cevents(:,2) - cevents(:,1);
    log = dur == 0;
    
    cevents(log,:) = [];
else
    cevents = [];
end

end