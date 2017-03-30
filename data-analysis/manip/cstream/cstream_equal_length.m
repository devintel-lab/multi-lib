function [ cstream1 cstream2] = cstream_equal_length(cstream1, cstream2)
%
% the function takes two cstreams that have different lengths and append 0
% on the shorter one so that the two new cstreams have the same length 
%
% Input: two cstream2
% Output: two new cstreams with the same length
%
% If two cstreams have different lengths, this function will pad 0 values
% to the shorter one, so that the two will have the same length.
% this operation is needed in the other to do some pairwise calculations.
% For example, calling cstream_shared to find the shared moments
% 
% 
%

length1 = size(cstream1,1);
length2 = size(cstream2,1);
if (length1 > length2)
    cstream2(length2:length1,1) = cstream1(length2:length1,1);
    cstream2(length2:length1,2) = 0; 
else
    cstream1(length1:length2,1) = cstream2(length1:length2,1);    
    cstream1(length1:length2,2) = 0; 
end;
