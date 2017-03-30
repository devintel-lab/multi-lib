function make_joint_eye_inhand_smart_room(subexpIDs)
subs = cIDs(subexpIDs);
agents = {'child', 'parent'};
for s = 1:numel(subs)
    sub = subs(s);
    fprintf('%d\n', sub);
    timebase = get_variable(sub, 'cstream_trials');
    for a = 1:2
        for b = 1:2
            agent1 = agents{a};
            agent2 = agents{b};
            inhandvar1 = sprintf('cevent_inhand_right-hand_obj-all_%s', agent1);
            inhandvar2 = sprintf('cevent_inhand_left-hand_obj-all_%s', agent1);
            eyevar = sprintf('cevent_eye_roi_%s', agent2);
            if has_all_variables(subs(s), {eyevar, inhandvar1, inhandvar2})
                eyedata = get_variable(sub, eyevar);
                inhanddata1 = get_variable(sub, inhandvar1);
                inhanddata2 = get_variable(sub, inhandvar2);
                eyedatacst = cevent2cstreamtb(eyedata, timebase);
                inhanddatacst1 = cevent2cstreamtb(inhanddata1, timebase);
                inhanddatacst2 = cevent2cstreamtb(inhanddata2, timebase);
                
                jointcst = timebase;
                jointcst(:,2) = 0;
                log = ( eyedatacst(:,2) == inhanddatacst1(:,2) ) | ( eyedatacst(:,2) == inhanddatacst2(:,2) );
                jointcst(log,2) = eyedatacst(log,2);
                jointcev = cstream2cevent(jointcst);
                %             vis_cstreams({eyedata, inhanddata, joint});
                %             pause();
                jointname = sprintf('cevent_inhand-eye_%s-%s', agent1, agent2);
                record_variable(sub, jointname, jointcev);
                record_variable(sub, strrep(jointname, 'cevent', 'cstream'), jointcst);
            end
        end
    end
end