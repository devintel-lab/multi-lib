function newCont = cont_time_shift(cont, offset)
%cont_time_shift shifts the timestamps for a cont variable by OFFSET.
% Usage:
% cont_time_shift(cont, offset)


% the same with cstream time shift 
%
newCont = cstream_time_shift(cont, offset); 
