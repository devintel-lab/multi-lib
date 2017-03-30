function [ subject_ids ] = find_subjects( variables, experiments )
%Find subjects that have all the required variables
%   Sometimes you need to find a list of subjects that have the particular
%   variables you're going to need for a calculation.  This function should
%   accomplish the search for those subjects.
%
%   find_subjects( VARIABLES ), where VARIABLES is a cell array of variable
%   names, searches for subjects with all those variables.
%
%   find_subjects( VARIABLES, EXPERIMENTS ) restricts the results to
%   subjects that are in the given array of experiment numbers.

if nargin == 2
    possible_subjects = list_subjects(experiments);
else
    possible_subjects = list_subjects();
end

if ~iscell(variables)
    variables = {variables};
end

subject_ids = func_filter(@(sid) has_all_vars(variables, sid), possible_subjects);


end

function has_all = has_all_vars(variables, subject_id)
% returns true if the subject has all of the requested variables available

has_all = 1;
for i = 1:length(variables)
    if ~ has_variable(subject_id, variables{i})
        has_all = 0;
        return
    end
end

end
