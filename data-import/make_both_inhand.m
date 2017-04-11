function make_both_inhand(IDs)
% finds when both hands are touching the same object

subs = cIDs(IDs);
agents = {'child', 'parent'};
for s = 1:numel(subs)
    for a = 1:2
        if all(cellfun(@(a) has_variable(subs(s), a), {sprintf('cstream_inhand_left-hand_obj-all_%s'...
                ,agents{a}), sprintf('cstream_inhand_right-hand_obj-all_%s',agents{a})}))
            gt = get_variable(subs(s), 'cstream_trials');
            left = get_variable(subs(s), sprintf('cstream_inhand_left-hand_obj-all_%s', agents{a}));
            right = get_variable(subs(s), sprintf('cstream_inhand_right-hand_obj-all_%s', agents{a}));
            [gt,left,right] = align_cstreams(gt,left,right);
            both = [left(:,2) right(:,2)];
            log = both(:,1) ~= both(:,2);
            both(log,:) = 0;
            both_hands = [left(:,1) both(:,1)];
            single = [left(:,2) right(:,2)];
            log = log == 0;
            single(log,:) = 0;
            cevl = cstream2cevent([left(:,1) single(:,1)]);
            cevr = cstream2cevent([left(:,1) single(:,2)]);
            cevlr = sortrows(cat(1, cevl, cevr), [1 2 3]);
            
            record_variable(subs(s), sprintf('cstream_inhand_both-hand_%s', agents{a}), both_hands);
            cev_both_hands = cstream2cevent(both_hands);
            record_variable(subs(s),sprintf('cevent_inhand_both-hand_%s', agents{a}), cev_both_hands);
            
            record_variable(subs(s), sprintf('cevent_inhand_single-hand_%s', agents{a}), cevlr);
        end
    end
end