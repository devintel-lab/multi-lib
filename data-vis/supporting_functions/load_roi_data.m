function dataout = load_roi_data(subID)
cr = get_variable(subID, 'cstream_eye_roi_child');
pr = get_variable(subID, 'cstream_eye_roi_parent');

dataout = cat(2, cr(:,2), pr(:,2));
end