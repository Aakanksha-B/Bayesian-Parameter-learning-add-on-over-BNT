
A= 1; B = 2; C = 3 ;D = 4;
n = 4;
dag = zeros(n);
dag(A,B)=0;
dag(B,C)=1;
dag (A,C)=1;
dag(C,D)=1;
ns = [1,1,1,3];
total = sum(ns);

bnet = mk_bnet(dag,ns,'discrete',[4]);
bnet.CPD{A} = gaussian_CPD(bnet, A, 'full_mean', [0], 'cov',1);
bnet.CPD{B} = gaussian_CPD(bnet, B, 'full_mean', [0], 'cov',1);
%size of weights = sum of sizes of parents x size of node
bnet.CPD{C} = gaussian_CPD(bnet, C, 'full_mean', [0], 'cov',1,'weights',[1,1]);

bnet.CPD{D} = softmax_CPD(bnet,D);

% Nsamples =500;
% samples = [];
% for s=1:Nsamples
%   samples(:,s) = cell2mat(sample_bnet(bnet));
% end
% data =samples';
% save('softmax_test_data.mat','data');
% mean(samples,2)

load('softmax_test_data.mat');
samples = data';
train_samples = samples(:,1:350);
mean(train_samples,2);
test_samples = samples(:,351:500);  %100 17 83
mean(test_samples,2);
nu= 2;
alpha = 1;

bnet = learn_all_parameters(bnet, train_samples,nu,alpha);
test(bnet,test_samples);



%%%real network with the data was genrated
% bnet = mk_bnet(dag,ns,'discrete',[4]);
% bnet.CPD{A} = gaussian_CPD(bnet, A, 'mean', [2], 'cov',1);
% bnet.CPD{B} = gaussian_CPD(bnet, B, 'mean', [3], 'cov',1);
% %size of weights = sum of sizes of parents x size of node
% bnet.CPD{C} = gaussian_CPD(bnet, C, 'mean', [3], 'cov',1,'weights',[1,1]);
% 
% bnet.CPD{D} = softmax_CPD(bnet,D);
