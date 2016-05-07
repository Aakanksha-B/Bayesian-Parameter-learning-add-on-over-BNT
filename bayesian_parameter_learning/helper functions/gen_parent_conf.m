function parent_conf = gen_parent_conf(bnet,dp)
%takes indices of discrete parents as input and generates all possible
%parent configurations for that node 
% e.g. for two parents of size 3 and 2 it would be
%----------------
% 1 2 3 1 2 3
% 1 1 1 2 2 2
ns = bnet.node_sizes(dp);                                                                                                                                                                                                                       
prod_sizes = prod(ns) ;
parent_conf = zeros(length(ns),prod_sizes);% total no. of parents x total no.of parent configurations
t = 1;
for l = 1:length(ns)
    k=1;
    value =1;
    while k<=prod_sizes
        if value>ns(l)
            value = 1;
        end    
        parent_conf(l,k:k+t-1)= value;
        k= k+t;
        value=value+1;
    end
    t = t*ns(l);
end 