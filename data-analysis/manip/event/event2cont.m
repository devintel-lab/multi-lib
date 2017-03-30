function cont_data = event2cont(event_data)
%event2cont  Convert (binary) event data to cont data
% All times when the event occurs will be 1's in the cont stream,
% other times will be 0.
% cont_data = event2cont(event_data);
%
cont_data = cstream2cont( event2cstream(event_data) );
