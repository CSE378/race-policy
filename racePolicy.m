function [desLwSpeed, desRwSpeed] = racePolicy(obs)
% You must implement this function. The input/output of the function must be as follows.
% Use main to test your implementation. 
% Inputs:
%   obs: a number for the reading of the light sensor. Ranges from 1 
%        if off the track, and 0 if on the track.
% Outputs:
%   desLwSpeed, desRwSpeed: desired left and right wheel speeds


persistent stepCount
persistent mode
persistent turnCounter

% Initialize Variables
if isempty(stepCount)
    stepCount = 0;
    mode = "straight";
    turnCounter = 0;
end
stepCount = stepCount + 1;

%When going offtrack, first try right turn
if obs > 0.9 && mode == "straight"
    mode = "right";
elseif obs < 0.8 && mode ~= "straight"
    mode = "straight";
    turnCounter = 0;
elseif obs > 0.95 && mode == "right" && turnCounter == 30
    mode = "left";
    turnCounter = 0;
end

%Set speeds
if mode == "straight"
    [desLwSpeed, desRwSpeed] = move("straight");
elseif mode == "right"
    [desLwSpeed, desRwSpeed] = move("right");
    turnCounter = turnCounter + 1;
elseif mode == "left"
    [desLwSpeed, desRwSpeed] = move("left");
end

%Record current obs for next timestamp
prevObs = obs;
