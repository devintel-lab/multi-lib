function load_frame_ui(h, b, m, z, subID, camIDs)
% possible optimization
% check if object moved, if not, skip the assignment
sensors = [1 2 3 4 5 6];
mosdata = load_motion_data(subID, sensors);
inhand = load_inhand_data(subID);
roi = load_roi_data(subID);
% speech = load_speech_data(subID);

figure(b);
b.UserData.subID = subID;
b.UserData.camIDs = camIDs;

for c = 1:numel(camIDs);
    b.UserData.sp(c).axh = subplot(numel(camIDs), 1, c);
    xlim([0 640]);
    ylim([0 480]);
    set(gca, 'xtick', []);
    set(gca, 'ytick', []);
    b.UserData.sp(c).im = image('CData', rand(480,640));
    b.UserData.sp(c).root = [get_subject_dir(subID) sprintf('/cam%02d_frames_p/', camIDs(c))];
end

figure(z); % topdown scatter plot
axz = axes;
axz.UserData.s2 = scatter(1,1, 'filled');
axz.UserData.colors = [
    0.0784    0.1686    0.5490;
    0.6353    0.0784    0.1843;
         0         0    1.0000;
         0    1.0000    1.0000;
    0.4941    0.1843    0.5569;
    1.0000         0    1.0000;];
% axz.UserData.s2.CData = axz.UserData.colors;
patch([-400 -400 450 450], [-500 100 100 -500], [45 45 45 45], [0 0.4471 0.7412]);
x_lim = [-400 450];
y_lim = [-1000 600];
xlim(x_lim);
ylim(y_lim);
xlabel('x');
ylabel('y');
axz.Title.String = 'accumulated sensor position topdown view';

figure(m);
axm = axes;
axm.UserData.s3 = scatter3(axm, sensors, sensors, sensors, [1200; 1200;300;300;300;300], [0 1 1; 1 0 .6; 0 1 1; 0 1 1; 1 0 .6; 1 0 .6], 'filled', 'markeredgecolor', 'k');
axm.UserData.ll = line(mosdata.x_line,mosdata.y_line, mosdata.z_line, 'color', 'k');
axm.UserData.vert = [0 0 0; 0 50 0; 50 50 0; 50 0 0; 0 0 50; 0 50 50; 50 50 50; 50 0 50];
axm.UserData.obj(1) = patch('vertices', axm.UserData.vert, 'faces', [1 2 3 4;5 6 7 8;1 2 6 5;4 3 7 8;1 5 8 4;2 3 7 6], 'facecolor', 'b');
axm.UserData.obj(2) = patch('vertices', axm.UserData.vert, 'faces', [1 2 3 4;5 6 7 8;1 2 6 5;4 3 7 8;1 5 8 4;2 3 7 6], 'facecolor', 'g');
axm.UserData.obj(3) = patch('vertices', axm.UserData.vert, 'faces', [1 2 3 4;5 6 7 8;1 2 6 5;4 3 7 8;1 5 8 4;2 3 7 6], 'facecolor', 'r');
axm.UserData.gazeline_c = line([NaN NaN], [NaN NaN], [NaN NaN], 'color', [0 0.7 1], 'linestyle', '--');
axm.UserData.gazeline_p = line([NaN NaN], [NaN NaN], [NaN NaN], 'color', [1 0 .6], 'linestyle', '--');
axm.UserData.sensors = sensors;
axm.UserData.numsensors = length(sensors);
axm.UserData.mosdata = mosdata;
axm.UserData.inhand = inhand;
axm.UserData.roi = roi;
% child and parent
patch([-400 -400 450 450], [-500 100 100 -500], [45 45 45 45], [0 0.4471 0.7412]); % don't use alpha
axm.UserData.textc = text(0, 200, 350, 'C');
axm.UserData.textp = text(0, -600, 350, 'P');
x_lim = [-400 450];
y_lim = [-1000 600];
z_lim = [-50 400];
xlim(x_lim);
ylim(y_lim);
zlim(z_lim);

xlabel('x');
ylabel('y');
zlabel('z');
axm.UserData.tablez = 45;
axm.UserData.tablezplus1 = axm.UserData.tablez + 1;

