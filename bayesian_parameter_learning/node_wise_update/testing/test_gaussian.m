function bnet = test_gaussian(bnet,i,cases,pi)
%used to test a gaussian node 
ns_i = bnet.node_sizes(i);
mu_all = get_field(bnet.CPD{i},'full_mean');
mu = mu_all (:,pi);
c_all = get_field(bnet.CPD{i},'cov');
c = c_all(:,:,pi);
M = size(cases,2);
count =0;
k=0;
if ns_i ==1   %univariate node 
    t = -2.5*c;
    while t<2.5*c
        l_lim = mu+t;
        u_lim = mu+t+c;
        samples_in_range = 0;
        for j=1:M
            if l_lim<=cases(j) && cases(j)<=u_lim
                samples_in_range = samples_in_range +1;
            end
        end 
        k=k+1;
        sample_prob =samples_in_range/M;
        [cdf,err] = mvncdf(l_lim,u_lim,mu,c);
        cdf;
        if abs(cdf-sample_prob)<0.05
                count=count+1;
        end
        t=t+c;
    end
    count;
    (count*100)/k
end

k=0;
if ns_i==2   %bivariate node 
    sd_x = sqrt(c(1,1));
    sd_y = sqrt(c(2,2));
    tx = -1.5*sd_x;
    while tx<1.4*sd_x
        l_limx = mu(1)+tx;
        u_limx = mu(1)+tx+sd_x;
        ty = -1.5*sd_y;
        while ty<1.4*sd_x
            l_limy = mu(2)+ty;
            u_limy = mu(2)+ty+sd_y;
            samples_in_range = 0;
            for j=1:M
                
                if l_limx<=cases(1,j) && cases(1,j)<=u_limx && l_limy<=cases(2,j) && cases(2,j)<=u_limy
                    samples_in_range = samples_in_range +1;
                end
            end 
            k=k+1;
            sample_prob =samples_in_range/M;
            [cdf,err] = mvncdf([l_limx,l_limy],[u_limx,u_limy],mu',c);
            cdf;
            if abs(cdf-sample_prob)<0.1
                count=count+1;
            end 
            ty = ty+sd_y;
        end    
        tx=tx+sd_x;
    end
    k;
    count*100/k
end
