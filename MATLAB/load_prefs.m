function prefs = load_prefs(theme)
%
% load_prefs theme
% load_prefs(theme)
% prefs = load_prefs(theme)
%
% INPUTS:
%         theme : name of saved set of preferences
%
% OUTPUTS:
%         prefs : struct of preference handles
%
% This function automatically loads MATLAB preferences from a .mat file.
% These preferences mostly apply to the font and colors used for the
% background and text, but other preferences, such as tab sizing and code
% folding settings, are also applied.
%
% EXAMPLES:
% The following will load my usual preferences.
%
%     load_prefs dalle
%
% The following calls will produce the same results.  The last call also
% gives an output of all settings from the struct.
%
%     load_prefs('dalle')
%     prefs = load_prefs('dalle');
%
% Suppose you want to change a few of the preferences using MATLAB's
% graphical user interface for settings, which can be opened using the
% command
%
%     preferences
%
% or by finding it in the "File" menu.  Then the preferences you have
% created can be saved using the command
%
%     save_prefs myprefs
%
% which can be used later on other MATLAB instances.  However, for this to
% work, you must have the appropriate write/insert privileges in the folder
% "theme/".
%
% THEMES:
% The available themes are described below.
%
%     contrast: like 'dark' but with brighter font colors
%        dalle: my preferred settings including soft, 2-char tabs
%         dark: identical to 'dalle'
%      default: all default MATLAB settings (except possibly font)
%         gray: a gray color scheme
%        white: default colors but with other settings changed
%
% It is also possible to save your own themes by using the partner function
% "save_prefs".
%

% VERSIONS:
%  2011.03.23 @Derek Dalle     : Initial version
%  2011.12.22 @Derek Dalle     : Updates to file system
%
% Public domain


%% --- Load the preferences file. ---

% Initialize the settings struct
settings = [];

% Initialize the error object.
q = struct('lasterr', []);

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

% Load the settings.
load(fname)


%% --- Color settings ---

% First tell MATLAB not to use system colors.
q = setBoolean(q, 'ColorsUseSystem', false);

% String color
q = setColor(q, 'Colors_M_Strings', settings.colors.string);

% Unterminated strings
q = setColor(q, 'Colors_M_UnterminatedStrings', ...
	settings.colors.unterminated);

% Keyword color
q = setColor(q, 'Colors_M_Keywords', settings.colors.keyword);

% Comment color
q = setColor(q, 'Colors_M_Comments', settings.colors.comment);

% System commands
q = setColor(q, 'Colors_M_SystemCommands', settings.colors.system);

% Error color
q = setColor(q, 'Colors_M_Errors', settings.colors.error);

% Code suggestions
q = setColor(q, 'ColorsMLintAutoFixBackground', ...
	settings.colors.suggestion);

% Cell backgrounds
q = setColor(q, 'Editorhighlight-lines', settings.colors.cell);

% Line on the right
q = setColor(q, 'EditorRightTextLimitLineColor', ...
	settings.colors.textline);

% Link color
q = setColor(q, 'Colors_HTML_HTMLLinks', settings.colors.link);

% Background color
q = setColor(q, 'ColorsBackground', settings.colors.background);

% Text color
q = setColor(q, 'ColorsText', settings.colors.text);

% Variable highlighting
q = setColor(q, 'EditorVariableHighlightingColor', ...
	settings.colors.highlight);

% Nonlocal variables
q = setColor(q, 'Editor.NonlocalVariableHighlighting.TextColor', ...
	settings.colors.nonlocal);

% Current line color
q = setColor(q, 'Editorhighlight-caret-row-boolean-color', ...
	settings.colors.current);


%% --- Editor environment ---

% Number of spaces per tab
q = setInteger(q, 'EditorSpacesPerIndent', settings.tab.width);

% On/off setting of hard tabs.
q = setBoolean(q, 'EditorTabTospaces', settings.tab.hard);

% Whether or not to use emacs-style tabs
q = setBoolean(q, 'EditorEmacsTab', settings.tab.emacs);

