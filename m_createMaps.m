% Create some maps environment
% By: Minh Hoai Nguyen (minhhoai@cs.stonybrook.edu)
% Created: 08-Feb-2019
% Last modified: 08-Feb-2019

function m_createMaps()
    v1 = [200, 500, 0];
    v2 = [800, 500, 0];
    map = ones(1000, 1000);
    map = drawPath(map, v1, v2);
    
    mapdata.mp = map;
    mapdata.sp = v1;
    mapdata.ep = v2(1:2);
    maps{1} = mapdata;
    

    v1 = [200, 300, 0];
    v2 = [800, 300, 0];
    v3 = [800, 900, 0];
    map = ones(1000, 1000);
    map = drawPath(map, v1, v2);
    map = drawPath(map, v2, v3);
    
    mapdata.mp = map;
    mapdata.sp = v1;
    mapdata.ep = v3(1:2);
    maps{2} = mapdata;


    v1 = [200, 100, 0];
    v2 = [500, 100, 0];
    v3 = [400, 300, 0];
    v4 = [800, 500, 0];
    v5 = [500, 800, 0];
    map = ones(1000, 1000);
    map = drawPath(map, v1, v2);
    map = drawPath(map, v2, v3);
    map = drawPath(map, v3, v4);
    map = drawPath(map, v4, v5);
    
    mapdata.mp = map;
    mapdata.sp = v1;
    mapdata.ep = v5(1:2);
    maps{3} = mapdata;

    ml_save('maps.mat', 'maps', maps);

    
function map = drawPath(map, v1, v2)
    pathWd = 15;
    [imH, imW] = size(map);
    [IX, IY] = meshgrid(1:imW, 1:imH);
    IX = IX(:);
    IY = IY(:);
    pts = cat(2, IX, IY);
    pts(:,3) = 0;
    
    % Check the distance
    linIdxs = sub2ind([imH, imW], IY, IX);
    dist = points_to_line(pts, v1, v2);    
    idxs0 = dist <= pathWd;
    
    % Check the angles
    idxs1 = pts*(v2-v1)' > v1*(v2-v1)';
    idxs2 = pts*(v1-v2)' > v2*(v1-v2)';
    
    n = length(IX);
    
    A = pts - repmat(v1, [n, 1]);
    idxs3 = sqrt(sum(A.^2, 2)) <= pathWd;
    
    A = pts - repmat(v2, [n, 1]);
    idxs4 = sqrt(sum(A.^2, 2)) <= pathWd;
    
    idxs5 = and(and(idxs1, idxs2), idxs0);    
    idxs6 = or(idxs3, idxs4);
    
    idxs7 = or(idxs5, idxs6);
    
    linIdxs = linIdxs(idxs7);
    map(linIdxs) = 0;
    

% v1, v2: 1*3 vectors for two vertices of the line (on 3D)
% pts: n*3 vectors for n points
function d = points_to_line(pts, v1, v2)
      a = v1 - v2;
      n = size(pts, 1);
      b = pts - repmat(v2, n, 1);     
      axb = cross(repmat(a, [n,1]), b);      
      n2 = sqrt(sum(axb.^2, 2));
      d = n2/ norm(a);
      