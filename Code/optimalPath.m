function [s,logphi] = optimalPath(xi,b)

%  xi=[0.981, 76.171, 0.145, 5.995, 0.5, 12, 0]; 
%  
%  b = [ones(1,12).*190 ones(1,12).*90];

delta = xi(1);
k = xi(2);
gamma = xi(3);
mu_S = xi(4); 
sigma = xi(5);
kappa = xi(6);
pi = xi(7);
 
lastperiod=length(b);

% Compute vector of mu_t - the mean offered log wage in each period
muv = mu(xi,1:lastperiod);

% Vectors to store search effort and reservation wage
s = zeros(1,lastperiod);
logphi = zeros(1,lastperiod);

% Compute steady state
[s(lastperiod), logphi(lastperiod)] = steadyState(xi,b(lastperiod));

% Show steady state effort and reservation wage (for debugging)
s(lastperiod);
logphi(lastperiod);

% Backwards induction loop to solve for search effort and res. wage 
for t=(lastperiod-1):-1:1
    
    % The integral that shows up in both FOC
    integral = (1-normcdf((logphi(t+1)-muv(t+1))/sigma)) ...
        .*(muv(t+1) - logphi(t+1) ...
            + sigma.*normpdf((logphi(t+1)-muv(t+1))/sigma)...
            ./(1-normcdf((logphi(t+1)-muv(t+1))/sigma)));
        
    % For large values of x, normpdf(x)/(1-normcdf(x), gets very close
    % to zero, but also to dividing by approximately zero. The result is
    % that the integral can numerically evaluate to NaN or <0.
    % We have to check for that and set it to 0 in those cases to avoid
    % complex solutions.
    if  isnan(integral)==1 || integral<0
        integral=0;
    end
    
    s(t) = min((1/k * delta/(1-delta) * integral )^(1/gamma),1);
    
    logphi(t) = (1-delta) * (log(b(t))- k*(s(t)^(1+gamma))/(1+gamma)) ...
        +delta * logphi(t+1) ...
        +delta * s(t)*integral;

end

% Show search effort and reservation wage path
[s', logphi'];

% plot(1:24,s)
% plot(1:24,phi)

end 
