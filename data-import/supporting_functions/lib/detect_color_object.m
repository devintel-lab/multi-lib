function [blob_size, blob_center, blob_cells] = detect_color_object(img, agent_type, obj_num, obj_params) % blob_cells
%  This function is the key part of color object detection 
%  You need to change this function for another experiment setting. 
% 
%  img: input RGB image
%  seg_img: output segmented binary image. It actually consists of four
%  images. 
% 
%  write by: txu@indiana.edu update date: Oct. 15, 2013


% convert from RGB to HSV
hsv = rgb2hsv(img);
h = hsv(:,:,1);
s = hsv(:,:,2);
v = hsv(:,:,3);

%%%%%%%%%%%%%%%%%%%%%%%
% img_hsv = figure;
% subplot(1, 3, 1);
% imshow(h);
% title('Hue')
% subplot(1, 3, 2);
% imshow(s);
% title('Saturation')
% subplot(1, 3, 3);
% imshow(v);
% title('Value')
% pause
%%%%%%%%%%%%%%%%%%%%%%%

% [img_h, img_w] = size(h);
blob_size = nan(1, (obj_num+1));
blob_center = nan(1, (obj_num+1)*2);

% Roughly segment image according to thresholds
blob_cells = cell(1, obj_num);
bk   = (s < obj_params.bg_s_low) | (v < obj_params.bg_v_low);  % background
blob_cells{2} = (h > obj_params.blue_h_low) & (h < obj_params.blue_h_high) ...
    & (s > obj_params.blue_s_low)  & ~bk; % blue  object
if strcmp(agent_type, 'topdown')
    blob_cells{3} = (h > obj_params.green_h_low) & (h < obj_params.green_h_high) & (s > obj_params.green_s_low_topdown)  & ~bk; % green object
else
    blob_cells{3} = (h > obj_params.green_h_low) & (h < obj_params.green_h_high) & (s > obj_params.green_s_low)  & ~bk; % green object
end

% if isfield(obj_params, 'red_h_low_child') || isfield(obj_params, 'red_h_low_parent') 
if strcmp(agent_type, 'child')
    if isfield(obj_params, 'red_h_orhigh_child')
        blob_cells{4} = ((h > obj_params.red_h_low_child) | (h < obj_params.red_h_orhigh_child)) ...
            & (s > obj_params.red_s_low_child)  & (v > obj_params.red_v_low_child) & ~bk; % red objects
    else
        blob_cells{4} = ((h > obj_params.red_h_low_child) & (h < obj_params.red_h_andhigh_child)) ...
            & (s > obj_params.red_s_low_child)  & (v > obj_params.red_v_low_child) & ~bk; % red objects
    end
elseif strcmp(agent_type, 'parent')
    if isfield(obj_params, 'red_h_orhigh_parent')
        blob_cells{4} = ((h > obj_params.red_h_low_parent) | (h < obj_params.red_h_orhigh_parent)) ...
            & (s > obj_params.red_s_low_parent)  & (v > obj_params.red_v_low_parent) & ~bk; % red objects
    else
        blob_cells{4} = ((h > obj_params.red_h_low_parent) & (h < obj_params.red_h_andhigh_parent)) ...
            & (s > obj_params.red_s_low_parent)  & (v > obj_params.red_v_low_parent) & ~bk; % red objects
    end
elseif strcmp(agent_type, 'topdown')
    blob_cells{4} = ((h > obj_params.red_h_low_parent) | (h < obj_params.red_h_orhigh_parent)) ...
        & (s > obj_params.red_s_low_topdown) & (v > obj_params.red_v_low_child) & ~bk;
end

skin = h < 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% skin = (h >= 0.967  |  h < 0.08)  & (v > 0.35) & (s > 0.11 & s < 0.6) &
% ~bk; % skin color; not very well tuned yet.

for oidx = 2:(obj_num+1)
    tmp_blob = blob_cells{1, oidx};
    % smooth the images
    tmp_blob = medfilt2(tmp_blob, [8 8]);

    % filter out small far blobs, get only the blobs that are the actual
    % object
    tmp_blob = get_object_blobs(tmp_blob);
    
    blob_cells{1, oidx} = tmp_blob;
    
    [blob_size(oidx), blob_center(1, (oidx*2-1):oidx*2)] = cal_blob_size_and_center(tmp_blob);
end