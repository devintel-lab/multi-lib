function load_frame(subid, timestamp, camIDs)
framenum = time2frame_num(timestamp, subid);
for c = 1:numel(camIDs);
    subplot(numel(camIDs), 1, c);
    path = [get_subject_dir(subid) sprintf('/cam%02d_frames_p/img_%d.jpg', camIDs(c), framenum)];
    im = imread(path);
    image(im);
    axis image; % maintain image size
    set(gca, 'xtick', []);
    set(gca, 'ytick', []);
end
end