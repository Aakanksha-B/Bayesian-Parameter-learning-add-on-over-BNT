function bnet = test_discrete_no_pr(bnet,i,cases)
ns_i = bnet.node_sizes(i);
counts = zeros(ns_i,1);
for k = 1:length(cases)
    counts(cases(1,k),1)=counts(cases(1,k),1)+1;
end


cpt = zeros(ns_i,1);

for l=1:ns_i
    if sum(counts(:))~= 0
         cpt(l)= counts(l)/sum(counts(:));
    else
         cpt(l) = 1/ns_i;
    end
end


CPT_test = reshape(cpt,ns_i,1);
CPT_learnt = get_field(bnet.CPD{i},'cpt');

true_num = size(find(abs(CPT_test-CPT_learnt)<0.05),1);
accuracy = true_num*100/ns_i
