function imdata = get_image_by_time(subj_id, cam, time)


sub_dir = get_subject_dir(subj_id);
frame = time2frame_num(time, subj_id);
fname = fullfile(sub_dir, sprintf('cam%02d_frames_p', cam), sprintf('img_%d.jpg', frame));

imdata = imread(fname);
