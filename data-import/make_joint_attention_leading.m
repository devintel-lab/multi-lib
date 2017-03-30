function allf = make_joint_attention_leading(IDs)

subs = cIDs(IDs);
allf = cell(numel(subs), 1);
for s = 1:numel(subs)
    if all(cellfun(@(a) has_variable(subs(s), a), {'cevent_eye_joint-attend_both','cevent_eye_joint-attend_child-lead_both','cevent_eye_joint-attend_parent-lead_both'}));
        both = get_variable(subs(s), 'cevent_eye_joint-attend_both');
        child = get_variable(subs(s), 'cevent_eye_joint-attend_child-lead_both');
        parent = get_variable(subs(s), 'cevent_eye_joint-attend_parent-lead_both');
        
        child(:,3) = 1;
        parent(:,3) = 2;
        
        tog = cat(1, child, parent);
        tog = sortrows(tog, [1 2 3]);
        final = zeros(size(tog));
        overlap = zeros(size(tog,1), 1);
        agent = overlap;
        for c = 1:size(tog, 1)
            [a,b] = min(abs(both(:,1)-tog(c,2)));
            if a < 1
                if ismember(b, overlap)
                    error('%d overlap detected for event %f %f %d', subs(s), tog(c,1), tog(c,2), tog(c,3));
                else
                    overlap(c,1) = b;
                    final(c,:) = both(b,:);
                    agent(c,1) = tog(c,3);
                end
            end
        end
%         final = sortrows(final, [1 2 3]);
        allf{s,1} = {final tog both};
        clog = agent(agent>0) == 1;
        cfinal = final(clog,:);
        plog = agent(agent>0) == 2;
        pfinal = final(plog,:);
        
        cfinal = sortrows(cfinal, [1 2 3]);
        pfinal = sortrows(pfinal, [1 2 3]);
        
        record_variable(subs(s), 'cevent_eye_joint-attend_child-lead-moment_both', cfinal);
        record_variable(subs(s), 'cevent_eye_joint-attend_parent-lead-moment_both', pfinal);
        base = make_time_base(subs(s));
        ccst = cevent2cstream_v2(cfinal, [],[], base);
        pcst = cevent2cstream_v2(pfinal, [],[], base);
        record_variable(subs(s), 'cstream_eye_joint-attend_child-lead-moment_both', ccst);
        record_variable(subs(s), 'cstream_eye_joint-attend_parent-lead-moment_both', pcst);
    end
end

end