% Smart indent
q = setString(q, 'Editor.Language.MATLAB.Indenting', settings.tab.indent);

% Get the font setting.
q = setFont(q, 'Desktop.Font.Code', settings.editor.font);

% On/off switch for syntax highlighting
q = setBoolean(q, 'Editor.Language.MATLAB.SyntaxHighlighting', ...
	settings.editor.syntax);

% Get the value for different editor.
q = setString(q, 'EditorOtherEditorTextFieldEntry', ...
	settings.editor.other);

% Whether or not to use the built-in editor
q = setBoolean(q, 'EditorBuiltinEditor', settings.editor.matlab);

% Whether or not cell mode is on
q = setBoolean(q, 'EditorCodeBlockDividers', settings.editor.cell);

% Whether or not to reload files
q = setBoolean(q, 'EditorAutoReloadFiles', settings.editor.reload);

% Whether or not to show line numbers
q = setBoolean(q, 'EditorShowLineNumbers', settings.editor.linenumbers);

% Number of columns in a row
q = setInteger(q, 'EditorRightTextLineLimit', ...
	settings.editor.text.columns);

% Whether or not to show line ar right text limit
q = setBoolean(q, 'EditorRightTextLineVisible', ...
	settings.editor.text.rightlineon);

% Width of the line at the right text limit
q = setInteger(q, 'EditorRightTextLimitLineWidth', ...
	settings.editor.text.rightlinewidth);

% Current line highlighting
q = setBoolean(q, 'Editorhighlight-caret-row-boolean', ...
	settings.editor.text.highlight);

% Highlightinf for nonlocal variables
q = setBoolean(q, 'Editor.NonlocalVariableHighlighting', ...
	settings.editor.text.nonlocal);

% MLint on/off switch
q = setBoolean(q, ...
	'Editormlint-display', settings.editor.mlint.display);

% Underline type for mlint
q = setInteger(q, ...
	'Editormlint-underlining', settings.editor.mlint.underline);

% Whether or not to highlight autofix suggestions
q = setBoolean(q, ...
	'ColorsUseMLintAutoFixBackground', settings.editor.mlint.highlight);

% Prompt for exiting debug mode
q = setBoolean(q, ...
	'EditorPromptBeforeExitingDebugMode', settings.editor.debug.exitprompt);

% Autowrap of comments
q = setBoolean(q, ...
	'EditorAutoWrapComments', settings.editor.comment.autowrap);

% Comment width
q = setInteger(q, ...
	'EditorMaxCommentWidth', settings.editor.comment.width);

% Something called data tips
q = setBoolean(q, ...
	'EditorEnableDataTips', settings.editor.datatips);


%% --- Code folding ---

% Whether or not code folding is available
q = setBoolean(q, ...
	'Editorcode-folding-enable', settings.folding.enabled);

% Code folding for cells
q = setBoolean(q, ...
	'EditorMCodeFoldEnabledcell', settings.folding.cell.enable);

% Initial folding for cells
q = setBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpencell', settings.folding.cell.open);

% Code folding for class definitions
q = setBoolean(q, ...
	'EditorMCodeFoldEnabledclassdef', settings.folding.class.enable);

% Initial folding for class definitions
q = setBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenclassdef', settings.folding.class.open);

% Code folding for block comments
q = setBoolean(q, ...
	'EditorMCodeFoldEnabledblockcomments', settings.folding.comment.enable);

% Initial folding for block comments
q = setBoolean(q, 'EditorMCodeFoldCollapseFileOpenblockcomments', ...
	settings.folding.comment.open);

% Code folding for Class enumeration
q = setBoolean(q, 'EditorMCodeFoldEnabledenumeration', ...
	settings.folding.enumeration.enable);

% Initial folding for Class enumeration
q = setBoolean(q, 'EditorMCodeFoldCollapseFileOpenenumeration', ...
	settings.folding.enumeration.open);

% Code folding for Class events
q = setBoolean(q, ...
	'EditorMCodeFoldEnabledevents', settings.folding.events.enable);

% Initial folding for Class events
q = setBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenevents', settings.folding.events.open);

