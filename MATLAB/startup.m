
% Formatting
format compact

% Check the Operating system.
if ispc
	% -- Windows --
	
	% Check if the AFS directory is available.
	if isdir('\\afs\umich.edu\user\d\a\dalle\Public\')
		% Add the path to unit conversion files.
		addpath \\afs\umich.edu\user\d\a\dalle\Public\matlab\units\src\
		% Add the path to set_plot.
		addpath \\afs\umich.edu\user\d\a\dalle\Public\matlab\set_plot\src\
		% Add the path to the prefs repository.
		addpath \\afs\umich.edu\user\d\a\dalle\Public\matlab\prefs\src\
	else
		% Error messages
		fprintf('The AFS directories could not be found.\n');
	end
	
else
	% -- Unix --
	
	% Check if the AFS directory is available.
	if isdir('/afs/umich.edu/user/d/a/dalle/Public/')
		% Add the path to unit conversion files.
		addpath /afs/umich.edu/user/d/a/dalle/Public/matlab/units/src/
		% Add the path to set_plot.
		addpath /afs/umich.edu/user/d/a/dalle/Public/matlab/set_plot/src/
		% Add the path to the prefs repository.
		addpath /afs/umich.edu/user/d/a/dalle/Public/matlab/prefs/src/
	else
		% Error messages
		fprintf('The AFS directories could not be found.\n');
	end
	
end
