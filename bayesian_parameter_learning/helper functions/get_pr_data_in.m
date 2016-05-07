function [cdata_in ddata_in] = get_pr_data_in(ns,cps,dps,indices)
%this func enumrates all parents indices of node i in the data, puts the continuous data (from contiuous nodes)
% discete data (from discrete parents)into 2 different
% arrays and returns.
cdata_in =[];
ddata_in = [];
counter = 1;

for j= 1:length(cps)
   index = indices(cps(j));
   cdata_in(counter) = index;
   k = 1;
    while k<ns(cps(j))
      cdata_in(counter+k)=index+k;
      k = k+1;
    end
    counter = counter+k;
end


for l= 1:length(dps), ddata_in = [ddata_in indices(dps(l))]; end
    