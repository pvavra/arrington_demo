function P = PTB_Initialize(colorBackground)
% InitializePTB(computerName) initiliazes psychtoolbox and opens a window
%
% Input:
%   colorBackground     ... color. [either a scalar between 0 and 255,
%                       or [r g b] triplet or [r g b a] quadruple) to be
%                       used for the background of the new window. default
%                       is white [255];
%
% Output:
%   P                   ... struct. Contains PTB parameters which are
%                       necessary to run PTB tasks
%
% SEE ALSO: PTB_Close

%% initialize variables & set defaults
P = struct();

if ~exist('colorBackground','var')
    colorBackground = 127;
end

%% Basic Setup for PTB

% stop all echo-ing
echo off all

% prepare monitor-related parameters
P.availableScreens      = Screen('Screens');
P.screenNumber          = max(P.availableScreens);
P.screenResolution      = Screen('Resolution', P.screenNumber);

% skip sync-tests --- might want to keep that at `0` for testing
Screen('Preference', 'SkipSyncTests', 1);

% use full screen for fast(er) rendering (even if later not using full
% screen for display purposes)
P.windowRect = [0 0 P.screenResolution.width P.screenResolution.height];

% use vertical offset to move everything up/down to adjust, e.g., for
% Prisma monitor
P.verticalOffset = 0;

font = 'Courier New'; % default on Prisma Stimulus PC

P.viewingDistance = 35; % in cm
P.monitorWidth = 30.2; % in cm
P.textSize = 25;

P.colorBackground = colorBackground;

%% open PTB window
[P.window,P.windowRect] = Screen('OpenWindow',...
    P.screenNumber, P.colorBackground, P.windowRect);

% store old priority
% Uncomment this to use maximal priority - NB by PV: I did not need to use
% this, but also I do not care about milisecond precise timing for my
% task.. 
% P.oldPriority = Priority(MaxPriority(P.window));

% enable flip logging
if isunix
    Screen('GetFlipInfo',P.window,1)
end


%% define parameters which depend on window being opened
% timing-related parameters - can be used in task
P.ifi                 = Screen('GetFlipInterval', P.window);
P.refreshRate         = Screen('FrameRate',P.window);
% for each flip, use the following buffer
P.buffer              = .5; % as ratio of a frame


% Setup font
% decide on appropriate font-size
oldTextSize=Screen('TextSize', P.window ,P.textSize);

Screen('TextFont', P.window, char(font));     % Need "char" input.

% prepare window for drawing
HideCursor;

% set mouse coordinates to upper left corner -- make sure there is no
% button to be clicked there...
% SetMouse(0,0, P.window);

% jump to command window so that button presses do not affect your code
commandwindow

end
