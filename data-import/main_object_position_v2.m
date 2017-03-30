function main_object_position_v2(subid, corp)

if numel(subid) > 1
    for s = 1 : numel(subid)
        fprintf('%d out of %d\n', s, numel(subid));
        main_object_position_v2(subid(s), corp);
    end
    return
end


if strcmp(corp, 'child')
    camid = 5;
elseif strcmp(corp, 'parent')
    camid = 6;
else
    disp('corp argument must be parent or child');
end


trials = get_trials(subid);

[frames filetype prefix] = start_end(subid, camid, trials(1), trials(end));


object_min_distance = zeros(5, numel(frames));
object_mean_distance = zeros(5, numel(frames));

type = {'jpg' 'tif'};
ft_other = type{~ismember(type, filetype)};

for i = 1 : numel(frames)
    f_num = frames(i);
    img_file = sprintf('%s/img_%d_seg.%s', prefix, f_num, filetype);
    try
        img = imread(img_file);
    catch exception
        try
            img_file = sprintf('%s/img_%d_seg.%s', prefix, f_num, ft_other);
        catch exception2
        end
    end
           
        
    if max(max(img)) == 1
        img = img == 1;
    else
        img = img >= 50;
    end
    
    xmax = size(img, 2);
    ymax = size(img, 1);
    xcenter = xmax/2;
    ycenter = ymax/2;
    max_distance = sqrt(xcenter^2 + ycenter^2);
    
    segs = seperate_seg(img);
    
    if mod(f_num, 250) == 0
        fprintf('%d out of %d\n', f_num, frames(end));
    end
    
    
    for m = 2:4
        area = regionprops(bwconncomp(segs{m}),'PixelList', 'Area', 'Centroid');
        
        dmin = max_distance; % a big number
        dsum = 0;
        npixel = 0;
        for n = 1 : size(area,1)
            % compute the min
            temp = min(distance([xcenter; ycenter], area(n).PixelList'));
            %                     disp(temp)
            if (temp < dmin)
                dmin = temp;
            end;
            
            dsum = dsum + area(n).Area * distance([xcenter;ycenter], area(n).Centroid');
            npixel = npixel + area(n).Area;
        end;
        
        object_min_distance(m,i) = dmin/max_distance;
        if npixel > 0
            object_mean_distance(m,i) = (dsum/npixel)/max_distance;
        else
            object_mean_distance(m,i) = 1;
        end;
        
    end
end
disp(size(object_min_distance));

times = make_time(subid, frames);
disp(size(times));

for seg = 2:4
    vals = object_min_distance(seg, :)';
    var_name = sprintf('cont_vision_min-dist_obj%d_%s', seg-1, corp);
    record_variable(subid, var_name, [times, vals]);

%     vals = object_mean_distance(seg, :)';
%     var_name = sprintf('cont_vision_mean-dist_obj%d_%s', seg-1, corp);
%     record_variable(subid, var_name, [times, vals]);

end % for

%     function [frames filetype prefix] = start_end(subid, camid, start, last)
%         dir_name = get_subject_dir(subid);
%         prefix = sprintf('%s/cam0%d_frames_p', dir_name, camid);
%         frames = zeros(last+10, 2);
%         filetype = 'jpg';
%         for f = start:last
%             img_file1 = sprintf('%s/img_%d_seg.%s', prefix, f, filetype);
%             if exist(img_file1, 'file')
%                 if start == 0;
%                     frames(f+1, :) = [f 1];
%                 else
%                     frames(f,:) = [f 1];
%                 end
%             elseif exist(strrep(img_file1, 'jpg', 'tif'), 'file')
%                 filetype = 'tif';
%                 if start == 0;
%                     frames(f+1, :) = [f 1];
%                 else
%                     frames(f,:) = [f 1];
%                 end
%             end
%         end
%         log = frames(:,2) == 0;
%         frames(log,:) = [];
%         frames = frames(:,1);
%     end



end