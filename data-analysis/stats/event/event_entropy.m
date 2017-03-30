function e = event_entropy_of_lengths(data)
% event_entropy_of_lengths(EVENT_DATA) 
%
% This function takes a sequence of eye fixations (cevent) and treats each
% instance in a cevent as a distinct category. In this way, the whole cevent is
% viewed as a distribution and event lengths are viewed a probability. The
% function then calculates the entropy of the whole cevent. The idea is to
% capture the dynamics of cevent, both the number of instances and the lengths
% of those instances. 


p = data(:,2) - data(:,1);
p = p ./sum(p);
e = -sum(log2(p) .* p);

