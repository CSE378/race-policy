classdef bicycleEnv < handle
%     cannot modify directly from outside
    properties (Access = public)
        x = 0;
        y = 0;
        xs; ys;
        theta = 0;
        maps; % 6 maps 
        mp; % current map
    end
    
    
    methods
        function obj = bicycleEnv()
%             load maps
            t = load('maps.mat');
            obj.maps = t.maps;
            obj.reset();
        end
        
%         update the robot status after each step
        function [obs, fin] = step(obj, act)
            v = act(1);
            gamma = act(2);
            [obj.x, obj.y, obj.theta] = obj.update_bicycle(obj.x, obj.y, obj.theta, v, gamma);
%             test if the sensor are on the line or not (we need three sensors)
            obs = obj.update_sensor(obj.x, obj.y, obj.theta, obj.mp);
            fin = obj.check_end(obj.x, obj.y, obj.xs, obj.ys);
        end
        
%         reset the map and put the robot at the initial point with initial
%         orientation
        function reset(obj)
            id = 3;
            t = obj.maps{id};
            obj.mp = t.mp;
            obj.x = t.sp(1);
            obj.y = t.sp(2);
            obj.theta = -t.sp(3);
            obj.xs = t.ep(1);
            obj.ys = t.ep(2);
        end
        
    end
    
    methods (Static, Access = private)
        function [x, y, theta] = update_bicycle(x, y, theta, v, gamma)
            L = 1;
            dx = v * cosd(theta);
            dy = v * sind(theta);
            dtheta = v / L * tand(gamma);

            x = x + dx;
            y = y + dy;
            theta = theta + dtheta;
        end
        
        function s = update_sensor(x, y, theta, mp)
            % constrain the position inside the playground
            mgn = 6; % margin of the playground
            [mh, mw] = size(mp);
            x = min(max(mgn, round(x)), mw - mgn);
            y = min(max(mgn, round(y)), mh - mgn);
            s2 = mp(y, x);
            % asix length
            ax = 2;
            p1 = [0, ax]';
            p2 = [0, -ax]';
            rmat = [cosd(theta), -sind(theta); sind(theta), cosd(theta)];
            p1 = round(rmat * p1) + [x, y]';
            p2 = round(rmat * p2) + [x, y]';
            s1 = mp(p1(2), p1(1));
            s3 = mp(p2(2), p2(1));
            
%             s = [s1, s3];
            s = [s1, s3];
        end 
        
        function fin = check_end(x, y, xs, ys)
            d = (x - xs)^2 + (y - ys)^2;
            if d < 10
                fin = 1;
            else
                fin = 0;
            end
        end
    end
    
end