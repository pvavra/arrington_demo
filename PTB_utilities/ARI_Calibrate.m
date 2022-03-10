function r = ARI_Calibrate(P,npoints)
%--------------------------------------------------------------------------
% adapted by PV from:
%% vpx_Calibrate
%
%   presents calibration stimulus on the screen.  It performs calibration
%   by communicating with ViewPoint.  If the number of stimulus points
%   is not specified the default value is 12.
%
%   USAGE: vpx_Calibrate(npoints)
%   INPUT: npoints - if not specified, defaults to 12 stimulus points.
%                  - positive value, npoints = number of stimulus points.
%                  - negative value, npoints = re-present point.
%
%   Example: vpx_Calibrate calibrates 12 stimulus points.
%            vpx_Calibrate(6) calibrates 6 stimulus points.
%            vpx_Calibrate(-3) re-presents stimulus point number 3.
%
%   Note: Re-presenting a point assumes vpx_Calibrate was already
%   called with a positive number to setup the number of stimulus points.
%
%   ViewPoint EyeTracker Toolbox (TM)
%   Copyright 2005-2010, Arrington Research, Inc.
%   All rights reserved.
%--------------------------------------------------------------------------

window = P.window;
screensize = P.windowRect;

if(nargin==1)
    npoints=12;
end

nstartpoint = 1;
if(npoints < 0)
    npoints = abs(npoints);
    nstartpoint = npoints;
else
    strfinal=strcat(['calibration_points',blanks(1),num2str(npoints)]);
    vpx_SendCommandString(strfinal);
end

vpx_SendCommandString('calibration_snapMode ON');
vpx_SendCommandString('calibration_autoIncrement ON');

% You can adjust the calibration area within which the calibration stimulus
% points are presented.  See ViewPoint pdf manual chapter 16.9.26.
vpx_SendCommandString('calibration_RealRect 0.2 0.2 0.8 0.65'); % PV: position on screen as offset-top offset-left end-botto, end-right

WaitSecs(1);



orderCalib = randperm(npoints);
% orderCalib = 12:-1:1
vpx_SendCommandString(sprintf('calibration_CustomOrderList %s', num2str(orderCalib)));
vpx_SendCommandString('calibration_PresentationOrder Custom');

% [x,y]=vpx_GetCalibrationStimulusPoint(1);


for i = orderCalib % nstartpoint : npoints
    strfinal1=strcat(['calibration_snap',blanks(1),num2str(i)]);
    [x,y]=vpx_GetCalibrationStimulusPoint(i);
    rectSmall=[(x*screensize(3))-(2.5),(y*screensize(4))-(2.5),(x*screensize(3))+(2.5),(y*screensize(4))+(2.5)];
    
    for j = 20 : -1 : 1
        rect=[(x*screensize(3))-(j*2.5),(y*screensize(4))-(j*2.5),(x*screensize(3))+(j*2.5),(y*screensize(4))+(j*2.5)];
        Screen(window,'FillRect',[0 255 0],rect);
        Screen(window,'FillRect',[255 255 255],rectSmall);
        Screen(window,'Flip');
        WaitSecs(0.05);
        
        Screen(window,'FillRect',P.colorBackground);
    end
    
    vpx_SendCommandString(strfinal1);
    
    
    for j = 2 : 20
        rect=[(x*screensize(3))-(j*2.5),(y*screensize(4))-(j*2.5),(x*screensize(3))+(j*2.5),(y*screensize(4))+(j*2.5)];
        Screen(window,'FillRect',[0 255 0],rect);
        Screen(window,'FillRect',[255 255 255],rectSmall);
        Screen(window,'Flip');
        
        WaitSecs(0.05);
    end
    
    WaitSecs(0.20);
    
    Screen(window,'FillRect',P.colorBackground);
    Screen(window,'Flip');
end
