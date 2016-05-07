function [bnet] = learn_discrete_dp(i,dp,bnet,cases)
% searches the data to find instances of each parent configuration, and
% update the counts and CPT based on each value this node 'i' takes.

parent_conf = gen_parent_conf(bnet,dp);
data_size = size(cases);
ns_i = bnet.node_sizes(i);
ns = bnet.node_sizes(dp);                                                                                                                                                                                                                       
prod_sizes = prod(ns) ;
count = zeros(prod_sizes,ns_i);%zeros(prod_sizes,ns_i);
disp('init_count')
init_count = reshape(get_field(bnet.CPD{i},'counts'),prod_sizes,ns_i)

for j = 1: data_size(2)      
    for k = 1:prod_sizes
        if isequal(cases(1:data_size(1)-1,j),parent_conf(:,k))
            for l=1:ns_i
                if isequal(cases(data_size(1),j),l)
                    count(k,l) = count(k,l) + 1;   
                    % update count(l) when data(j) matches parent_configuration(k) and current node takes the it's l'th value 
                    break;
                end
            end
            break;
            
        end
    end
end 

bnet.CPD{i} = set_fields(bnet.CPD{i},'counts',reshape(count,prod_sizes*ns_i,1));

% calculate probablities and update CPT 

cpt = zeros(prod_sizes,ns_i);
for k = 1:prod_sizes
     for l=1:ns_i
         if sum(count(k,:))~= 0
            cpt(k,l)= count(k,l)+init_count(k,l)/sum(count(k,:))+sum(init_count(k,:));
         else
             cpt(k,l) = 1/ns_i;
         end
     end
end

bnet.CPD{i} = set_fields(bnet.CPD{i},'CPT',reshape(cpt,prod_sizes*ns_i,1));
