% For Q1.1
% Load reference ans and inputs
load('matlab.mat');

% Fixed inputs
v = {[1;0;0],[0;1;0],[0;0;1]}; % example test cases. No multiple rotation 
theta = {pi,pi,pi};
P = [1;1;1];
result_1 = ones(0,0);
for i = 1:3
    %theta{i}
    res = rotateAxis(v{i}, theta{i}, P);
    result_1 = [result_1,res];
end 
%q1 = isequal( result_1,result_1_ref); % 1 --> Pass 0--> Fail
q1 = sum(abs(result_1-result_1_ref),'all') < 10*eps;% add some tolerance for numeric variation.



% For Q1.2
result_2 = ones(0,0);
for i = 1:size(norm_unit_q,2)
    %theta{i}
    norm_q = norm_unit_q(:,i); % norm_unit_q has been generated (in the loaded matrix)
    res = rotateQuat(norm_q,P);
    result_2 = [result_2,res];
end 
%q2 = isequal( result_2,result_2_ref); % 1 --> Pass 0--> Fail
q2 = sum(abs(result_2-result_2_ref),'all') < 10*eps; % add some tolerance for numeric variation.
q1,q2 %1->pass 0->Fail
