A= 1; B = 2; C = 3 ;D = 4;E = 5;F =6;
n = 6;
dag = zeros(n);
%dag(A,B)=1;
dag(A,D)=1;
dag(B,E)=1;
dag(C,F)=1;
dag(D,F) = 1;
dag(E,F) = 1;
ns = [2,2,2,2,2,2];
bnet = mk_bnet(dag, ns,'discrete' ,[1,2,3]);
bnet.CPD{1} = tabular_CPD(bnet,1,'CPT',[0.6,0.4]);
bnet.CPD{2} = tabular_CPD(bnet,2,'CPT',[0.5,0.5]);
bnet.CPD{3} = tabular_CPD(bnet,3,'CPT',[1,0.01]);
bnet.CPD{4} = gaussian_CPD(bnet, 4, 'mean', [[2,2],[4,4]], 'cov',[[1,0],[0,1],[1,0],[0,1]]);
bnet.CPD{5} = gaussian_CPD(bnet, 5, 'mean', [[3,3],[6,6]], 'cov',[[1,0],[0,1],[1,0],[0,1]]);
bnet.CPD{6} = gaussian_CPD(bnet, 6, 'mean', [[2,2],[4,4]], 'cov',[[1,0],[0,1],[1,0],[0,1]],'weights',[20,20,20,20,3,3,3,3,10,10,10,10,5,5,5,5]);

load('test5data.mat');

nu= 2
alpha = 1

train_samples = samples(:,[1:8 ]);%51:70]);
test_samples = samples(:,71:80);
bnet=learn_all_parameters(bnet, train_samples,nu,alpha);
test(bnet,test_samples);

engine = jtree_inf_engine(bnet);
evidence = cell(1,n); % no evidence
%evidence{1} = 1;
[engine, ll] = enter_evidence(engine, evidence);

mu = zeros(2,n);
sigma = zeros(2,2,n);
dprob = zeros(1,n);
addev = 1;
tol = 1e-2;
for i=bnet.cnodes(:)'
    m = marginal_nodes(engine, i, addev);
    mu(:,i) = real(m.mu);
    sigma(:,:,i) = real(sqrt(m.Sigma));
end
for i=bnet.dnodes(:)'
    m = marginal_nodes(engine, i, addev);
    max_i = find(m.T == max(m.T));
    if size(max_i,1)>1 || isempty(max_i)
        dprob(i) = 0;
    else
        dprob(i) = max_i;
    end
    m.T;
end
mu 
sigma
dprob

% bnet = mk_bnet(dag, ns,'discrete' ,[1,2,3]);
% bnet.CPD{1} = tabular_CPD(bnet,1,'CPT',[0.6,0.4]);
% bnet.CPD{2} = tabular_CPD(bnet,2,'CPT',[0.5,0.5]);
% bnet.CPD{3} = tabular_CPD(bnet,3,'CPT',[0.8,0.2]);
% bnet.CPD{4} = gaussian_CPD(bnet, 4, 'mean', [[2,2],[4,4]], 'cov',[[1,0],[0,1],[1,0],[0,1]]);
% bnet.CPD{5} = gaussian_CPD(bnet, 5, 'mean', [[3,3],[6,6]], 'cov',[[1,0],[0,1],[1,0],[0,1]]);
% bnet.CPD{6} = gaussian_CPD(bnet, 6, 'mean', [[2,2],[4,4]], 'cov',[[1,0],[0,1],[1,0],[0,1]],'weights',[20,20,20,20,3,3,3,3,10,10,10,10,5,5,5,5]);

% Nsamples =50;
% samples = [];
% for s=1:Nsamples
%   samples(:,s) = cell2mat(sample_bnet(bnet));
% end
% 
% save('test5data.mat','samples');