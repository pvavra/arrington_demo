function P = EYE_Initialize(P, useEyetracker)

if useEyetracker
    fprintf('going to use Arrington Research eyetracker\n');
    try
        addpath('C:\ARI\ViewPoint\ViewPoint_EyeTracker_Toolbox');
        vpx_Initialize
    catch e
    end
    
    % Note: There might be a way to send a specific file-name to the
    % eyetracker PC but I haven't found a working one.. 
    % Might be worth the time to try this out for easier organization of
    % files later.. 
    vpx_SendCommandString('dataFile_NewUnique');
    
    P.eye = struct();
    P.eye.SendMessage      = @ARI_SendMessage;
    P.eye.Calibrate        = @ARI_Calibrate;
    P.eye.GetFile          = @DoNothing;
    P.eye.StartRecording   = @() vpx_SendCommandString('dataFile_resume');
    P.eye.StopRecording    = @() vpx_SendCommandString('dataFile_Pause');
    P.eye.CloseFile        = @() vpx_SendCommandString('dataFile_Close');
    P.eye.Shutdown         = @DoNothing;
    
else
    fprintf('===========================\n');
    fprintf('Eyetracker will NOT be used.\n')
    fprintf('\tSetting up dummy-functions\n');
    fprintf('===========================\n');
    P.eye = struct();
    P.eye.SendMessage      = @PrintToCommandWindow;
    P.eye.Calibrate        = @DoNothing;
    P.eye.GetFile          = @DoNothing;
    P.eye.StartRecording   = @DoNothing;
    P.eye.StopRecording    = @DoNothing;
    P.eye.CloseFile        = @DoNothing;
    P.eye.Shutdown         = @DoNothing;
end

end