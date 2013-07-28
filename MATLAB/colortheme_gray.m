% colortheme_contrast
%
% This script automatically changes MATLAB's colors to a dark theme.  The
% background color is black, and the other colors are selected to give as
% much contrast as possible.
%
% This script does not affect font settings.
%
% VERSIONS:
%  02/13/10 @Derek Dalle     : Initial version
%


% First tell MATLAB not to use system colors.
com.mathworks.services.Prefs.setBooleanPref('ColorsUseSystem',0);

% Set the string color.
com.mathworks.services.Prefs.setColorPref(...
  'Colors_M_Strings',java.awt.Color(0.04,0.52,0.78));

% Set the specific color for unterminated strings.
com.mathworks.services.Prefs.setColorPref(...
  'Colors_M_UnterminatedStrings',java.awt.Color(0.6,0.2,0));

% Set the keyword color.
com.mathworks.services.Prefs.setColorPref(...
  'Colors_M_Keywords',java.awt.Color(0.0,0.0,1.0));

% Set the comment color.
com.mathworks.services.Prefs.setColorPref(...
  'Colors_M_Comments',java.awt.Color(0.2,0.5,0.2));

% Set the color for system commands.
com.mathworks.services.Prefs.setColorPref(...
  'Colors_M_SystemCommands',java.awt.Color(0.58,0.45,0));

% Set the color for errors.
com.mathworks.services.Prefs.setColorPref(...
  'Colors_M_Errors',java.awt.Color(0.75,0,0));

% Set the color M-Lint suggestion highlighting.
com.mathworks.services.Prefs.setColorPref(...
  'ColorsMLintAutoFixBackground',java.awt.Color(0.93,0.84,0.84));

% Set the color for cell backgrounds.
% This line does not activate cell mode automatically.
com.mathworks.services.Prefs.setColorPref(...
  'Editorhighlight-lines',java.awt.Color(0.85,0.86,0.86));

% This line sets the color of the line on the right.
com.mathworks.services.Prefs.setColorPref(...
  'EditorRightTextLimitLineColor',java.awt.Color(0,0,0));

% Set the color for links.
com.mathworks.services.Prefs.setColorPref(...
  'Colors_HTML_HTMLLinks',java.awt.Color(0.5,0.06,0.9));

% Set the background color.
com.mathworks.services.Prefs.setColorPref(...
  'ColorsBackground',java.awt.Color(0.85,0.85,0.85));

% Set the text color.
com.mathworks.services.Prefs.setColorPref(...
  'ColorsText',java.awt.Color(0,0,0));

% These two commands could be used to force using some of the colors. 
% com.mathworks.services.ColorPrefs.notifyColorListeners(...
%   'ColorsBackground');
% com.mathworks.services.ColorPrefs.notifyColorListeners(...
%   'ColorsText');

% Pull up preferences dialog for confirmation.
preferences('Colors');