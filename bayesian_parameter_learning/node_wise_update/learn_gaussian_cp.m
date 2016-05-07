function bnet = learn_gaussian_cp(bnet,cp,j,cases,nu,alpha,p_i)
%to learn a gaussian node with gaussian parents. Heckerman's procedure for
%learning GBN's ,note- we start with all zero means.
nodes = [cp j];

ns = bnet.node_sizes;
lenc = length(nodes);
total = sum(ns(nodes));

FMu = get_field(bnet.CPD{j},'full_mean');

Mu = get_field(bnet.CPD{j},'mean');
C = get_field(bnet.CPD{j},'cov');
W = get_field(bnet.CPD{j},'weights');
m=FMu(:,p_i);
c=C(:,:,p_i);
w=W(:,:,p_i);
joint_mean = [zeros(total-ns(j),1);m];
D = eye(total);
%D(total-ns(j)+1:total,total-ns(j)+1:total)=c;
B =[zeros(total,total-ns(j)),[w';zeros(ns(j))]];

I = eye(total);
U = I - B;
T = U*inv(D)*U';

mu =  joint_mean;  % mean of hypothetical sample
n = lenc ; % no. of nodes
if alpha+1 ==n
    nu = nu+1;
    alpha = alpha+1;
end


beta = (nu * (alpha-n+1)/(nu+1)) * inv(T); % variance of hypothetical sample
%beta=zeros(total);
M = size(cases,2);
mean_s = mean(cases,2);
cov_s = (M-1) * cov(cases');

k=0;
error = 0.009*ones(total,1);
inc_step =M;

while(1)
    %% if nu>M return
    beta_s = beta + cov_s + (nu*M/(nu+M))*(mean_s-mu)*transpose(mean_s-mu);
    if all(all(beta_s==0))  
        return 
    else
    alpha_s = alpha + inc_step;
    mu_s = (nu*mu + M*mean_s)/ (nu + M);
    nu_s = nu+ inc_step;
    if any(abs(mu_s-mu) > error) && (k<40) %&& inc_step~=1
        k=k+1;
        beta=beta_s;
        mu=mu_s;
        nu=nu_s;
        alpha=alpha_s;
        %inc_step=6;
    else
        break
    end
    end
end

% disp('stationary point')
% k
i=lenc;
s = total;
% cp is the the combined precision matrix till the i^th  node
n_prop = struct('precision',[], 'weights',[],'cp',[],'cov',[]);

%may change to _s here
T_s = nu *(alpha-n+1)/(nu+1) * inv(beta);
%T_s = nu_s *(alpha_s-n+1)/(nu_s+1) * inv(beta_s);

n_prop.cp{i} = T_s;
while i > 1
    n_prop.precision{i} = n_prop.cp{i}(s-ns(nodes(i))+1:s,s-ns(nodes(i))+1:s);
    n_prop.weights{i} = -1 * n_prop.cp{i}(1:s-ns(nodes(i)),s-ns(nodes(i))+1:s)*inv(n_prop.precision{i});
    s= s-ns(nodes(i));
    n_prop.cp{i-1} = n_prop.cp{i}(1:s,1:s) - n_prop.weights{i}*n_prop.precision{i}*(n_prop.weights{i}.');
    i =i-1;
end    

n_prop.precision{1}= n_prop.cp{1};
b = n_prop.weights{lenc}';

for k= 1:length(n_prop.precision)
    n_prop.cov{k} = inv(n_prop.precision{k});
end

 mean_o = mu_s(total-ns(j)+1:total)-b*mu_s(1:total-ns(j));
 mean_f = mu_s(total-ns(j)+1:total);

FMu(:,p_i) = mean_f;
W(:,:,p_i) = b;
Mu(:,p_i) = mean_o;
C(:,:,p_i) = n_prop.cov{lenc};

bnet.CPD{j} = set_fields(bnet.CPD{j},'mean',Mu);
bnet.CPD{j} = set_fields(bnet.CPD{j},'cov',C);
bnet.CPD{j} = set_fields(bnet.CPD{j},'weights',W);
bnet.CPD{j} = set_fields(bnet.CPD{j},'full_mean',FMu);
