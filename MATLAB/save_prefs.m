function prefs = save_prefs(theme)
%
% save_prefs(theme)
% s = save_prefs(theme)
%
% INPUTS:
%         theme : name of saved set of preferences
%
% OUTPUTS:
%         prefs : struct of preference handles
%
% This function automatically saves the current MATLAB preferences to a 
% .mat file.  These preferences mostly apply to the font and colors used 
% for the background and text, but other preferences, such as tab sizing
% and code folding settings, are also applied.
%
% The resulting .mat file can be applied to any MATLAB instance at any time
% using the function 'load_prefs'.  For this function to work properly, you
% must have the appropriate write/insert privileges in the folder "theme/",
% which is a subdirectory of the folder containing this function.
%
% EXAMPLES:
% The following will save the current settings to a theme called 'myprefs'.
%
%     save_prefs myprefs
%
% The following calls will produce the same results.  The last call also
% gives an output of all settings from the struct.
%
%     save_prefs('myprefs')
%     prefs = save_prefs('myprefs');
%
% Then, all of these settings can be loaded at any time using
%
%     load_prefs myprefs
%
% Other themes are also provided; see the documentation for "load_prefs"
% for more details.
%

% VERSIONS:
%  2011.03.23 @Derek Dalle     : Initial version
%  2011.12.23 @Derek Dalle     : Better handling of errors and files
%
% Public domain


%% --- Version information ---

% Initialize the colors struct.
c = struct();
% Struct for tab settings
t = struct();
% Struct for file settings
f = struct();
% Struct for editor settings
e = struct();
% Struct for code folding settings
fd = struct();
% Settings for the window and appearance
d = struct();
% Settings for the keyboard and shortcuts
k = struct();

% Initialize the error struct.
q = struct('lasterr', []);


%% --- Color settings ---

% String color
[q, c.string] = getColor(q, 'Colors_M_Strings');

% Unterminated strings
[q, c.unterminated] = getColor(q, 'Colors_M_UnterminatedStrings');

% Keyword color
[q, c.keyword] = getColor(q, 'Colors_M_Keywords');

% Comment color
[q, c.comment] = getColor(q, 'Colors_M_Comments');

% System commands
[q, c.system] = getColor(q, 'Colors_M_SystemCommands');

% Error color
[q, c.error] = getColor(q,	'Colors_M_Errors');

% Code suggestions
[q, c.suggestion] = getColor(q, 'ColorsMLintAutoFixBackground');

% Cell backgrounds
[q, c.cell] = getColor(q, 'Editorhighlight-lines');

% Line on the right
[q, c.textline] = getColor(q, 'EditorRightTextLimitLineColor');

% Link color
[q, c.link] = getColor(q, 'Colors_HTML_HTMLLinks');

% Background color
[q, c.background] = getColor(q, 'ColorsBackground');

% Text color
[q, c.text] = getColor(q, 'ColorsText');

% Variable highlighting
[q, c.highlight] = getColor(q, 'EditorVariableHighlightingColor');

% Nonlocal variables
[q, c.nonlocal] = getColor(q, ...
	'Editor.NonlocalVariableHighlighting.TextColor');

% Current line color
[q, c.current] = getColor(q, 'Editorhighlight-caret-row-boolean-color');


%% --- Editor environment ---

% Number of spaces per tab
[q, t.width] = getInteger(q, ...
	'EditorSpacesPerIndent');

% On/off setting of hard tabs.
[q, t.hard] = getBoolean(q, ...
	'EditorTabToSpaces');

% Whether or not to use emacs-style tabs
[q, t.emacs] = getBoolean(q, ...
	'EditorEmacsTab');

% Smart indent
[q, t.indent] = getString(q, ...
	'Editor.Language.MATLAB.Indenting');

% Get the font setting.
[q, e.font] = getFont(q, ...
	'Desktop.Font.Code');

% On/off switch for syntax highlighting
[q, e.syntax] = getBoolean(q, ...
	'Editor.Language.MATLAB.SyntaxHighlighting');

