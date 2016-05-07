function bnet = learn_gaussian_mixed(bnet,cps,dps,i,samples,indices,nu,alpha)
% updates the weights, means and cov for a gaussian node with discrete
% and conituous parents

ns = bnet.node_sizes;
%get the indices(row no.) of cp an dp in data
[cdata_in, ddata_in] = get_pr_data_in(ns,cps,dps,indices);
[i_in, d] = get_pr_data_in(ns,i,[],indices);
pr_c = gen_parent_conf(bnet,dps);
d_sample= samples(ddata_in,:);
 for k=1:size(pr_c,2)
    %get the indices(col. no.) of data points having this parent
    ind = get_matching_samples(d_sample,pr_c(:,k));
    if ~isempty(ind)
       cases = samples([cdata_in i_in],ind);
       bnet=learn_gaussian_cp(bnet,cps,i,cases,nu,alpha,k);   
    end  
 end