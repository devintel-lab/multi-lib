function combined_img = combine_obj_detection_results(img_cells, img_h, img_w, edge_widths, edge_heights)
if ~exist('edge_widths', 'var')
    edge_widths = [0 0];
end

if ~exist('edge_heights', 'var')
    edge_heights = [0 0];
end

num_img = length(img_cells);

if mod(num_img, 2) ~= 0
    error('The number of image cells must be even');
end

for iidx = 1:num_img
    tmp_img = img_cells{iidx};
    if isempty(tmp_img)
        tmp_img = false(img_h, img_w);
    end
%     tmp_img = change_image_value_range(tmp_img);
    tmp_img = add_edge(tmp_img, edge_widths, edge_heights);
    img_cells{iidx} = tmp_img;
end

if num_img == 4
    combined_img = [...
        img_cells{1} img_cells{2}; ...
        img_cells{3} img_cells{4}];
elseif num_img == 6
    combined_img = [...
        img_cells{1} img_cells{2} img_cells{3};...
        img_cells{4} img_cells{5} img_cells{6}];
else
    error('Currently, this script only works for segmented images with 4 or 6 panels');
end

%%%%%%%%%%%%%%%%%% OLD CODES - NO USE %%%%%%%%%%%%%%%%%%
% combined_img = [];
% for eidx = 1:(num_img/2)
%     combined_img = [combined_img; ...
%         img_cells{eidx*2-1} img_cells{eidx*2}];
% end

% img1 = change_image_value_range(img1);
% img2 = change_image_value_range(img2);
% img3 = change_image_value_range(img3);
% img4 = change_image_value_range(img4);

% img1 = add_edge(img1, edge_widths, edge_heights);
% img2 = add_edge(img2, edge_widths, edge_heights);
% img3 = add_edge(img3, edge_widths, edge_heights);
% img4 = add_edge(img4, edge_widths, edge_heights);

% img1 = imresize(img1, 0.5);
% img2 = imresize(img2, 0.5);
% img3 = imresize(img3, 0.5);
% img4 = imresize(img4, 0.5);

% % to delete the small blobs that have low intensities.
% img1(img1<0.1) = 0;
% img2(img2<0.1) = 0;
% img3(img3<0.1) = 0;
% img4(img4<0.1) = 0;
% img1(img1>=0.1) = 1;
% img2(img2>=0.1) = 1;
% img3(img3>=0.1) = 1;
% img4(img4>=0.1) = 1;

% combined_img = [img1 img2; img3 img4];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% add lines for better view.  Can be deleted.
combined_img = imresize(combined_img, 0.5);

[height, width] = size(combined_img);
if num_img == 4
    combined_img(height/2, :) = 1;
    combined_img(:, width/2) = 1;
elseif num_img == 6
    combined_img(height/2, :) = 1;
    combined_img(:, floor(width/3)) = 1;
    combined_img(:, floor(width/3*2)) = 1;
else
    error('Currently, this script only works for segmented images with 4 or 6 panels');
end

%%%%%%%%%%%%%%%%%% visualize for debugging %%%%%%%%%%%%%%%%%%
% tmph = figure('Position', [50, 50, 1200, 800]);
% imshow(combined_img);
% pause
% close(tmph);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end



