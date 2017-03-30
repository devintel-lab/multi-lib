function segs = seperate_seg(inputIm, scale)
% Seperate the image from into four segmentions
% 
% segs = seperate_seg(inputIm);
%   Input:
%     inputIm: binary image read from img_?_seg.tif
%   Output:
%     segs: 4 cell arrays *ymid*xmid matrix (where [ymid xmid] = round(size(inputIm)) )
%           segs(1,:,:) is the segmentation for hands and faces
%           segs(2,:,:) is the segmentation for object 1
%           segs(3,:,:) is the segmentation for object 2
%           segs(4,:,:) is the segmentation for object 3

% 
if isempty(inputIm)
    segs = [];
    return;
end
if ~exist('scale','var') || isempty(scale)
    scale = 2;
end

%check to make sure image is binary
if numel(unique(inputIm)) ~= 2
    error('input image not binary');
end

%clear cross
columns = sum(inputIm,1) == size(inputIm,1); %finds columns filled with 1s
rows = sum(inputIm,2) == size(inputIm, 2); %finds rows filled with 1s
newIm = inputIm;
newIm(:,columns) = 0; %sets these columns to 0
newIm(rows,:) = 0; %sets these rows to 0

% clear cross
[ymax, xmax] = size(inputIm);
% newIm = inputIm;
ymid = round(ymax/2);
% newIm(ymid,1:xmax) =  zeros(xmax,1);
xmid = round(xmax/2);
% newIm(1:ymax,xmid) =  zeros(ymax,1);

%segs = zeros(4, ymax, xmax);
%segs = segs>1;

% For logical data, using 'nearest' in imresize can be faster and get same result  
segs{1} = imresize(newIm(1:ymid, 1:xmid), scale, 'nearest');
segs{2} = imresize(newIm(1:ymid, xmid+1:xmax), scale, 'nearest');
segs{3} = imresize(newIm(ymid+1:ymax, 1:xmid), scale, 'nearest');
segs{4} = imresize(newIm(ymid+1:ymax, xmid+1:xmax), scale, 'nearest');
