function info = var_info(subject, var_name)
% var_info - Try to find data about a variable, such as who made it and how
%
% var_info(subject, var_name)
%   Looks inside the variable file for a .info field, and if it's there,
%   returns a struct containing information about the variable.  If not,
%   returns [].
%
%
% The .info field was added after much of experiment 14 was analyzed, so
% only some variables have this information.  If the variable you're
% looking at does have it, it should include at least this information:
%
%         stack: a struct array with the functions that called
%                record_variable (see 'help dbstack')
%          user: the username of the person who *ran* the script - not
%                necessarily the one who *wrote* it.
%     timestamp: when the variable was recorded
%       subject: the subject id of the variable
%          path: the path the variable was recorded to originally
%
% If you're looking for the script that created the variable, but can't
% find it, it might be that it only exists on another computer---so check
% both Einstein and Salk.  Newer versions of record_variable also record
% which computer the script was run on.
%

filename = get_variable_path(subject, var_name);
contents = load(filename);

try
    info = contents.sdata.info;
catch Ex
    info = [];
end


