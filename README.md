# arrington_demo

This repo has a simple Psychtoolbox demo task for using the Arrington eyetracker at the Prisma scanner in Magdeburg. 

The files are organized in such a way that all helping functions are placed into subfolders, and only the scripts which need to be run by researchers directly are placed in the top folder. 

The top scripts are:
 * `Calibration.m` - simplified, but usable Calibration task for eye-tracking and pupil size
 * `demo_task.m` - a simple task showing how to send "event triggers" to the eyetracker logfiles. 
 * `ExpandPath.m` - a helper function which adds the subfolders to Matlab's search path.


# Usage

Both the `demo_task.m` and `Calibration.m` have a variable `useEyetracker` which is per default set to 0. This means that no actual communication with the Arrington eyetracker is happening. The idea is that one should first test whether the scripts work before enabling the eyetracker.

To enable the eyetracker, set `useEyetracker = 1;` just before the `Eye_Initialize()` call.
