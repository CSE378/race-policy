clc
clear

a = bicycleEnv;
res = zeros(1000, 2);
v = 1;
gamma = 0;
K = 100;
thetas = a.theta;
prep = [a.x, a.y];
sw = 1;
for t = 1 : 1000

    obs = a.step([v, gamma]);
    
    if obs(1) < 0.5
        v = 0.001;
        gamma = 89.9;
    elseif obs(2) < 0.5
        v = 0.001;
        gamma = -89.9;
    else
        v = 1;
        gamma = 0;
    end
    
    disp(a.theta);
    
    res(t, :) = [a.x, a.y];
end

figure; imshow(a.mp); hold on; scatter(res(:, 1), res(:, 2));