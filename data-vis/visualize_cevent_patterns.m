function visualize_cevent_patterns(data, args, cont_data, cont_args)
% This is a plotting function for visualizing temperol pattens
% For input format, please see the function get_test_data() below
% 
% Example:
% >>>  args.legend = {'Event1'; 'Event2'; 'Event3'; 'Event4'};
% >>>  plot_temp_patterns({}, 1, args)

% add other vs target

% debugging:
% visualize_cevent_patterns(data, args)

LENGTH_CEVENT = 3;
text_unit = 0.35;
text_offset = 2.6;

if isempty(data)
    data = get_test_data();
end

if isfield(args, 'trial_times')
    max_trial_due = max(args.trial_times(:,2)-args.trial_times(:,1));
    text_unit = text_unit * (max_trial_due/100);
    text_offset = text_offset * (max_trial_due/100);
end

if ~exist('args', 'var')
    args.info = 'No user input information here';
end

% How many instances on each figure
if isfield(args, 'MAX_ROWS')
	MAX_ROWS = args.MAX_ROWS;
else
    MAX_ROWS = 20;
end

if isfield(args, 'colormap')
    colormap = args.colormap;
else
    colormap = get_colormap();
end

% preprocess cell data, transfer it into a matrix
if iscell(data)
    num_data_stream = size(data, 2);
    data_new = {};
    max_num_cvent_data_column = nan(1,num_data_stream);
    
    % go through each stream (each column in the cell data)
    for dsidx = 1:num_data_stream
        data_column = data(:,dsidx);
        
        data_column_length = cellfun(@(data_one) ...
            size(data_one, 1), ...
            data_column, ...
            'UniformOutput', false);
        data_column_length = vertcat(data_column_length{:});
        list_cevent_length = unique(data_column_length(:,1));
        % if data is a cell and needs to be processed
        if sum(~ismember(list_cevent_length, 1)) > 0
            max_data_column_length = max(list_cevent_length);
            data_column_new = nan(length(data_column), max_data_column_length*LENGTH_CEVENT);
            for didx = 1:length(data_column)
                data_column_one = data_column{didx};
                for doidx = 1:max_data_column_length
                    if doidx <= size(data_column_one,1)
                        data_column_new(didx,(doidx-1)*3+1:doidx*3) = ...
                            data_column_one(doidx,1:3);
                    end
                end
            end
        else
            data_column_new = vertcat(data_column{:});
            max_data_column_length = list_cevent_length(1);
        end
        data_new{dsidx} = data_column_new;
        max_num_cvent_data_column(dsidx) = max_data_column_length;
    end
    data = horzcat(data_new{:});
    tmp_count = 0;
    for tmpi = 1:length(max_num_cvent_data_column)
        prev_tmp_count = tmp_count + 1;
        tmp_count = tmp_count + max_num_cvent_data_column(tmpi);
        stream_position_new(prev_tmp_count:tmp_count) = ...
            tmpi;
    end
    args.stream_position = stream_position_new;
end

% end
[rows, cols] = size(data);
if ~iscell(data)
    cols = cols / LENGTH_CEVENT;
end

if ~isfield(args, 'stream_position')
    args.stream_position = ones(1,cols);
end

if isfield(args, 'legend')
    if ~isfield(args, 'legend_location')
        if ~exist('cont_args', 'var')
            args.legend_location = 'NorthEastOutside';
        else
            args.legend_location = 'NorthWestOutside';
        end
    end
end

