function bnet = learn_gaussian_no_pr(bnet,i,cases,nu,alpha,pi)
%used to update a gaussian node has which has no parents or only discrete
%parents. the procedure for GBN also followed for a single node.
ns_i = bnet.node_sizes(i);
mu_all = get_field(bnet.CPD{i},'mean');
mu = mu_all (:,pi); %zeros(ns_i,1)
c_all = get_field(bnet.CPD{i},'cov');
c = c_all(:,:,pi);
M = size(cases,2);

mean_s = mean(cases,2);
cov_s = (M-1) * cov(cases');

T=inv(c);
beta = (nu * (alpha-1+1)/(nu+1)) * inv(T);
 
k=0;
error=0.009*ones(ns_i,1);
inc_step=M;
while(1)
    beta_s = beta + cov_s + (nu*M/(nu+M))*(mean_s-mu)*transpose(mean_s-mu);
    alpha_s = alpha + inc_step;
    mu_s = (nu*mu + M*mean_s)/ (nu + M);
    nu_s = nu+ inc_step;
    if any(abs(mu_s-mu) > error) && (k<40)
        k=k+1;
        beta=beta_s;
        mu=mu_s;
        nu=nu_s;
        alpha=alpha_s;
    else
        break
    end
end

% disp('stationary point')
% k
T_s = nu_s *(alpha_s-1+1)/(nu_s+1) * inv(beta_s);
cov_ss = inv(T_s);

mu_all(:,pi) =mu_s;
c_all(:,:,pi)=cov_ss;
bnet.CPD{i} = set_fields(bnet.CPD{i},'mean',mu_all);
bnet.CPD{i} = set_fields(bnet.CPD{i},'full_mean',mu_all);
bnet.CPD{i} = set_fields(bnet.CPD{i},'cov',c_all);