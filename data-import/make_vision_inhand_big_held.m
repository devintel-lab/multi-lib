function make_vision_inhand_big_held(IDs, dominantorbig, obj_list)
%finds moments when object is big in child view and also agent's hand
subs = cIDs(IDs);
agents = {'child', 'parent'};
for s = 1:numel(subs) % cycle through subjects
    for a = 1:2 % cycle through two agents
        agent = agents{a};
        if has_variable(subs(s), sprintf('cstream_vision_size_obj-%s_child', dominantorbig)) % check to see vars exist
            dom = get_variable(subs(s), sprintf('cstream_vision_size_obj-%s_child', dominantorbig)); % get dominant vision var
            var = sprintf('cstream_inhand_left-hand_obj-all_%s', agent); 
            left = get_variable(subs(s), var); % get left hand
            right = get_variable(subs(s), strrep(var, 'left', 'right')); % get right hand
            
            % check to see that cstream lengths are equal, if not, convert
            %to cevents then back to cstreams with a set timebase. The
            %timebase is arbitrarly set to the be timeseries for left hand.
            if ~isequal(size(dom,1), size(left,1), size(right,1))
                fprintf('%d: cstreams not of equal length\n', subs(s));
                all = {dom, left, right};
                timebase = left(:,1);
                cstreams = cell(3,1);
                for f = 1:3
                    cev = cstream2cevent(all{f});
                    cstreams{f,1} = cevent2cstream_v2(cev, [], [], timebase);
                end
                dom = cstreams{1};
                left = cstreams{2};
                right = cstreams{3};
            else
                timebase = left(:,1);
            end
            fcev = cell(length(obj_list),1);
            
            for o = obj_list % cycle through each object
                log_dom = dom(:,2) == o; % when object o is big
                log_left = left(:,2) == o; % when in left hand
                log_right = right(:,2) == o; % when in right hand
                together = log_dom & (log_left | log_right); % when big and in either hand
                part = zeros(length(together),1);
                part(together) = o; % now reassign the ones to o
                fcst = [timebase part]; % put the timebase back with the category column
                fcev{o,1} = cstream2cevent(fcst); % convert this to cevents
            end
            cev = vertcat(fcev{:}); % put all cevents together
            cev = sortrows(cev, [1 2 3]); % sort all of the cevents based on time
            rname = sprintf('cevent_vision-inhand_obj-%s-%s-held_child', dominantorbig, agent); % save
            record_variable(subs(s), rname, cev);
            cst = cevent2cstream_v2(cev, [], [], timebase); % convert to cstream
            record_variable(subs(s), strrep(rname, 'cevent' ,'cstream'), cst); % save
        end
    end
end

end