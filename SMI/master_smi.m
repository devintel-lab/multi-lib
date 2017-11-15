function master_smi(subID, flag, filename)
% This function works only for comma separated txt data
% flag can be one of:
%   - 'overall'     (for debugging use; export all files listed below)
%   - 'all'         (exports all files except blink & saccade & undefined & missing)
%   - 'roi'         (cstream_eye_roi_child & cevent_eye_roi_child)
%   - 'fixroi'      (cstream_eye_roi_fixation_child & cevent_eye_roi_fixation_child)
%   - 'trials'      (cevent_trials)
%   - 'cont2xy'     (cont2_eye_xy_child)
%   - 'blinkroi'    (cstream_eye_roi_blink_child)
%   - 'saccaderoi'  (cstream_eye_roi_saccade_child)
%   - 'undefined'   (cstream_eye_roi_undefined_child)   (when the event is not categorized by the SMI program)
%   - 'missing'     (cstream_eye_roi_missing_child)     (when the point of regard is beyond the screen)
%
% AOI data:
%   n+1 'White Space'
%   (n is the number of AOIs)
%   99  blink
%   98  saccade
%   97  undefined
%   96  missing
%   
%filename = 'Raw Data - Raw Data';
disp('[*] Creating data files, please wait...')
sep = filesep();

if ~exist('flag', 'var')
    flag = 'all';
end

if ~exist('filename', 'var')
    filename = 'Raw Data - Raw Data.txt';
end

path = [get_subject_dir(subID) sep 'derived' sep]; 
file_dir = [get_subject_dir(subID) sep 'extra_p' sep filename];

T = readtable(file_dir);

%Exclude Trials and Stimulus
numOfData = numel(T.RecordingTime_ms_);
trialsToBeExcluded = {};
stimulusToBeExcluded = {};
trialsToBeIncluded = [1:numOfData];
stimulusToBeIncluded = [1:numOfData];
for i = 1:numel(trialsToBeExcluded)
    trialsToBeIncluded = intersect(trialsToBeIncluded, ...
        find(~strcmp(trialsToBeIncluded{i}, T.Trial)));
end
for i = 1:numel(stimulusToBeExcluded)
    stimulusToBeIncluded = intersect(stimulusToBeIncluded, ...
        find(~strcmp(stimulusToBeIncluded{i}, T.Stimulus)));
end
categoryGroupToBeIncluded = find(strcmp('Eye', T.CategoryGroup));
indexToBeIncluded = intersect(trialsToBeIncluded, stimulusToBeIncluded);
indexToBeIncluded = intersect(indexToBeIncluded, categoryGroupToBeIncluded);

%Innitializing data(recordingTime/trials/stimulus/categoryRight/x/y/aoi/numOfCleanData)
sampleRate = 30;
recordingTime  = T.RecordingTime_ms_(indexToBeIncluded) / 1000;
trials = {T.Trial{indexToBeIncluded}};
stimulus = {T.Stimulus{indexToBeIncluded}};
categoryRight = {T.CategoryRight{indexToBeIncluded}};
cellx = {T.PointOfRegardRightX_px_{indexToBeIncluded}};
celly = {T.PointOfRegardRightY_px_{indexToBeIncluded}};
cellaoi = {T.AOINameRight{indexToBeIncluded}};
numOfCleanData = numel(recordingTime);
x = zeros(numOfCleanData, 1);
y = zeros(numOfCleanData, 1);
aoi = zeros(numOfCleanData, 1);

%Number of AOIs in the study
numOfAOIs = 0;
listOfAOIs = {};
for i = 1:numOfCleanData
    if ~any(strcmp(cellaoi{i}, listOfAOIs)) &&...
            ~strcmp(cellaoi{i}, 'White Space') &&...
            ~strcmp(cellaoi{i}, '-')
        numOfAOIs = numOfAOIs + 1;
        listOfAOIs = horzcat(listOfAOIs, cellaoi{i});
    end
end
disp(['[*] There are ' num2str(numOfAOIs) ' AOIs in this study'])

for i = 1:numOfCleanData
    if strcmp(cellx{i}, '-')
        x(i) = NaN;
    else
        x(i) = str2num(cellx{i});
    end
    
    if strcmp(celly{i}, '-')
        y(i) = NaN;
    else
        y(i) = str2num(celly{i});
    end
    
    if strcmp(cellaoi{i}, '-')
        aoi(i) = 96;
    elseif strcmp(cellaoi{i}, 'White Space')
        aoi(i) = numOfAOIs + 1;
    else
        aoi(i) = str2num(cellaoi{i});
    end
