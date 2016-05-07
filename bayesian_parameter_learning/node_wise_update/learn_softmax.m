function bnet = learn_softmax(i,ps,bnet,cases)
% updates the weights and offset for a softmax node using Iteratively
% reweighted least squares algorithm available in the netlab toolbox

[w,b] = learn_softmax_wb(i,ps,bnet,cases);

bnet.CPD{i} = set_fields(bnet.CPD{i},'weights',w);
bnet.CPD{i} = set_fields(bnet.CPD{i},'offset',b);

 