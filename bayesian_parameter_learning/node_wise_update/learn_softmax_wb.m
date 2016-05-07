function[w b] = learn_softmax_wb(i,ps,bnet,cases)
n_col= size(cases,2);
irow=size(cases,1);
ns_i = bnet.node_sizes(i);
ns_cp= bnet.node_sizes(ps); 

sum_sizes = sum(ns_cp);

net = glm(sum_sizes,ns_i,'softmax')

target = zeros(ns_i,n_col);
for k= 1:n_col
    target(cases(irow,k),k)=1;
end
target=target';
data = cases(1:irow-1,:)';

IRLS_iter = 10;
options = foptions;
options(1) =  1;
%options(14) = IRLS_iter;

net = glmtrain(net,options,data,target);
w = net.w1;
b = net.b1;

