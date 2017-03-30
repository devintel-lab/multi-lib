function [events category_id] = cstream2events(cstream)
% cstream2events  Make a set of events data. 
%                 Each is from a category of cstream data
%
% events = cevent2events(cstream);
%
% [events category_id] = cstream2events(cstream);
% 
% events is a cell array, in which each element is a event data converted from a category of cevent data
%
cevent = cstream2cevent(cstream);
[events category_id] = cevent2events(cevent);