% Get the value for different editor
[q, e.other] = getString(q, ...
	'EditorOtherEditorTextFieldEntry');

% Whether or not to use the built-in editor
[q, e.matlab] = getBoolean(q, ...
	'EditorBuiltinEditor');

% Whether or not cell mode is on
[q, e.cell] = getBoolean(q, ...
	'EditorCodeBlockDividers');

% Whether or not to reload files
[q, e.reload] = getBoolean(q, ...
	'EditorAutoReloadFiles');

% Whether or not to show line numbers
[q, e.linenumbers] = getBoolean(q, ...
	'EditorShowLineNumbers');

% Number of columns in a row
[q, e.text.columns] = getInteger(q, ...
	'EditorRightTextLineLimit');

% Whether or not to show line ar right text limit
[q, e.text.rightlineon] = getBoolean(q, ...
	'EditorRightTextLineVisible');

% Width of the line at the right text limit
[q, e.text.rightlinewidth] = getInteger(q, ...
	'EditorRightTextLimitLineWidth');

% Current line highlighting
[q, e.text.highlight] = getBoolean(q, ...
	'Editorhighlight-caret-row-boolean');

% Highlightinf for nonlocal variables
[q, e.text.nonlocal] = getBoolean(q, ...
	'Editor.NonlocalVariableHighlighting');

% MLint on/off switch
[q, e.mlint.display] = getBoolean(q, ...
	'Editormlint-display');

% Underline type for mlint
[q, e.mlint.underline] = getInteger(q, ...
	'Editormlint-underlining');

% Whether or not to highlight autofix suggestions
[q, e.mlint.highlight] = getBoolean(q, ...
	'ColorsUseMLintAutoFixBackground');

% Prompt for exiting debug mode
[q, e.debug.exitprompt] = getBoolean(q, ...
	'EditorPromptBeforeExitingDebugMode');

% Autowrap of comments
[q, e.comment.autowrap] = getBoolean(q, ...
	'EditorAutoWrapComments');

% Comment width
[q, e.comment.width] = getInteger(q, ...
	'EditorMaxCommentWidth');

% Something called data tips
[q, e.datatips] = getBoolean(q, ...
	'EditorEnableDataTips');


%% --- Code folding ---

% Whether or not code folding is available
[q, fd.enabled] = getBoolean(q, ...
	'Editorcode-folding-enable');

% Code folding for cells
[q, fd.cell.enable] = getBoolean(q, ...
	'EditorMCodeFoldEnabledcell');

% Initial folding for cells
[q, fd.cell.open] = getBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpencell');

% Code folding for class definitions
[q, fd.class.enable] = getBoolean(q, ...
	'EditorMCodeFoldEnabledclassdef');

% Initial folding for class definitions
[q, fd.class.open] = getBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenclassdef');

% Code folding for block comments
[q, fd.comment.enable] = getBoolean(q, ...
	'EditorMCodeFoldEnabledblockcomments');

% Initial folding for block comments
[q, fd.comment.open] = getBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenblockcomments');

% Code folding for Class enumeration
[q, fd.enumeration.enable] = getBoolean(q, ...
	'EditorMCodeFoldEnabledenumeration');

% Initial folding for Class enumeration
[q, fd.enumeration.open] = getBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenenumeration');

% Code folding for Class events
[q, fd.events.enable] = getBoolean(q, ...
	'EditorMCodeFoldEnabledevents');

% Initial folding for Class events
[q, fd.events.open] = getBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenevents');

% Code folding for if blocks
[q, fd.if.enable] = getBoolean(q, ...
	'EditorMCodeFoldEnabledif');

% Initial folding for if blocks
[q, fd.if.open] = getBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenif');

% Code folding for for blocks
[q, fd.for.enable] = getBoolean(q, ...
	'EditorMCodeFoldEnabledfor');

% Initial folding for for blocks
[q, fd.for.open] = getBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenfor');

% Code folding for functions
[q, fd.function.enable] = getBoolean(q, ...
	'EditorMCodeFoldEnabledfunction');

