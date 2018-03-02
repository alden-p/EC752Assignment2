function SSE = sse3(xi)
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


Hazard12_true = [0.105	0.135	0.115	0.11	0.08	0.072	...
    0.073	0.062	0.06	0.062	0.059	0.059	0.095	0.06	...
    0.058	0.06	0.05	0.051	0.051	0.047	0.046	0.047	...
    0.039	0.041	0.05	0.04	0.041	0.048	0.039	0.038	...
    0.042];

Hazard18_true = [0.1	0.1349	0.11	0.1	0.079	0.069	0.069 ...
    0.059	0.057	0.057	0.048	0.049	0.06	0.057	0.055 ...
    0.056	0.055	0.055	0.076	0.055	0.043	0.048	0.047 ...
    0.04	0.05	0.04	0.042	0.048	0.04	0.04	0.043];

ReWage12_true = [4.165	4.167	4.13	4.1	4.065	4.06	4.02    4 ...
    3.97	3.95	3.95	3.92	3.85	3.88	3.86	3.81	...
    3.81	3.9	3.83	3.78	3.81	3.71	3.79	3.73	3.81];

ReWage18_true = [4.17	4.163	4.13	4.08	4.053	4.054	4.01 ...
    4	3.98	3.96	3.97	3.93	3.93	3.885	3.895	3.82 ...
    3.85	3.9	3.74	3.83	3.79	3.76	3.77	3.75	3.8];

 Moments_true = [Hazard12_true, Hazard18_true, ReWage12_true, ReWage18_true]';


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
Moments_hat = [500*haz1(1:length(Hazard12_true)), 500*haz2(1:length(Hazard12_true)), logw1(1:length(ReWage18_true)), logw2(1:length(ReWage18_true))]';


SSE = (Moments_hat - Moments_true)'*(Moments_hat - Moments_true);


end