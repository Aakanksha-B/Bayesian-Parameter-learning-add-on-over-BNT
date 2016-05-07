function bnet = learn_discrete_no_pr(bnet,i,cases)
ns_i = bnet.node_sizes(i);
counts = zeros(ns_i,1);
for k = 1:length(cases)
    counts(cases(1,k),1)=counts(cases(1,k),1)+1;
end
bnet.CPD{i}=set_fields(bnet.CPD{i},'counts',counts);

cpt = zeros(ns_i,1);

for l=1:ns_i
    if sum(counts(:))~= 0
         cpt(l)= counts(l)/sum(counts(:));
    else
         cpt(l) = 1/ns_i;
    end
end


bnet.CPD{i} = set_fields(bnet.CPD{i},'CPT',cpt);
