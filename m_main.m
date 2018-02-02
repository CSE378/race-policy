env = bicycleEnv();
env.rideBike(@simple_policy, 1);


function [vel, gamma] = simple_policy(obs)
    if obs(1) < 0.5
        vel = 0.001;
        gamma = 89.9;
    elseif obs(2) < 0.5
        vel = 0.001;
        gamma = -89.9;
    else
        vel = 1;
        gamma = 0;
    end
end