% Code folding for if blocks
q = setBoolean(q, ...
	'EditorMCodeFoldEnabledif', settings.folding.if.enable);

% Initial folding for if blocks
q = setBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenif', settings.folding.if.open);

% Code folding for for blocks
q = setBoolean(q, ...
	'EditorMCodeFoldEnabledfor', settings.folding.for.enable);

% Initial folding for for blocks
q = setBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenfor', settings.folding.for.open);

% Code folding for functions
q = setBoolean(q, ...
	'EditorMCodeFoldEnabledfunction', settings.folding.function.enable);

% Initial folding for functions
q = setBoolean(q, 'EditorMCodeFoldCollapseFileOpenfunction', ...
	settings.folding.function.open);

% Code folding for help comment blocks
q = setBoolean(q, ...
	'EditorMCodeFoldEnabledhelp-comments', settings.folding.help.enable);

% Initial folding for help comment blocks
q = setBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenhelp-comments', ...
	settings.folding.help.open);

% Code folding for Class methods
q = setBoolean(q, ...
	'EditorMCodeFoldEnabledmethods', settings.folding.methods.enable);

% Initial folding for Class methods
q = setBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenmethods', settings.folding.methods.open);

% Code folding for properties
q = setBoolean(q, ...
	'EditorMCodeFoldEnabledproperties', settings.folding.properties.enable);

% Initial folding for properties
q = setBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenproperties', ...
	settings.folding.properties.open);

% Status of code folding for single-program, multiple data
q = setBoolean(q, ...
	'EditorMCodeFoldEnabledspmd', settings.folding.spmd.enable);

% Initial folding for single-program, multiple data
q = setBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenspmd', settings.folding.spmd.open);

% Code folding for switch blocks
q = setBoolean(q, ...
	'EditorMCodeFoldEnabledswitch', settings.folding.switch.enable);

% Initial folding for switch blocks
q = setBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenswitch', settings.folding.switch.open);

% Code folding for try blocks
q = setBoolean(q, ...
	'EditorMCodeFoldEnabledtry', settings.folding.try.enable);

% Initial folding for try blocks
q = setBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpentry', settings.folding.try.open);

% Code folding for while blocks
q = setBoolean(q, ...
	'EditorMCodeFoldEnabledwhile', settings.folding.while.enable);

% Initial folding for while
q = setBoolean(q, ...
	'EditorMCodeFoldCollapseFileOpenwhile', settings.folding.while.open);


%% --- File settings ---

% Autosave on or off
q = setBoolean(q, ...
	'EditorAutoSaveOn', settings.file.autosave.enabled);

% Whether to replace autosave extension
q = setBoolean(q, ...
	'EditorAutoSaveReplaceExtension', settings.file.autosave.replaceext);

% Autosave append extension
q = setString(q, ...
	'EditorAutoSaveAppendExt', settings.file.autosave.appendext);

% Confirm to close setting
q = setBoolean(q, ...
	'MatlabExitConfirm', settings.file.confirm);

% Matlab extension
q = setString(q, ...
	'Editor.Language.MATLAB.Extenstions', settings.file.extension);

% Java heap size in MB
q = setInteger(q, 'JavaMemHeapMax', settings.heap);


%% --- Desktop settings ---

% White space setting for desktop
q = setString(q, ...
	'GeneralNumDisplay', settings.desktop.format.compact);

% Number format for desktop
q = setString(q, ...
	'GeneralNumFormat2', settings.desktop.format.long);

% Use system font for other text
q = setBoolean(q, ...
	'GeneralTextUseSystemFont', settings.desktop.sysfont);

% The font in use
q = setFont(q, ...
	'Desktop.Font.Text', settings.desktop.font);

% Confirmation to clear command window
q = setBoolean(q, ...
	'CommandWindowClearConfirmation', settings.desktop.clear);

% Command window startup message
q = setBoolean(q, ...
	'CommandWindowShowStartupMessage', settings.desktop.startup);


%% --- Keyboard ---

