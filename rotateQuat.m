function Prot = rotateQuat(q, P)
% You must implement this function. 
% The input/output of the function must be exactly as follows.
% Inputs:
%   q: 4*1 vector representing a unit quaternion
%   P: 3*1 vector for a point in 3D space
% Outputs:
%   Prot: a 3*1 vector for the point P after rotation
Res = quatProduct(q, quatProduct([0; P], quatInverse(q)));
Prot = [Res(2); Res(3); Res(4)];



