function [blob_size, blob_center] = cal_blob_size_and_center(blob_img)
% Calculate the total size of the blobs in input binary image.
% Note the "size" is actually the proportion of the blobs in the image.
% 
% blob_img: input binary image, which can contain multiple blobs.
% blob_size:
% blob_center: 
%
[h w] = size(blob_img);

region  = regionprops(blob_img);

if isempty(region)
    blob_size = 0;
    blob_center = [NaN NaN];
    return;
end

centers = vertcat(region.Centroid);
sizes   = vertcat(region.Area);
weight  = sizes / sum(sizes);

blob_size = sum(sizes) / (h*w);
blob_center(1) = sum(centers(:,1) .* weight);
blob_center(2) = sum(centers(:,2) .* weight);

end