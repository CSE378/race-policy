classdef DDRobotEnv < handle
% ==================> DO NOT modify this file  <===================
% Environment for Differential Drive Robot
% By: Minh Hoai Nguyen (minhhoai@cs.stonybrook.edu)
% Created: 07-Feb-2019
% Last modified: 07-Feb-2019

    properties (Access = private)
        x = 0; % current position of the robot
        y = 0;
        theta = 0; % current heading angle        
        map; % current map
        xs; ys; % finish point     
        lwSpeed = 1 % current left and right wheel speed
        rwSpeed = 1        
    end
    
    properties (Constant)
        maxSpeed = 1;
        minSpeed = -1;
        maxSpeedChange = 0.1;
        wheelRadius = 10; % radius of the wheels
        width = 50; % distance between left and right wheels
        length = 100; % length of the robot
        sensorSz = 10;
    end
        
    methods
        % load the map nd put the robot at the initial point and orientation
        function obj = DDRobotEnv(mapdata)
            obj.map = mapdata.mp;
            obj.x = mapdata.sp(1); % start position
            obj.y = mapdata.sp(2); 
            obj.theta = mapdata.sp(3); % start angle
            obj.xs = mapdata.ep(1);
            obj.ys = mapdata.ep(2);
        end
        
        function dispRobot(obj)           
            obj.drawRect(obj.width, obj.length, obj.x, obj.y, obj.theta, 'g'); % body           
            obj.drawRect(obj.length/6, obj.length/2, obj.x + obj.width/2*cos(obj.theta + pi/2), ...
                obj.y + obj.width/2*sin(obj.theta + pi/2), obj.theta, 'b'); % left wheel
            obj.drawRect(obj.length/6, obj.length/2, obj.x + obj.width/2*cos(obj.theta - pi/2), ...
                obj.y + obj.width/2*sin(obj.theta - pi/2), obj.theta, 'b'); % right wheel
            
            % Draw the sensor
            L = obj.length/2;
            sX = round(obj.x + L*cos(obj.theta));
            sY = round(obj.y + L*sin(obj.theta));
            obj.drawRect(2*obj.sensorSz+1, 2*obj.sensorSz+1, sX, sY, 0, 'r');
        end

        
        % dispLevel: display level:
        %   0: no display
        %   1: display the trajectory
        %   2: display iteratively. Require keyboard to continue.
        function [traj, done] = run(obj, controlPolicy, maxStep, dispLevel)
            [obs, ~] = obj.step(0, 0);
            if ~exist('maxStep', 'var')
                maxStep = 5000;
            end
            traj = zeros(2, maxStep);  

            
            if exist('dispLevel', 'var') && dispLevel > 0
                clf;
            else
                dispLevel = 0;
            end

            for step=1:maxStep
                [desLwSpeed, desRwSpeed] = controlPolicy(obs); 
                [obs, status] = obj.step(desLwSpeed, desRwSpeed);
                traj(:, step) = [obj.x, obj.y];
                
                if dispLevel == 2
                    clf; imshow(obj.map); hold on;
                    hold on; scatter(traj(1,1:step), traj(2,1:step), 100, '.r');
                    scatter(obj.xs, obj.ys, 225, 'o', 'MarkerFaceColor',[0 .7 .7]);                     
                    obj.dispRobot();
                    title(sprintf('step %d, sensor: %g. Press anykey to continue', step, obs));
                    pause;
                end
                
                if status ~= 0
                    break;
                end
            end
            traj = traj(:, 1:step);
            
            if dispLevel == 1
                imshow(obj.map); hold on; scatter(traj(1,:), traj(2,:), 100, '.r');
                scatter(obj.xs, obj.ys, 225, 'o', 'MarkerFaceColor',[0 .7 .7]); 
                obj.dispRobot();
            end
            
            if dispLevel > 0
                if status == 1                    
                    title(sprintf('Reach destination in %d steps', step));
                elseif status == 0
                    title(sprintf('Fail to reach destiniation in %d steps', maxStep));
                elseif status == -1
                    title('Fail. Go out of bound');
                end
            end
        end
        
    end
    
    methods (Access = private)
        % update the robot position, orientation, and wheel speed based on the desired speeds
        % desLwSpeed, desRwSpeed: desried speed of the left and right wheel.
        % obs: sensor reading
        % status: 
        %   0, still running
        %   -1: fail
        %   1: success
        function [obs, status] = step(obj, desLwSpeed, desRwSpeed)            
            % Update speed based on the desired and current speeds
            obj.lwSpeed = obj.changeSpeed(obj.lwSpeed, desLwSpeed, obj.maxSpeedChange, obj.minSpeed, obj.maxSpeed);
            obj.rwSpeed = obj.changeSpeed(obj.rwSpeed, desRwSpeed, obj.maxSpeedChange, obj.minSpeed, obj.maxSpeed);
            
            % Left and right speeds
            Vl = obj.lwSpeed*obj.wheelRadius;
            Vr = obj.rwSpeed*obj.wheelRadius;
            
            % Rotation angle
            omega = (Vr - Vl)/obj.width;            
            V = 0.5*(Vr + Vl);
            
            obj.theta = obj.theta + omega;
            obj.x = obj.x + V*cos(obj.theta);
            obj.y = obj.y + V*sin(obj.theta);            

            % test if the sensor are on the line or not (we need three sensors)            
            [obs, isFail] = obj.readSensor();
            isSuccess = obj.checkEnd(obj.x, obj.y, obj.xs, obj.ys);            
            
            if isSuccess
                status = 1;
            elseif isFail
                status = -1;
            else
                status = 0;
            end
        end
        
        function [s, isFail] = readSensor(obj)
            L = obj.length/2;
            sX = round(obj.x + L*cos(obj.theta));
            sY = round(obj.y + L*sin(obj.theta));
            sW = obj.sensorSz;
            
            if sY-sW < 1 || sY + sW > size(obj.map,1) || sX-sW < 1 || sX + sW > size(obj.map,2) 
                s = nan;
                isFail = true;
            else                
                sensorVals = obj.map(sY-sW:sY+sW,sX-sW:sX+sW);
                s = mean(sensorVals(:));
                isFail = false;
            end            
        end 
    end
    
    methods (Static, Access = private)        
        function updatedSpeed = changeSpeed(currentSpeed, desiredSpeed, maxSpeedChange, minSpeed, maxSpeed)
            if desiredSpeed > currentSpeed + maxSpeedChange
                updatedSpeed = currentSpeed + maxSpeedChange;
            elseif desiredSpeed < currentSpeed - maxSpeedChange
                updatedSpeed = currentSpeed - maxSpeedChange;
            else
                updatedSpeed = desiredSpeed;
            end            
            updatedSpeed = min(updatedSpeed, maxSpeed);
            updatedSpeed = max(updatedSpeed, minSpeed);
        end

        % Check if the destination is within reach
        function isSuccess = checkEnd(x, y, xs, ys)
            d = (x - xs)^2 + (y - ys)^2;
            if d < 50
                isSuccess = 1;
            else
                isSuccess = 0;
            end
        end
        
        function drawRect(width, length, x, y, theta, color)            
            alpha = atan2(width, length);
            L = sqrt(width^2 + length^2)/2;
            
            angles = [theta - alpha, theta + alpha, theta + pi - alpha, theta + pi + alpha];
            rectx = x + L*cos(angles);
            recty = y + L*sin(angles);
            plot(rectx, recty);
            fill(rectx, recty, color);
        end
    end    
end
