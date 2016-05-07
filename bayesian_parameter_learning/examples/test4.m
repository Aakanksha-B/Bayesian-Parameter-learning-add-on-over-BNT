n = 6;
dag = zeros(n);
dag(1,4)=1;
dag(1,2)=1;
dag(1,3)=1;
dag(2,4)=1;
dag(3,4)=1;
dag(4,6)=1;
dag(5,6)=1;

ns = [5,5,9,2,9,2];
total = sum(ns);

bnet = mk_bnet(dag, ns,'discrete' ,[1,2,3,5]);
bnet.CPD{1} = tabular_CPD(bnet,1);
bnet.CPD{2} = tabular_CPD(bnet,2);
bnet.CPD{3} = tabular_CPD(bnet,3);
bnet.CPD{4} = gaussian_CPD(bnet,4,'mean',[3*ones(225,1); 4*ones(225,1)],'cov',repmat([[1,0],[0,1]],[1,225]));
bnet.CPD{5} = tabular_CPD(bnet,5);
bnet.CPD{6} = gaussian_CPD(bnet,6,'mean',5*ones(18,1),'cov',repmat([[1,0],[0,1]],[1,9]),'weights',ones(36,1));


load('test4data.mat');

nu= 2
alpha = 1

train_samples = samples(:,[1:50 ]);%251:500]);
test_samples = samples(:,51:250);
bnet=learn_all_parameters(bnet, train_samples,nu,alpha);
%test(bnet,test_samples);

engine = jtree_inf_engine(bnet);
evidence = cell(1,n); % no evidence
evidence{1} = 1;
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
    m.T
end
mu 
sigma
dprob


% bnet = mk_bnet(dag, ns,'discrete' ,[1,2,3,5]);
% bnet.CPD{1} = tabular_CPD(bnet,1);
% bnet.CPD{2} = tabular_CPD(bnet,2);
% bnet.CPD{3} = tabular_CPD(bnet,3);
% bnet.CPD{4} = gaussian_CPD(bnet,4,'mean',[3*ones(225,1); 4*ones(225,1)],'cov',repmat([[1,0],[0,1]],[1,225]));
% bnet.CPD{5} = tabular_CPD(bnet,5);
% bnet.CPD{6} = gaussian_CPD(bnet,6,'mean',5*ones(18,1),'cov',repmat([[1,0],[0,1]],[1,9]),'weights',ones(36,1));
% Nsamples =500;
% samples = [];
% for s=1:Nsamples
%   samples(:,s) = cell2mat(sample_bnet(bnet));
% end
% 
% save('test4data.mat','samples');

% 6
% full_mean =
% 
%    12.6209    9.8445   12.8098   11.0237   11.5263   13.0094   12.5558   12.7374   10.8219
%    11.7846    9.3386   11.7925   11.4197   11.2608   13.3358   12.2945   11.4979   10.4324
% 
% 
% mean =
% 
%     3.3802    0.1241    4.7958    2.9368    2.0703    0.1937    4.1586    0.4045    0.5503
%     0.9149    0.1124    3.5651    2.4710    5.1662    0.0014    3.0563    0.3476    4.6016
% 
%  