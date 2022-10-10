clear all;

exp_id = 32;
% save_path = ['M:\experiment_' int2str(exp_id) '\gaze_heatmap_by_subject'];
save_path = '/multi-lib/user_output/parent_eye_gaze_heatmap/';
img_w = 720;
img_h = 480;
agent = 'parent';
% agent = 'child';
var_name = ['cont2_eye_xy_' agent];
graph_format = 'png';

%%
sub_list = list_subjects(exp_id);

if ~exist('save_path', 'dir')
    mkdir(save_path);
end

drawing_method = 1;

for sidx = 1:length(sub_list)
%     sidx = 1;
    sub_id = sub_list(sidx);
    
    if ~has_variable(sub_id, var_name)
        fprintf('\n%s does not exist for sub %d\n', var_name, sub_id);
        continue
    end
    
    eye_data = get_variable(sub_id, var_name);
    
    h = figure;
    set(h, 'Position', [100 50 1200 900]);
    data_size = size(eye_data(:, 2));
    x_data = eye_data(:, 2);
    y_data = eye_data(:, 3);
    
    x_percentage = sum(~isnan(x_data))/length(x_data);
    y_percentage = sum(~isnan(y_data))/length(y_data);
    
    if x_percentage == y_percentage
        gaze_quality = y_percentage;
    else
        gaze_quality = min(x_percentage, y_percentage);
    end
    
    if drawing_method == 1                
        x_range = [min(x_data) max(x_data)];
        y_range = [min(y_data) max(y_data)];
        
        x_plot = [x_range(1) x_range(1) x_range(2) x_range(2)];
        y_plot = [y_range(1) y_range(2) y_range(2) y_range(1)];
        
        hold on;
        fill(x_plot, y_plot, 'k');        
        plot(x_data, y_data, 'y.', 'MarkerSize', 1)
        hold off;
        
%         xlim(x_range);
%         ylim(y_range);
        xlim([0 img_w]);
        ylim([0 img_h]);
    elseif drawing_method == 2 && false % this method not in use
        plot_matrix = zeros(img_h, img_w);
        for edidx = 1: size(x_data)
            index_column = floor(x_data(edidx))+1;
            index_row = 480-floor(y_data(edidx));
            
            if index_row < 1
                index_row = 1;
            end
            
            if index_column > 720
                index_column = 720;
            end
            
            if ~isnan(index_column) && ~isnan(index_row)
                plot_matrix(index_row, index_column) = ...
                    plot_matrix(index_row, index_column) + 1;
            end
        end
        
        imagesc(plot_matrix, [0 10])
        colormap(jet)
        
    elseif drawing_method == 3 && false % this method not in use
        for edidx = 1: size(x_data)
            draw_rect(x_data(edidx), y_data(edidx));
        end
    %     hold on;
    %     
    %     for eidx = 1:size(eye_data, 1)
    %         this_eye_xy = eye_data(eidx, 2:3);
    %         plot(this_eye_xy(1), this_eye_xy(2));
    %     end
    %     hold off
        x_range = [min(eye_data(:,2)) max(eye_data(:,2))];
        y_range = [min(eye_data(:,2)) max(eye_data(:,3))];
        xlim(x_range);
        ylim(y_range);
%         whitebg('black');
    end
    
    textstr = sprintf('%d %s %.4f valid gaze data', sub_id, agent, gaze_quality);
    annotation('textbox', [0.7 0.86 0.1 0.1], 'String', textstr, 'Color', 'r', 'BackgroundColor', 'k', 'FitBoxToText', 'on');

    filename = sprintf('%d_%s_gaze_heatmap', sub_id, agent);
    saveas(h, fullfile(save_path, filename), graph_format);
    disp(save_path);
    close(h);
% pause
end
