function bnet = learn_softmax_mixed(i,dps,cps,bnet,samples,indices)
% updates the weights and offset for a softmax node using Iteratively
% reweighted least squares algorithm available in the netlab toolbox
weights = get_field(bnet.CPD{i},'weights');
offsets = get_field(bnet.CPD{i},'offset');
ns = bnet.node_sizes;
[cdata_in ddata_in] = get_rel_data(ns,cps,dps,indices);
pr_c = gen_parent_conf(bnet,dps);
 for k=1:size(pr_c,2)
    cases= samples(ddata_in,:);
    ind = get_matching_samples(cases,pr_c(:,k));
    if ~isempty(ind)
       cases = samples([cdata_in indices(i)],ind);
       [w, b] = learn_softmax_wb(i,cps,bnet,cases);
       weights(:,:,k)=w;
       offsets(:,k)=b;
    end  
 end

bnet.CPD{i} = set_fields(bnet.CPD{i},'weights',weights);
bnet.CPD{i} = set_fields(bnet.CPD{i},'offset',offsets);

 