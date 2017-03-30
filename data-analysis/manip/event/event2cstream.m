function cstream = event2cstream(event,start_time,interval,default, end_time)
%event2cstream: Convert (binary) event data to cstream data
%               All the event will be consider as category 1. 
%
% cstream = event2cstream(event,start_time,interval,default, end_time)
% cevent:  input cevent data
% start_time: the timestamp when the converted cstream starts.
% interval: the interval between two consecutive time stamps of converted
%           cstream data.
% default:  the default value for converted cstream data
% end_time: (optional) the timestamp when the converted cstream ends.
% res:      the converted cstream
%
if ~exist('end_time', 'var')
    cstream = cevent2cstream( event2cevent(event), start_time,interval,default);
else
    cstream = cevent2cstream( event2cevent(event), start_time,interval,default, end_time);
end