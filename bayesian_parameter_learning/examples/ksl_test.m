n = 9;
f=1;k=2;h=3;b=4;s=5;a=6;w=7;g=8;y=9;
dag = zeros(n);
dag(y,w)=1;
dag(y,s)=1;
dag(y,a)=1;
dag(g,w)=1;
dag(g,s)=1;
dag(g,a)=1;
dag(w,a)=1;
dag(w,s)=1;
dag(y,f)=1;
dag(g,f)=1;
dag(s,f)=1;
dag(g,k)=1;
dag(y,k)=1;
dag(k,b)=1;
dag(g,b)=1;
dag(b,h)=1;
dag(f,h)=1;

ns = [1,1,2,1,2,2,2,2,2];
total = sum(ns);

bnet = mk_bnet(dag, ns,'discrete' ,[3,5,6,7,8,9]);
bnet.CPD{f} = gaussian_CPD(bnet,1,'full_mean',zeros(1,8),'cov',ones(1,8));
bnet.CPD{k} = gaussian_CPD(bnet,2,'full_mean',zeros(1,4),'cov',ones(1,4));
bnet.CPD{h} = softmax_CPD(bnet,3);
bnet.CPD{b} = gaussian_CPD(bnet,4,'full_mean',[0,0],'cov',[1,1],'weights',[1,1]);
bnet.CPD{s} = tabular_CPD(bnet,5, (1/16)*ones(16,1));
bnet.CPD{a} = tabular_CPD(bnet,6,(1/16)*ones(16,1));
bnet.CPD{w} = tabular_CPD(bnet,7,0.125*ones(8,1));
bnet.CPD{g} = tabular_CPD(bnet,8,[0.5 0.5]);
bnet.CPD{y} = tabular_CPD(bnet,9,[0.5 0.5]);

data = load('shuffled_ksldata.mat')
nu= 2
alpha = 1
samples=data.B;
train_samples = samples(1:700,:)';
test_samples = samples(701:1000,:)';
bnet =learn_all_parameters(bnet, train_samples,nu,alpha);
test(bnet,test_samples);
