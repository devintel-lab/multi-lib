function demo_vis_hist(option)
% Outputs a histogram of durations for a particular cevent variable
%
% Loops through subjects in 'subexpIDs' and loads data specified by 'varname'.
% Uses 'histc' function to bin the data according the user input 'edges'.
% The output will be saved in the input directory as a csv. Additionally,
% if 'flag_savefig' is set to 1, visual figures will also be saved for each
% subject in this same directory.
%
% subexpIDs : array of subject IDs or experiment IDs
%
% varname : string name of cevent variable
%
% edges : 1xN double array that specifies the bin edges.
% The upper bound is always Inf, meaning, 0:1:10 becomes [0:1:10 Inf]. This
% combines all durations that are greater than 10 into the last bin.
% 
% directory : full or relative path to the directory where results are
% saved
%
% nametag : a short, unique string to help name the files
%
% flag_savefig : boolean indicating whether to save figures in addition to
% .csv. Setting this to 0 can speed up the runtime of this function, if you
% don't need the individual images.
%
% example results
%
% binedges	7002	7003
% 0          6	     29
% 0.25	    19	     27
% 0.5	    11	     23
% 0.75	     5	     15
% 1	         5        5
%
% Note, first row means 0 to 0.25 and last row means 1 to Infinity.
%
% Output files
%   1 .csv file containing all histogram data for all subjects.
%   2 .jpg file with the full histogram for all subjects (normalized)
%   3 folder containing .jpg files, one for each individual subject

switch option
    case 1
        % categorical data (cevent)
        subexpIDs = 72;
        varname = 'cevent_eye_roi_child';
        nametag = 'child_eye';
        directory = '/multi-lib/user_output/vis_hist/case1';
        edges = 0:.25:10;
        flag_savefig = 1;
        vis_hist(subexpIDs, varname, edges, directory, nametag, flag_savefig);

        
    case 2
        % continous data
        subexpIDs = 72;
        varname = 'cont_motion_pos-speed_right-hand_child';
        nametag = 'child_r_hand_speed';
        directory = '/multi-lib/user_output/vis_hist/case2';
        edges = 0:50:500;
        flag_savefig = 1;
        vis_hist(subexpIDs, varname, edges, directory, nametag, flag_savefig);  
end