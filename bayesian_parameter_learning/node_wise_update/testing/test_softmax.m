function bnet = test_softmax(i,ps,bnet,cases)
% uses the weights and offset for a softmax node to estimate the value of i^th 
% node in test data and then check if it is correct.
w = get_field(bnet.CPD{i},'weights');
b = get_field(bnet.CPD{i},'offset');

ns_i = bnet.node_sizes(i);

count=0;
col=size(cases,2);
rows=size(cases,1);
for j=1:col
    pr=zeros(ns_i,1);
    s = sum(exp(w'*cases(1:rows-1,j)+b));
    for k =1:ns_i
        pr(k) = exp(w(:,k)'*cases(1:rows-1,j)+b(k))/s;
    end 
    pr;
    q=find(pr==max(pr));
    
    if q==cases(rows,j)
        count=count+1;
    end
end
count*100/col
% for k=ns_i
%     pr(k) = exp(w(:k)*x+b(k)/sum()