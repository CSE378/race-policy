function [desLwSpeed, desRwSpeed] = racePolicy(obs)
% You must implement this function. The input/output of the function must be as follows.
% Use main to test your implementation. 
% Inputs:
%   obs: a number for the reading of the light sensor. 
% Outputs:
%   desLwSpeed, desRwSpeed: desired left and right wheel speeds


% You can use persistent variables to store history. Eg.
persistent stepCount 

if isempty(stepCount)
    stepCount = 0;
end
stepCount = stepCount + 1;

% Very simple policy, go straight for 10 steps and then spin around
if stepCount < 10
    desLwSpeed = 1;
    desRwSpeed = 1;
else
    desLwSpeed = 0;
    desRwSpeed = 0;
end
