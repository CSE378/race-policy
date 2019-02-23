function [desLwSpeed, desRwSpeed] = move(direction)

speed = 0.35;

if direction == "right"
    desLwSpeed = 0;
    desRwSpeed = speed + 0.1;
elseif direction == "left"
    desLwSpeed = speed + 0.2;
    desRwSpeed = 0;
elseif direction == "straight"
    desLwSpeed = speed;
    desRwSpeed = speed;
end