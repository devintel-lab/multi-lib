function copy_subject_file(subject, source, dest, varargin)
%COPY_SUBJECT_FILE copy a file from one place in a subject dir to another
%
% Usage:
%   copy_subject_file(SUBJECT, SOURCE, DESTINATION)
%       Within the SUBJECT's directory, copy a file from one place to
%       another.  If the DESTINATION file already exists, or if the SOURCE
%       file does not exist, an exception is thrown.  COPYFILE, which is
%       used internally, may also throw exceptions of its own.  If the
%       DESTINATION's directory is not there, we try to make it.
%
%   copy_subject_file(..., 'dry')
%       A "dry run": show what would be done.  If an exception would be
%       thrown, it is thrown in this case too (except for ones generated
%       directly by COPYFILE).
%
%   copy_subject_file(..., 'quiet')
%       Don't say what's happening.
%
%   copy_subject_file(..., 'force')
%       Don't give up if the destination file already exists.  Try to copy
%       over it, if possible.
%
copymove_subject_file('copy', subject, source, dest, varargin{:});
