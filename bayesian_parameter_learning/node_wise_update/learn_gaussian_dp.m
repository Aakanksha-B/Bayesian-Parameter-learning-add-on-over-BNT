function bnet = learn_gaussian_dp(i,dps,cps,bnet,samples,indices,nu,alpha)
% updates the means and cov for a gaussian node with only discrete
% parents

ns = bnet.node_sizes;
%get the indices(row no.) of cp an dp in data
[cdata_in, ddata_in] = get_pr_data_in(ns,cps,dps,indices);
[i_in, d] = get_pr_data_in(ns,i,[],indices);

pr_c = gen_parent_conf(bnet,dps);
d_sample= samples(ddata_in,:);
 for k=1:size(pr_c,2)
    %get the indices(col. no.) of data points having this parent
    %configuration k
    ind = get_matching_samples(d_sample,pr_c(:,k));
    if ~isempty(ind)
       cases = samples(i_in,ind);
       bnet=learn_gaussian_no_pr(bnet,i,cases,nu,alpha,k);
    end  
 end
