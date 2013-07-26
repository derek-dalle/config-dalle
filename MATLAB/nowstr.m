function nowstr
%
% This function prints the current time and date in a reasonable format.
%

% Use built-in commands.
disp(datestr(clock, 'yyyy.mm.dd hh:MM'))
