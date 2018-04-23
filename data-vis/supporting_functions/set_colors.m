function colors = set_colors(n)

num_colors = 150;

multisensory_colors = [
         0         0    1.0000
         0    1.0000         0
    1.0000         0         0
    1.0000         0    1.0000];
predefined_colors = distinguishable_colors(num_colors);
predefined_colors = [
    multisensory_colors
    predefined_colors(7:end, :)];

if nargin > 0
    if numel(n) == 1
        if n <= 0
            colors = ones(n,3);
            for i = 1 : n
                fprintf('set color for category %d\n', i);
                colors(i,:) = uisetcolor();
            end
        else
%             fprintf(['Too many color categories, please enter color matrix ' ....
%                 'in this case. Now the program will apply predefined colors.\n']);
            if n <= num_colors+4
                colors = predefined_colors(1:n, :);
            else
                new_colors = distinguishable_colors(n+1);
                colors = [
                    predefined_colors(1:4, :)
                    new_colors(6:end, :)];
            end
        end
    elseif size(n,2) == 3
        colors = n;
    else
        colors = predefined_colors;
    end
else
    colors = predefined_colors;
end

% predefined_colors = [
%          0         0    1.0000
%          0    1.0000         0
%     1.0000         0         0
%     1.0000         0    1.0000
%     1.0000    0.8276         0
%          0    0.3448         0
%     0.5172    0.5172    1.0000
%     0.6207    0.3103    0.2759
%          0    1.0000    0.7586
%          0    0.5172    0.5862
%          0         0    0.4828
%     0.5862    0.8276    0.3103
%     0.9655    0.6207    0.8621
%     0.8276    0.0690    1.0000
%     0.4828    0.1034    0.4138
%     0.9655    0.0690    0.3793
%     1.0000    0.7586    0.5172
%     0.1379    0.1379    0.0345
%     0.5517    0.6552    0.4828
%     0.9655    0.5172    0.0345
%     0.5172    0.4483         0
%     0.4483    0.9655    1.0000
%     0.6207    0.7586    1.0000
%     0.4483    0.3793    0.4828
%     0.6207         0         0
%          0    0.3103    1.0000
%          0    0.2759    0.5862
%     0.8276    1.0000         0
%     0.7241    0.3103    0.8276
%     0.2414         0    0.1034
%     0.9310    1.0000    0.6897
%     1.0000    0.4828    0.3793
%     0.2759    1.0000    0.4828
%     0.0690    0.6552    0.3793
%     0.8276    0.6552    0.6552
%     0.8276    0.3103    0.5172
%     0.4138         0    0.7586
%     0.1724    0.3793    0.2759
%          0    0.5862    0.9655
%     0.0345    0.2414    0.3103
%     0.6552    0.3448    0.0345
%     0.4483    0.3793    0.2414
%     0.0345    0.5862         0
%     0.6207    0.4138    0.7241
%     1.0000    1.0000    0.4483
%     0.6552    0.9655    0.7931
%     0.5862    0.6897    0.7241
%     0.6897    0.6897    0.0345
%     0.1724         0    0.3103
%          0    0.7931    1.0000
%     0.3103    0.1379         0
%          0    0.7241    0.6552
%     0.6207         0    0.2069
%     0.3103    0.4828    0.6897
%     0.1034    0.2759    0.7586
%     0.3448    0.8276         0
%     0.4483    0.5862    0.2069
%     0.8966    0.6552    0.2069
%     0.9655    0.5517    0.5862
%     0.4138    0.0690    0.5517];
% 


is_plot_colors = false;
if is_plot_colors
    num_colors = size(colors, 1);
    h_colormap = figure('Position', [20 20 300 1000], 'Visible', 'off'); % 
    size_unit = 20;
    hold on;
    for i = 1:num_colors
        colorone = colors(i, :);
        plot_x = [3 3 7 7];
        upper_y = (num_colors-i+1) * size_unit;
        lower_y = (num_colors-i) * size_unit+size_unit/10;
        plot_y = [lower_y upper_y upper_y lower_y];
        fill(plot_x, plot_y, colorone, 'EdgeColor', 'k');
        text(mean(plot_x), mean(plot_y), sprintf('%d', i), 'HorizontalAlignment', 'center');
    end
    xlim([2 8]);
    ylim([0 (num_colors+1)*size_unit]);
    % set(gca, 'XTick',[]);
    % set(gca, 'YTick',[]);
    set(gca,'Visible','off');
    hold off;
    title_str = 'plot_colormap';
    text(mean(plot_x), -size_unit, title_str, 'HorizontalAlignment', 'center');
    set(h_colormap,'PaperPositionMode','auto');
    saveas(h_colormap, [title_str '.png']);
end


end