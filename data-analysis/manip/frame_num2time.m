function [ time ] = frame_num2time( frame_num, timing_info_or_sid )
%Converts a frame number to a time stamp
%   frame_num2time(FRAME_NUM, TIMING_INFO)
%       Converts the given frame number to a timestamp, using the timing
%       information supplied, which should be the result of
%       get_timing(subject_id).
%   frame_num2time(FRAME_NUM, SUBJECT_ID)
%       Converts the given frame number to a timestamp, by fetching the
%       timing information for the given subject from the disk.  This
%       version of the function is slower, so if you are running it in a
%       long loop, it would be better to fetch the timing information
%       yourself.
%
%   Frame numbers, which are also the row numbers in variables derived from
%   video, correspond to a particular MATLAB timestamp.  This function will
%   calculate that timestamp, given the timing information of a subject
%   (from get_timing()) or a subject_id.
%
%   frame_num2time will always return -1 if the frame number you give it is
%   -1.  This is to preserve the -1 as a marker of an invalid trial.  Frame
%   numbers should never be negative, but if you really want to convert -1,
%   try converting -0.99999999999.
%


if frame_num == -1
    time = -1;
    return
end

if isstruct(timing_info_or_sid)
    timing_info = timing_info_or_sid;
else
    timing_info = get_timing(timing_info_or_sid);
end

camTime = timing_info.camTime;
camRate = timing_info.camRate;

% If there is no frame zero, subtract one from frame_num
% because the first frame is supposed to be at exactly the camera
% start time.
if ~ (isfield(timing_info, 'camCountsFromZero') && timing_info.camCountsFromZero)
    frame_num = frame_num - 1;
end

time = camTime + (frame_num / camRate);

end
