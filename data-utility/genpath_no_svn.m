function p = genpath_no_svn(d)
%GENPATH Generate recursive toolbox path.
%   P = GENPATH returns a new path string by adding
%   all the subdirectories of MATLABROOT/toolbox, including empty
%   subdirectories. 
%
%   P = GENPATH(D) returns a path string starting in D, plus, recursively, all
%   the subdirectories of D, including empty subdirectories.
%   
%   NOTE: GENPATH will not exactly recreate the original MATLAB path.
%
%   See also PATH, ADDPATH, RMPATH, SAVEPATH.
%
%   This version, modified by Thomas Smith, is the same, but leaves out
%   directories starting with '.', so it avoids .svn directories for
%   instance.

%   Copyright 1984-2006 The MathWorks, Inc.
%   $Revision: 1.13.4.4 $ $Date: 2006/10/14 12:24:02 $
%------------------------------------------------------------------------------

if nargin==0,
  p = genpath_no_svn(fullfile(matlabroot,'toolbox'));
  if length(p) > 1, p(end) = []; end % Remove trailing pathsep
  return
end

% initialise variables
methodsep = '@';  % qualifier for overloaded method directories
p = '';           % path to be returned

% Generate path based on given root directory
files = dir(d);
if isempty(files)
  return
end

% Add d to the path even if it is empty.
p = [p d pathsep];

% set logical vector for subdirectory entries in d
isdir = logical(cat(1,files.isdir));
%
% Recursively descend through directories which are neither
% private nor "class" directories.
%
dirs = files(isdir); % select only directory entries from the current listing


% modified: any dir starting with '.' is left out.
for i=1:length(dirs)
   dirname = dirs(i).name;
   if    ~strncmp( dirname,'.',1) && ...
         ~strncmp( dirname,methodsep,1) && ...
         ~strcmp( dirname,'private')
      p = [p genpath_no_svn(fullfile(d,dirname))]; % recursive calling of this function.
   end
end

%------------------------------------------------------------------------------

end
