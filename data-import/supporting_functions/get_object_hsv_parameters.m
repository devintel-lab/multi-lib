
function obj_hsv_params = get_object_hsv_parameters(exp_id, sub_id)

% This is the script containing all the HSV parameters for 
% generating vision related variables.
% 
% Updated Apr. 5, 2013
% Contact: txu@indiana.edu
% 
% 
% Comman thresholds:
%         obj_hsv_params.obj_list = [1 2 3];
%         
%         obj_hsv_params.blue_h_low = 0.55;
%         obj_hsv_params.blue_h_high = 0.68;
%         obj_hsv_params.blue_s_low = 0.4;
% 
%         obj_hsv_params.green_h_low = 0.25;
%         obj_hsv_params.green_h_high = 0.40;
%         obj_hsv_params.green_s_low = 0.4;
% 
%         obj_hsv_params.red_h_low_child = 0.80;
%         obj_hsv_params.red_h_andhigh_child = 0.975;
%         obj_hsv_params.red_s_low_child = 0.6;
%         obj_hsv_params.red_v_low_child = 0.2;
%             
%         obj_hsv_params.red_h_low_parent = 0.78;
%         obj_hsv_params.red_h_orhigh_parent = 0.05;
%         obj_hsv_params.red_s_low_parent = 0.45;
%         obj_hsv_params.red_v_low_parent = 0.3;
% 
%%%%%%%%%%%%%%%%%%%%%%%%%
% 
obj_hsv_params.bg_s_low = 0.09;
obj_hsv_params.bg_v_low = 0.07;

if exp_id == 14
    if sub_id > 1418
        exp_id = 45;
    end
end

switch exp_id
        
    case 991 % for for 2nd_taiwan
        obj_hsv_params.obj_list = [1 2 3];
        
        obj_hsv_params.blue_h_low = 0.55;
        obj_hsv_params.blue_h_high = 0.70;
        obj_hsv_params.blue_s_low = 0.5;

        obj_hsv_params.green_h_low = 0.25;
        obj_hsv_params.green_h_high = 0.45;
        obj_hsv_params.green_s_low = 0.2;

        obj_hsv_params.red_h_low_child = 0.80;
        obj_hsv_params.red_h_andhigh_child = 0.975;
        obj_hsv_params.red_s_low_child = 0.6;
        obj_hsv_params.red_v_low_child = 0.2;

%         obj_hsv_params.red_h_low_parent = 0.85;
%         obj_hsv_params.red_h_orhigh_parent = 0.05;
%         obj_hsv_params.red_s_low_parent = 0.6;
%         obj_hsv_params.red_v_low_parent = 0.3;

    case 992 % for pure testing
        obj_hsv_params.obj_list = [1 2 3];
        
        obj_hsv_params.blue_h_low = 0.55;
        obj_hsv_params.blue_h_high = 0.70;
        obj_hsv_params.blue_s_low = 0.5;
        obj_hsv_params.blue_v_low = 0.2;

        obj_hsv_params.green_h_low = 0.25;
        obj_hsv_params.green_h_high = 0.45;
        obj_hsv_params.green_s_low = 0.2;
        obj_hsv_params.green_v_low = 0.1;

