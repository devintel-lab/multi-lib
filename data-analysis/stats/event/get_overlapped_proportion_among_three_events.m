%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the proportion of overlappaed part with three events
% Input: Three events (head, hand, and eye timestamps) :: (event start time, event end time)
% Output: Sum of overlapped event duration
% Author: Seehyun Kim
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function sum_event_duration = get_overlapped_proportion_among_three_events(indic1, indic2, indic3)

first_overlapped_event_part = event_AND(indic1, indic2);
total_overlapped_event_part = event_AND(first_overlapped_event_part, indic3);

duration = zeros(1,1);
sum_event_duration = 0;

if total_overlapped_event_part == 0
    sum_event_duration = 0;
else
    for j = 1:size(total_overlapped_event_part,1)
        duration(j,1) = total_overlapped_event_part(j,2) - total_overlapped_event_part(j,1);
        sum_event_duration = sum_event_duration + total_overlapped_event_part(j,2) - total_overlapped_event_part(j,1);
    end
end
