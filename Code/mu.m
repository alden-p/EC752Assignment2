function f = mu(xi,t)
   
delta = xi(1);
k = xi(2);
gamma = xi(3);
mu_S = xi(4); 
sigma = xi(5);
kappa = xi(6);
pi = xi(7);

f = mu_S + pi*min(t-kappa,zeros(1,length(t)));


end 

