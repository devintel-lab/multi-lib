function out = make_time_base(subid)
gg = get_timing(subid);

out = (gg.trials(1):1:gg.trials(end))';

out = (out-1)/gg.camRate + gg.camTime;


end