if isfield(args, 'ForceZero')
    if isfield(args, 'ref_index')
        ref_index = args.ref_index;
    elseif isfield(args, 'ref_column')
        ref_column = args.ref_column;
    else
        ref_column = 2;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~iscell(data)
        if isfield(args, 'time_ref')
            time_ref = args.time_ref;
        elseif exist('ref_column', 'var')
            time_ref = data(:,ref_column);
        else
            time_ref = data(ref_index(1), ref_index(2));
            time_ref = repmat(time_ref, size(data,1), 1);
        end
        
        tmp_ref_nan = sum(isnan(time_ref));
        if tmp_ref_nan > 0
            error('Error! There is nan data in the reference time column!');
        end
        data_mat = data;
    else
        data_mat = cell2mat(data);
        if isfield(args, 'time_ref')
            time_ref = args.time_ref;
        elseif exist('ref_column', 'var')
            time_ref = data(:,ref_column);
        else
            time_ref = data(ref_index(1), ref_index(2));
            time_ref = repmat(time_ref, size(data,1), 1);
        end
        if sum(isnan(time_ref)) > 0
%             time_idx_list = sort([1:3:size(data_mat,2) 2:3:size(data_mat,2)]);
            nan_count_data = sum(isnan(data_mat));
            [I J] = find(nan_count_data);
            ref_column = min(setdiff(1:size(data_mat,2), J));
            if isfield(args, 'ref_column')
                warning(['The reference column for ForceZero time has NaN ' ...
                    'values and thus is changd to column ' int2str(ref_column) '.']);
            end
            time_ref = data_mat(:,ref_column);
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for j = cols:-1:1
        data_mat(:,j*LENGTH_CEVENT-1) = data_mat(:,j*LENGTH_CEVENT-1) - time_ref;
        data_mat(:,j*LENGTH_CEVENT-2) = data_mat(:,j*LENGTH_CEVENT-2) - time_ref;
    end
else
    data_mat = data;
end

if isfield(args, 'color_code') && strcmp(args.color_code, 'cevent_value')    
    value_idx_list = 3:LENGTH_CEVENT:size(data_mat,2);
    max_cevent_value = max(max(data_mat(:,value_idx_list)));
end

% to calculate how many figure will be needed in total
num_figures = floor(rows/MAX_ROWS)+ceil(mod(rows/MAX_ROWS, 1));

for fidx = 1:num_figures
    if isfield(args, 'figure_visible') && ~args.figure_visible
        h = figure('Visible','Off');
    else
        h = figure;
    end
    
    if isfield(args, 'set_position')
        set(h, 'Position', args.set_position);
    end
    
    if exist('cont_data', 'var')
        subplot(1,2,1);
        
        if ~exist('cont_args', 'var')
            cont_args.info = 'No user input information here';
        end
        
        cont_args.stream_position = args.stream_position;
        
        if ~isfield(cont_args, 'colormap')
            cont_args.colormap = {};
        end
        
        if ~isfield(cont_args, 'LineWidth')
            cont_args.LineWidth = 1;
        end        
        
        if isfield(cont_args, 'legend') && ~isfield(cont_args, 'legend_location')
            cont_args.legend_location = 'NorthEastOutside';
        end
    end
    %% The first half of the figure
    hold on;
    
    % to get how many rows/instances will be in this figure
    if fidx == num_figures
        if mod(rows, MAX_ROWS) == 0
            rows_one = MAX_ROWS;
        else
            rows_one = mod(rows, MAX_ROWS);
        end
    else
        rows_one = MAX_ROWS;
    end
    
    % to get the sub chunk of data for this figure
    if fidx == num_figures
        sub_data_mat = data_mat((fidx-1)*MAX_ROWS+1:end,:);
    else
        sub_data_mat = data_mat((fidx-1)*MAX_ROWS+1:(fidx)*MAX_ROWS,:);
    end
    
    start_time_idx = 1:LENGTH_CEVENT:size(sub_data_mat,2);
    end_time_idx = 2:LENGTH_CEVENT:size(sub_data_mat,2);
    
    min_x = min(min(sub_data_mat(:,start_time_idx),[],'omitnan'),[],'omitnan') - 0.1;
    max_x = max(max(sub_data_mat(:,end_time_idx),[],'omitnan'),[],'omitnan') + 0.1;
    max_y = 0;
    
    length_of_streams = length(unique(args.stream_position));
    each_stream_space = 1/length_of_streams;
    
    % draw legend cubics
    if isfield(args, 'legend') && isfield(args, 'colormap')
        for lidx = 1:length(args.legend)
            x = [min_x, min_x, min_x, min_x];
            y = [0.1, 1, 1, 0.1];
            color = args.colormap(lidx, :);
            fill(x, y, cell2mat(color));
        end
    end

    if isfield(args, 'row_text')
        row_text_pos_y = nan(MAX_ROWS, 1);
    end
    
    % Draw the background bars - white / grey
    for rowidx = 1:MAX_ROWS
        % Draw left to right in each row
        x = [min_x, max_x, max_x, min_x];
        y = [(rowidx-1)*(1+each_stream_space), (rowidx-1)*(1+each_stream_space), ...
            rowidx*(1+each_stream_space), rowidx*(1+each_stream_space)];
        color = [1 1 1];
