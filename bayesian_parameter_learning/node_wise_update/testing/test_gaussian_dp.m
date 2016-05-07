function bnet = test_gaussian_dp(bnet,dps,i,tdata,indices)
% updates the means and cov for a gaussian node with only discrete
% parents

ns = bnet.node_sizes;
%get the indices(row no.) of dp in data
[c, ddata_in] = get_pr_data_in(ns,[],dps,indices);
[i_in, d] = get_pr_data_in(ns,i,[],indices);
pr_c = gen_parent_conf(bnet,dps);
d_sample= tdata(ddata_in,:);
 for k=1:size(pr_c,2)
    %get the indices(col. no.) of data points having this parent
    %configuration k
    ind = get_matching_samples(d_sample,pr_c(:,k));
    if ~isempty(ind)
       cases = tdata(i_in,ind);
       bnet=test_gaussian(bnet,i,cases,k);
    end  
 end
