function [s,logphi,haz,logw_reemp,surv,D,E_logw_reemp] = solveModel(xi,b)

% Calculate path of search effort and reservation wages
[s,logphi] = optimalPath(xi,b);

% Calculate hazard and reemployment wages
[haz, logw_reemp] = predictedMoments(xi,b,s,logphi);

% Calculate Survival Function
surv = ones(1,length(b));
for t = 2:length(b);
    surv(t)=surv(t-1)*(1-haz(t-1));
end

% Calculate hazard rate beyond steady state (up to period 96)
T = 96; % Event Horizon
Tminb = T - length(b);
haz_long = [haz ones(1,Tminb)*haz(length(b))];

% Calculate the reemployment wage beyond steady state
logw_reemp_long = [logw_reemp ones(1,Tminb)*logw_reemp(length(b))];

% Calculate Survival Function
surv_long = ones(1,T);
for t = 2:T;
    surv_long(t)=surv_long(t-1)*(1-haz_long(t-1));
end

% Calculate expected duration
D=sum(surv_long);

% density (surv * haz):
dens_long = haz_long.*surv_long;

% Expected Reemployment Wage
E_logw_reemp = sum(dens_long.*logw_reemp_long)/sum(dens_long);

end