%         if mod(rowidx, 2) < 1
%             color = [1 1 1];
%         else
%             color = [0.8 0.8 0.8];
%         end
        fill(x, y, color);
    end
    
    % Draw actual instances row by row
    for rowidx = 1:rows_one
%         min_y_row = 99;
%         max_y_row = 0;
        % Draw left to right in each row
        pos_num_old = -1;
        for columnidx = 1:cols
            cevent_one = data_mat(rowidx+(fidx-1)*MAX_ROWS,(columnidx-1)*3+1:(columnidx-1)*3+3);
            pos_num_new = args.stream_position(columnidx);
            if isfield(args, 'var_text')
                if iscell(args.var_text)
                    var_text_one =  args.var_text{pos_num_new};
                elseif ischar(args.var_text)
                    var_text_one = sprintf('%s%d', args.var_text, pos_num_new);
                end
            end
            
            if ~(isempty(cevent_one) || sum(isnan(cevent_one)) > 0)
                start_time = cevent_one(1);
                end_time = cevent_one(2);
%                 if isfield(args, 'is_cont2cevent') && args.is_cont2cevent()
                if cevent_one(3) > 100
                    cevent_one(3) = cevent_one(3) - args.cont_value_offset;
                    cont_colormap = get_colormap(args.cont_color_str{pos_num_new}, args.convert_max_int);
                    color = get_color(cevent_one(3), args.convert_max_int, cont_colormap);
                else
                    if ~isfield(args, 'color_code') || strcmp(args.color_code, 'cevent_type')
                        color = get_color(columnidx, cols, colormap); %get_color(cevent_one(3));
                    elseif isfield(args, 'color_code') && strcmp(args.color_code, 'cevent_value')
                        color = get_color(cevent_one(3), max_cevent_value, colormap);
    %                     args.edge_color = get_color(mod(cevent_one(3), 10), max_cevent_value, colormap);
                    end
                end
                [~, y] = create_square(start_time, end_time, rowidx, columnidx, color, args);
                y_new = mean(y);
                if pos_num_old ~= pos_num_new && isfield(args, 'var_text')
                    text(-(text_unit*length(var_text_one)+text_offset), y_new, var_text_one, ...
                        'FontSize', 8, 'BackgroundColor', [0.8 0.8 0.8], 'Interpreter', 'none');
                end
            elseif (cevent_one(3) == 0)
                if pos_num_old ~= pos_num_new && isfield(args, 'var_text')
                    [~, y] = create_square(0, 0, rowidx, columnidx, [1 1 1], args);
                    y_new = mean(y);
                    text(-(text_unit*length(var_text_one)+text_offset), y_new, var_text_one, 'FontSize', ...
                        8, 'Color', [1 0 0], 'BackgroundColor', [0.8 0.8 0.8], 'Interpreter', 'none');
                end
            else
                if pos_num_old ~= pos_num_new && isfield(args, 'var_text')
                    [~, y] = create_square(0, 0, rowidx, columnidx, [1 1 1], args);
                    y_new = mean(y);
                    text(-(text_unit*length(var_text_one)+text_offset), y_new, var_text_one, 'FontSize', ...
                        8, 'Color', [1 1 1], 'BackgroundColor', [0.8 0.8 0.8], 'Interpreter', 'none');
                end
            end
            pos_num_old = pos_num_new;
        end
        if isfield(args, 'row_text')
            row_text_pos_y(rowidx) = y(1);
        end
        max_y = rowidx*(1+each_stream_space);
    end
    
    % draw verticle lines according to the user
    if isfield(args, 'vert_line')
        for vidx = 1:length(args.vert_line)
            x = [args.vert_line(vidx), args.vert_line(vidx), args.vert_line(vidx)+0.01, args.vert_line(vidx)+0.01];
            y = [0, max_y, max_y, 0];
            color = [1 0 0];
            fill(x, y, 'r', 'EdgeColor', color);
        end
    end

    % set transpenrency, so the overlaps between cevents can be shown    
    if isfield(args, 'transparency')
        alpha(args.transparency);
    end
    
    if isfield(args, 'legend')
        new_legend = cell(size(args.legend));
        for i = 1:length(args.legend)
            new_legend{i} = plot_no_underline(args.legend{i});
        end
        
        legend(new_legend, 'Location', args.legend_location);
    end
    
    if isfield(args, 'row_text')
        for rowidx = 1:rows_one
            if strcmp(args.row_text_type, 'time')
                row_text_one = sprintf('%s: %.1f-%.1f', args.row_text{rowidx}, args.trial_times(rowidx, 1), args.trial_times(rowidx, 2));
            else
                row_text_one = args.row_text{rowidx};
            end
            text(max_x+0.5, row_text_pos_y(rowidx), row_text_one, 'FontWeight', 'bold', 'Interpreter', 'none');%, 'FontSize', 12, 'BackgroundColor', [1 1 1]); -1*length(row_text_one)
        end
    end
    
    if isfield(args, 'xlim_list')
        xlim_list = args.xlim_list;
    else
        xlim_list = [min_x max_x];
    end
    
    if isfield(args, 'ylim_list')
        ylim_list = args.ylim_list;
    else
        ylim_list = [0 max_y];
    end
    
    xlim(xlim_list);
    ylim(ylim_list);
    
    if isfield(args, 'title')
        title(plot_no_underline(args.title), 'FontWeight', 'bold'); %, 'FontSize', 12, 'BackgroundColor', [1 1 1]
    end
    
    if isfield(args, 'xlabel')
        xlabel(args.xlabel);
    end
    
    %% the second half of the plot if applicable    
    if exist('cont_data', 'var')
        subplot(1,2,2);
        hold on;
        
        % draw legend cubics
        if isfield(cont_args, 'legend') && isfield(cont_args, 'colormap')
            for lidx = 1:length(cont_args.legend)
                color = get_color(lidx, length(cont_args.legend), colormap);
                line([0], [0], 'Color', color);
            end
        end
        
        % to get the sub chunk of cont_data for this figure
        if fidx == num_figures
            sub_cont_data_mat = cont_data((fidx-1)*MAX_ROWS+1:end,:);
            sub_time_ref = time_ref((fidx-1)*MAX_ROWS+1:end,:);
        else
            sub_cont_data_mat = cont_data((fidx-1)*MAX_ROWS+1:(fidx)*MAX_ROWS,:);
            sub_time_ref = time_ref((fidx-1)*MAX_ROWS+1:(fidx)*MAX_ROWS,:);
        end

        min_x = 99;
        max_x = -99;        
        for rowidx = 1:rows_one
            vec = sub_cont_data_mat{rowidx,1};
            tmp_min_x = min((vec(:,1) - sub_time_ref(rowidx)),[],'omitnan');
            tmp_max_x = max((vec(:,1) - sub_time_ref(rowidx)),[],'omitnan');
            if tmp_min_x < min_x
                min_x = tmp_min_x;
            end
            if tmp_max_x > max_x
                max_x = tmp_max_x;
            end
        end
        min_x = min_x - 0.2;
        max_x = max_x + 0.2;

        % Draw the background bars - white / grey
        for rowidx = 1:MAX_ROWS
            % Draw left to right in each row
            x = [min_x, max_x, max_x, min_x];
            y = [(rowidx-1)*(1+each_stream_space), (rowidx-1)*(1+each_stream_space), ...
                rowidx*(1+each_stream_space), rowidx*(1+each_stream_space)];
            if mod(rowidx, 2) < 1
                color = [1 1 1];
            else
                color = [0.8 0.8 0.8];
            end
            fill(x, y, color);
        end
        
        if isfield(cont_args, 'target_value_ref_column')
            target_value_ref_column = cont_args.target_value_ref_column;
            if mod(target_value_ref_column, LENGTH_CEVENT) ~= 0
                error('Invalid target_value_ref_column value!');
            end                

            value_column = sub_data_mat(:,target_value_ref_column);
        end
        
        % start draw lines one by one
        for rowidx = 1:rows_one
            if isfield(cont_args, 'target_value_ref_column')
                value_id = value_column(rowidx);                
                vec = sub_cont_data_mat{rowidx,value_id};
                
                if ~isempty(cont_args.colormap)
                    color = cont_args.colormap{value_id};
                else
                    color = get_color(value_id, size(sub_cont_data_mat, 2), colormap); %get_color(cevent_one(3));
                end
                
                create_line(vec, rowidx, sub_time_ref(rowidx), color, cont_args);
            else
                for cdmi = 1:size(sub_cont_data_mat, 2)                
                    if ~isempty(cont_args.colormap)
                        color = cont_args.colormap{cdmi};
                    else
                        color = get_color(cdmi, size(sub_cont_data_mat, 2), colormap); %get_color(cevent_one(3));
                    end

                    vec = sub_cont_data_mat{rowidx,cdmi};
                    create_line(vec, rowidx, sub_time_ref(rowidx), color, cont_args);
                end
            end
        end
        
        % draw verticle lines according to the user
        if isfield(cont_args, 'vert_line')
            for vidx = 1:length(cont_args.vert_line)
                x = [cont_args.vert_line(vidx), cont_args.vert_line(vidx), cont_args.vert_line(vidx)+0.01, cont_args.vert_line(vidx)+0.01];
                y = [0, max_y, max_y, 0];
                color = [1 1 1];
                fill(x, y, 'k', 'EdgeColor', color);
            end
        end

        xlim([min_x max_x]);
        ylim([0 max_y]);
        
        if isfield(cont_args, 'legend')
            new_legend = cell(size(cont_args.legend));
            for i = 1:length(cont_args.legend)
                new_legend{i} = plot_no_underline(cont_args.legend{i});
            end
            legend(new_legend, 'Location', cont_args.legend_location);
        end

        if isfield(cont_args, 'title')
            title(plot_no_underline(cont_args.title), 'FontSize', 14, 'FontWeight', 'bold');
        end
    end
    
    set(gca, 'ytick', []);
    hold off;
    %% all the plotting is done, start saving    
    if isfield(args, 'save_name')
        save_name = args.save_name;
        
        fs = 8;
        paper = [0 0 15 8];
        
        h = gcf;
        set(h, 'PaperPositionMode', 'manual');
        set(h, 'PaperUnits', 'inches');
        set(h, 'InvertHardCopy', 'off');
        set(h, 'PaperPosition', paper);
        set(findall(h,'-property','FontSize'),'FontSize', fs)
        
        if isfield(args, 'save_multiwork_exp_dir')
            save_name = fullfile(args.save_multiwork_exp_dir, save_name);
        end
        if ~isfield(args, 'save_format')
            save_format = 'png';
        else
            save_format = args.save_format;
        end
    
        if isfield(args, 'figure_visible') && ~args.figure_visible
            saveas(h, [save_name '_' int2str(fidx) '.' save_format]);
        else
            if isfield(args, 'set_position')
                set(gcf, 'Position', args.set_position);
                pause(1)
            end
            if isfield(args, 'print') && args.print
                print(h, [save_name '_' int2str(fidx) '.' save_format], '-dpng');
            else
                ftmp = getframe(gcf);              %# Capture the current window
                imwrite(ftmp.cdata, [save_name '_' int2str(fidx) '.' save_format]);  %# Save the frame data
            end
        end