% Initial folding for functions
[q, fd.function.open] = getBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenfunction');

% Code folding for help comment blocks
[q, fd.help.enable] = getBoolean(q, ...
	'EditorMCodeFoldEnabledhelp-comments');

% Initial folding for help comment blocks
[q, fd.help.open] = getBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenhelp-comments');

% Code folding for Class methods
[q, fd.methods.enable] = getBoolean(q, ...
	'EditorMCodeFoldEnabledmethods');

% Initial folding for Class methods
[q, fd.methods.open] = getBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenmethods');

% Code folding for properties
[q, fd.properties.enable] = getBoolean(q, ...
	'EditorMCodeFoldEnabledproperties');

% Initial folding for properties
[q, fd.properties.open] = getBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenproperties');

% Status of code folding for single-program, multiple data
[q, fd.spmd.enable] = getBoolean(q, ...
	'EditorMCodeFoldEnabledspmd');

% Initial folding for single-program, multiple data
[q, fd.spmd.open] = getBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenspmd');

% Code folding for switch blocks
[q, fd.switch.enable] = getBoolean(q, ...
	'EditorMCodeFoldEnabledswitch');

% Initial folding for switch blocks
[q, fd.switch.open] = getBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenswitch');

% Code folding for try blocks
[q, fd.try.enable] = getBoolean(q, ...
	'EditorMCodeFoldEnabledtry');

% Initial folding for try blocks
[q, fd.try.open] = getBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpentry');

% Code folding for while blocks
[q, fd.while.enable] = getBoolean(q, ...
	'EditorMCodeFoldEnabledwhile');

% Initial folding for while
[q, fd.while.open] = getBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenwhile');


%% --- File settings ---

% Autosave on or off
[q, f.autosave.enabled] = getBoolean(q, ...
	'EditorAutoSaveOn');

% Whether to replace autosave extension
[q, f.autosave.replaceext] = getBoolean(q, ...
	'EditorAutoSaveReplaceExtension');

% Autosave append extension
[q, f.autosave.appendext] = getString(q, ...
	'EditorAutoSaveAppendExt');

% Confirm to close setting
[q, f.confirm] = getBoolean(q, ...
	'MatlabExitConfirm');

% Matlab extension
[q, f.extension] = getString(q, ...
	'Editor.Language.MATLAB.Extensions');

% Java heap size in MB
[q, hp] = getInteger(q, ...
	'JavaMemHeapMax');


%% --- Desktop settings ---

% White space setting for desktop
[q, d.format.compact] = getString(q, ...
	'GeneralNumDisplay');

% Number format for desktop
[q, d.format.long] = getString(q, ...
	'GeneralNumFormat2');

% Use system font for other text
[q, d.sysfont] = getBoolean(q, ...
	'GeneralTextUseSystemFont');

% The font in use
[q, d.font] = getFont(q, ...
	'Desktop.Font.Text');

% Confirmation to clear command window
[q, d.clear] = getBoolean(q, ...
	'CommandWindowClearConfirmation');

% Command window startup message
[q, d.startup] = getBoolean(q, ...
	'CommandWindowShowStartupMessage');


%% --- Keyboard ---

% This controls the startup message about desktop shortcuts
[q, k.notify] = getBoolean(q, ...
	'MATLABDesktopShortcuts.R2009bChange.NotifyUser');

% Windows/emacs standard key bindings
[q, k.current] = getString(q, ...
	'CurrentKeyBindingSet');


%% --- Saving and output ---

% Combine everything into one struct for saving
settings = struct(...
	'colors'  , c , ...
	'editor'  , e , ...
	'tab'     , t , ...
	'folding' , fd, ...
	'file'    , f , ...
	'desktop' , d , ...
	'heap'    , hp, ...
	'keyboard', k);

% Check if the filename ends in .mat.
if isempty(regexp(theme, '\.mat$', 'once'))
	% Append .mat
	theme = [theme, '.mat'];
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
% Append the path to the name of the theme.
fname = [mpath, 'theme', sl, theme];

