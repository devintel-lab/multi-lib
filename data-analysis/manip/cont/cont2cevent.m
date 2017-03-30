function cevent_data = cont2cevent(var_data, bins, max_gap)
%cont2cevent   Convert cont variable to cevent one
%  cevent_data = cont2cevent(var_data, bins);
%    var_data: cont data to be converted
%    bins: bin_num*1 vector, specifying the minimum value to go in the bin
%    cevent_data: generated cevent data
%    max_gap:  The maximum gap allowable in converting cont to cevent data.
%    cstream2cevent has a default max_gap of 1 second.
%
%  Example:  cont2cevent(var_data, [0 100 200 300 400 500]);
%

if (nargin < 3)
    max_gap = 1;
end

bin_num = length(bins)+1;
var_leng = size(var_data,1);

event_series = zeros(var_leng,2);
event_series(:,1) = var_data(:,1);
for j = 1:bin_num-1
    mask = var_data(:,2) >= bins(j);
    event_series(mask,2) = event_series(mask,2) + 1;
end

cevent_data = cstream2cevent(event_series); % max gap is now initiated in cstream2cevent
