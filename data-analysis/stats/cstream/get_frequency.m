function res = get_frequency(vec)
%This function generates frequency f from category stream s in descending order
% s - category stream without timestamp
% e.g.
%       32
%       33
%       33
%       17
%       17
%       33
%       33
%       33
%       34
%       34
%       33
%       32
%       16
% f - frequency of category in descending order  (symbol, cnt)
%    0  762
%    2  282
%   16  282
%    8  237
%   18  190
%   17  186
%    4  185
%    1  176
%   32  113
%   34  106
%   10   91
%
% example)
% f1 = get_frequency(s1(:,2)')


[b m n] = unique(sort(vec),'last'); % m is the last index of each value. freq(i) = m(i) - m(i-1) 
m1 = circshift(m,[0 1]); m1(1) = 0; 
res = [b' [m - m1]'];

% sort by descending order of column 2
res = sortrows(res,-2);

