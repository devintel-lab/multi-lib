
function newCstream = cstream_time_shift(cstream, offset)
%
%  this function shifts the whole cstream by an offset
% 
%   Input: cstream nd an offset in seconds; the offset can be both
%   positive (moving forward) or negative (moving backward). 
%
%   Output: a newCstream 
%
%  this function is useful to shift the whole cstream 
%
%


rate = cstream(2,1) - cstream(1,1); 
n = round(abs(offset)/rate); 
newCstream = zeros(size(cstream)); 
newCstream(:,1) = cstream(:,1);
if (offset > 0 ) 
    newCstream(n+1:end,2) = cstream(1:end-n,2); 
elseif (offset < 0)
    newCstream(1:end-n,2) = cstream(n+1:end,2);
end;


