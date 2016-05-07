function ind = get_matching_samples(cases,pr_con)
%this function checks the data to find which all data points have 
% a particular parent conf .
ind = [];
for k = 1:size(cases,2)
    if cases(:,k)== pr_con
       ind = [ind k];
    end
end