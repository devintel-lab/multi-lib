function res = cevent2cstream(cevent,start_time,interval,default, end_time)
% cevent2cstream   Generte stream from event
%
% Warning:
% Note that this is a lossy conversion: if there are overlapping events in
% the cevent, then only one of them will come through in the cstream.
%
% res = cevent2cstream(cevent,start_time,interval,default)
% cevent:  input cevent data
% start_time: the timestamp when the converted cstream starts.
% interval: the interval between two consecutive time stamps of converted
%           cstream data.
% default:  the default value for converted cstream data
% end_time: (optional) the timestamp when the converted cstream ends.
% res:      the converted cstream
%
% Example 1:
% s = cevent2cstream(cevent_speech,results(sbjID).speechTime,0.001,0);
%
% Was: Copy from Ikhyun's function, make_cstream_from_cevent. Feb 19, 2009
% Now: calls ruj_cevent2cstream because the old version had a floating
% point error accumulation error
%
if ~exist('end_time', 'var')
    end_time = cevent(end,2);
end

if ~exist('default', 'var')
    default = 0;
end

res = ruj_cevent2cstream(cevent, start_time:interval:end_time, default);


