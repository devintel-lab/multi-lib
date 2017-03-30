function [match, idx1, log2] = intersect_order(sub_list1, sub_list2)
% [match, idx1, log2] = intersect_order(sub_list1, sub_list2)
% like intersect, but retains order of sublist2;
% match is the intersection of sublist1 and sublist2;
% match has the same order as sublist2
% idx1 is list of indices such that sublist1(idx1) = match;
% log2 is a logical such that sublist2(log2) = match;

s1 = sub_list1;
s2 = sub_list2;

[log2,b] = ismember(s2, s1);
idx1 = b(log2);

match = s1(idx1);
end