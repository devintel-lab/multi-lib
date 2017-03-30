--------------------------------------------------------------------
Fixation finding algorithm steps:

This fixation finding algorithm is based on velocity and spatial 
information.

3 steps:
  (1):	Divide cont_eye_x/y into big fixations based on velocity
          highThresh, minimum fixation duration >= minDur
  (2):    Divide big fixations from (1) into small fixations based on
          velocity lowThresh
  (3):    Merge small fixations from (2) based on spatial information. if
          distance between centers of two consecutive fixations is <=
          minDist, then these fixations will be merged into one, also
          minimum fixation duration >= minDur

--------------------------------------------------------------------
How to run it:

VelocityAndDistanceThresholdFixations is the main function.

It requires inputs:   
	data:   [time cont_eye_x cont_eye_y], Nx3
	xmax, ymax: upper bounds for eye tracking data
	sample_rate: recording rate for eye tracking data

The outputs are: 
	fix_x:          center x of each fixation, n*1
	fix_y:          center y of each fixation, n*1
	fix_times:      onset of each fixation, n*1
	fix_durations:  duration of each fixation, n*1

Example:
    sub_id = 1903;
    xmax = 240;
    ymax = 260;
    sample_rate = 0.016;
    cont_x = get_variable(sub_id, 'cont_eye_x');
    cont_y = get_variable(sub_id, 'cont_eye_y)';
    data = [cont_x(:,1) cont_x(:,2) cont_y(:,2)];

    [fix_x, fix_y, fix_time, fix_durations] = ...
        VelocityAndDistanceThresholdFixations(data, xmax, ymax, sample_rate);

--------------------------------------------------------------------
About the parameters:


	highThresh: this is the high velocity threshold for dividing cont_eye_x/y into 
                big fixations as a first step
	lowThresh:  this is the low velocity threshold for dividing big fixations from 
                the first step into smaller fixations as a second step
	minDur:     minimun duration for fixation. This parameter will be used in 
                dividing cont values into big fixations and in the third step
                where big fixations are merged if they are close enough
	minDist:    this parameter is used in the third step where the program
                will merge small fixations from the second step if they are
                close enough spatially (distance between centers of fixations <= minDist)

    These parameters are fixed based on xmax, ymax, sample_rate from
    different eye tracking data. Fixed parameter values are stored in file
    '_fixation_parameters'.