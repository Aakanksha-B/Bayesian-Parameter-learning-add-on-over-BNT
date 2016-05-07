function [bnet] = test_discrete_dp(i,dp,bnet,cases)
% searches the data to find instances of each parent configuration, and
% update the counts and CPT based on each value this node 'i' takes.

parent_conf = gen_parent_conf(bnet,dp);
data_size = size(cases);
ns_i = bnet.node_sizes(i);
ns = bnet.node_sizes(dp);                                                                                                                                                                                                                       
prod_sizes = prod(ns) ;
count = zeros(prod_sizes,ns_i);

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

% calculate probablities 
cpt = zeros(prod_sizes,ns_i);
for k = 1:prod_sizes
     for l=1:ns_i
         if sum(count(k,:))~= 0 
            cpt(k,l)= count(k,l)/sum(count(k,:));
         else
             cpt(k,l) = 1/ns_i; % if there's no data for a particular parent configuration
         end
     end
end

CPT_test = reshape(cpt,prod_sizes*ns_i,1);
CPT_learnt = get_field(bnet.CPD{i},'cpt');
CPT_learnt = reshape(CPT_learnt,prod_sizes*ns_i,1);

true_num = size(find(abs(CPT_test-CPT_learnt)<0.05),1);
accuracy = true_num*100/(prod_sizes*ns_i)

            