%         print(h, '-dpsc', [save_name '_' int2str(fidx) '.' save_format]);
        close(h);
        
    end
end

end

% Get color according to rainbow color cue pallet
function color = get_color(k, k_base, colormap)
    if ~isempty(colormap);
        color = colormap(k, :);
    else
        color = hsv2rgb([k/k_base,1,0.85]);
    end
end

% Draw one rectangle
% x1: start time
% x2: end time
% y1: y axe coordinate (center)
% color: color of the shape
% height: the height of each rectangle, default value is 0.25
function [x, y] = create_square(x1, x2, y1, cidx, color, args)          
    length_of_streams = length(unique(args.stream_position));
    each_stream_space = 1/length_of_streams;
    position_value = args.stream_position(cidx);
%         color = color*(each_stream_space*position_value)+...
%             (1-each_stream_space*position_value);
    y1 = (y1-1)*(1+each_stream_space);
    y1 = y1 + (length_of_streams-position_value+1)*each_stream_space;    
    
    if ~isfield(args, 'height')
        height = each_stream_space*0.5; %0.2;
    else
        height = args.height;
    end
    if isfield(args, 'edge_color')
        edge_color = args.edge_color; %0.2;
    else
        edge_color = 'none';
    end
    
    x = [x1, x2, x2, x1];
    y = [y1-height, y1-height, y1+height, y1+height];
    rect = fill(x, y, cell2mat(color), 'EdgeColor', edge_color);
