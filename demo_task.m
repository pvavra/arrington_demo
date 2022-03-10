% This script contains a minimalistic example of using the Eyetracker
% (after it was calibrated), but with a few tricks related to keeping the
% timing of screen updates as accurate as possible (c.f. comments of
% `P.buffer` and after the `Screen('Flip',..)` call
%
%
% Demo Task: 
%
% shows a simple rectangle "stimulus" left/right of middle of
% screen, alternating position every second for 20secs in total.

ExpandPath(); % add subfolders to matlab's path

%% use a struct to keep all relevant Psychtoolbox variables in "one place"
P = struct(); 
P.availableScreens      = Screen('Screens');
P.screenNumber          = max(P.availableScreens);
P.screenResolution      = Screen('Resolution', P.screenNumber);

% use full screen for fast(er) rendering (even if later not using full
% screen for display purposes)
% P.windowRect = [0 0 P.screenResolution.width P.screenResolution.height];
% alternative: use only small window, e.g. for debugging
P.windowRect = [100 100 500 500];

P.colorBackground = 127; % grey

% we will use a buffer for "whenFlip":
% we will request the fliptime to be a fraction of the interframe interval
% earlier than the mathematically expected time for the next screen update.
% This way, we make sure that Matlab will be able to request the
% buffer-flip sufficiently ahead of the desired time so that the graphics
% card can actually manage the flip as desired.
P.buffer = 0.5; % keeping 50% of ifi for matlab->gpu communication

%% initialize eyetracker
% set this to "0" for debugging without eyetracker, to "1" for using the
% Arrington eyetracker at the Prisma
useEyetracker = 0; 

P = EYE_Initialize(P,useEyetracker); % this adds a P.eye struct to P. 


%% open PTB window
[P.window, P.windowRect] = Screen('OpenWindow',...
    P.screenNumber, P.colorBackground, P.windowRect);

% get screen refresh interval (inter-frame interval)
P.ifi = Screen('GetFlipInterval', P.window); 

% derive usable screen size (in case we are not running full screen..) 
% -- only for convenience below
P.windowWidth = P.windowRect(3) - P.windowRect(1);
P.windowHeight = P.windowRect(4) - P.windowRect(2);


%% Start recording on Eyetracking PC:
P.eye.StartRecording();


%% Demo task
% Task parameters:
%--------------------------------------------------------------------------
% total duration of demo task
tTotal = 20; % in seconds
% duration the stimulus will hold its position, before switching
tHoldPosition  = 1; % in seconds
% stimulus color, here white
stimColor= 255;
% stimulus size (rectangle specified as array of pixel positions of
% corners: [xStart yStart xEnd yEnd]
stimRect = [0 0 20 20];
% "left" and "right" positions for where to draw the stimulus
% here: a simple horizontal and vertical offset, so that it can be simply
% added to the above stimRect 
stimLeftOffset = [ ...
    P.windowWidth/4 ... % x offest = 1/4 of screen
    P.windowHeight/2 ...% y offset = 1/2 of screen
    P.windowWidth/4 ...
    P.windowHeight/2 ...
    ];

stimRightOffset = [ ...
    P.windowWidth*3/4 ... % x offest = 3/4 of screen
    P.windowHeight/2 ...  % y offset = 1/2 of screen
    P.windowWidth*3/4 ...
    P.windowHeight/2 ...
    ];

% Calculate some parameters for more readable code below
%--------------------------------------------------------------------------
% how often do we need to switch position:
nSwitch = floor(tTotal/tHoldPosition); 


% Start task
%--------------------------------------------------------------------------
missed = NaN(nSwitch+1,1); % will store info whether flip deadlines were missed
currentPosition = 0; % initialize
tLastFlip = Screen('Flip', P.window); % initialize this for the loop below
tStart = tLastFlip; % store t0

for iDraw = 1:(nSwitch + 1)
   % switch position
   currentPosition = mod(currentPosition + 1,2); % using modulo to toggle
   
   % based on position indicator, select where exactly to draw rectangle
   switch currentPosition
       case 0
           placedRect = stimRect + stimLeftOffset;
       case 1
           placedRect = stimRect + stimRightOffset;
   end
       
   % draw stimulus
   Screen('FillRect', P.window, stimColor, placedRect);
   
   % calculate when we will need to up to update the screen
   %-----------------------------------------------------------------------
   % IMPORTANT: Do not use WaitSecs for "holding the position". Instead,
   % use the whenFlip variable as shown here.
   % Reason: WaitSecs blocks Matlab execution. Hence nothing, esp. no
   % timing triggers can be sent to the eyetracker. 
   % One could first send the triggers and then WaitSecs for the desired
   % time. But because the execution of the above loop and sending the
   % trigger take time, each iteration will be slightly longer than the
   % tHoldPosition specifies. The longer the actual task is, the more this
   % error will accumulate. 
   whenFlip = tLastFlip + tHoldPosition - P.ifi * P.buffer;
   
      
   % request monitor update
   %-----------------------------------------------------------------------
   % this function will return immediately after the screen update actually
   % happened (independent of how much time beforehand it got called)
   [tLastFlip, ~, ~ , missed(iDraw), ~ ] = ... % note: storing missed
       Screen('Flip', P.window, whenFlip); 
   
   % send trigger to eyetracker
   %-----------------------------------------------------------------------
   % note: this gets executed immediately after the Screen-Update above
   % happened.
   P.eye.SendMessage(sprintf(...
       '%s - switched position to %i', ...
       tLastFlip - tStart, ... % add timestamp to msg [for debugging..]
       currentPosition ));
end

%% Stop recording on eyetracking computer
% this halts data storage, but keeps the file open. 
% One could, for example, halt data recording in between runs, but keep the
% same file for all runs.
P.eye.StopRecording(); 

% this closes the file "for good"
P.eye.CloseFile();

%% Close PTB window 
sca;


%% mini-report on missed flips:
% this can be used to tweak/test different P.buffer fractions. 
if any(missed>0) 
    fprintf('\n%i task-relevant deadlines were missed.\n', sum(missed>0));
else
    fprintf('\nall task-relevant deadlines were kept.\n');
end
  