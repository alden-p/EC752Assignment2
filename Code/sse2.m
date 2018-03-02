function SSE = sse2(xi)
%xi: The values of parameters

% ===== Fixed Parameters =====
pre_wage = exp(4.15);
b_UI = pre_wage * 0.60; % UI benefits
b_UA = pre_wage * 0.30; % UA benefits
b1 = [ones(1,12).*b_UI ones(1,24).*b_UA];
b2 = [ones(1,18).*b_UI ones(1,18).*b_UA];


% ===== Moments to Match from Schmieder et al. =====
D12_true=14.225;
D18_true=15.175;
B12_true=6.685;
B18_true=8.455;
LogPostWage12_true=4.0139;
LogPostWage18_true=4.0061;
dDdP_true = 0.16;
dWdP_true = -0.0013;

% Moments_true = [D12_true, D18_true, B12_true, B18_true, ...
%     LogPostWage12_true, LogPostWage18_true, dDdP_true, dWdP_true]';
 Moments_true = [D12_true, dDdP_true, LogPostWage12_true]';


[s1,logphi1,haz1,logw1,surv1,D12] = solveModel(xi,b1);
[s2,logphi2,haz2,logw2,surv2,D18] = solveModel(xi,b2);

% density (surv * haz):
dens1 = haz1.*surv1;
dens2 = haz2.*surv2;

% Expected Reemployment Wage
LogPostWage12 = sum(dens1.*logw1)/sum(dens1);
LogPostWage18 = sum(dens2.*logw2)/sum(dens2);

% Compute extra Moments
dDdP = (D18-D12)/(18-12);
dWdP = (LogPostWage18 - LogPostWage12)/(18-12);

B12=sum(surv1(1:12));
B18=sum(surv2(1:18));

% Moments_hat = [D12, D18, B12, B18, ...
%     LogPostWage12, LogPostWage18, dDdP, dWdP]';
Moments_hat = [D12, dDdP, LogPostWage12]';
SSE = (Moments_hat - Moments_true)'*(Moments_hat - Moments_true);


end