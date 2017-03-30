function draw_motion_scatter(IDs, plane)
% IDs can be experiment IDs or a list of subjects
% plane is a 2 point vector:
% bird's eye view is [4,3] z,y
% from door perspective [4,2] z,x
% from experimenter perspective [3,2] y,x
% 
% 

if ~exist('plane', 'var') || isempty(plane)
    plane = [4,3];
end

subs = cIDs(IDs);
var_list_all = {'cont3_motion_pos_head_child', 'cont3_motion_pos_head_parent',...
    'cont3_motion_pos_left-hand_child', 'cont3_motion_pos_right-hand_child',...
    'cont3_motion_pos_left-hand_parent','cont3_motion_pos_right-hand_parent'};
colors = 'rybgcm';
legend_names = {'child-head','parent-head','left-hand child','right-hand child', 'left-hand parent', 'right-hand parent'};
for s = 1:numel(subs)
    fprintf('%d\n',subs(s));
    figure;
    log = cellfun(@(A) has_variable(subs(s), A), var_list_all);
    if sum(log) > 0
        var_list = var_list_all(log);
        all = cell(numel(var_list));
        for v = 1:numel(var_list)
            data = get_variable_by_trial_cat(subs(s), var_list{v});
            data(:,5) = v;
            all{v} = data;
        end
        all = vertcat(all{:});
        all = downsample(all, 2);
        gscatter(all(:,plane(1)),all(:,plane(2)), all(:,5), colors(log),[],5);
%         ylim([-30 30]);xlim([-15 15]);
        legend(legend_names(log));
        legend('location', 'northeastoutside');
        title(sprintf('%d',subs(s)));
        set(gcf, 'position', [100 100 1200 800]);
        ff = getframe(gcf);
        path = fullfile(get_multidir_root, sprintf('experiment_%d',sub2exp(subs(s))),'included','data_vis','motion');
        if ~exist(path, 'dir')
            mkdir(path);
        end
        imwrite(ff.cdata, fullfile(path, sprintf('%d_motion_yz.png', subs(s))), 'png');
        close gcf
    end
end