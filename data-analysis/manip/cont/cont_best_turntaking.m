function [score, shift] = cont_best_turntaking(cont1, cont2, window)
%cont_best_turntaking attempts to align one cont value to the other
%   USAGE:
%   [score, shift] = cont_best_turntaking(cont1, cont2, window_size)
%
% cont_best_turntaking tries to find the best time shift to make
% these two stream turn-taking.  this function
% takes only two cont streams that have the same size and sampling rate. 
%
% Turn-taking is defined as one stream has a high value when the other one
% has a low value.  One of the streams is negated, and the two streams are
% used in cont_best_overlap.  See also: CONT_BEST_OVERLAP
%
% Input: two cont  
%        window specifies the max temporal shift since we don't want to get
%        unrealistic warping in time
% Output: overall turntaking score, and the temporal shift for cont2 to
% best match cont1. 
%
%
cont2(:,2:end) = -cont2(:,2:end); 
[score, shift] = cont_best_overlap(cont1, cont2, window);

