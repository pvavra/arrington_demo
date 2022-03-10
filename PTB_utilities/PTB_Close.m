function PTB_Close(P)
% ClosePTB() close all relevant PsychToolbox window.
%
% This is the complement of InitilializePTB() and closes all relevant
% windows, etc.
%
% SEE ALSO: InitializePTB
%


%% close stuff

%% set defaults
if ~exist('P','var')
    P = struct();
end

% reset priority to old value
if isfield(P,'oldPriority')
    Priority(P.oldPriority);
end

ShowCursor;

sca;

if isfield(P,'eye')
	P.el.StopRecording();
    P.el.CloseFile();
    P.el.Shutdown();
end

end