% This controls the startup message about desktop shortcuts
q = setBoolean(q, ...
	'MATLABDesktopShortcuts.R2009bChange.NotifyUser', ...
	settings.keyboard.notify);

% Windows/emacs standard key bindings
q = setString(q, ...
	'CurrentKeyBindingSet', settings.keyboard.current);


%% --- Output ---

% Check for an output
if nargout > 0
	% Move the main variable.
	prefs = settings;
	% Check for an error.
	if isfield(q, 'lasterr') && ~isempty(q.lasterr)
		prefs.lasterr = q.lasterr;
	end
end

% Pull up preferences dialog for confirmation.
preferences('Colors');


% --- SUBFUNCTION 1: Apply a Boolean preferance ---
function q = setBoolean(q, str, val)
%
% q = setBoolean(q, str, val)
%
% INPUTS:
%         q   : error struct
%         str : name of prefernce to be set
%         val : value to be set (true or false)
%
% OUTPUTS:
%         q   : error struct with s.lasterr set if preference failed
%

% Attempt to apply the preference
try
	% This is the actual application.
	com.mathworks.services.Prefs.setBooleanPref(str, val);
catch msg
	% Save the failure message.
	q.lasterr = msg;
	% Give a warning.
	warning('load_prefs:MissingPref', ['The preference %s ', ...
		'could not be loaded.'], str);
end


% --- SUBFUNCTION 2: Apply a color preferance ---
function q = setColor(q, str, val)
%
% q = setColor(q, str, val)
%
% INPUTS:
%         q   : error struct
%         str : name of prefernce to be set
%         val : value to be set (true or false)
%
% OUTPUTS:
%         q   : error struct with s.lasterr set if preference failed
%

% Attempt to apply the preference
try
	% This is the actual application.
	com.mathworks.services.Prefs.setColorPref(str, val);
catch msg
	% Save the failure message.
	q.lasterr = msg;
	% Give a warning.
	warning('load_prefs:MissingPref', ['The preference %s ', ...
		'could not be loaded.'], str);
end


% --- SUBFUNCTION 3: Apply an integer preferance ---
function q = setInteger(q, str, val)
%
% q = setInteger(q, str, val)
%
% INPUTS:
%         q   : error struct
%         str : name of prefernce to be set
%         val : value to be set (true or false)
%
% OUTPUTS:
%         q   : error struct with s.lasterr set if preference failed
%

% Attempt to apply the preference
try
	% This is the actual application.
	com.mathworks.services.Prefs.setIntegerPref(str, val);
catch msg
	% Save the failure message.
	q.lasterr = msg;
	% Give a warning.
	warning('load_prefs:MissingPref', ['The preference %s ', ...
		'could not be loaded.'], str);
end


% --- SUBFUNCTION 4: Apply a string preferance ---
function q = setString(q, str, val)
%
% q = setString(q, str, val)
%
% INPUTS:
%         q   : error struct
%         str : name of prefernce to be set
%         val : value to be set (true or false)
%
% OUTPUTS:
%         q   : error struct with s.lasterr set if preference failed
%

% Attempt to apply the preference
try
	% This is the actual application.
	com.mathworks.services.Prefs.setStringPref(str, val);
catch msg
	% Save the failure message.
	q.lasterr = msg;
	% Give a warning.
	warning('load_prefs:MissingPref', ['The preference %s ', ...
		'could not be loaded.'], str);
end


% --- SUBFUNCTION 5: Apply a color preferance ---
function q = setFont(q, str, val)
%
% q = setFont(q, str, val)
%
% INPUTS:
%         q   : error struct
%         str : name of prefernce to be set
%         val : value to be set (true or false)
%
% OUTPUTS:
%         q   : error struct with s.lasterr set if preference failed
%

% Attempt to apply the preference
try
	% This is the actual application.
	com.mathworks.services.Prefs.setFontPref(str, val);
catch msg
	% Save the failure message.
	q.lasterr = msg;
	% Give a warning.
	warning('load_prefs:MissingPref', ['The preference %s ', ...
		'could not be loaded.'], str);
end
