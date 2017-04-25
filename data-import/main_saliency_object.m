function main_saliency_object(subid, corp, channel)
%corp is 'child' or 'parent'
%channel is 'I' 'M' or 'O'
%subid can be a list of subjects

if numel(subid) > 1
    for s = 1: numel(subid)
        fprintf('%d out of %d\n', s, numel(subid));
        try
        main_saliency_object(subid(s), corp, channel);
        catch
            continue
        end
    end
    return
end

if strcmp(corp, 'child')
    camid = 1;
elseif strcmp(corp, 'parent')
    camid = 2;
else
    disp('corp argument must be parent or child');
end

trials = get_trials(subid);

[frames, extp, extsp, prefix, sprefix] = presal2(subid, camid, channel);

old_segs = {};

for i = 1:size(frames,1)
    f_num = frames(i,1);
    sal_file = sprintf('%s/img_%d%s', sprefix, f_num, extsp{i});
    simg = imread(sal_file);
    simg = thresholding(simg, 50);
    img_file = sprintf('%s/img_%d_seg%s', prefix,f_num, extp{i});
    img = get_image(img_file);
    
    xmax = size(img,2);
    ymax = size(img,1);
    area_size = xmax*ymax;
    
    resize = size(simg,1) / size(img,1);
    segs = seperate_seg(img, resize*2);
    segs{5} = segs{1} | segs{2} | segs{3} | segs{4};
    segs{6} = segs{2} | segs{3} | segs{4};
    
    if isempty(old_segs)
        old_segs = segs;
    end
    
    if mod(f_num, 250) == 0
        fprintf('%d out of %d\n', f_num, frames(end,1));
    end
    
    for m = 1:6
        combined_obj_img = old_segs{m} | segs{m};
        salient_obj_img = combined_obj_img & simg;
        
        npixel(i,m) = size(find(salient_obj_img == 1), 1)/area_size;
    end
    old_segs = segs;
end
all_frames = [trials(1):1:trials(end)]';
times = make_time(subid, all_frames);
var_vals = {'hands', 'obj1', 'obj2', 'obj3', 'all', 'all-obj'};
for m = 1:6
    data = zeros(size(all_frames,1),1);
    vals = npixel(:,m);
    member = ismember(all_frames, frames(:,1));
    data(member, 1) = vals;
    var_name = sprintf('cont_vision_%s-#pixel_%s_%s', channel, var_vals{m}, corp);
    record_variable(subid, var_name, [times, data]);
end


    function imgout = get_image(filename)
        imgout = imread(filename);
        if numel(size(imgout)) > 2
            imgout = double(squeeze(imgout(:,:,1)));
        end
        if max(max(imgout)) == 1
            imgout = imgout == 1;
        else
            imgout = imgout >= 50;
        end
    end

    function [frames, extp, extsp, prefix, sprefix] = presal2(subid, camid, channel)
        dir_name = get_subject_dir(subid);
        prefix = sprintf('%s/cam0%d_frames_p', dir_name, camid);
        sprefix = sprintf('%s/cam0%d_saliency_p/%s', dir_name, camid, channel);
        prefixfiles = dir(fullfile(prefix, 'img*seg*'));
        sprefixfiles = dir(fullfile(sprefix, 'img*'));
        allp_o = {prefixfiles.name}';
%         allp = arrayfun(@(A) A.name, prefixfiles, 'uniformoutput', 0);
        allp = cellfun(@(A) strrep(A,'_seg', ''), allp_o, 'uniformoutput', 0);
        allsp = {sprefixfiles.name}';
%         allsp = arrayfun(@(A) A.name, sprefixfiles, 'uniformoutput', 0);
        [~,fpartp,extp] = cellfun(@(A) fileparts(A), allp, 'uniformoutput', 0);
        [~,fpartsp,extsp] = cellfun(@(A) fileparts(A), allsp, 'uniformoutput', 0);
        [frames,allpidx,allspidx] = intersect(fpartp, fpartsp);
        D = cellfun(@(A) sscanf(A, 'img_%d'), frames);
        [frames, sortidx] = sort(D);
        extp = extp(allpidx);
        extp = extp(sortidx);
        extsp = extsp(allspidx);
        extsp = extsp(sortidx);
    end

    function [frames, p, prefix, sprefix] = presal(subid, camid, channel, start, last)
        dir_name = get_subject_dir(subid);
        prefix = sprintf('%s/cam0%d_frames_p', dir_name, camid);
        sprefix = strrep(prefix, 'frames', 'saliency');
        frames = zeros(last+10,4);
        for f = start:last
            if mod(f, 250) == 0
                fprintf('presal: %d out of %d\n', f, last);
            end
            simg_file = sprintf('%s/%s/img_%d.png', sprefix, channel, f);
            if exist(simg_file, 'file')
                info = imfinfo(simg_file);
                simgsize = info.Height*info.Width;
                if start == 0;
                    frames(f+1,[1 2]) = [f simgsize];
                else
                    frames(f,[1 2]) = [f simgsize];
                end
            end
            jimg_file = sprintf('%s/img_%d_seg.jpg', prefix, f);
            timg_file = strrep(jimg_file, 'jpg', 'tif');
            if exist(jimg_file, 'file')
                info = imfinfo(jimg_file);
                jimgsize = info.Height*info.Width;
                if start == 0;
                    frames(f+1,3) = jimgsize;
                else
                    frames(f,3) = jimgsize;
                end
            end
            if exist(timg_file, 'file')
                info = imfinfo(timg_file);
                timgsize = info.Height*info.Width;
                if start == 0;
                    frames(f+1,4) = timgsize;
                else
                    frames(f,4) = timgsize;
                end
            end
        end
        log = frames(:,1) > 0;
        frames = frames(log,:);
        log = sum(frames(:,[3 4]), 2) == 0;
        frames(log,:) = [];
        pick = repmat(frames(:,2), 1,2) - frames(:,[3 4]);
        [~, p] = min(pick, [], 2);
    end
end