%         obj_hsv_params.red_h_low_child = 0.80;
%         obj_hsv_params.red_h_andhigh_child = 0.975;
%         obj_hsv_params.red_s_low_child = 0.6;
%         obj_hsv_params.red_v_low_child = 0.2;

        obj_hsv_params.red_h_low_parent = 0.9;
        obj_hsv_params.red_h_andhigh_parent = 0.995;
        obj_hsv_params.red_s_low_parent = 0.8;
        obj_hsv_params.red_v_low_parent = 0.2;

    case 999 % for pure testing
        obj_hsv_params.obj_list = [1 2 3];
        
        obj_hsv_params.blue_h_low = 0.55;
        obj_hsv_params.blue_h_high = 0.70;
        obj_hsv_params.blue_s_low = 0.5;

        obj_hsv_params.green_h_low = 0.25;
        obj_hsv_params.green_h_high = 0.40;
        obj_hsv_params.green_s_low = 0.4;

        obj_hsv_params.red_h_low_child = 0.80;
        obj_hsv_params.red_h_andhigh_child = 0.975;
        obj_hsv_params.red_s_low_child = 0.6;
        obj_hsv_params.red_v_low_child = 0.2;

        obj_hsv_params.red_h_low_parent = 0.85;
        obj_hsv_params.red_h_orhigh_parent = 0.05;
        obj_hsv_params.red_s_low_parent = 0.6;
        obj_hsv_params.red_v_low_parent = 0.3;
        
    case 14 %for new subjects in exp 14 > 1418, go to exp 45
        
        obj_hsv_params.obj_list = [1 2 3];
        
        obj_hsv_params.blue_h_low = 0.55;
        obj_hsv_params.blue_h_high = 0.70;
        obj_hsv_params.blue_s_low = 0.3;

        obj_hsv_params.green_h_low = 0.25;
        obj_hsv_params.green_h_high = 0.40;
        obj_hsv_params.green_s_low = 0.2;

        obj_hsv_params.red_h_low_child = 0.78;
        obj_hsv_params.red_h_orhigh_child = 0.006;
        obj_hsv_params.red_s_low_child = 0.5;
        obj_hsv_params.red_v_low_child = 0.3;

        obj_hsv_params.red_h_low_parent = 0.78;
        obj_hsv_params.red_h_orhigh_parent = 0.01;
        obj_hsv_params.red_s_low_parent = 0.6;
        obj_hsv_params.red_v_low_parent = 0.3;
        
    case 16
        obj_hsv_params.obj_list = [1 2 3 4 5];
        
        obj_hsv_params.blue_h_low = 0.55;
        obj_hsv_params.blue_h_high = 0.70;
        obj_hsv_params.blue_s_low = 0.4;

        obj_hsv_params.green_h_low = 0.25;
        obj_hsv_params.green_h_high = 0.40;
        obj_hsv_params.green_s_low = 0.5;

        obj_hsv_params.red_h_low_child = 0.96;
        obj_hsv_params.red_h_orhigh_child = 0.04;
        obj_hsv_params.red_s_low_child = 0.6;
        obj_hsv_params.red_v_low_child = 0.3;
 
        obj_hsv_params.red_h_low_parent = 0.96;
        obj_hsv_params.red_h_orhigh_parent = 0.04;
        obj_hsv_params.red_s_low_parent = 0.6;
        obj_hsv_params.red_v_low_parent = 0.4;
        
        obj_hsv_params.yellow_h_low = 0.13;
        obj_hsv_params.yellow_h_high = 0.25;
        obj_hsv_params.yellow_s_low = 0.6;
        obj_hsv_params.yellow_v_low = 0.4;
        
        obj_hsv_params.pink_h_low = 0.85;
        obj_hsv_params.pink_h_high = 0.96;
        obj_hsv_params.pink_s_low = 0.5;
        obj_hsv_params.pink_v_low = 0.3;
        
    case 17        
        obj_hsv_params.obj_list = [1 2 3];
        
        if ~ismember(sub_id, [1701 1702])
            disp(['Warning: this scrip only works for child cameras in ' ...
                '1701, 1702, and all parent cameras']);
        else
            obj_hsv_params.blue_h_low = 0.50;
            obj_hsv_params.blue_h_high = 0.70;
            obj_hsv_params.blue_s_low = 0.50;

            obj_hsv_params.green_h_low = 0.23;
            obj_hsv_params.green_h_high = 0.45;
            obj_hsv_params.green_s_low = 0.50;

            obj_hsv_params.red_h_low_child = 0.78;
            obj_hsv_params.red_h_orhigh_child = 0.01;
            obj_hsv_params.red_s_low_child = 0.6;
            obj_hsv_params.red_v_low_child = 0.3;
        end

        if ismember(sub_id, [1701 1702 1703 1705])
            obj_hsv_params.red_h_low_parent = 0.78;
            obj_hsv_params.red_h_orhigh_parent = 0.02;
            obj_hsv_params.red_s_low_parent = 0.6;
            obj_hsv_params.red_v_low_parent = 0.3; 
        else
            obj_hsv_params.red_h_low_parent = 0.78;
            obj_hsv_params.red_h_orhigh_parent = 0.045;
            obj_hsv_params.red_s_low_parent = 0.6;
            obj_hsv_params.red_v_low_parent = 0.3; 
        end
        
    case {18, 23}
        obj_hsv_params.obj_list = [1 2 3 4 5];
        
        obj_hsv_params.blue_h_low = 0.55;
        obj_hsv_params.blue_h_high = 0.70;
        obj_hsv_params.blue_s_low = 0.4;

        obj_hsv_params.green_h_low = 0.25;
        obj_hsv_params.green_h_high = 0.40;
        obj_hsv_params.green_s_low = 0.5;

        obj_hsv_params.red_h_low_child = 0.96;
        obj_hsv_params.red_h_orhigh_child = 0.04;
        obj_hsv_params.red_s_low_child = 0.6;
        obj_hsv_params.red_v_low_child = 0.3;
 
        obj_hsv_params.red_h_low_parent = 0.96;
        obj_hsv_params.red_h_orhigh_parent = 0.04;
        obj_hsv_params.red_s_low_parent = 0.6;
        obj_hsv_params.red_v_low_parent = 0.4;
        
        obj_hsv_params.yellow_h_low = 0.13;
        obj_hsv_params.yellow_h_high = 0.25;
        obj_hsv_params.yellow_s_low = 0.6;
        obj_hsv_params.yellow_v_low = 0.4;
        
        obj_hsv_params.pink_h_low = 0.85;
        obj_hsv_params.pink_h_high = 0.96;
        obj_hsv_params.pink_s_low = 0.5;
        obj_hsv_params.pink_v_low = 0.3;
        
    case 32
        obj_hsv_params.obj_list = [1 2 3];
        
        obj_hsv_params.blue_h_low = 0.55;
        obj_hsv_params.blue_h_high = 0.70;
        obj_hsv_params.blue_s_low = 0.3;

        obj_hsv_params.green_h_low = 0.25;
        obj_hsv_params.green_h_high = 0.40;
        obj_hsv_params.green_s_low = 0.2;

        if ismember(sub_id, [3201 3209])
            obj_hsv_params.red_h_low_child = 0.83;
            obj_hsv_params.red_h_orhigh_child = 0.005;
            obj_hsv_params.red_s_low_child = 0.6;
            obj_hsv_params.red_v_low_child = 0.3;
        else
            obj_hsv_params.red_h_low_child = 0.80;
            obj_hsv_params.red_h_andhigh_child = 0.975;
            obj_hsv_params.red_s_low_child = 0.6;
            obj_hsv_params.red_v_low_child = 0.2;
        end

        obj_hsv_params.red_h_low_parent = 0.78;
        obj_hsv_params.red_h_orhigh_parent = 0.05;
        obj_hsv_params.red_s_low_parent = 0.4;
        obj_hsv_params.red_v_low_parent = 0.3; 
        
    case 34
        obj_hsv_params.blue_h_low = 0.55;
        obj_hsv_params.blue_h_high = 0.68;
        obj_hsv_params.blue_s_low = 0.4;

        obj_hsv_params.green_h_low = 0.25;
        obj_hsv_params.green_h_high = 0.40;
        obj_hsv_params.green_s_low = 0.4;

        obj_hsv_params.red_h_low_child = 0.80;
        obj_hsv_params.red_h_andhigh_child = 0.975;
        obj_hsv_params.red_s_low_child = 0.6;
        obj_hsv_params.red_v_low_child = 0.2;
            
        obj_hsv_params.red_h_low_parent = 0.78;
        obj_hsv_params.red_h_orhigh_parent = 0.05;
        obj_hsv_params.red_s_low_parent = 0.45;
        obj_hsv_params.red_v_low_parent = 0.2;
        
    case 35