end

%%%%%%%%%%%%%%%%%%%%%%%%%
% create line
% 
% vec: one chunk of cont data, [time data]
% row: xth row this chunk at
% time_ref: the 0 time spot / offset
% 
function ln = create_line(vec, row, time_ref, color, args)
    length_of_streams = length(unique(args.stream_position));
    each_stream_space = 1/length_of_streams;
    
    x = vec(:,1) - time_ref;
    y = vec(:,2);
    max_y = max(y,[],'omitnan');
    min_y = min(y,[],'omitnan');
    alpha = (1+each_stream_space)/(max_y - min_y);
    y = (y - min_y)*alpha + (row-1)*(1+each_stream_space);
    ln = line(x, y, 'Color', color, 'LineWidth', args.LineWidth);
end

% Get test data
function ret = get_test_data()

ret = {
        [0.1 0.2 1], [0.3 0.43 2], [0.5 0.6 3], [0.36 0.7 4], [0.7 1.0 5];
        [0 0.3 1], [0.3 0.54 2], [0.5 0.6 3], [0.6 0.7 4], [0.7 1.0 5];
        [0.1 0.35 1], [0.3 0.5 2], [0.5 0.6 3], [0.6 0.7 4], [0.7 1.0 5];
        [0.1 0.2 1], [0.2 0.4 2], [0.5 0.6 3], [0.6 0.7 4], [0.7 1.0 5];
        [0 0.23 1], [0.3 0.4 2], [0.5 0.6 3], [0.6 0.7 4], [0.7 1.0 5];
        [0.13 0.21 1], [0.35 0.5 2], [0.5 0.65 3], [0.6 0.7 4], [0.7 1.0 5];
        [0.1 0.3 1], [0.3 0.4 2], [0.5 0.6 3], [0.6 0.79 4], [0.7 1.0 5];
        [0.1 0.32 1], [0.3 0.5 2], [0.5 0.6 3], [0.6 0.7 4], [0.7 1.0 5];
    };
end