end

%Seperate the data for each trials
trialIndex = {};
trialSet = {};
numOfTrials = 0;
for i = 1:numOfCleanData
    if ~any(strcmp(trials{i}, trialSet))
        numOfTrials = numOfTrials + 1;
        trialSet{numOfTrials} = trials{i};
    end
end
for i = 1:numel(trialSet)
    trialIndex{i} = find(strcmp(trialSet{i}, trials));
end

%Formate time stamps
trialLength = 7;
startingTime = 30;
intervalBetweenTwoTrials = 1;
intervalBetweenTwoStamps = 0.033;
numOfTimeStamps = trialLength * sampleRate;
formattedTimeStamps = zeros(numOfTimeStamps, 1);
for i = 1:numOfTimeStamps
    mili = rem(i - 1, 3) * intervalBetweenTwoStamps;
    pointSec = fix((i - 1) / 3) * 0.1;
    sec = mili + pointSec;
    formattedTimeStamps(i) = sec;
end

revisedData = {};

for i = 1:numel(trialIndex)
    currentTrialInd = trialIndex{i};
    tmpRecordingTime = recordingTime(currentTrialInd);
    %tmpStimulus = {stimulus{currentTrialInd}};
    tmpCategoryRight = {categoryRight{currentTrialInd}};
    tmpx = x(currentTrialInd);
    tmpy = y(currentTrialInd);
    tmpaoi = aoi(currentTrialInd);
    tmpRecordingTime = tmpRecordingTime - tmpRecordingTime(1);
    finalIndex = suitTimeStamps(tmpRecordingTime, formattedTimeStamps);
    tmpTrialData = {};
    for j = 1:numel(finalIndex)
        tmpInd = finalIndex(j);
        if ~isnan(tmpInd)
            tmpTrialData{j,1} = formattedTimeStamps(tmpInd) + ...
                (trialLength + intervalBetweenTwoTrials) * (i - 1) + 30;
            tmpTrialData{j,2} = tmpCategoryRight{tmpInd};
            tmpTrialData{j,3} = tmpx(tmpInd);
            tmpTrialData{j,4} = tmpy(tmpInd);
            tmpTrialData{j,5} = tmpaoi(tmpInd);
        else
            tmpTrialData{j,1} = NaN;
            tmpTrialData{j,2} = NaN;
            tmpTrialData{j,3} = NaN;
            tmpTrialData{j,4} = NaN;
            tmpTrialData{j,5} = NaN;
        end
    end
    revisedData = vertcat(revisedData, tmpTrialData);
end

%Stimulus list
stimList = {};
currentStimulus = '';
for i = 1:numel(stimulus)
    if ~strcmp(stimulus{i}, currentStimulus)
        currentStimulus = stimulus{i};
        stimList{end+1} = currentStimulus;
    end
end

%Simulus(characters) list to number list
visitedStim = {};
tmpCounter = 0;
stimNumList = [];
for i = 1:numel(stimList)
    if ismember(stimList{i}, visitedStim)
        stimNumList(end+1) = find(strcmp(stimList{i}, visitedStim));
    else
        tmpCounter = tmpCounter + 1;
        stimNumList(end+1) = tmpCounter;
        visitedStim{end+1} = stimList{i};
    end
end

%Transcribe the final data to lab format data
cevent_trials = [];
for i = 1:numOfTrials
    cevent_trials(i, 1) = 30 + ...
        (i - 1) * (trialLength + intervalBetweenTwoTrials);
    cevent_trials(i, 2) = cevent_trials(i, 1) + trialLength;
    cevent_trials(i, 3) = stimNumList(i);
end

cont2_eye_xy_child = [];
cstream_eye_roi_child = [];
cstream_eye_roi_fixation_child = [];
cstream_eye_roi_saccade_child = [];
cstream_eye_roi_blink_child = [];
cstream_eye_roi_undefined_child = [];

%fixCounter = 1;

