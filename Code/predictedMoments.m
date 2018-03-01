function [haz, logw_reemp] = predictedMoments(xi,b,s,logphi)

% xi=[0.981, 76.171, 0.145, 5.995, 0.5, 12, 0];
% 
% b = [ones(1,12).*190 ...
%     ones(1,12).*90];

delta = xi(1);
k = xi(2);
gamma = xi(3);
mu_S = xi(4); 
sigma = xi(5);
kappa = xi(6);
pi = xi(7);

lastperiod=length(b);
% [s,logphi] = optimalPath(xi,b);
% [s', logphi'];

% Calculate the means of the wage offer distriubtion
muv = mu(xi,1:lastperiod);

% Empty vectors to be filled next
haz = zeros(1,length(b));
logw_reemp = zeros(1,length(b));

for t=(lastperiod-1):-1:1
    % Calculate the hazard haz(t) as a function of logphi(t+1) and muv(t)
    % using equation 13 from the model:
    haz(t)=s(t).*(1-normcdf((logphi(t+1)-muv(t))/sigma));
    
    % Calculate the log_reemployment wage for individuals whose spells
    % end in t as a function of logphi(t+1) and muv(t) 
    logw_reemp(t)= muv(t) + sigma.*normpdf((logphi(t+1)-muv(t))/sigma)...
            ./(1-normcdf((logphi(t+1)-muv(t))/sigma));
    
end

% Since at the end we are in the steady state we can just fill in:
haz(lastperiod) = haz(lastperiod-1);
logw_reemp(lastperiod) = logw_reemp(lastperiod-1);

%  plot(1:24,logw_reemp);
%  plot(1:24,haz);

end

