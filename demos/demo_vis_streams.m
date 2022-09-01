function demo_vis_streams(option)

switch option
    case 1
        subexpIDs = [7106 7107 7108];
        vars = {'cevent_eye_roi_child', 'cevent_eye_roi_parent', 'cevent_eye_joint-attend_both'};
        labels = {'ceye', 'peye', 'ja'};
        directory = '/multi-lib/user_output/vis_streams/case1';
        % note that directory = '.' will save in the current directory
        vis_streams(subexpIDs, vars, labels, directory);
        
    case 2
        % if you want to choose your own colors, set the setcolors
        % parameter to 4 (or however many different categories you have)
        % a dialog box will appear that enables you to set the colors.
        subexpIDs = [7106 7107 7108];
        vars = {'cevent_eye_roi_child', 'cevent_eye_roi_parent', 'cevent_eye_joint-attend_both'};
        labels = {'ceye', 'peye', 'ja'};
        directory = '/multi-lib/user_output/vis_streams/case2';
        setcolors = 4;
        vis_streams(subexpIDs, vars, labels, directory, setcolors);
        
    case 3
        % alternatively, setcolors can be an Nx3 matrix specifying the
        % colors to use
        subexpIDs = [7106 7107 7108];
        vars = {'cevent_eye_roi_child', 'cevent_eye_roi_parent', 'cevent_eye_joint-attend_both'};
        labels = {'ceye', 'peye', 'ja'};
        directory = '/multi-lib/user_output/vis_streams/case3';
        setcolors = [
            1 .5 0; % orange
            1 1 0; % yellow
            0 1 1; % cyan
            .5 .5 .5 % gray
            ];
        vis_streams(subexpIDs, vars, labels, directory, setcolors);
        
    case 4
        % vars can also be data. If there are 3 subjects, then make sure
        % the data is a cell array of 3 double arrays
        subexpIDs = [7106 7107 7108];
        rawdata1 = get_variable(7106, 'cevent_eye_roi_child');
        rawdata2 = get_variable(7107, 'cevent_eye_roi_child');
        rawdata3 = get_variable(7108, 'cevent_eye_roi_child');
        data.data = {rawdata1; rawdata2; rawdata3};
        data.sub_list = subexpIDs;
        data.edge = 1;
        
        vars = {data, 'cevent_eye_roi_parent', 'cevent_eye_joint-attend_both'};
        labels = {'ceye', 'peye', 'ja'};
        directory = '/multi-lib/user_output/vis_streams/case4';
        vis_streams(subexpIDs, vars, labels, directory);
        
    case 5
        % continuous functions can be converted to cevents using
        % cont2scaled.m
        subexpIDs = [7106 7107 7108];
        vars = {'cont_vision_size_obj1_child'
            'cont_vision_size_obj2_child'
            'cont_vision_size_obj3_child'};
        labels = {'size1', 'size2', 'size3'};
        colors = [0 0 1; 0 1 0; 1 0 0];
        
        input = cell(3,1);
        for v = 1:3
            input{v,1} = cont2scaled(subexpIDs, vars{v}, 5, 10, 50, [1 1 1], colors(v,:));
        end
        directory = '/multi-lib/user_output/vis_streams/case5';
        vis_streams(subexpIDs, input, labels, directory);
        
    case 6
        % can also draw a black box around portions of the graph. This is
        % useful for visualizing grouped data. In the below example, the
        % data for cevent_eye_joint-attend_both will be plotted as boxes.
        % box data should come first in vars{} cell array.
        subexpIDs = [7106 7107 7108];
        vars = {
            struct('data', 'cevent_eye_joint-attend_both', 'box', 1)
            'cevent_eye_roi_child'
            'cevent_eye_roi_parent'
            };
        labels = {'null', 'ceye', 'peye'};
        directory = '/multi-lib/user_output/vis_streams/case6';
        % note that directory = '.' will save in the current directory
        vis_streams(subexpIDs, vars, labels, directory);
        
end
end