for i = 1:size(revisedData, 1)
    cont2_eye_xy_child(i, 1) = revisedData{i, 1};
    cont2_eye_xy_child(i, 2) = revisedData{i, 3};
    cont2_eye_xy_child(i, 3) = revisedData{i, 4};
    cstream_eye_roi_child(i, 1) = revisedData{i, 1};
    cstream_eye_roi_child(i, 2) = revisedData{i, 5};
    if strcmp(revisedData{i, 2}, 'Fixation')
        cstream_eye_roi_fixation_child(i, 1) = revisedData{i, 1};
        cstream_eye_roi_fixation_child(i, 2) = revisedData{i, 5};
        %fixCounter = fixCounter + 1;
    else
        cstream_eye_roi_fixation_child(i, 1) = revisedData{i, 1};
        cstream_eye_roi_fixation_child(i, 2) = 0;
    end
    %----Saccade----
    if strcmp(revisedData{i, 2}, 'Saccade')
        cstream_eye_roi_saccade_child(i, 1) = revisedData{i, 1};
        cstream_eye_roi_saccade_child(i, 2) = revisedData{i, 5};
        cstream_eye_roi_child(i, 1) = revisedData{i, 1};
        cstream_eye_roi_child(i, 2) = 98;
    else
        cstream_eye_roi_saccade_child(i, 1) = revisedData{i, 1};
        cstream_eye_roi_saccade_child(i, 2) = 0;
    end
    %-----Blink-----
    if strcmp(revisedData{i, 2}, 'Blink')
        cstream_eye_roi_blink_child(i, 1) = revisedData{i, 1};
        cstream_eye_roi_blink_child(i, 2) = revisedData{i, 5};
        cstream_eye_roi_child(i, 1) = revisedData{i, 1};
        cstream_eye_roi_child(i, 2) = 99;
    else
        cstream_eye_roi_blink_child(i, 1) = revisedData{i, 1};
        cstream_eye_roi_blink_child(i, 2) = 0;
    end
    %---Undefined---
    if strcmp(revisedData{i, 2}, '-')
        cstream_eye_roi_undefined_child(i, 1) = revisedData{i, 1};
        cstream_eye_roi_undefined_child(i, 2) = revisedData{i, 5};
        cstream_eye_roi_child(i, 1) = revisedData{i, 1};
        cstream_eye_roi_child(i, 2) = 97;
    else
        cstream_eye_roi_undefined_child(i, 1) = revisedData{i, 1};
        cstream_eye_roi_undefined_child(i, 2) = 0;
    end
    %----missing----
    if 96 == revisedData{i, 5}
        cstream_eye_roi_missing_child(i, 1) = revisedData{i, 1};
        cstream_eye_roi_missing_child(i, 2) = revisedData{i, 5};
        cstream_eye_roi_child(i, 1) = revisedData{i, 1};
        cstream_eye_roi_child(i, 2) = 96;
    else
        cstream_eye_roi_missing_child(i, 1) = revisedData{i, 1};
        cstream_eye_roi_missing_child(i, 2) = 0;
    end
end

