function [center_mean_dist, center_min_dist] = cal_center2obj_dist(obj_num, blob_cells)

center_mean_dist = NaN(1, obj_num+2);
center_min_dist  = NaN(1, obj_num+2);

[img_h, img_w] = size(blob_cells{2});

seg_center_x = img_w/2;
seg_center_y = img_h/2;
max_distance = sqrt(img_w^2 + img_h^2);

idx_obj_all = obj_num+2;
tmp_img_mask = blob_cells{2};
if length(blob_cells) ~= (obj_num+1)
    error('The number of seg image panel does not match with object number');
end
for bidx = 3:(obj_num+1)
    tmp_img_mask = tmp_img_mask | blob_cells{bidx};
end
blob_cells{idx_obj_all} = tmp_img_mask;

for bidx = 2 : (obj_num+2)
    %spatial(bidx,frame_idx) = region_spatial_dist(segs{bidx}, 480, 8, 720, 18);
    % there could be multiple area for each object
    blob_one = blob_cells{bidx};
%     if length(unique(blob_one)) > 2
%         unique(blob_one)
%         error('The input segmented blobs are not logical matrix')
%     end
    area = regionprops(blob_one, 'Area', 'Centroid', 'PixelList', 'BoundingBox'); %, 'Image'
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% for debugging %%%%%%%%%%%%%%%%%%%%%
    % htmp = figure;
    % subplot(1,2,1);
    % imshow(bwlabel(blob_one));
    % subplot(1,2,2);
    % imshow(logical(blob_one));
    % pause
    % close(htmp)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if ~isempty(area)
        dmin_center = max_distance;
        dsum_center = 0;
        npixel_center = 0;
        for n = 1 : size(area,1)
            % compute the min
            temp_center = min(distance([seg_center_x; seg_center_y], area(n).PixelList'));
            if (temp_center < dmin_center)
                dmin_center = temp_center;
            end;

            dsum_center = dsum_center + area(n).Area * distance([seg_center_x; seg_center_y], area(n).Centroid');
            npixel_center = npixel_center + area(n).Area;
        end

        center_min_dist(bidx) = dmin_center/max_distance;
        if (npixel_center > 0)
            center_mean_dist(bidx) = (dsum_center/npixel_center)/max_distance;
        else
            center_mean_dist(bidx) = 1;
        end
    end
end
