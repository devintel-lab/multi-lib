% Overall goal -- get eye roi 3 seconds after naming ends, and calculate basic stats
% How to use this file.
% Set a breakpoint by clicking the "-" symbol on the left, next the line numbers. A red dot will appear. Try it for the line with the text 'clear;'
% Then, hit Run at the top of this window.
% Hit Step to go one line at a time. Have the Workspace panel open in another window to view the variables and the state of the program as it executes.
clear;

subid = 7206;
eye_roi = get_variable(subid, 'cevent_eye_roi_child');
naming = get_variable(subid, 'cevent_speech_naming_local-id');
trials = get_variable(subid, 'cevent_trials');

% extract_ranges is a useful function that cuts data at the moments of another cevent
% |------cevent 1-------|
%     |----cevent 2--------|
%     |--cevent 1 cut---|
%
% in the above example, we cut cevent1 to cevent2, and the end result is a cevent1 that lies within the ranges of cevent2

% let's first cut our naming to only include in-trial data
naming_cut = extract_ranges(naming, 'cevent', trials);

% naming is a cell array, each array contains naming data for one trial
% let's concatenate the cell arrays to get 1 big array, since we don't want to work at the trial level

naming_trial = cat(1, naming_cut{:}); % this is just the syntax to concatenate vertically (dimension 1)

% now our naming moments are "clean", we can be sure they only include in-trial data

% remember that we don't want to extract data during the full naming moment, rather, we want to extract 3 seconds after each naming moment ends

% Therefore, let's first shift the naming events by 3 second

% METHOD 1
% cevent_relative_intervals can do that, we give our cevent data, specificy start, startend, end and then a shift
naming_one_sec = cevent_relative_intervals(naming_trial, 'end', [0 3]);

% METHOD 2
% Here's another way to do the shift, using matlab syntax only.
naming_one_sec = cat(2, naming_trial(:,2), naming_trial(:,2)+3, naming_trial(:,3)); % here we concatenate horizontally (dimension 2), the old offsets, and the old offsets + 3 seconds

% METHOD 3
% another way to concatenate, this is identical to the above just a different syntax
naming_one_sec = [naming_trial(:,2), naming_trial(:,2) + 3, naming_trial(:,3)];

% Ok, summary time. We've loaded our data. Cut the naming to trials (to get "clean" naming). Shifted our naming by 3 second, and I showed 3 ways to do that shift.

% Now, we cut eye_roi data to the shifted data.

eye_roi_after_naming = extract_ranges(eye_roi, 'cevent', naming_one_sec);

% Now for calculating statistics.

% eye_roi_after_naming is a cell array, 3 cell for each naming moment
% let's loop through each cell (that is, loop through each naming moment) and calculate stats
for n = 1:numel(eye_roi_after_naming)
    % grab the eye data for nth naming event
    this_eye = eye_roi_after_naming{n}; % curly brackets is how you access the data contained in a cell array
    this_naming = naming_one_sec(n,:); % get just this naming event
    % to calculate proportion of ROI looking, we need to take total looking time / amount of naming
    % first we need to determine which eye events are target vs non-target
    % the named object is the 3rd category in naming_one_sec.
    named_object = this_naming(1,3); % the 3rd column will retrieve the target object
    
    % So we have the raw eye data during the nth naming event, and we have which object is named.
    % let's assume the naming event is 30 40 3 (onset 30, offset 40, named object 3)
    % During that 10 second window, there could be eye ROIs to any number of objects
    % Some will be be on-target, some may not.
    % We need to separate the on-target from the others and then calculate statistics
    
    % To do this, you will need to find the eye ROIs that match the named_object
    mask = this_eye(:,3) == named_object; % mask is a logical array, 1 and 0, where the conditional operation is true. That is, where column 3 is equal to named_object
    target_only = this_eye(mask,:); % now we create a new array, target_only, which is a subset of this_eye. We feed in the mask to grab only those rows.
    
    % here are our basic measures, let's create the variables and just set them to 0 for now
    mean_duration = 0;
    proportion = 0;
    frequency = 0;
    number = 0;
    % Now, there is a chance target_only is empty (meaning, no ROI to the target), so we need to check before proceeding
    if ~isempty(target_only)
        % let's calculate stats
        
        % mean_duration
        eye_durations = target_only(:,2)-target_only(:,1); % offsets minus onsets
        mean_duration = mean(eye_durations);
        
        % proportion
        sum_eye_durations = sum(eye_durations); % total looking time toward target object
        duration_naming_event = this_naming(2) - this_naming(1); % duration of the naming event
        proportion = sum_eye_durations / duration_naming_event;
        
        % number
        number = size(target_only, 1); % number of distinct eye looks to target. 1 means first dimension (rows)
        
        % frequency is the just number, scaled to 60 seconds
        frequency = number / duration_naming_event * 60;
    end
    
    % Ok that is it for looks to target. Now for non-target looks.
    % recall this line to get the target only
    %   mask = this_eye(:,3) == named_object
    % mask is a logical array, 1s and 0s, where 1 is target and 0 is off-target
    % Let's get the complement of mask
    mask_non_target = this_eye(:,3) ~= named_object; % ~ is a built in matlab syntax, it turns 1s into 0s and 0s into 1s
    non_target = this_eye(mask_non_target,:);
    
    % now we just repeat the part of the code before, to calcuate stats on non_target
    % here are our basic measures, let's create the variables and just set them to 0 for now
    non_target_mean_duration = 0;
    non_target_proportion = 0;
    non_target_frequency = 0;
    non_target_number = 0;
    % Now, there is a chance non_target is empty (meaning, no ROI to non-target), so we need to check before proceeding
    if ~isempty(non_target)
        % let's calculate stats
        
        % mean_duration
        eye_durations = non_target(:,2)-non_target(:,1); % offsets minus onsets
        non_target_mean_duration = mean(eye_durations);
        
        % proportion
        sum_eye_durations = sum(eye_durations); % total looking time toward target object
        duration_naming_event = this_naming(2) - this_naming(1); % duration of the naming event
        non_target_proportion = sum_eye_durations / duration_naming_event;
        
        % number
        non_target_number = size(non_target, 1); % number of distinct eye looks to target. 1 means first dimension (rows)
        
        % frequency is the just number, scaled to 60 seconds
        non_target_frequency = non_target_number / duration_naming_event * 60;
    end
    
    % lets now concatenate the stats into one big array
    this_stats = cat(2,subid,this_naming,proportion,non_target_proportion,mean_duration,non_target_mean_duration,frequency,non_target_frequency,number,non_target_number);
    
    % Remember, everthing this in loop is just for one naming event, so let's put this_stats into a cell array
    all_stats{n} = this_stats;
end

% all of our stats are in cell arrays, let's concatenate them vertically as we did before
combined_stats = cat(1, all_stats{:});

% for convenient viewing, let's dump the array and stats into a .csv file using write2csv. We provide the array, a filename, and comma-separated headers for each column
write2csv(combined_stats, '/multi-lib/user_output/matlab_tutorial/matlab_tutorial_part_1.csv', {'subid, onset, offset, category, proportion, non_target_proportion, mean_duration, non_target_mean_duration, frequency, non_target_frequency, number, non_target_number'});

% There ya go, in about 50 lines of code, you can essentially replicate extract_multi_measures.
