function ExpandPath()
% ExpandPath() adds relevant (sub)folders to Matlab's path
%
% Note: this script currently assumes it is in the projectRoot directory

% get directory where this script is located
[projectRoot,~,~] = fileparts(mfilename('fullpath'));

% add PTB utility functions (like InitializePTB)
addpath(sprintf('%s/PTB_utilities',projectRoot));

% add PTB tasks
addpath(sprintf('%s/PTB_tasks',projectRoot));
end
