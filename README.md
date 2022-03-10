# arrington_demo

This repo has a simple Psychtoolbox demo task for using the Arrington eyetracker at the Prisma scanner in Magdeburg. 

The files are organized in such a way that all helping functions are placed into subfolders, and only the scripts which need to be run by researchers directly are placed in the top folder. 

The top scripts are:
 * `Calibration.m` - simplified, but usable Calibration task for eye-tracking and pupil size
 * `demo_task.m` - a simple task showing how to send "event triggers" to the eyetracker logfiles. 
 * `ExpandPath.m` - a helper function which adds the subfolders to Matlab's search path.

