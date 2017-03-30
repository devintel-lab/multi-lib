%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the proportion of overlappaed part with three events
% There are eight possibilities to represent whole cases
% Input: Three events (head, hand, and eye timestamps) :: (event start time, event end time)
% Output: Each proportion for eight possibilities
% 0 represents stationary / 1 indicates moving
% 000, 001, 010, 100, 011, 110, 101, 111
% Author: Seehyun Kim
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function proportion__overlap_part = get_all_overlapped_proportions_among_three_events(indicator1, indicator2, indicator3)

temp = [indicator1(1,1), indicator2(1,1), indicator3(1,1)];
minTime = min(temp);
temp = [indicator1(size(indicator1,1),2), indicator2(size(indicator2,1),2), indicator3(size(indicator3,1),2)];
maxTime = max(temp);

% Get Complimented Event
comp_indic1 = event_NOT(indicator1, [minTime maxTime]);
comp_indic2 = event_NOT(indicator2, [minTime maxTime]);
comp_indic3 = event_NOT(indicator3, [minTime maxTime]);

prop_event_duration = zeros(8,1);
% 000
sum_event_duration = get_overlapped_proportion_among_three_events(comp_indic1, comp_indic2, comp_indic3);
prop_event_duration(1,1) = sum_event_duration / maxTime;

% 001
sum_event_duration = get_overlapped_proportion_among_three_events(comp_indic1, comp_indic2, indicator3);
prop_event_duration(2,1) = sum_event_duration / maxTime;

% 010
sum_event_duration = get_overlapped_proportion_among_three_events(comp_indic1, indicator2, comp_indic3);
prop_event_duration(3,1) = sum_event_duration / maxTime;

% 100
sum_event_duration = get_overlapped_proportion_among_three_events(indicator1, comp_indic2, comp_indic3);
prop_event_duration(4,1) = sum_event_duration / maxTime;

% 011
sum_event_duration = get_overlapped_proportion_among_three_events(comp_indic1, indicator2, indicator3);
prop_event_duration(5,1) = sum_event_duration / maxTime;

% 110
sum_event_duration = get_overlapped_proportion_among_three_events(indicator1, indicator2, comp_indic3);
prop_event_duration(6,1) = sum_event_duration / maxTime;

% 101
sum_event_duration = get_overlapped_proportion_among_three_events(indicator1, comp_indic2, indicator3);
prop_event_duration(7,1) = sum_event_duration / maxTime;

% 111
sum_event_duration = get_overlapped_proportion_among_three_events(indicator1, indicator2, indicator3);
prop_event_duration(8,1) = sum_event_duration / maxTime;

proportion__overlap_part = prop_event_duration;
