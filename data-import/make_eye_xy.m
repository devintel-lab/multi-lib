function make_eye_xy(IDs, corp, ranges)
%eye_range.txt is a tab-delimited file in extra_p of each subject folder
%and specifies the range of eye data as indicated by the red bar in the
%first and last frames of cam01 and cam02. The first line of eye_range.txt
%is the child onset and offset, while the second line is for parent. This
%script also filters out data points outside of bound pixel width and
%height. It assumes 640 x 480 resolution.

% IDs = 3408;
% corp = [1];

xmax = 640;
ymax = 480;
% addpath('./gaze');

if numel(num2str(IDs(1))) > 2
    sid = IDs;
else
    sid = list_subjects(IDs);
end
if numel(sid) > 1
    if exist('ranges', 'var') && ~isempty(ranges)
        error('Cannot specify ranges if more than one sid');
    end
    for s = 1:numel(sid)
        make_eye_xy_v2(sid(s), corp);
    end
    return
end

if ~exist('ranges', 'var') || isempty(ranges)
    %look for eye_range.txt in extra_p
    fn = fullfile(get_subject_dir(sid), 'extra_p', 'eye_range.txt');
    ranges = dlmread(fn, '\t');
    ranges = (num2cell(ranges,2))';
    ranges = ranges(corp);
end

if ~iscell(ranges)
    ranges = {ranges};
end

person = {'child' 'parent'};

sub_dir = get_subject_dir(sid);
sub_dir_extra_p = [sub_dir '/extra_p'];
dirs = {sub_dir sub_dir_extra_p};
txtendings = {'.txt' '_eye.txt'};

prefix = strfind(sub_dir, '__');
prefix = {[sub_dir(prefix:end) '_'] ''};

for p = 1:numel(corp)
    personid = person{corp(p)};
    range = ranges{p};
    if range(1) ~= -1
        for d = 1:numel(dirs)
            for t = 1:numel(txtendings)
                for f = 1:numel(prefix);
                    eye_file = sprintf('%s/%s%s%s', dirs{d}, prefix{f}, personid, txtendings{t});
                    if exist(eye_file, 'file')
                        disp('Found eye file');
                        if ~exist('foundfile', 'var')
                            foundfile = eye_file;
                        end
                    end
                end
            end
        end
        if ~exist('foundfile', 'var')
            disp(['Could not find eye text file for ' personid]);
            break
        end
        eye_file = foundfile; disp(eye_file);
        clear foundfile;
        
        stop = 0;
        
        fid = fopen(eye_file, 'r');
        allrows = {};
        idx = 1;
        %open and read file line by line until 'recordFrameCount' is reached
        while stop == 0
            tline = fgetl(fid);
            if strfind(tline, 'recordFrameCount')
                headers = textscan(tline, '%s');
                fgetl(fid); %skip blank line
                tline = fgetl(fid); %get first line of data
                while tline ~= -1
                    allrows{idx,1} = tline;
                    tline = fgetl(fid);
                    idx = idx + 1;
                end
                stop = 1;
            end
        end
        fclose(fid);
        
        bw = cellfun(@(A) strtrim(A), allrows, 'un', 0);
        tmp = cellfun(@(A) strsplit(A, ' '), bw, 'un', 0);
        alldata = vertcat(tmp{:});
        headers = headers{1};
        %find correct indices for headers
        porxidx = ismember(headers, 'porX');
        poryidx = ismember(headers, 'porY');
        sfcidx = ismember(headers, 'sceneFrameCount');
        if sum(sfcidx) == 0
            sfcidx = ismember(headers, 'movieFrameCount');
        end
        %get the relevant columns in the data
        reldata = horzcat(alldata(:,sfcidx), alldata(:,porxidx), alldata(:,poryidx));
        reldata = str2double(reldata);
        %get data in range
        ib = find(reldata(:,1) == range(1));
        ie = find(reldata(:,1) == range(2));
        xydata = reldata(ib:ie,[2 3]);
        %filter data
        xydata(xydata(:,1)>xmax,:) = NaN;
        xydata(xydata(:,1)<0,:) = NaN;
        
        xydata(xydata(:,2)>ymax,:) = NaN;
        xydata(xydata(:,2)<0,:) = NaN;
        
        %get subject information
        tinfo = get_timing(sid);
        base = (0:size(xydata,1)-1)';
        base = base/tinfo.camRate;
        %create the time sequence
        timebase = base + tinfo.camTime;
        eye_data = [timebase xydata(:,[1 2])];

        %% start checking and saving
        if ismember(sid, get_rescale_gaze_subject_list)
            is_record_var = true;
            enable_visualize_heatmap = false;
            enable_check_visualize_range = false;
            frame_offset = 0; %by default
            check_save_eye_xy_variables(sid, eye_data, personid, ...
                frame_offset, is_record_var, enable_visualize_heatmap, enable_check_visualize_range);
        else
            %record variables
            record_variable(sid, sprintf('cont2_eye_xy_%s', personid), [timebase xydata(:,[1 2])]);
            record_variable(sid, sprintf('cont_eye_x_%s', personid), [timebase xydata(:,1)]);
            record_variable(sid, sprintf('cont_eye_y_%s', personid), [timebase xydata(:,2)]);
        end
    end
end