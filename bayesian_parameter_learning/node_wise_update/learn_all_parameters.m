function [bnet] = learn_all_parameters(bnet, samples,nu,alpha)
% Does node wise update of parameters. Checks the type of node and
%parents and call the suitable subroutine to learn parameters.
n = length(bnet.CPD);
ns = bnet.node_sizes;
%sample_means = sum(bnet.node_sizes(bnet.cnodes))
offset=0; % for observed nodes
indices = get_start_data_in(bnet);
unobserved=[];
i=1;
for k=bnet.equiv_class
    if ~any(k==bnet.observed)
        unobserved(i)=k;
        i=i+1;
    end
end

for i=1:n%unobserved
    disp('learning')
    i
    dps= intersect(bnet.dnodes,parents(bnet.dag,i));
    cps= intersect(bnet.cnodes,parents(bnet.dag,i));
    [cdata_in, ddata_in] = get_pr_data_in(ns,cps,dps,indices);
    
    if isa(bnet.CPD{i},'tabular_CPD') 
       if ~isempty(dps) && isempty(cps)  % discrete node discrete parents only 
         cases = samples([ddata_in indices(i)],:);
         bnet = learn_discrete_dp(i,dps,bnet,cases); % 
       end
       if isempty(dps) && isempty(cps) % no parents
           cases = samples(indices(i),:);
           bnet = learn_discrete_no_pr(bnet,i,cases);
       end
      % CPT = get_field(bnet.CPD{i}, 'cpt');
    end
    if isa(bnet.CPD{i},'softmax_CPD')   
        if isempty(dps) && ~isempty(cps) % continuous parents only
            cases = samples([cdata_in indices(i)],:);
            bnet = learn_softmax(i,cps,bnet,cases);
        end 
        if ~isempty(dps) && ~isempty(cps) % discrete and continuous parents 
            bnet = learn_softmax_mixed(i,dps,cps,bnet,samples,indices);
                    
        end 
    end
 if isa(bnet.CPD{i},'gaussian_CPD')
      %print_gaussian_param(bnet,i);
        % to get the indices(row no.) for the data for this node.
        [i_in, d] = get_pr_data_in(ns,i,[],indices);
        
        if isempty(dps) && isempty(cps) % no parents
            cases = samples(i_in,:);
            bnet = learn_gaussian_no_pr(bnet,i,cases,nu,alpha,1); 
        end 
        if ~isempty(dps) && isempty(cps) % discrete parents only
            bnet = learn_gaussian_dp(i,dps,cps,bnet,samples,indices,nu,alpha);
        end 
        if isempty(dps) && ~isempty(cps) % continuous parents only
            cases = samples([cdata_in i_in],:);
            bnet = learn_gaussian_cp(bnet,cps,i,cases,nu,alpha,1);
        end 
        if ~isempty(dps) && ~isempty(cps) % discrete and continuous parents 
            bnet = learn_gaussian_mixed(bnet,cps,dps,i,samples,indices,nu,alpha);
        end 
        %print_gaussian_param(bnet,i);
end
end