figure(h);
axs = get(h, 'children');
for a = 1:numel(axs)
    set(h, 'CurrentAxes', axs(a));
    axs(a).UserData.hline_start = line('XData', [0 0], 'YData', [0 10], 'linewidth', 3, 'color', [1 .75 0]);
    axs(a).UserData.hline_end = line('XData', [0 0], 'YData', [0 10], 'linewidth', 3, 'color', [0 1 1]);
    caxs = get(axs(a), 'children');
    set(caxs, 'hittest', 'off'); % turn off hittest for rectangles
    set(axs(a), 'buttondownfcn', {@disp_pos, b, axm, axs, axz});
end
end

function disp_pos(axh, hit, b, axm, axs, axz)
for a = 1:numel(axs)
    axs(a).UserData.hline_start.Visible = 'off';
    axs(a).UserData.hline_end.Visible = 'off';
end
axh.UserData.hline_start.Visible = 'on';
axh.UserData.hline_end.Visible = 'on';
frameidx = floor((axh.CurrentPoint(1)-30)*30);
if hit.Button == 1
    axm.Title.String = sprintf('time: %.f', axh.CurrentPoint(1));
    axh.UserData.hline_start.XData = [axh.CurrentPoint(1) axh.CurrentPoint(1)];
    axm.UserData.s3.XData = axm.UserData.mosdata.x(frameidx,:);
    axm.UserData.s3.YData = axm.UserData.mosdata.y(frameidx,:);
    axm.UserData.s3.ZData = axm.UserData.mosdata.z(frameidx,:);
    axm.UserData.ll.XData(2:3:end) = axm.UserData.mosdata.x(frameidx,:);
    axm.UserData.ll.YData(2:3:end) = axm.UserData.mosdata.y(frameidx,:);
    axm.UserData.ll.ZData(2:3:end) = axm.UserData.mosdata.z(frameidx,:);
    axm.UserData.gazeline_c.XData = [NaN NaN];
    axm.UserData.gazeline_c.YData = [NaN NaN];
    axm.UserData.gazeline_c.ZData = [NaN NaN];
    axm.UserData.gazeline_p.XData = [NaN NaN];
    axm.UserData.gazeline_p.YData = [NaN NaN];
    axm.UserData.gazeline_p.ZData = [NaN NaN];
    axm.UserData.gazeline_c.XData(1) = axm.UserData.mosdata.x(frameidx, 1);
    axm.UserData.gazeline_c.YData(1) = axm.UserData.mosdata.y(frameidx, 1);
    axm.UserData.gazeline_c.ZData(1) = axm.UserData.mosdata.z(frameidx, 1);
    axm.UserData.gazeline_p.XData(1) = axm.UserData.mosdata.x(frameidx, 2);
    axm.UserData.gazeline_p.YData(1) = axm.UserData.mosdata.y(frameidx, 2);
    axm.UserData.gazeline_p.ZData(1) = axm.UserData.mosdata.z(frameidx, 2);
    for o = 1:3
        if axm.UserData.inhand.log(frameidx,o) == 1
            newframeidx = axm.UserData.inhand.inhand(frameidx,o);
            usetableheight = 1;
        else
            newframeidx = frameidx;
            usetableheight = 0;
        end
        
        if newframeidx ~= 0
            idx = axm.UserData.inhand.inhand(newframeidx,o);
            
            axm.UserData.obj(o).Vertices = axm.UserData.vert;
            axm.UserData.obj(o).Vertices(:,1) = axm.UserData.obj(o).Vertices(:,1) + axm.UserData.mosdata.x(newframeidx,idx);
            axm.UserData.obj(o).Vertices(:,2) = axm.UserData.obj(o).Vertices(:,2) + axm.UserData.mosdata.y(newframeidx,idx);
            if usetableheight
                axm.UserData.obj(o).Vertices(:,3) = axm.UserData.obj(o).Vertices(:,3) + axm.UserData.tablez;
            else
                axm.UserData.obj(o).Vertices(:,3) = axm.UserData.obj(o).Vertices(:,3) + axm.UserData.mosdata.z(newframeidx,idx);
            end
        end
        if axm.UserData.roi(frameidx,1) == o
            axm.UserData.gazeline_c.XData(2) = axm.UserData.obj(o).Vertices(1,1);
            axm.UserData.gazeline_c.YData(2) = axm.UserData.obj(o).Vertices(1,2);
            axm.UserData.gazeline_c.ZData(2) = axm.UserData.obj(o).Vertices(1,3);
        end
        if axm.UserData.roi(frameidx,2) == o
            axm.UserData.gazeline_p.XData(2) = axm.UserData.obj(o).Vertices(1,1);
            axm.UserData.gazeline_p.YData(2) = axm.UserData.obj(o).Vertices(1,2);
            axm.UserData.gazeline_p.ZData(2) = axm.UserData.obj(o).Vertices(1,3);
        end
    end
    
    if axm.UserData.roi(frameidx,1) == 4
        axm.UserData.gazeline_c.XData(2) = axm.UserData.mosdata.x(frameidx, 2);
        axm.UserData.gazeline_c.YData(2) = axm.UserData.mosdata.y(frameidx, 2);
        axm.UserData.gazeline_c.ZData(2) = axm.UserData.mosdata.z(frameidx, 2);
    end
    if axm.UserData.roi(frameidx,2) == 4
        axm.UserData.gazeline_p.XData(2) = axm.UserData.mosdata.x(frameidx, 1);
        axm.UserData.gazeline_p.YData(2) = axm.UserData.mosdata.y(frameidx, 1);
        axm.UserData.gazeline_p.ZData(2) = axm.UserData.mosdata.z(frameidx, 1);
    end
    
    for cc = 1:length(b.UserData.camIDs)
        im = imread([b.UserData.sp(cc).root sprintf('img_%d.jpg', frameidx)]);
        b.UserData.sp(cc).im.CData = im(end:-1:1,:,:);
    end
    drawnow update;
