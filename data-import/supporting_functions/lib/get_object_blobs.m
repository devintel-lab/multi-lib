function [new_bw] = get_object_blobs(bw)

[h w] = size(bw);

% setting the thresholds
thresh_major_blob_ratio = 0.7;
thresh_max_dist_bw_blobs = 0.7;
thresh_min_blob_ratio = 0.1;
thresh_min_blob_rel = 0.02;
thresh_min_blob_abs = h*w*0.0001;

thresh_filter = thresh_max_dist_bw_blobs * (1/thresh_min_blob_ratio) ...
    * thresh_major_blob_ratio;

diag = sqrt(h*h + w*w);
blob_prpts = regionprops(bw);
num_blobs = length(blob_prpts);

if num_blobs > 1
    blob_prpts = regionprops(bw, 'Area', 'Centroid', 'BoundingBox', 'Image');
    
    blob_cells = {};
    blob_area = nan(num_blobs, 1);
    blob_centers = nan(num_blobs, 2);
    filter_blob_list = [];
    
    
    for nbidx = 1:num_blobs
        tmp_mask = false(h,w);
        tmp_bounding_box = blob_prpts(nbidx).BoundingBox;
        [blob_h blob_w] = size(blob_prpts(nbidx).Image);
        x1 = max(1, floor(tmp_bounding_box(1)));
        y1 = max(1, floor(tmp_bounding_box(2)));
        x2 = min(w, x1+blob_w-1);
        y2 = min(h, y1+blob_h-1);
        
        tmp_mask(y1:y2, x1:x2) = blob_prpts(nbidx).Image > 0;
        tmp_blob = tmp_mask & bw;
        blob_cells{nbidx} = tmp_blob;
        
        blob_area(nbidx) = blob_prpts(nbidx).Area;        
        blob_centers(nbidx, :) = blob_prpts(nbidx).Centroid;
    end

    blob_area_sum = sum(blob_area);
    blob_area_ratio = blob_area / blob_area_sum;
    [v_major i_major] = max(blob_area_ratio);
    is_major_blob = v_major > thresh_major_blob_ratio;
    blob_dist2major_ratio = nan(num_blobs, 1);
    blob_filter_thresh = nan(num_blobs, 1);

    for nbidx = 1:num_blobs        
        if is_major_blob
            tmp_diff = blob_centers(i_major, :) - blob_centers(nbidx, :);
            tmp_dist = sqrt(sum(tmp_diff.*tmp_diff));            
            tmp_dist_ratio = tmp_dist / diag;
            blob_dist2major_ratio(nbidx) = tmp_dist_ratio;
            
            tmp_probs = tmp_dist_ratio * (1/blob_area_ratio(nbidx)) ...
                * v_major;
            blob_filter_thresh(nbidx) = tmp_probs;

            if tmp_probs > thresh_filter
                filter_blob_list = [filter_blob_list nbidx];
            end            
        end
        
        if blob_area_ratio(nbidx) < thresh_min_blob_rel || ...
                blob_area(nbidx) < thresh_min_blob_abs
            filter_blob_list = [filter_blob_list nbidx];
        end
        
    end
%     is_major_blob
%     blob_area_ratio
%     blob_area
%     thresh_min_blob_abs
%     filter_blob_list

    obj_blob_list = setdiff(1:num_blobs, filter_blob_list);
    new_bw = false(h,w);
    for nbidx = 1:length(obj_blob_list)
        
        new_bw = new_bw | blob_cells{obj_blob_list(nbidx)};
%         imshow(blob_cells{obj_blob_list(nbidx)});
    end

% blob_area_ratio
% blob_dist2major_ratio
% blob_filter_thresh
% 
% num_blobs
% filter_blob_list
% imshow(new_bw)
% pause

else
    new_bw = bw;
end

end