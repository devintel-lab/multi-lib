function copymove_subject_file(action, subject, source, dest, varargin)
%COPYMOVE_SUBJECT_FILE Move a file from one place in a subject dir to another
%
% Usage:
%   copymove_subject_file('copy', SUBJECT, SOURCE, DESTINATION)
%       Within the SUBJECT's directory, COPY a file from one place to
%       another.
%
%   copymove_subject_file('move', SUBJECT, SOURCE, DESTINATION)
%       Within the SUBJECT's directory, move a file from one place to
%       another.
%
% If the DESTINATION file already exists, or if the SOURCE file does not
% exist, an exception is thrown.  MOVEFILE or COPYFILE, which are used
% internally, may also throw exceptions of its own.  If the DESTINATION's
% directory is not there, we try to make it.
%
%   copymove_subject_file(..., 'dry')
%       A "dry run": show what would be done.  If an exception would be
%       thrown, it is thrown in this case too (except for ones generated
%       directly by MOVEFILE).
%
%   copymove_subject_file(..., 'quiet')
%       Don't say what's happening.
%
%   copymove_subject_file(..., 'force')
%       Don't give up if the destination file already exists.  Try to
%       copy/move over it, if possible.
%
args = varargin;

if strcmp(action, 'copy')
    action_func = @copyfile;
    action_word = 'Copying';
elseif strcmp(action, 'move')
    action_func = @movefile;
    action_word = 'Moving';
else
    error('copymove_subject_file:badaction', ...
        'ACTION must be one of ''copy'' and ''move'' (got %s)', action);
end

% Defaults:
really = 1; % Yes, really perform the action
quiet = 0;  % No, don't suppress status messages
force = 0;  % No, don't do the action if the destination already exists

if ismember('dry', args)
    really = 0;
    args = setdiff(args, 'dry');
end
if ismember('quiet', args)
    quiet = 1;
    args = setdiff(args, 'quiet');
end
if ismember('force', args)
    force = 1;
    args = setdiff(args, 'force');
end

if ~isempty(args)
    error('copymove_subject_file:arg', 'Unrecognized arguments %s', evalc('disp(args);'));
end


% idea: parameterize, to move, copy, or remove (i.e. move to extra_p)

subject_dir = get_subject_dir(subject);
full_source = fullfile(subject_dir, source);
full_dest = fullfile(subject_dir, dest);

% Ensure source exists
if ~ exist(full_source, 'file')
    error('copymove_subject_file:nxsource', 'Source file does not exist');
end
% Ensure dest does not exist
if exist(full_dest, 'file') && ~ force
    error('copymove_subject_file:xdest', 'Destination file already exists');
end

dest_dirname = fileparts(full_dest);
need_to_make_dir = ~ exist(dest_dirname, 'dir');

if force
    extra_args = {'f'};
else
    extra_args = {};
end
    


% 
% Do the move, or not
%

if really
    if need_to_make_dir
        if ~ quiet
            fprintf('Making destination dir %s\n', dest_dirname);
        end
        mkdir(dest_dirname);
    end
    
    if ~ quiet
        % Say we're moving/copying the file
        fprintf('%s %s\n\tto %s\n', action_word, full_source, full_dest);
    end
    
    action_func(full_source, full_dest, extra_args{:});
    
else
    if need_to_make_dir && ~ quiet
        fprintf('Would make destination dir %s\n', dest_dirname);
    end
    if ~ quiet
        fprintf('Would %s %s\n\tto %s\n', action, full_source, full_dest);
    end
end