else
    axh.UserData.hline_end.XData = [axh.CurrentPoint(1) axh.CurrentPoint(1)];
    startframeidx = floor((axh.UserData.LastPoint-30)*30);
    framelist = startframeidx:1:frameidx;
    linepos = linspace(axh.UserData.LastPoint, axh.CurrentPoint(1), length(framelist));
    toskip = 3;
    skip = toskip;
    numdata = length(framelist)*axm.UserData.numsensors;
    axz.UserData.s2.XData = nan(1,numdata);
    axz.UserData.s2.YData = nan(1,numdata);
    axz.UserData.s2.ZData = nan(1,numdata);
    axz.UserData.s2.ZData(1,:) = axm.UserData.tablezplus1;
    axz.UserData.s2.CData = zeros(numdata,3);
    
    for sidx = 1:axm.UserData.numsensors
        axz.UserData.s2.CData(sidx:axm.UserData.numsensors:numdata,1) = axz.UserData.colors(sidx,1);
        axz.UserData.s2.CData(sidx:axm.UserData.numsensors:numdata,2) = axz.UserData.colors(sidx,2);
        axz.UserData.s2.CData(sidx:axm.UserData.numsensors:numdata,3) = axz.UserData.colors(sidx,3);
    end
    axzidx = reshape(1:axm.UserData.numsensors*numdata, [axm.UserData.numsensors numdata])';
    for s = 1:length(framelist)
        if skip == 0
            %                 fprintf('frame: %d\n', framelist(s));
            for cc = 1:length(b.UserData.camIDs)
                im = imread([b.UserData.sp(cc).root sprintf('img_%d.jpg', framelist(s))]);
                b.UserData.sp(cc).im.CData = im(end:-1:1,:,:);
            end
            skip = toskip;
        else
            skip = skip - 1;
        end
        axm.Title.String = sprintf('time: %.f', linepos(s));
        axh.UserData.hline_start.XData = [linepos(s) linepos(s)];
        axm.UserData.s3.XData = axm.UserData.mosdata.x(framelist(s),:);
        axm.UserData.s3.YData = axm.UserData.mosdata.y(framelist(s),:);
        axm.UserData.s3.ZData = axm.UserData.mosdata.z(framelist(s),:);
        axz.UserData.s2.XData(1,axzidx(s,:)) = axm.UserData.mosdata.x(framelist(s),:);
        axz.UserData.s2.YData(1,axzidx(s,:)) = axm.UserData.mosdata.y(framelist(s),:);
        axm.UserData.ll.XData(2:3:end) = axm.UserData.mosdata.x(framelist(s),:);
        axm.UserData.ll.YData(2:3:end) = axm.UserData.mosdata.y(framelist(s),:);
        axm.UserData.ll.ZData(2:3:end) = axm.UserData.mosdata.z(framelist(s),:);
        axm.UserData.gazeline_c.XData = [NaN NaN];
        axm.UserData.gazeline_c.YData = [NaN NaN];
        axm.UserData.gazeline_c.ZData = [NaN NaN];
        axm.UserData.gazeline_p.XData = [NaN NaN];
        axm.UserData.gazeline_p.YData = [NaN NaN];
        axm.UserData.gazeline_p.ZData = [NaN NaN];
        axm.UserData.gazeline_c.XData(1) = axm.UserData.mosdata.x(framelist(s), 1);
        axm.UserData.gazeline_c.YData(1) = axm.UserData.mosdata.y(framelist(s), 1);
        axm.UserData.gazeline_c.ZData(1) = axm.UserData.mosdata.z(framelist(s), 1);
        axm.UserData.gazeline_p.XData(1) = axm.UserData.mosdata.x(framelist(s), 2);
        axm.UserData.gazeline_p.YData(1) = axm.UserData.mosdata.y(framelist(s), 2);
        axm.UserData.gazeline_p.ZData(1) = axm.UserData.mosdata.z(framelist(s), 2);
        for o = 1:3
            if axm.UserData.inhand.log(framelist(s),o) ~= 1
                idx = axm.UserData.inhand.inhand(framelist(s),o);
                axm.UserData.obj(o).Vertices = axm.UserData.vert;
                axm.UserData.obj(o).Vertices(:,1) = axm.UserData.obj(o).Vertices(:,1) + axm.UserData.mosdata.x(framelist(s),idx);
                axm.UserData.obj(o).Vertices(:,2) = axm.UserData.obj(o).Vertices(:,2) + axm.UserData.mosdata.y(framelist(s),idx);
                axm.UserData.obj(o).Vertices(:,3) = axm.UserData.obj(o).Vertices(:,3) + axm.UserData.mosdata.z(framelist(s),idx);
            else
                axm.UserData.obj(o).Vertices(:,3) = axm.UserData.vert(:,3) + axm.UserData.tablez;
            end
            if axm.UserData.roi(framelist(s),1) == o
                axm.UserData.gazeline_c.XData(2) = axm.UserData.obj(o).Vertices(1,1);
                axm.UserData.gazeline_c.YData(2) = axm.UserData.obj(o).Vertices(1,2);
                axm.UserData.gazeline_c.ZData(2) = axm.UserData.obj(o).Vertices(1,3);
            end
            if axm.UserData.roi(framelist(s),2) == o
                axm.UserData.gazeline_p.XData(2) = axm.UserData.obj(o).Vertices(1,1);
                axm.UserData.gazeline_p.YData(2) = axm.UserData.obj(o).Vertices(1,2);
                axm.UserData.gazeline_p.ZData(2) = axm.UserData.obj(o).Vertices(1,3);
            end
        end
        if axm.UserData.roi(framelist(s),1) == 4
            axm.UserData.gazeline_c.XData(2) = axm.UserData.mosdata.x(framelist(s), 2);
            axm.UserData.gazeline_c.YData(2) = axm.UserData.mosdata.y(framelist(s), 2);
            axm.UserData.gazeline_c.ZData(2) = axm.UserData.mosdata.z(framelist(s), 2);
        end
        if axm.UserData.roi(framelist(s),2) == 4
            axm.UserData.gazeline_p.XData(2) = axm.UserData.mosdata.x(framelist(s), 1);
            axm.UserData.gazeline_p.YData(2) = axm.UserData.mosdata.y(framelist(s), 1);
            axm.UserData.gazeline_p.ZData(2) = axm.UserData.mosdata.z(framelist(s), 1);
        end
        

        
        drawnow update;
    end
    axh.UserData.hline_start.XData = [axh.UserData.LastPoint axh.UserData.LastPoint];
end
axh.UserData.LastPoint = axh.CurrentPoint(1);
end
