env = bicycleEnv();
env.rideBike(@goStraightPolicy, 1);


% a policy that keeps going straight
function [vel, gamma] = goStraightPolicy(obs)
    vel = 1;
    gamma = 0;
end
