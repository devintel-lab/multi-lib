function check_motion_quality(subexpIDs, sensorList)
[subs, ~, subpaths] = cIDs(subexpIDs);
if ~exist('sensorList', 'var') || isempty(sensorList)
    sensorList = [1 2 3 4 5 6];
end
var_list = {
    'cont_motion_pos-speed_head_child'
    'cont_motion_pos-speed_head_parent'
    'cont_motion_pos-speed_left-hand_child'
    'cont_motion_pos-speed_right-hand_child'
    'cont_motion_pos-speed_left-hand_parent'
    'cont_motion_pos-speed_right-hand_parent'
    };
fprintf('\n');
for i = 1:numel(var_list)
    fprintf('Sensor %d : %s\n', i, var_list{i});
end
fprintf('\nHit down arrow for next subject\n');
fprintf('Hit up arrow for previous subject\n\n');

h = figure('position', [100 100 1280 720]);
colors =     [1.0000         0         0
         0    1.0000    1.0000
    1.0000    1.0000         0
         0    1.0000         0
    0.8510    0.3255    0.0980
    0.7490         0    0.7490];

h.KeyPressFcn = @keypressed;
h.UserData.idx = 1;
h.UserData.numsubs = numel(subpaths);
h.UserData.subpaths = subpaths;
h.UserData.subs = subs;
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
        clf;
        ax = subplot(6,1,1);
        subpath = h.UserData.subpaths{h.UserData.idx};
        subid = h.UserData.subs(h.UserData.idx);
        title(subid);
        firstflag = 1;
        for s = sensorList
            if exist([h.UserData.subpaths{h.UserData.idx} var_list{s} '.mat'], 'file')

                data = get_variable(subpath, var_list{s});
                tb = get_variable(subpath, 'cevent_trials');
                exr = extract_ranges(data, 'cont', tb);
                data = vertcat(exr{:});
                ax = subplot(6, 1, s);
                plot(data(:,1), data(:,2), 'color', colors(s,:));
                ax.Color = [0 0 0];
                ax.YLim = [0 400];
                ax.XLim = [data(1,1) data(1,1) + 10];
                if firstflag
                    ax.Title.String = sprintf('%d    sensor %d', subid, sensorList(s));
                    firstflag = 0;
                else
                    ax.Title.String = sprintf('sensor %d', sensorList(s));
                end
                
            end
        end
    end
end


