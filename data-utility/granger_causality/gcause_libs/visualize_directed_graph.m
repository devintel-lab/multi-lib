function visualize_directed_graph(weight_matrix, node_texts, save_name)

% weight_matrix = results_gcause.gcause_mat;
% node_texts = {'Child Vocal', 'Parent Vocal'};
[num_nodes, m] = size(weight_matrix);
if num_nodes ~= m
    error('Weight matrix should have the same number of rows and columns');
end

len_unit = 10;
len_side = 6;
len_gap = (len_unit - len_side)/2;
height = len_unit * ceil(num_nodes/2);
width = len_unit * 2 + len_gap;

color_max = 20;
color_pos = get_colormap('red', color_max);
color_neg = get_colormap('blue', color_max);

h = figure('Position', [100 100 50*width 50*height], 'Visible', 'off');  % 
hold on;
xlim([0 width]);
ylim([0 height]);
for nidx = 1:num_nodes
    rowi = ceil(num_nodes/2)-1;
    columni = mod(nidx+1, 2);
    x = columni*len_unit + len_gap*(columni+1);
    y = rowi*len_unit + len_gap;
    rectangle('Position', [x y len_side len_side], 'Curvature',1, 'LineWidth', 3);
    center_x = x+len_side/2;
    center_y = y+len_side/2;
    text(center_x, center_y, node_texts{nidx}, 'HorizontalAlignment', 'center', 'FontSize', 18);
    
    for arrowidx = 1:nidx-1
        % [to this node, from this node]
        start_upper = [x-len_side center_y+1];
        stop_upper = [x center_y+1];
        
        weight_one = weight_matrix(nidx, arrowidx);
        color_index = min(ceil(abs(weight_one))+1, color_max);
        if weight_one > 0
            arrow_color = color_pos(color_index, :);
        else
            arrow_color = color_neg(color_index, :);
        end
        
        arrow('Start', start_upper, 'Stop', stop_upper, 'Length', 20, ...
            'Width', 3, 'Ends', 'stop', 'TipAngle', 30, 'BaseAngle', 60, 'Color', arrow_color);
        text(x-len_side/2, center_y+1, sprintf('%.2f', weight_one), ...
            'FontSize', 14, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
        
        start_lower = [x-len_side center_y-1];
        stop_lower = [x center_y-1];
        
        weight_one = weight_matrix(arrowidx, nidx);
        color_index = min(ceil(abs(weight_one))+1, color_max);
        if weight_one > 0
            arrow_color = color_pos(color_index, :);
        else
            arrow_color = color_neg(color_index, :);
        end
        
        arrow('Start', start_lower, 'Stop', stop_lower, 'Length', 20, ...
            'Width', 3, 'Ends', 'start', 'TipAngle', 30, 'BaseAngle', 60, 'Color', arrow_color);
        text(x-len_side/2, center_y-1, sprintf('%.2f', weight_one), ...
            'FontSize', 14, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
    end
end

hold off;
set(gca,'Visible','off');
set(h,'PaperPositionMode','auto');

if nargin > 2
    saveas(h, save_name);
    close(h);
end