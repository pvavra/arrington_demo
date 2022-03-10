function P = Task_CalibPupil(P)
% starts with Black/Grey/White/Grey transitions
% then plays "point running in circle"
% ends with Black/Grey/White/Grey transitions


T = P.TCalib;

P.eye.SendMessage('SYNCTIME');
P.eye.SendMessage('Pupil calibration - start');


t = Screen('Flip',P.window);

%% Black & White

t = ShowBlackAndWhite(T,P, t);


P.eye.SendMessage('Rotation - Start[pre flip]');
%% Rotations
for iRotation = 1:T.nRotations
    for iFrame = 1:(T.nPositions)
        % draw stimulus
        Screen('FillRect', P.window, 255, ...
            [T.x(iFrame) T.y(iFrame)...
            T.x(iFrame)+T.stimulusDiameter T.y(iFrame)+T.stimulusDiameter]);
   
        %flip
        t = Screen('Flip',P.window,t + P.ifi - P.buffer);
    end
end
% fprintf('\n');
% and remove stimulus 
t = Screen('Flip',P.window,t + P.ifi - P.buffer); 
P.eye.SendMessage('Rotation - end [post flip]');


t = ShowBlackAndWhite(T,P, t);
P.eye.SendMessage('Pupil calibration - end');

P.TCalib = T;
end

function t = ShowBlackAndWhite(T,P,t)

% start with black
Screen('FillRect', P.window, 0, P.windowRect);
t = Screen('Flip',P.window,...
    T.durationGrey + t + P.ifi - P.buffer);
P.eye.SendMessage('Pupil calibration - black on');

% then grey - here using background color
Screen('FillRect', P.window, P.colorBackground, P.windowRect);
t = Screen('Flip',P.window,...
    T.durationBlack + t + P.ifi - P.buffer);
P.eye.SendMessage('Pupil calibration - grey on');

% then white
Screen('FillRect', P.window, 255, P.windowRect);
t = Screen('Flip',P.window,...
    T.durationGrey + t + P.ifi - P.buffer);
P.eye.SendMessage('Pupil calibration - white on');

% then grey
Screen('FillRect', P.window, P.colorBackground, P.windowRect);
t = Screen('Flip',P.window,...
    T.durationWhite + t + P.ifi - P.buffer);
P.eye.SendMessage('Pupil calibration - grey on');

t = Screen('Flip',P.window,...
    T.durationGrey + t + P.ifi - P.buffer);

end