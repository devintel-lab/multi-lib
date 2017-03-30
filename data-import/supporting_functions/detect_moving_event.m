function [events] = detect_moving_event(position, params)
%Detect_moving_event examines position data to return a cevent
%
%[events] = detect_moving_event(position, params)
%
% position:  It can have more than one dimension of position: [t1 x1] or [t1
%   x1 y1] or [t1 x1 y1 z1] or whatever.
% params:  Parameters to detect the movement. 
%     params.thresh_lo:  Lower  threshold of movement. It's in mm/sec or 
%     params.thresh_hi:  Higher threshold of movement. It's in mm/sec or 
%     params.fixation_creep:   It's in mm or degree.
%     params.min_fixation:     It's in second
%     params.fixation_filter:  It's in second
%     params.moving_filter:    It's in second
%  

    speed = cont_speed(position);
    cevent_over = cont2cevent(speed, [-Inf, params.thresh_lo, params.thresh_hi]);


    mvmts_filtered = filter_small_fixations(cevent_over, params.fixation_filter);

    mvmts_merged = merge_multiple_movements(mvmts_filtered);

    fixations_merged = merge_fixations(mvmts_merged, position, params);

    %the merging fixations also deletes short ones.
    fixations_merged = merge_multiple_movements(fixations_merged);

    events = fixations_merged(fixations_merged(:,3)>=2, 1:2);
    events = events( events(:,2) - events(:,1) >= params.moving_filter, :);
end

%% filter small fixations
function [res] = filter_small_fixations(cevent, fixation_filter)
    small_duration = abs(cevent(:, 2) - cevent(:, 1)) < fixation_filter;
    is_fixation = (cevent(:, 3) == 1);
    res = cevent(~(small_duration & is_fixation), :);
end

%% When there is a lot of movement, maybe some is fast and some is slow.
% This merges such a sequence into one "fast" movement so that subsequent
% parts of the algorithm are easier.
function [res] = merge_multiple_movements(cevent)
% i: index in the input
% n: index in the result (increments more slowly than i)
    n = 1;
    res(n,:) = cevent(1,:);
    for i = 2 : size(cevent,1)
        if (cevent(i-1,3) > 1) && (cevent(i,3) > 1)
            % continue the previous one (which is res(n,:))
            res(n,2) = cevent(i,2);
            res(n,3) = max(res(n,3), cevent(i,3));
        else
            % start a new one
            n = n + 1;
            res(n,:) = cevent(i,:);
        end;

    end; % for

end % function

%% merge_fixations    Merges two fixations that are separated by a slow movement, 
%                    if they are not too far apart (fixation_creep)
%
% acts:  The detected movement. cevent;
% position:  The raw positions (of the head/hand ... )
% params:
% 
% merged:  the merged movements
function merged = merge_fixations(acts, position, params)
    FIX = 1;
    %SLOW = 2;
    %FAST = 3;

    % init output
    merged = [];
    merged_idx = 1;

    acts_max = size(acts, 1);
    acts_idx = 1;

    while acts_idx <= acts_max
        % copy the next thing we're working on.
        merged(merged_idx, :) = acts(acts_idx, :);

        if (merged(merged_idx, 3) == FIX)
            % merge until we can't anymore
            while (acts_idx + 2 <= acts_max)
                if (merge_ok(merged(merged_idx, :),    ...
                        acts(acts_idx:acts_idx+2, :),  ...
                        position, params.fixation_creep))
                    merged(merged_idx, 2) = acts(acts_idx+2, 2);
                    acts_idx = acts_idx + 2;
                else
                    break
                end
            end
        end

        % end of loop invariants:
        % acts_idx points to the next act that we haven't dealt with
        % merged_idx points to the next entry in merged, and merged_idx - 1 is
        % an entry that's totally done merging.
        acts_idx = acts_idx + 1;
        if (merged(merged_idx, 3) ~= FIX || ...
                merged(merged_idx, 2) - merged(merged_idx, 1) > params.min_fixation)
            merged_idx = merged_idx + 1;
        end
    end
end

%%
%
%
function ok = merge_ok(cur, to_merge, position, fixation_creep)
    %FIX = 1;
    SLOW = 2;
    %FAST = 3;

    slow_between = (to_merge(2, 3) == SLOW);

    so_far_pos       = cont_extract_ranges(position, cur);
    so_far_center    = cont_mean(so_far_pos{1});
    potential_pos    = cont_extract_ranges(position, to_merge(3, :));
    potential_center = cont_mean(potential_pos{1});
    dist = distances(so_far_center, potential_center);

    not_too_far = (dist <= fixation_creep);

    ok = slow_between && not_too_far;
end

