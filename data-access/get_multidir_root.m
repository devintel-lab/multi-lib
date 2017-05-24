function [ multidir ] = get_multidir_root( )
%Returns a best guess at where the data files live.
%   This is the environment variable $MULTIDIR_ROOT, or if that's not
%   defined, then /ein/multiwork is used, which is the correct directory on
%   Salk.
%
%   If you are using these scripts on your own computer, you could try
%   mounting the MULTIWORK share from Einstein as a network drive, say on
%   Z:, and then setting the MULTIDIR_ROOT environment variable to "Z:".
%   For help on setting environment variables, search google for e.g.
%   "environment variables windows" or "environment variables linux".

multidir = getenv('MULTIDIR_ROOT');
if strcmp(multidir, '')
%     multidir = '/ein/multiwork';
    sep = filesep();
	root_path = strsplit(userpath, sep);
	root_path = root_path{1};
    multidir = [root_path sep 'bell' sep 'multiwork'];
end

end
