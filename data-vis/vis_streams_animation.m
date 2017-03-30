function vis_streams_animation(subexpIDs, varList, labels, camIDs)
% cut table to be more accurate
if ischar(subexpIDs)
    switch subexpIDs
        case 'demo1'
            close all;
            subexpIDs = 72;
            varList = {'cstream_eye_roi_child'};
            labels = {'ceye'};
            camIDs = [];
    end
end
varListrequired = {
    'cont3_motion_pos_head_child' % 1 2 3
    'cont3_motion_pos_head_parent' % 4 5 6
    'cont3_motion_pos_left-hand_child' % 7 8 9
    'cont3_motion_pos_right-hand_child' % 10 11 12
    'cont3_motion_pos_left-hand_parent' % 13 14 15
    'cont3_motion_pos_right-hand_parent'
    'cstream_eye_roi_child'
    'cstream_eye_roi_parent'
    'cstream_inhand_left-hand_obj-all_child'
    'cstream_inhand_right-hand_obj-all_child'
    'cstream_inhand_left-hand_obj-all_parent'
    'cstream_inhand_right-hand_obj-all_parent'};

h = figure('position', [50 100 960 540]);
m = figure('position', [1025 564 560 420]); % motion
b = figure('position', [1026 100 284 372]); % frames
z = figure('position', [1325 100 483 371]);

h.UserData.idx = 1;
[subs,~,subpaths] = cIDs(subexpIDs);

% varCheck = cat(1, varListrequired, varList);
log1 = cellfun(@(a) has_all_variables(a, varList), subpaths);
log2 = cellfun(@(a) has_all_variables(a, varListrequired), subpaths);
log = log1 & log2;
h.UserData.subs = subs(log);
h.UserData.subpaths = subpaths(log);
h.UserData.numsubs = length(h.UserData.subs);
h.KeyPressFcn = @keypressed;
update_vis();

    function keypressed(h, event)
        flagChanged = 0;
        if strcmp(event.Key, 'downarrow')
            if h.UserData.idx < h.UserData.numsubs
                flagChanged = 1;
                h.UserData.idx = h.UserData.idx + 1;
            end
        elseif strcmp(event.Key, 'uparrow')
            if h.UserData.idx > 1
                h.UserData.idx = h.UserData.idx - 1;
                flagChanged = 1;
            end
        end
        if flagChanged
            update_vis();
        end
    end

    function update_vis()
        figure(h);
        clf();
        figure(b);
        clf('reset');
        figure(m);
        clf('reset');
        figure(z);
        clf('reset');
        vis_streams(h.UserData.subs(h.UserData.idx), varList, labels, [], [], 1, h);
        load_frame_ui(h,b,m,z,h.UserData.subs(h.UserData.idx), camIDs);
    end
end

