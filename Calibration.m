ExpandPath();

%% initial setup for current participant
% Open input dialog and get information
INPUT = inputdlg(...
    {'subject number (e.g. 13)'}, ...
    'Eyetracker calibration',1,...
    {'1'});

subjectNumber = str2double(INPUT{1});

timeExperiment = tic;

% set seed to make randomizations reproducible
rng(subjectNumber);

% move cursor into command window to avoid overwriting stuff
commandwindow

% initiliaze machine-related stuff
%---------------------------------------------------------------------------
P = PTB_Initialize(127); % pass background color

% use (P,0) to turn off eyetracker, but keep the code the same in the task
useEyetracker = 0;
P = EYE_Initialize(P, useEyetracker);


%% Run gaze-calibration
% this runs Arrington's Psychtoolbox script

DrawFormattedText(P.window, ...
    'Starte Kalibrierung\n\n',...
    'center','center', 255);  % use white
Screen('Flip', P.window);

WaitSecs(2);

P.eye.Calibrate(P);

%% Calibrate Pupil
% start recording eye position
P.eye.StartRecording();

% prepare settings
P.TCalib = Task_CalibPupil_Prep(P);

% run actual task
Task_CalibPupil(P);

%% post-process (non-time-sensitive)
% gaze/pupilometry related stuff
P.eye.StopRecording();
P.eye.CloseFile();
Screen('Flip',P.window);
SaveCalib(P, subjectNumber, day);


%% wind PTB down again
%---------------------------------------------------------------------------
PTB_Close(P);

toc(timeExperiment)
diary off
