function [eye_mean_dist, eye_min_dist, center_mean_dist, center_min_dist] = cal_eye2obj_dist(this_eye_xy, obj_num, ratio, blob_cells, max_distance_half)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Warning: this set of parameters are hard-coded
eye_w = 640;
eye_h = 480;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

eye_mean_dist = NaN(1, obj_num+2);
eye_min_dist  = NaN(1, obj_num+2);
center_mean_dist = NaN(1, obj_num+2);
center_min_dist  = NaN(1, obj_num+2);

[img_h, img_w] = size(blob_cells{2});

if (eye_w*ratio ~= img_w) || (eye_h*ratio ~= img_h)
    error('Height and widtch ranges of eye data do not match with the recorded images');
end

if ~isempty(this_eye_xy)
    seg_eye_x = this_eye_xy(:,1)*ratio;
    seg_eye_y = this_eye_xy(:,2)*ratio;
    box_gaze_x_min = max(1, floor(seg_eye_x)-1);
    box_gaze_x_max = min(img_w, ceil(seg_eye_x)+1);
    box_gaze_y_min = max(1, floor(seg_eye_y)-1);
    box_gaze_y_max = min(img_h, ceil(seg_eye_y)+1);
end

seg_center_x = img_w/2;
seg_center_y = img_h/2;
if max_distance_half
    max_distance = sqrt(seg_center_x^2 + seg_center_y^2);
else
    max_distance = sqrt(img_w^2 + img_h^2);
end
blob_cells{5} = blob_cells{2} | blob_cells{3} | blob_cells{4};

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
    if ~isempty(this_eye_xy)
        mask_within_blob = blob_one(box_gaze_y_min:box_gaze_y_max, box_gaze_x_min:box_gaze_x_max);
        %             is_within_blob = false;
        if sum(~mask_within_blob) < 1
            is_within_blob = true;
        else
            is_within_blob = false;
        end
        
        if ~isnan(seg_eye_x) && ~isnan(seg_eye_y) && ~isempty(area)
            dmin_eye = max_distance; % a big number
            dsum_eye = 0;
            npixel_eye = 0;
            
            for n = 1 : size(area,1)
                % compute the min
                if ~is_within_blob
                    temp_eye = min(distance([seg_eye_x; seg_eye_y], area(n).PixelList'));
                    if (temp_eye < dmin_eye)
                        dmin_eye = temp_eye;
                    end
                end
                
                dsum_eye = dsum_eye + area(n).Area * distance([seg_eye_x; seg_eye_y], area(n).Centroid');
                npixel_eye = npixel_eye + area(n).Area;
            end
            
            if is_within_blob
                eye_min_dist(bidx) = 0;
            else
                eye_min_dist(bidx) = dmin_eye/max_distance;
            end
            
            eye_mean_dist(bidx) = (dsum_eye/npixel_eye)/max_distance;
        end
    end
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
