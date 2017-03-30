function [ experiment_nums ] = list_experiments()
%Returns a list of all the experiment numbers
%   Subjects are grouped into experiments---each experiment has several
%   subjects in it, and possibly a different kind of data analysis.  This
%   function returns a list of the experiment numbers.
%   They are returned, one per row, in a vector.

table = read_subject_table();
experiment_nums = unique(table(:, 2));


end
