function output = add_edge(img, edge_widths, edge_heights)
output = add_left_right_edge(img', edge_heights);
output = add_left_right_edge(output', edge_widths);
end

function output = add_left_right_edge(img, edge_widths)
height = size(img, 1);
output = [zeros(height, edge_widths(1)), img, zeros(height, edge_widths(2))];
end