% Save the settings.
save(fname, 'settings', '-mat');

% Check for an output
if nargout > 0
	% Move the variable to the one used in the output.
	prefs = settings;
	% Check for an error message.
	if isfield(q, 'lasterr') && ~isempty(q.lasterr)
		% Save the entry.
		prefs.lasterr = q.lasterr;
	end
end


% --- SUBFUNCTION 1: Get a Boolean preferance ---
function [q, val] = getBoolean(q, str)
%
% [q, val] = getBoolean(q, str)
%
% INPUTS:
%         q   : error struct
%         str : name of prefernce to be set
%
% OUTPUTS:
%         q   : error struct with s.lasterr set if preference failed
%         val : value to be set (true or false)
%

% Attempt to apply the preference
try
	% This is the actual application.
	val = com.mathworks.services.Prefs.getBooleanPref(str);
catch msg
	% Save the failure message.
	q.lasterr = msg;
	% Give a warning.
	warning('save_prefs:MissingPref', ['The preference %s ', ...
		'could not be saved.'], str);
	% Set an empty output.
	val = NaN;
end


% --- SUBFUNCTION 2: Get a color preferance ---
function [q, val] = getColor(q, str)
%
% [q, val] = getColor(q, str)
%
% INPUTS:
%         q   : error struct
%         str : name of prefernce to be set
%
% OUTPUTS:
%         q   : error struct with s.lasterr set if preference failed
%         val : value to be set (true or false)
%

% Attempt to apply the preference
try
	% This is the actual application.
	val = com.mathworks.services.Prefs.getColorPref(str);
catch msg
	% Save the failure message.
	q.lasterr = msg;
	% Give a warning.
	warning('save_prefs:MissingPref', ['The preference %s ', ...
		'could not be saved.'], str);
	% Set an empty output.
	val = NaN;
end


% --- SUBFUNCTION 3: Get an integer preferance ---
function [q, val] = getInteger(q, str)
%
% [q, val] = getInteger(q, str)
%
% INPUTS:
%         q   : error struct
%         str : name of prefernce to be set
%
% OUTPUTS:
%         q   : error struct with s.lasterr set if preference failed
%         val : value to be set (true or false)
%

% Attempt to apply the preference
try
	% This is the actual application.
	val = com.mathworks.services.Prefs.getIntegerPref(str);
catch msg
	% Save the failure message.
	q.lasterr = msg;
	% Give a warning.
	warning('save_prefs:MissingPref', ['The preference %s ', ...
		'could not be saved.'], str);
	% Set an empty output.
	val = NaN;
end


% --- SUBFUNCTION 4: Get a string preferance ---
function [q, val] = getString(q, str)
%
% [q, val] = getString(q, str)
%
% INPUTS:
%         q   : error struct
%         str : name of prefernce to be set
%
% OUTPUTS:
%         q   : error struct with s.lasterr set if preference failed
%         val : value to be set (true or false)
%

% Attempt to apply the preference
try
	% This is the actual application.
	val = com.mathworks.services.Prefs.getStringPref(str);
catch msg
	% Save the failure message.
	q.lasterr = msg;
	% Give a warning.
	warning('save_prefs:MissingPref', ['The preference %s ', ...
		'could not be saved.'], str);
	% Set an empty output.
	val = NaN;
end


% --- SUBFUNCTION 5: Apply a color preferance ---
function [q, val] = getFont(q, str)
%
% [q, val] = getFont(q, str)
%
% INPUTS:
%         q   : error struct
%         str : name of prefernce to be set
%
% OUTPUTS:
%         q   : error struct with s.lasterr set if preference failed
%         val : value to be set (true or false)
%

% Attempt to apply the preference
try
	% This is the actual application.
	val = com.mathworks.services.Prefs.getFontPref(str);
catch msg
	% Save the failure message.
	q.lasterr = msg;
	% Give a warning.
	warning('save_prefs:MissingPref', ['The preference %s ', ...
		'could not be saved.'], str);
	% Set an empty output.
	val = NaN;
end
