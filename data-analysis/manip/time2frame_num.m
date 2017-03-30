function [ frame_num ] = time2frame_num( time, timing_info_or_sid )
%Find the frame number that corresponds to the time
%   time2frame_num(TIME, TIMING_INFO)
%       Converts the given timestamp to a frame number,  using the timing
%       information supplied, which should be the result of
%       get_timing(subject_id).
%   time2frame_num(TIME, SUBJECT_ID)
%       Converts the given timestamp to a frame number, by fetching the
%       timing information for the given subject from the disk.  This
%       version of the function is slower, so if you are running it in a
%       long loop, it would be better to fetch the timing information
%       yourself.
%
%   Frame numbers, which are also the row numbers in variables derived from
%   video, correspond to a particular MATLAB timestamp.  This function will
%   find the frame before the event at the given time happened, given the 
%   timing information of a subject (from get_timing()) or a subject_id.
%

if isstruct(timing_info_or_sid)
    timing_info = timing_info_or_sid;
else
    timing_info = get_timing(timing_info_or_sid);
end

camTime = timing_info.camTime;
camRate = timing_info.camRate;

% + 1 because there's no frame 0.
if isfield(timing_info, 'camCountsFromZero') && timing_info.camCountsFromZero
    frame_num = round(camRate * (time - camTime));
else
    frame_num = round(camRate * (time - camTime) + 1);
end

end
