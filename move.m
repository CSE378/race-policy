function [desLwSpeed, desRwSpeed] = move(direction)

if direction == "right"
    desLwSpeed = 0;
    desRwSpeed = 1;
elseif direction == "left"
    desLwSpeed = 1;
    desRwSpeed = 0;
elseif direction == "straight"
    desLwSpeed = 1;
    desRwSpeed = 1;
end