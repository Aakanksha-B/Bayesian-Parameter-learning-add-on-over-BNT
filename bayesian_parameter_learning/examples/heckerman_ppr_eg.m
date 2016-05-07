
A= 1; B = 2; C = 3 ;D = 4;
n = 3;
dag = zeros(n);
dag(A,B)=0;
dag(B,C)=1;
dag (A,C)=1;

ns = [1,1,1];
total = sum(ns);

bnet = mk_bnet(dag,ns,'discrete',[]);
bnet.CPD{A} = gaussian_CPD(bnet, A, 'mean', 0, 'cov',1);
bnet.CPD{B} = gaussian_CPD(bnet, B, 'mean', 0, 'cov',1);
%size of weights = sum of sizes of parents x size of node
bnet.CPD{C} = gaussian_CPD(bnet, C, 'full_mean', 0, 'cov',1,'weights',[1,1]);

mat = load('univariate.mat');
samples = mat.R';
train_samples = samples(:,1:40);
test_samples = samples(:,41:50);
nu= 2
alpha = 1

bnet = learn_all_parameters(bnet, samples,nu,alpha);
test(bnet,test_samples);
