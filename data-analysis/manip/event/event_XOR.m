function res = event_XOR(event1, event2)
%event_XOR returns the times when exactly one of event1 or event2 is active.
%  to be modified --- the whole set should be set explicitly
%
et_and = event_AND(event1, event2);
et_or  = event_OR(event1, event2);
minTime = et_or(1,1);
maxTime = et_or(event_number(et_or),2);
res = event_AND(event_NOT(et_and,[minTime maxTime]), et_or);
