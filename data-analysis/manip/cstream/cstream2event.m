function event = cstream2event(cstream, categories)
% cstream2event converts cstream data to a single event variable
%
%   USAGE:
%   cstream2event(cstream)
%       Make a new event variable.  The events are the times when the
%       cstream's value is not equal to zero.
%
%   cstream2event(cstream, categories)
%       Make a new event variable.  The events are the times when the
%       cstream's value is one of the values in CATEGORIES.
%
%   If you use this function on cont data, that's probably fine, it will
%   just set the event to true when the value is not equal to zero.  Of
%   course, with floating-point data, equality is hard to come by, so you
%   might want to use cont2cevent instead.  See also: CONT2CEVENT
%
% Example:
%
% >> cstream = [1 1; 2 1; 3 2; 4 2; 5 2; 6 0; 7 0; 8 3];
% >> cstream2event(cstream)
% ans =
%      1     6
%      8     9
% 
% >> cstream2event(cstream, [0 1])
% ans =
%      1     3
%      6     8
% 


if nargin == 2
    bin_stream = [ cstream(:, 1)  ismember(cstream(:, 2), categories) ];
else
    bin_stream = [ cstream(:, 1)  (cstream(:, 2) ~= 0) ];
end

cevent = cstream2cevent(bin_stream, 1);
event = cevent(:, 1:2);
    


