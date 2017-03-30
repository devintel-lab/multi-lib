function dataout = load_inhand_data(subID)
% sensors
% cl 3
% cr 4
% pl 5
% pr 6
sensors = [3 4 5 6];
cl = get_variable(subID, 'cstream_inhand_left-hand_obj-all_child');
cr = get_variable(subID, 'cstream_inhand_right-hand_obj-all_child');
pl = get_variable(subID, 'cstream_inhand_left-hand_obj-all_parent');
pr = get_variable(subID, 'cstream_inhand_right-hand_obj-all_parent');

inhand = cat(2, cl(:,2), cr(:,2), pl(:,2), pr(:,2));
out = zeros(size(inhand,1), 3);
lastknown = out;
firstlog = [1 1 1];
for i = 1:size(inhand)
    for o = 1:3
        idx = find(inhand(i,:) == o, 1, 'first');
        if ~isempty(idx)
            if firstlog(o)
                out(1:i,o) = i;
                firstlog(o) = 0;
            end
            out(i,o) = sensors(idx);
            lastknown(i,o) = i;
        else
            if i > 1
                lastknown(i,o) = lastknown(i-1,o);
            end
        end
    end
end
log = out == 0;
out(log) = lastknown(log);
dataout.log = log;
dataout.inhand = out;
end