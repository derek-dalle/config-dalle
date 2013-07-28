function colortheme_dark
%
% colortheme_dark
%
% This script automatically changes MATLAB's colors to a dark theme.  The
% background color is black, and the remaining colors are changed as little
% as possible from the defaults.
%
% This script does not affect font settings.
%

% VERSIONS:
%  2010.02.13 @Derek Dalle     : Initial version
%  2011.03.21 @Derek Dalle     : Added variable highlighting for 7.11+
%
% Public domain

% Get the MATLAB version info.
v0 = version;
% Find the separators.
i0 = regexp(v0, '\.');
% Primary version number.
v1 = str2double(v0(1:i0(1)-1));
% Secondary version number.
v2 = str2double(v0(i0(1)+1:i0(2)-1));

% First tell MATLAB not to use system colors.
com.mathworks.services.Prefs.setBooleanPref('ColorsUseSystem',0);

% Set the string color.
com.mathworks.services.Prefs.setColorPref(...
  'Colors_M_Strings',java.awt.Color(1.0,0.5,1.0));

% Set the specific color for unterminated strings.
com.mathworks.services.Prefs.setColorPref(...
  'Colors_M_UnterminatedStrings',java.awt.Color(0.87,0.49,0));

% Set the keyword color.
com.mathworks.services.Prefs.setColorPref(...
  'Colors_M_Keywords',java.awt.Color(0.35,0.5,1.0));

% Set the comment color.
com.mathworks.services.Prefs.setColorPref(...
  'Colors_M_Comments',java.awt.Color(0.22,0.53,0.28));

% Set the color for system commands.
com.mathworks.services.Prefs.setColorPref(...
  'Colors_M_SystemCommands',java.awt.Color(0.64,0.5,0));

% Set the color for errors.
com.mathworks.services.Prefs.setColorPref(...
  'Colors_M_Errors',java.awt.Color(0.95,0,0));

% Set the color M-Lint suggestion highlighting.
com.mathworks.services.Prefs.setColorPref(...
  'ColorsMLintAutoFixBackground',java.awt.Color(0.35,0.2,0.33));

% Set the color for cell backgrounds.
% This line does not activate cell mode automatically.
com.mathworks.services.Prefs.setColorPref(...
  'Editorhighlight-lines',java.awt.Color(0.02,0.02,0.02));

% This line sets the color of the line on the right.
com.mathworks.services.Prefs.setColorPref(...
  'EditorRightTextLimitLineColor',java.awt.Color(0.3,0.3,0.3));

% Set the color for links.
com.mathworks.services.Prefs.setColorPref(...
  'Colors_HTML_HTMLLinks',java.awt.Color(0.5,0.25,1));

% Set the background color.
com.mathworks.services.Prefs.setColorPref(...
  'ColorsBackground',java.awt.Color(0,0,0));

% Set the text color.
com.mathworks.services.Prefs.setColorPref(...
  'ColorsText',java.awt.Color(0.8,0.8,0.8));

% Check if the version is MATLAB 2010b or newer.
if v1 > 7 || (v1 == 7 && v2 >= 11)
	% Set the variable highlight color.
	com.mathworks.services.Prefs.setColorPref(...
		'EditorVariableHighlightingColor',java.awt.Color(0.15,0.23,0.37));
end

% These two commands could be used to force using some of the colors. 
% com.mathworks.services.ColorPrefs.notifyColorListeners(...
%   'ColorsBackground');
% com.mathworks.services.ColorPrefs.notifyColorListeners(...
%   'ColorsText');

% Pull up preferences dialog for confirmation.
preferences('Colors');