function [vel, gamma] = racePolicy(obs)
% You must implement this function. The input/output of the function must be as follows.
% Use m_main to test your implementation. 
% Inputs:
%   obs: 1*2 vector for the values of two light sensors
% Outputs:
%   vel: the desired veolicy. You can return whatever value, 
%        but the bicycle environment will clip it to [0, 1]
%   gamma: heading angle of the bike in degree. It will be clipped by [-20, 20]


% simple policy, keep going straight
vel = 1;
gamma = 0;



