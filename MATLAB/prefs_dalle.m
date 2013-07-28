function file = prefs_dalle(glob)
%
% prefs_dalle
% prefs_dalle(glob)
% file = prefs_dalle(glob)
%
%
% INPUTS:
%         glob : (optional) filter for files to be copied (Notes 1 & 2)
%
% OUTPUTS:
%         file : list of files copied to MATLAB userpath
%
% This function will load the theme 'dalle' using "load_prefs" and also
% copy (force copy) all files in the subdirectory "file/" (of the folder
% containing this function) that match the regular expression in the 
% variable "glob" to the MATLAB userpath.  Files that are copied to the
% MATLAB userpath are available for MATLAB to use at all times immediately 
% from the time MATLAB starts.  In other words, these files can be used
% without specifying the full path regardless of MATLAB's current working
% directory.
%
% Furthermore, if a file called "startup.m" is placed in the userpath, it
% will be called immediately each time MATLAB is opened.
%
% Subfolders of "file/" and files within those folders will NOT be copied.
%
% EXAMPLES:
% The simplest call to this function is with no inputs or outputs.
%
%    prefs_dalle
%
% This will apply the default filter and copy all "*.m" and "*.mat" files
% from the directory "file/".  The following commands would give exactly
% the same result.
%
%    prefs_dalle('\.(m|mat)$')
%    prefs_dalle \.(m|mat)$
%
% This tells MATLAB to look for files that end with ".m" or ".mat".  An
% additional option is to use
%
%    prefs_dalle('')
%
% which will tell the function to copy all files regardless of the file
% name.  The final example is
%
%    prefs_dalle('\.*m$')
%
% which tells MATLAB to copy all the ".m" files but not the ".mat" files.
%
% NOTES:
%    (1) The filter is described using regular expressions.  Any file that
%        matches the regular expression will be copied.  There are many
%        sources of information regular expressions.  Two recommendations
%        are the Wikipedia article and the documentation for the MATLAB
%        function "regexp".
%
%    (2) The default value for the filter is '\.(m|mat)$' which matches any
%        file that ends with ".m" or ".mat".  Note that this is case
%        sensitive, so ".M" files will not be copied.
%

% VERSIONS:
%  2011.12.23 @Derek Dalle     : Initial version
%
% Public domain

% Check inputs.
if nargin < 1 || ~ischar(glob)
	% Use the default.
	glob = '\.(m|mat)';
end

% Get the name of the current file (i.e. the function).
mname = mfilename;
% The full path to the current file.
mpath = which(mname);
% Find the last delimiter in the file name.
i = find(mpath == '/' | mpath == '\', true, 'last');
% Cut the mfilename out of the path.
mpath = mpath(1:i);
% Decide which char is better for the last folder.
if ispc, sl = '\'; else sl = '/'; end

% Path to "file/" subdirectory
fpath = [mpath, 'file', sl];

% Get the list of files in the folder.
dirs = dir(fpath);
% Number of hits.
n_dirs = numel(dirs);
% Initialize a cell array of matches.
f_match = cell(n_dirs, 1);
% Number of matching files.
n_match = 0;

% Get the userpath
upath = userpath;

% Check the operating system (decide between ';' and ':').
if ispc
	% Windows
	dl = ';';
else
	% Unix-ish
	dl = ':';
	% Note: Although Linux can handle ':' in folder names, MATLAB cannot,
	% so there is no limitation introduced here.
end

% Find the first instance of "dl".
i = find(upath == dl, true, 'first');
% Check for any finds.
if ~isempty(i)
	% Cut the userpath.
	upath = upath(1:i-1);
end

% Loop through the directories.
for i = 1:n_dirs
	% Check if the current page of dirs meets the requirements.
	if check_filter(dirs(i), glob)
		% Copy the file.
		copyfile([fpath, dirs(i).name], upath, 'f');
		% Increase the number of matches.
		n_match = n_match + 1;
		% Save the name of the file.
		f_match{n_match} = dirs(i).name;
	end
end

% Check for output.
if nargout > 0
	% Move the variable.
	file = f_match;
end

% Apply the preferences saved in the .mat file.
load_prefs('dalle');


% --- FUNCTION 1: Check filter ---
function q = check_filter(dcur, glob)
%
% q = check_filter(dcur, glob)
%
% INPUTS:
%         dcur : page of struct from MATLAB command "dir"
%         glob : filter
%
% OUTPUTS:
%         q    : true if dcur is a file whose name matches the filter
%

% Check for a directory.
if dcur.isdir;
	% Not a file.
	q = false;
else
	% Check for all-inclusive globs.
	q_all = any(strcmp(glob, {'', '*'}));
	% Check the filter.
	q_glob = ~isempty(regexp(dcur.name, glob, 'once'));
	% Output
	q = q_all || q_glob;
end
