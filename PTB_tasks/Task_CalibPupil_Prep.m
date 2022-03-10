function T = Task_CalibPupil_Prep(P)
 
T = struct();

% how many rotations should the target do per minute?
T.nRotationsPerMinute = 12;
T.nRotations          = 6;
T.circleRadiusInPixel = 300;
T.stimulusDiameter    = 20; % size of moving rect

% Black & White swaps
T.durationWhite = 5; % in sec
T.durationBlack = 5; % in sec
T.durationGrey  = 5; % in sec

% based on screen refresh rate and nRotations/min calculate how many
% distinct positions are required (one per screen refresh frame):
T.nPositions = 60 * P.refreshRate / T.nRotationsPerMinute;


% infer positions for circle centers, start counting at 12 o'clock
t = 0:(2*pi/T.nPositions):(2*pi*(1-1/T.nPositions));
x = T.circleRadiusInPixel * sin(t); 
y = T.circleRadiusInPixel * cos(t);

T.x = round(x) + P.windowRect(3)/2 - T.stimulusDiameter/2;
T.y = round(y) + P.windowRect(4)/3 - T.stimulusDiameter/2;

% T.textureStimulus = Screen('MakeTexture', P.window, 

end 