switch flag
    
    case 'overall'
        %----cont2----
        sdata.variable = 'cont2_eye_xy_child';
        sdata.data = cont2_eye_xy_child;
        save([path 'cont2_eye_xy_child.mat'], 'sdata')

        %-----roi-----
        sdata.variable = 'cstream_eye_roi_child';
        sdata.data = cstream_eye_roi_child;
        save([path 'cstream_eye_roi_child.mat'], 'sdata')

        sdata.variable = 'cevent_eye_roi_child';
        sdata.data = cstream2cevent(cstream_eye_roi_child);
        save([path 'cevent_eye_roi_child'], 'sdata')

        %---fixation---
        sdata.variable = 'cstream_eye_roi_fixation_child';
        sdata.data = cstream_eye_roi_fixation_child;
        save([path 'cstream_eye_roi_fixation_child.mat'], 'sdata')
        
        sdata.variable = 'cevent_eye_roi_fixation_child';
        sdata.data = cstream2cevent(cstream_eye_roi_fixation_child);
        save([path 'cevent_eye_roi_fixation_child'], 'sdata')
        
        %----Saccade----
        sdata.variable = 'cstream_eye_roi_saccade_child';
        sdata.data = cstream_eye_roi_saccade_child;
        save([path 'cstream_eye_roi_saccade_child.mat'], 'sdata')

        %-----Blink-----
        sdata.variable = 'cstream_eye_roi_blink_child';
        sdata.data = cstream_eye_roi_blink_child;
        save([path 'cstream_eye_roi_blink_child.mat'], 'sdata')

        %---Undefined---
        sdata.variable = 'cstream_eye_roi_undefined_child';
        sdata.data = cstream_eye_roi_undefined_child;
        save([path 'cstream_eye_roi_undefined_child.mat'], 'sdata')
        
        %----Missing----
        sdata.variable = 'cstream_eye_roi_missing_child';
        sdata.data = cstream_eye_roi_missing_child;
        save([path 'cstream_eye_roi_missing_child.mat'], 'sdata')
        
        %----trials----
        sdata.variable = 'cevent_trials';
        sdata.data = cevent_trials;
        save([path 'cevent_trials.mat'], 'sdata')
        
    case 'all'
        %----cont2----
        sdata.variable = 'cont2_eye_xy_child';
        sdata.data = cont2_eye_xy_child;
        save([path 'cont2_eye_xy_child.mat'], 'sdata')

        %-----roi-----
        sdata.variable = 'cstream_eye_roi_child';
        sdata.data = cstream_eye_roi_child;
        save([path 'cstream_eye_roi_child.mat'], 'sdata')

        sdata.variable = 'cevent_eye_roi_child';
        sdata.data = cstream2cevent(cstream_eye_roi_child);
        save([path 'cevent_eye_roi_child'], 'sdata')

        %---fixation---
        sdata.variable = 'cstream_eye_roi_fixation_child';
        sdata.data = cstream_eye_roi_fixation_child;
        save([path 'cstream_eye_roi_fixation_child.mat'], 'sdata')
        
        sdata.variable = 'cevent_eye_roi_fixation_child';
        sdata.data = cstream2cevent(cstream_eye_roi_fixation_child);
        save([path 'cevent_eye_roi_fixation_child'], 'sdata')
        
        %----trials----
        sdata.variable = 'cevent_trials';
        sdata.data = cevent_trials;
        save([path 'cevent_trials.mat'], 'sdata')
        
    case 'roi'
        %-----roi-----
        sdata.variable = 'cstream_eye_roi_child';
        sdata.data = cstream_eye_roi_child;
        save([path 'cstream_eye_roi_child.mat'], 'sdata')

        sdata.variable = 'cevent_eye_roi_child';
        sdata.data = cstream2cevent(cstream_eye_roi_child);
        save([path 'cevent_eye_roi_child'], 'sdata')
        
    case 'fixroi'
        %---fixation---
        sdata.variable = 'cstream_eye_roi_fixation_child';
        sdata.data = cstream_eye_roi_fixation_child;
        save([path 'cstream_eye_roi_fixation_child.mat'], 'sdata')
        
        sdata.variable = 'cevent_eye_roi_fixation_child';
        sdata.data = cstream2cevent(cstream_eye_roi_fixation_child);
        save([path 'cevent_eye_roi_fixation_child'], 'sdata')
        
    case 'trials'
        %----trials----
        sdata.variable = 'cevent_trials';
        sdata.data = cevent_trials;
        save([path 'cevent_trials.mat'], 'sdata')
        
    case 'cont2xy'
        %----cont2----
        sdata.variable = 'cont2_eye_xy_child';
        sdata.data = cont2_eye_xy_child;
        save([path 'cont2_eye_xy_child.mat'], 'sdata')
        
    case 'blinkroi'
        %-----Blink-----
        sdata.variable = 'cstream_eye_roi_blink_child';
        sdata.data = cstream_eye_roi_blink_child;
        save([path 'cstream_eye_roi_blink_child.mat'], 'sdata')
        
    case 'saccaderoi'
        %----Saccade----
        sdata.variable = 'cstream_eye_roi_saccade_child';
        sdata.data = cstream_eye_roi_saccade_child;
        save([path 'cstream_eye_roi_saccade_child.mat'], 'sdata')
        
    case 'undefined'
        %---Undefined---
        sdata.variable = 'cstream_eye_roi_undefined_child';
        sdata.data = cstream_eye_roi_undefined_child;
        save([path 'cstream_eye_roi_undefined_child.mat'], 'sdata')
        
    case 'missing'
        %----Missing----
        sdata.variable = 'cstream_eye_roi_missing_child';
        sdata.data = cstream_eye_roi_missing_child;
        save([path 'cstream_eye_roi_missing_child.mat'], 'sdata')
    otherwise
        disp('[-] Not a valid flag')
end
disp('[+] Data files created')
end
