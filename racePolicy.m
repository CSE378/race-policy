function [desLwSpeed, desRwSpeed] = racePolicy(obs)
% You must implement this function. The input/output of the function must be as follows.
% Use main to test your implementation. 
% Inputs:
%   obs: a number for the reading of the light sensor. Ranges from 1 
%        if off the track, and 0 if on the track.
% Outputs:
%   desLwSpeed, desRwSpeed: desired left and right wheel speeds


persistent stepCount
persistent prevObs
persistent inRightTurn
persistent keepTurning

% Update Variables
keepTurning = 0;
inRightTurn = false;
prevObs = obs;
if isempty(stepCount)
    stepCount = 0;
end
stepCount = stepCount + 1;

% Go straight by default
[desLwSpeed, desRwSpeed] = move("straight");
% If offtrack, try right turn first
if stepCount <= 100
    if obs > 0.8
        [desLwSpeed, desRwSpeed] = move("right");
        inRightTurn = true;
    end
    if inRightTurn
        [desLwSpeed, desRwSpeed] = move("left");
    end
end
% If we are getting back on track, turn left