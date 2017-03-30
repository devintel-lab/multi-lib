function master_preprocessing_toy_room(kidIDs, expID, option)
agents = {'child', 'parent'};
for k = 1:numel(kidIDs)
    kid = kidIDs(k);
    fprintf('%d\n', kid);
    root = get_kid_root(kid, expID);
    
    % create generic timing.mat to visualize results in temp_backus
    trialInfo.camRate = 30;
    trialInfo.camTime = 30;
    save(fullfile(root,'derived','timing.mat'), 'trialInfo');
    if sum(ismember(option, {'prefixation', 'all'})) > 0
        fid = fopen(fullfile(root,'supporting_files','extract_range.txt'), 'r');
        exr = textscan(fid, '[%d]');
        fclose(fid);
        maxFrame = exr{1}(2)-exr{1}(1) + 1;
        eye_range = dlmread(fullfile(root,'supporting_files','eye_range.txt'), ' ');
        for a = 1:2
            agent = agents{a};
            fn = fullfile(root,'supporting_files',[agent '_eye.txt']);
            if exist(fn, 'file')
                [data,info] = parse_yarbus(fn);
                frames = data{info.frameCount};
                data = [data{info.porX} data{info.porY}];
                log = frames >= eye_range(a,1) & frames <= eye_range(a,2);
                xy = data(log, [1 2]);
                xy = xy(1:maxFrame,:);
                xyd = diff(xy,1);
                xyspeed = sqrt(sum(xyd.^2,2));
                fr = (1:size(xy,1))';
                tb = (fr-1)/30+30;
                tbvel = [tb(2:end) xyspeed];
                tbvel(tbvel(:,2)>200,2) = NaN;
                sdata.data = tbvel;
                sdata.variable = ['cont_eye_xy-speed_' agent];
                save(fullfile(root,'derived',[sdata.variable '.mat']), 'sdata');
                frxy = [fr xy];
                padding = 100;
                xmax = 720+padding;
                xmin = -padding;
                ymax = 480+padding;
                ymin = -padding;
                %             x = frxy(:,2);
                %             y = frxy(:,3);
                %             invalid = x<0|x>xmax|y<0|y>ymax;
                %             frinvalid = fr;
                %             frinvalid = frinvalid(invalid);
                %             frinvalid(:,2) = frinvalid;
                sample_rate = 1;
                lowThresh = 28.82;
                [~, ~, fix_time, fix_durations] = VelocityAndDistanceThresholdFixations(frxy, xmax, ymax, xmin, ymin, sample_rate, 200, lowThresh, 10, 2); % 200, 28.82, 10, 2
                fixations = [fix_time fix_time+fix_durations];
                durs = fixations(:,2)-fixations(:,1);
                log = durs > 5;
                fixations = fixations(log,[1 2]);
                % split up long fixations into smaller ones
                newfixations = [];
                for f = 1:size(fixations)
                    splitbegin = fixations(f,1):60:fixations(f,2);
                    if splitbegin(end) == fixations(f,2)
                        splitbegin = splitbegin(1:end-1);
                    end
                    splitend = splitbegin-1;
                    grouped = cat(2, splitbegin', ([splitend(2:end) fixations(f,2)])');
                    newfixations = cat(1,newfixations,grouped);
                end
                fixations = newfixations;
                %             fixations = cat(1, fixations, frinvalid);
                fixations = sortrows(fixations, [1 2]);
                meanframe = round(mean(fixations,2));
                towrite = fixations;
                towrite(:,3) = meanframe;
                write2csv(towrite,fullfile(root,'supporting_files',['fixation_frames_' agent '.txt']), 'onset,offset,middleframe');
                fixations(1:2:end,3) = 1;
                fixations(2:2:end,3) = 2;
                frcst = cevent2cstreamtb(fixations, fr);
                tbcst = [tb frcst(:,2)];
                sdata.variable = ['cstream_fixations_' agent];
                sdata.data = tbcst;
                save(fullfile(root,'derived',['cstream_fixations_' agent]), 'sdata');
                tbcev = cstream2cevent(tbcst);
                sdata.variable = ['cevent_fixations_' agent];
                sdata.data = tbcev;
                save(fullfile(root,'derived',['cevent_fixations_' agent]), 'sdata');
                fixations(1:2:end,3) = 27;
                fixations(2:2:end,3) = 28;
                frcst = cevent2cstreamtb(fixations, fr);
                frcst(meanframe,2) = -1;
                log = frcst(:,2) == 0;
                frcst(log,2) = NaN;
                codingfile = fullfile(root,'supporting_files', ['coding_eye_roi_' agent '.mat']);
                sdata.data = frcst;
                sdata.variable = ['coding_eye_roi_' agent];
                save(codingfile, 'sdata');
                fprintf('Saved file : %s\n', codingfile);
            end
        end
    end
end
end