%         if ~ismember(sub_id, 3501:3505)
%             error('Wrong subject');
%         end
        
        obj_hsv_params.obj_list = [1 2 3];
        
        obj_hsv_params.blue_h_low = 0.55;
        obj_hsv_params.blue_h_high = 0.70;
        obj_hsv_params.blue_s_low = 0.3;

        obj_hsv_params.green_h_low = 0.25;
        obj_hsv_params.green_h_high = 0.40;
        obj_hsv_params.green_s_low = 0.2;

        obj_hsv_params.red_h_low_child = 0.80;
        obj_hsv_params.red_h_andhigh_child = 0.975;
        obj_hsv_params.red_s_low_child = 0.6;
        obj_hsv_params.red_v_low_child = 0.2;

        obj_hsv_params.red_h_low_parent = 0.78;
        obj_hsv_params.red_h_orhigh_parent = 0.05;
        obj_hsv_params.red_s_low_parent = 0.40;
        obj_hsv_params.red_v_low_parent = 0.3;
        
    case 39
        obj_hsv_params.obj_list = [1 2 3];
        
        obj_hsv_params.blue_h_low = 0.55;
        obj_hsv_params.blue_h_high = 0.70;
        obj_hsv_params.blue_s_low = 0.3;

        obj_hsv_params.green_h_low = 0.25;
        obj_hsv_params.green_h_high = 0.45;
        obj_hsv_params.green_s_low = 0.2;
        
        obj_hsv_params.red_h_low_child = 0.80;
        obj_hsv_params.red_h_andhigh_child = 0.975;
        obj_hsv_params.red_s_low_child = 0.6;
        obj_hsv_params.red_v_low_child = 0.2;

        if ismember(sub_id, [3901 3902 3908])
            obj_hsv_params.red_h_low_child = 0.78;
            obj_hsv_params.red_h_orhigh_child = 0.01;
            obj_hsv_params.red_s_low_child = 0.6;
            obj_hsv_params.red_v_low_child = 0.3;
        else
            obj_hsv_params.red_h_low_child = 0.80;
            obj_hsv_params.red_h_andhigh_child = 0.975;
            obj_hsv_params.red_s_low_child = 0.6;
            obj_hsv_params.red_v_low_child = 0.3;
        end
        
        obj_hsv_params.red_h_low_parent = 0.78;
        obj_hsv_params.red_h_orhigh_parent = 0.05;
        obj_hsv_params.red_s_low_parent = 0.4;
        obj_hsv_params.red_v_low_parent = 0.3;
        
    case 41
        obj_hsv_params.obj_list = [1 2 3];
        
        obj_hsv_params.blue_h_low = 0.55;
        obj_hsv_params.blue_h_high = 0.70;
        obj_hsv_params.blue_s_low = 0.3;

        obj_hsv_params.green_h_low = 0.20; %0.25
        obj_hsv_params.green_h_high = 0.40;
        obj_hsv_params.green_s_low = 0.40; %0.2
        
        obj_hsv_params.red_h_low_child = 0.80;
        obj_hsv_params.red_h_andhigh_child = 0.975;
        obj_hsv_params.red_s_low_child = 0.6;
        obj_hsv_params.red_v_low_child = 0.2;

        obj_hsv_params.red_h_low_parent = 0.78;
        obj_hsv_params.red_h_orhigh_parent = 0.05;
        obj_hsv_params.red_s_low_parent = 0.4;
        obj_hsv_params.red_v_low_parent = 0.3;
        
    case 43
        obj_hsv_params.bg_s_low = 0.09;
        obj_hsv_params.bg_v_low = 0.02;%0.07
        
        obj_hsv_params.obj_list = [1 2 3];
        
        obj_hsv_params.blue_h_low = 0.55;
        obj_hsv_params.blue_h_high = 0.68;
        obj_hsv_params.blue_s_low = 0.2;%0.4
        
        obj_hsv_params.green_h_low = 0.25;
        obj_hsv_params.green_h_high = 0.40;
        obj_hsv_params.green_s_low = 0.4;
        
        obj_hsv_params.red_h_low_child = 0.80;
        obj_hsv_params.red_h_orhigh_child = 0.02;%0.05
        obj_hsv_params.red_s_low_child = 0.7;
        obj_hsv_params.red_v_low_child = 0.3;
        
        
        obj_hsv_params.red_h_low_parent = 0.78;
        obj_hsv_params.red_h_orhigh_parent = 0.05;
        obj_hsv_params.red_s_low_parent = 0.40;%.45
        obj_hsv_params.red_v_low_parent = 0.3;
        
        %         if ismember(sub_id, 4306)
        %             obj_hsv_params.red_h_orhigh_child = 0.02;
        %         end
        
        %         if ismember(sub_id, [4302])
        %             obj_hsv_params.blue_s_low = 0.15;
        %         elseif ismember(sub_id, [4304])
        %             obj_hsv_params.red_s_low_child = 0.9;
        %             obj_hsv_params.bg_v_low = 0.01;
        %             obj_hsv_params.red_s_low_parent = 0.3;
        %         elseif ismember(sub_id, [4305 4308 4309])
        %             obj_hsv_params.red_s_low_parent = 0.4;
        %         end
        
        
    case 44
        obj_hsv_params.bg_s_low = 0.09;
        obj_hsv_params.bg_v_low = 0.02;%0.07
        
        obj_hsv_params.obj_list = [1 2 3];
        
        obj_hsv_params.blue_h_low = 0.55;
        obj_hsv_params.blue_h_high = 0.68;
        obj_hsv_params.blue_s_low = 0.2;%0.4
        
        obj_hsv_params.green_h_low = 0.25;
        obj_hsv_params.green_h_high = 0.40;
        obj_hsv_params.green_s_low = 0.4;
        
        obj_hsv_params.red_h_low_child = 0.80;
        obj_hsv_params.red_h_orhigh_child = 0.02;%0.05
        obj_hsv_params.red_s_low_child = 0.7;
        obj_hsv_params.red_v_low_child = 0.3;
        
        
        obj_hsv_params.red_h_low_parent = 0.78;
        obj_hsv_params.red_h_orhigh_parent = 0.05;
        obj_hsv_params.red_s_low_parent = 0.40;%.45
        obj_hsv_params.red_v_low_parent = 0.3;
        
    case 45 %new subjects in exp 14
        obj_hsv_params.obj_list = [1 2 3];
        
        obj_hsv_params.blue_h_low = 0.55;
        obj_hsv_params.blue_h_high = 0.75;
        obj_hsv_params.blue_s_low = 0.2;

        obj_hsv_params.green_h_low = 0.24;
        obj_hsv_params.green_h_high = 0.40;
        obj_hsv_params.green_s_low = 0.2;
        
        obj_hsv_params.red_h_low_child = 0.80;
        obj_hsv_params.red_h_orhigh_child = 0.05;
        obj_hsv_params.red_s_low_child = 0.55;
        obj_hsv_params.red_v_low_child = 0.2;

        obj_hsv_params.red_h_low_parent = 0.78;
        obj_hsv_params.red_h_orhigh_parent = 0.05;
        obj_hsv_params.red_s_low_parent = 0.4;
        obj_hsv_params.red_v_low_parent = 0.3; 
        
    case {70, 71, 72, 73, 74, 75, 49, 84}
        [~,b,~] = cIDs(sub_id);
        if b(3) < 20150401
            obj_hsv_params.bg_s_low = 0.09;
            obj_hsv_params.bg_v_low = 0.02;%0.07
            
            obj_hsv_params.obj_list = [1 2 3];
            
            obj_hsv_params.blue_h_low = 0.55;
            obj_hsv_params.blue_h_high = 0.68;
            obj_hsv_params.blue_s_low = 0.2;%0.4
            
            obj_hsv_params.green_h_low = 0.25;
            obj_hsv_params.green_h_high = 0.40;
            obj_hsv_params.green_s_low = 0.4;
            
            obj_hsv_params.red_h_low_child = 0.80;
            obj_hsv_params.red_h_orhigh_child = 0.02;%0.05
            obj_hsv_params.red_s_low_child = 0.7;
            obj_hsv_params.red_v_low_child = 0.3;
            
            
            obj_hsv_params.red_h_low_parent = 0.78;
            obj_hsv_params.red_h_orhigh_parent = 0.05;
            obj_hsv_params.red_s_low_parent = 0.40;%.45
            obj_hsv_params.red_v_low_parent = 0.3;
            
            obj_hsv_params.red_s_low_topdown = 0.6;
            obj_hsv_params.green_s_low_topdown = 0.3;
        else
            obj_hsv_params.bg_s_low = 0.09;
            obj_hsv_params.bg_v_low = 0.02;%0.07
            
            obj_hsv_params.obj_list = [1 2 3];
            
            obj_hsv_params.blue_h_low = 0.55;
            obj_hsv_params.blue_h_high = 0.68;
            obj_hsv_params.blue_s_low = 0.2;%0.4
            
            obj_hsv_params.green_h_low = 0.25;
            obj_hsv_params.green_h_high = 0.40;
            obj_hsv_params.green_s_low = 0.4;
            
            obj_hsv_params.red_h_low_child = 0.80;
            obj_hsv_params.red_h_orhigh_child = 0.02;%0.05
            obj_hsv_params.red_s_low_child = 0.7;
            obj_hsv_params.red_v_low_child = 0.3;
            
            
            obj_hsv_params.red_h_low_parent = 0.78;
            obj_hsv_params.red_h_orhigh_parent = 0.02;
            obj_hsv_params.red_s_low_parent = 0.7;%.45
            obj_hsv_params.red_v_low_parent = 0.3;
            
            obj_hsv_params.red_s_low_topdown = 0.6;
            obj_hsv_params.green_s_low_topdown = 0.3;
            if ismember(sub_id, [7428, 7523, 4941, 7428, 7525])
                obj_hsv_params.red_s_low_parent = 0.35;
            end
        end
        
    case {83, 84}
        obj_hsv_params.bg_s_low = 0.09;
        obj_hsv_params.bg_v_low = 0.02;%0.07
        
        obj_hsv_params.yellow_h_low = 0.083;
        obj_hsv_params.yellow_h_high = 0.11;
        obj_hsv_params.yellow_s_low = 0.48;
        obj_hsv_params.yellow_s_high = 0.6;
        obj_hsv_params.yellow_v_low = 0.7;
        
        obj_hsv_params.red_h_low_child = 0.80;
        obj_hsv_params.red_h_orhigh_child = 0.02;%0.05
        obj_hsv_params.red_s_low_child = 0.7;
        obj_hsv_params.red_v_low_child = 0.3;
        
        obj_hsv_params.blue_h_low = 0.55;
        obj_hsv_params.blue_h_high = 0.68;
        obj_hsv_params.blue_s_low = 0.2;%0.4
        
        
    case {98}
        obj_hsv_params.blue_h_low = 0.55;
        obj_hsv_params.blue_h_high = 0.70;
        obj_hsv_params.blue_s_low = 0.4;
        
        obj_hsv_params.green_h_low = 0.25;
        obj_hsv_params.green_h_high = 0.40;
        obj_hsv_params.green_s_low = 0.35;
        
        obj_hsv_params.red_h_low_child = 0.96;
        obj_hsv_params.red_h_orhigh_child = 0.04;
        obj_hsv_params.red_s_low_child = 0.6;
        obj_hsv_params.red_v_low_child = 0.3;
        
        obj_hsv_params.red_h_low_parent = 0.96;
        obj_hsv_params.red_h_orhigh_parent = 0.04;
        obj_hsv_params.red_s_low_parent = 0.5;
        obj_hsv_params.red_v_low_parent = 0.35;
        
        obj_hsv_params.yellow_h_low = 0.13;
        obj_hsv_params.yellow_h_high = 0.25;
        obj_hsv_params.yellow_s_low = 0.6;
        obj_hsv_params.yellow_v_low = 0.4;
        
        obj_hsv_params.pink_h_low = 0.85;
        obj_hsv_params.pink_h_high = 0.96;
        obj_hsv_params.pink_s_low = 0.5;
        obj_hsv_params.pink_v_low = 0.3;
        
        obj_hsv_params.bg_s_low = 0.09;
        obj_hsv_params.bg_v_low = 0.02;%0.07
        
        
    otherwise
        error(['The program hasn''t specified object detection ' ...
            'thresholds for this experiment yet!']);
end