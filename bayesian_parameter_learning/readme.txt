Steps for learning 
1.) Specify a dag which models the structure of bayesian network 
to be learnt.
2.) set some initial parameter for the distribution of each node 
based on it's type and and its parents type.
3.) the paramters 'nu' specifies your belief (basically the
no. of samples you would have seen to have set the prior parameters).
set it to
0 : if you know nothing
2-5 : if you unsure about the values but sure about some.
10-something less than your sample size :if you are very sure of 
the initial prameters

alpha is usually nu-1

Then call learn_all_parameters(bnet,samples,nu,alpha)