function make_joint_eye_inhand(IDs, corp)
%corp is mapping function from eye to hand; [1] means child-child, [2]
%means parent-parent, and [1 2] means child-child, parent-parent, child-parent 
%as well as parent-child

subs = cIDs(IDs);

person = {'child' 'parent'};

for s = 1:numel(subs)
    for p = 1:numel(corp)
        personID = person{corp(p)};
        if has_variable(subs(s), ['cstream_eye_roi_' personID])
            for a = 1:numel(corp)
                eye_data = get_variable(subs(s), ['cstream_eye_roi_' personID]);
                agentID = person{corp(a)};
                for o = 1:5
                    varname = sprintf('cstream_inhand_obj%d_%s', o, agentID);
                    if has_variable(subs(s), varname)
                        data = get_variable(subs(s), varname);
                        data(data(:,2) > 0, 2) = o;
                        if o == 1
                            inhand_data = data;
                        else
                            inhand_data = cat(2, inhand_data, data(:,2));
                        end
                    end
                end
                if ~isempty(inhand_data)
                    %check to see eye data and inhand data are the same size
                    if size(inhand_data, 1) ~= size(eye_data, 1)
                        %rescale by converting to cevent then back to cstream
                        eye_cev = cstream2cevent(eye_data);
                        eye_data = cevent2cstream_v2(eye_cev, 1, [1 2], inhand_data(:,1));
                    end
                    
                    %see where eye data matches inhand data
                    match = zeros(size(inhand_data, 1), 3);
                    for o = 1:size(inhand_data(:,2:end),2)
                        match_tmp = eye_data(:,2) ~= inhand_data(:,o+1);
                        match(:,o) = eye_data(:,2);
                        match(match_tmp,o) = 0;
                        log = eye_data(:,2) == 0;
                        match(log, o) = 0;
                    end
                    recdata = [eye_data(:,1) sum(match, 2)];
                    recname = sprintf('cstream_inhand-eye_%s-%s', agentID, personID);
                    record_variable(subs(s), recname, recdata);
                    %convert to cevent
                    
                    recdata = cstream2cevent(recdata);
                    recname = strrep(recname, 'cstream', 'cevent');
                    record_variable(subs(s), recname, recdata);
                end
            end
        end
    end
end
end