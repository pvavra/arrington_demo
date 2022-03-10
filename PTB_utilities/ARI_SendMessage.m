% Wrapper for sending messages to Arrington Research eyetracker (@Prisma)
function ARI_SendMessage(message)
% Note from Manual:  
% Inserts the string into the data file. The string must be inside quotes
% if it contains white spaces; in C programs the quote characters inside
% the command string must be escaped with backslashes. The string should be
% inside quotes. The string can either be inserted synchronously, i.e., at
% the end of the next data line (record), or asynchronously, i.e., on a
% separate line, depending upon the specification of
% dataFile_AsynchStringData. The default is asynchronous. When requests to
% insert strings are called more frequently than the data record is saved,
% and the dataFile_AsynchStringData is set to false, then the strings are
% concatenated. The string separator is the tab character.

% TODO: basic msg cleanup, e.g. remove \n, double-quotes etc.

commandString = sprintf('dataFile_InsertString "%s"', message)
vpx_SendCommandString(commandString)
end