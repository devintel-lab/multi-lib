function [ filename ] = record_variable( subject_id, variable_name, data )
%Records the given data under the given subject and name.
%   record_variable(SUBJECT_ID, VARIABLE_NAME, DATA)
%
%   Finds the filename that the data should be recorded in, using
%   get_variable_path.  Then, creates the little structure that goes in
%   that file, and records the data there using MATLAB's SAVE function.
%
%   If the given variable name does not have documentation, for now the
%   function will complain, but eventually the data will not be saved in
%   the requested place, but instead will be put in a temporary directory.
%
%   The return value is the filename where the data was saved.
%

global RECORDED_VARIABLES

% if ~ is_variable_documented(variable_name)
%     display('WARNING!  Variable is not documented yet!')
% end


matlab_user = getenv('MATLAB_USER');
if isempty(matlab_user)
    try
        matlab_user = get_real_user();
        setenv('MATLAB_USER', matlab_user);
    catch Err
        warning('Couldn''t find name of "real" matlab user');
    end
end


filename = get_variable_path(subject_id, variable_name);


sdata.variable = variable_name;
sdata.data = data;
sdata.info.stack = get_stack();
sdata.info.user = matlab_user;
sdata.info.timestamp = datestr(now);
sdata.info.subject = subject_id;
sdata.info.path = filename;

[status, hostname] = system('hostname');
if isequal(status, 0)
    % strcat strips off the trailing newline \n
    sdata.info.hostname = strcat(hostname);
else
    sdata.info.hostname = [];
end


if getenv('MATLAB_NO_RECORD_VARIABLE')
    RECORDED_VARIABLES{end+1} = sdata;
    fprintf('Pretended to save variable "%s" for subject %d\n', variable_name, subject_id);
else
    save(filename, 'sdata');
    fprintf('Saved variable "%s" for subject %d\n', variable_name, subject_id);
end


end


function stack = get_stack()
try
   error('Caught');
catch ME
   stack = ME.stack(2:end); % don't show get_stack() on the list
end
end

