%reads .mat info file and returns framerate for camera
function rate = get_rate(subid)

path = get_subject_dir(subid);
subinfo = get_subject_info(subid);

pathfile = [path '/__' int2str(subinfo(3)) '_' int2str(subinfo(4)) '_info.mat'];
z = load(pathfile);
rate = z.trialInfo.camRate;
end