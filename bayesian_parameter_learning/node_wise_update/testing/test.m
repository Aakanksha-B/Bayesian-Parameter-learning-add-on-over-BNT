function [ output_args ] = test(bnet, tdata)
%TEST find conditional probabilities from the test data and check how close
%it is to the learnt probabilities

n = length(bnet.CPD);
ns = bnet.node_sizes;
%sample_means = sum(bnet.node_sizes(bnet.cnodes))
offset=0; % for observed nodes
indices = get_start_data_in(bnet);

for i=[1:n]
    i
    dps= intersect(bnet.dnodes,parents(bnet.dag,i));
    cps= intersect(bnet.cnodes,parents(bnet.dag,i));
    [cdata_in, ddata_in] = get_pr_data_in(ns,cps,dps,indices);
    
    if isa(bnet.CPD{i},'tabular_CPD')
        disp('pure discrete');
       if ~isempty(dps) && isempty(cps)  % discrete node discrete parents only 
         cases = tdata([ddata_in indices(i)],:);
         bnet = test_discrete_dp(i,dps,bnet,cases);
       end
       if isempty(dps) && isempty(cps) % no parents
           cases = tdata(indices(i),:);
           bnet = test_discrete_no_pr(bnet,i,cases);
       end
    end
    if isa(bnet.CPD{i},'softmax_CPD') 
        disp('softmax');
        if isempty(dps) && ~isempty(cps) % continuous parents only
            cases = tdata([cdata_in indices(i)],:);
            bnet = test_softmax(i,cps,bnet,cases);
        end 
        if ~isempty(dps) && ~isempty(cps) % discrete and continuous parents 
            bnet = test_softmax_mixed(i,dps,cps,bnet,tdata,indices);
                    
        end 
    end
  if isa(bnet.CPD{i},'gaussian_CPD') 
        % to get the indices(row no.) for the data for this node.
        [i_in, d] = get_pr_data_in(ns,i,[],indices);
        
        if isempty(dps) % no discrete parents
            disp('pure gaussian');
            cases = tdata(i_in,:);
            bnet = test_gaussian(bnet,i,cases,1); 
        end 
        if ~isempty(dps) % discrete parents only
            disp('conditional gaussian');
            bnet = test_gaussian_dp(bnet,dps,i,tdata,indices);
        end 
    end
end


end

