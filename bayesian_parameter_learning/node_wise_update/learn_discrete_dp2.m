function [bnet] = learn_discrete_dp2(i,dp,bnet,cases)
parent_conf = gen_parent_conf(bnet,dp);
data_size = size(cases);
ns_i = bnet.node_sizes(i);
ns = bnet.node_sizes(dp);                                                                                                                                                                                                                       
prod_sizes = prod(ns) ;
cpt = 0.001*ones(prod_sizes,ns_i);%zeros(prod_sizes,ns_i);


for k = 1:prod_sizes
   count = zeros(ns_i,1);
   for j = 1: data_size(2)
     if isequal(cases(1:data_size(1)-1,j),parent_conf(:,k))
     
     for l=1:ns_i
         if isequal(cases(data_size(1),j),l)
              count(l) = count(l) + 1;   
                % update count(l) when data(j) matches parent_configuration(k) and current node takes the it's l'th value 
              break;
         end
     end
     end
   end
   
   for l=1:ns_i
         if sum(count(:))~= 0
            cpt(k,l)= count(l)/sum(count(:));
         else
             cpt(k,l) = 1/ns_i;
         end
   end
end

bnet.CPD{i} = set_fields(bnet.CPD{i},'CPT',reshape(cpt,prod_sizes*ns_i,1));
