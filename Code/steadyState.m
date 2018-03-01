function [s_S, logphi_S] = steadyState(xi,b_S)

%   xi=[0.995, 1000, 0.3, 10, 1, 12, 0]; 
%   b_S = 70;
% [s_S, logphi_S] = steadyState([0.995, 1000, 0.3, 10, 1, 12, 0],70)

delta = xi(1);
k = xi(2);
gamma = xi(3);
mu_S = xi(4); 
sigma = xi(5);
kappa = xi(6);
pi = xi(7);


    function f=steadyStateSystem(x)
       s=x(1);
       q=x(2);
       % The integral that shows up in both FOC
       integral = (1-normcdf((q-mu_S)/sigma)) ...
            .*(mu_S - q + sigma.*normpdf((q-mu_S)/sigma)./(1-normcdf((q-mu_S)/sigma)));
       
        
       % For large values of x, normpdf(x)/(1-normcdf(x), gets very close
       % to zero, but also to dividing by approximately zero. The result is
       % that the integral can numerically evaluate to NaN or <0. 
       % We have to check for that and set it to 0 in those cases to avoid
       % complex solutions.
       if  isnan(integral)==1 || integral<0
           integral=0; 
       end            
        
       % FOC for search effort
       f1 = min(s,1) - (1/k * delta/(1-delta) * integral )^(1/gamma);
       % FOC for reservation wage
       f2 = -1 * q + log(b_S) ...
            - k*(min(s,1)^(1+gamma))/(1+gamma) ...
            +delta/(1-delta)*min(s,1)*integral ;
       % We take the sum of squares of the deviations from 0 for the two
       % conditions as the minimand. When f is 0, the equation is solved.
       f = f1^2+f2^2;
    end 

% Lower and upper bound of parameter space (note that s cannot be < 0)
lb = [0,0];
ub = [1,1000];

% Initial value for fmincon
x0=[0.05,mu_S];

% test whether function works / only for debugging
steadyStateSystem(x0);

% Solve system of equations using fmincon
options = optimset('Display', 'on','Algorithm','interior-point');
x_star = fmincon(@steadyStateSystem,x0,[],[],[],[],lb,ub,[],options);

% Check that we have indeed found a solution - should be 0 or very close
steadyStateSystem(x_star);

% Return optimal solution
s_S = x_star(1);
logphi_S = x_star(2);

% Plot the objective function steadyStateSystem to see whether well behaved
if 0
    % search effort space
    pvec1 = 0:.01:.1; 
    % phi space
    pvec2 = 3:.1:10;
    % matrix to hold results
    objfun = zeros(length(pvec1),length(pvec2));
    
    % Solve objective function over the grid
    for m = 1:length(pvec1);
        for j = 1:length(pvec2);
            objfun(m,j)=steadyStateSystem([pvec1(m),pvec2(j)]);
            objfun(m,j)=steadyStateSystem([pvec1(m),pvec2(j)]);
        end
    end
    
    %figure
    surf(pvec1,pvec2,objfun'), ...
        xlabel('search effort','fontsize',16), ...
        ylabel('reservation wage','fontsize',16), ...
        zlabel('SSE','fontsize',16), ...
        title('Plot SSE around optimum over s and phi' ,'fontsize',16)
    filename = ['./figures/steadyStateSystem.pdf'];
    print(filename,'-dpdf');  
    
end


end 


