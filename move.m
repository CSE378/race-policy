function [desLwSpeed, desRwSpeed] = move(direction)

speed = 0.35;

if direction == "right"
    desLwSpeed = 0;
    desRwSpeed = speed;
elseif direction == "left"
    desLwSpeed = speed;
    desRwSpeed = 0;
elseif direction == "straight"
    desLwSpeed = speed;
    desRwSpeed = speed;
end