function indices = get_start_data_in(bnet)
%this function maps the indicies of nodes in the network to their
%actual index (for discrete nodes) and starting index (for continuous
%nodes)in the given dataset.
ns = bnet.node_sizes;

n =  length(ns);
indices= zeros(1,n);

for i = 1:n
   if i == 1
      counter =1;
      
   else
        if isa(bnet.CPD{i-1},'gaussian_CPD')
          counter = counter + ns(i-1);
       else
          counter = counter + 1;
       end
   end
   indices(i) = counter;
end