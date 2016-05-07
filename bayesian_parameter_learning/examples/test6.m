A= 1; B = 2; C = 3 ;D = 4;E = 5;F =6;
n = 6;
dag = zeros(n);
dag(A,B)=1;
dag(B,E)=1;
dag(C,E)=1;
dag(D,E) = 1;
dag(D,F) = 1;

fid = fopen('test6data2.txt');
out = textscan(fid,'%f%f%f%f%f%f%f%f%f%f%f%f','delimiter','\t');
samples = cell2mat(out)';
train_samples = samples(:,1:20);
test_samples = samples(:,20:30);
fclose(fid);

ns = 2*ones(6,1);
total = sum(ns);

bnet2 = mk_bnet(dag, ns,'discrete' ,[]);

bnet2.CPD{A} = gaussian_CPD(bnet2, A, 'mean', [0,0], 'cov',[[1,0],[0,1]]);
bnet2.CPD{B} = gaussian_CPD(bnet2, B, 'full_mean', [0,0], 'cov',[[1,0],[0,1]],'weights',ones(4,1));
%size of weights = sum of sizes of parents x size of node
bnet2.CPD{C} = gaussian_CPD(bnet2, C, 'full_mean', [0,0], 'cov',[[1,0],[0,1]]);
bnet2.CPD{D} = gaussian_CPD(bnet2, D, 'full_mean', [0,0], 'cov',[[1,0],[0,1]]);
bnet2.CPD{E} = gaussian_CPD(bnet2, E, 'full_mean', [0,0], 'cov',[[1,0],[0,1]],'weights',ones(12,1));
bnet2.CPD{F} = gaussian_CPD(bnet2, F, 'full_mean', [0,0], 'cov',[[1,0],[0,1]],'weights',ones(4,1));

% Nsamples =30;
% samples = [];
% for s=1:Nsamples
%   samples(:,s) = cell2mat(sample_bnet(bnet2));
% end
% samples'
% full_mean(samples,2)

nu= 2
alpha = 1
bnet =learn_all_parameters(bnet2, train_samples,nu,alpha);
test(bnet,test_samples);

engine = jtree_inf_engine(bnet);
evidence = cell(1,n); % no evidence
evidence{4} = [5.2,3.1] ;
[engine, ll] = enter_evidence(engine, evidence);

mu = zeros(2,n);
sigma = zeros(2,2,n);
dprob = zeros(1,n);

addev = 1;
tol = 1e-2;
for i=bnet.cnodes(:)'
    m = marginal_nodes(engine, i, addev);
    mu(:,i) = m.mu;
    sigma(:,:,i) = m.Sigma;
end
for i=bnet.dnodes(:)'
    m = marginal_nodes(engine, i, addev);
    dprob(i) = m.T(1);
end

mu
sigma
dprob
% 
% bnet2 = mk_bnet(dag, ns,'discrete' ,[]);
% 
% bnet2.CPD{A} = gaussian_CPD(bnet2, A, 'mean', [0,5], 'cov',[[1,0],[0,1]]);
% bnet2.CPD{B} = gaussian_CPD(bnet2, B, 'mean', [0,0], 'cov',[[1,0],[0,1]],'weights',[0,1,1,0]);
% %size of weights = sum of sizes of parents x size of node
% bnet2.CPD{C} = gaussian_CPD(bnet2, C, 'mean', [2,2], 'cov',[[1,0],[0,1]]);
% bnet2.CPD{D} = gaussian_CPD(bnet2, D, 'mean', [5,3], 'cov',[[1,0],[0,1]]);
% bnet2.CPD{E} = gaussian_CPD(bnet2, E, 'mean', [-1,1.5], 'cov',[[1,0],[0,1]],'weights',[0.5,0,0.5,0,-1,-0.5,0,-1,0.5,1,1,0.5]);
% bnet2.CPD{F} = gaussian_CPD(bnet2, F, 'mean', [3,0], 'cov',[[1,0],[0,1]],'weights',[1,0,0,1]);
% for i=1:n 
%     c = get_field(bnet2.CPD{i},'weights') 
%     
% end
% Nsamples =30;
% samples = [];
% for s=1:Nsamples
%   samples(:,s) = cell2mat(sample_bnet(bnet2));
% end
% samples'
% mean(samples,2)
% mu =
% 
%     0.2267    5.1235    2.0532    5.2180    5.0537    8.0841
%     5.1064    0.2069    1.9134    2.9039    5.0129    3.2423
