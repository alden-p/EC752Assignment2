%Author: Alden Porter
% This program runs the main functionality for problem 2

clear 
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1.1
[dDdP, SSE] = calibrateModel1();

fig1 = figure;

subplot(1, 2, 1)
plot(1:length(dDdP), dDdP)
title('Estimated dDdP')
ylabel('dDdP')
xlabel('Gamma')

subplot(1, 2, 2)
plot(1:length(SSE), SSE)
title('SSE')
ylabel('SSE')
xlabel('Gamma')

saveas(fig1, '../Output/Fig1.fig')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1.2

[dDdP, SSE] = calibrateModel2();

fig2 = figure;

subplot(1, 2, 1)
plot(1:length(dDdP), dDdP)
title('Estimated dDdP')
ylabel('dDdP')
xlabel('Gamma')

subplot(1, 2, 2)
plot(1:length(SSE), SSE)
title('SSE')
ylabel('SSE')
xlabel('Gamma')

saveas(fig2, '../Output/Fig2.fig')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1.3

[dDdP, SSE, SSEstar, kstar, gammastar, D12, gridk, gridgamma] = calibrateModel3();


[GRIDK, GRIDGAMMA] = meshgrid(gridk, gridgamma);

fig3 = figure;
surf(GRIDK', GRIDGAMMA', dDdP)
colormap('jet')
title('dDdP')
xlabel('K')
ylabel('Gamma')
zlabel('dDdP')
saveas(fig3, '../Output/Fig3.fig')

fig4 = figure;
surf(GRIDK', GRIDGAMMA', D12)
colormap('jet')
title('D12')
xlabel('K')
ylabel('Gamma')
zlabel('D12')
saveas(fig4, '../Output/Fig4.fig')

fig5 = figure;
surf(GRIDK', GRIDGAMMA', SSE)
colormap('jet')
title('SSE')
xlabel('K')
ylabel('Gamma')
zlabel('SSE')
saveas(fig5, '../Output/Fig5.fig')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2.1



xi=[0.995, 150, 0.145, 4.1, 0.5, 12, 0];

sse(xi)

sse_obj1 = @(theta) sse1([xi(1), theta(1), theta(2), xi(4), xi(5), xi(6), xi(7)]);

options = optimoptions('fmincon','UseParallel',true);

theta1_0 = [150, .145];
A = [];
b = [];
Aeq = [];
beq = [];
lb = [50 .01];
ub = [600 2];
nonlcon = [];
[theta1, fval]=fmincon(sse_obj1,theta1_0,A,b,Aeq,beq,lb,ub,nonlcon,options);
k1 = theta1(1)
gamma1 = theta1(2)


pre_wage = exp(4.15);
b_UI = pre_wage * 0.60; % UI benefits
b_UA = pre_wage * 0.30; % UA benefits
b1 = [ones(1,12).*b_UI ones(1,24).*b_UA];
b2 = [ones(1,18).*b_UI ones(1,18).*b_UA];
xn = [xi(1), theta1(1), theta1(2), xi(4), xi(5), xi(6), xi(7)];
[s1_n,logphi1_n,haz1_n,logw_reemp1_n,surv1_n,D12,E_logw_reemp1_n]=solveModel(xn,b1);
[s2_n,logphi2_n,haz2_n,logw_reemp2_n,surv2_n,D18,E_logw_reemp2_n]=solveModel(xn,b2);


% density (surv * haz):
dens1 = haz1_n.*surv1_n;
dens2 = haz2_n.*surv2_n;

% Expected Reemployment Wage
LogPostWage12 = sum(dens1.*logw_reemp1_n)/sum(dens1);
LogPostWage18 = sum(dens2.*logw_reemp1_n)/sum(dens2);

% Compute extra Moments
dDdP = (D18-D12)/(18-12);
dWdP = (LogPostWage18 - LogPostWage12)/(18-12);

B12=sum(surv1_n(1:12));
B18=sum(surv2_n(1:18));


fig6 = figure;
subplot(2, 1, 1)
plot(haz1_n)
hold on
plot(haz2_n)
title('Exit Hazard Path (No Skill Depreciation) using gamma* and k*')
xlabel('Months (t)')
legend('Regime 1','Regime 2')
hold off


subplot(2, 1, 2)
plot(logw_reemp1_n)
hold on
plot(logw_reemp2_n)
title('Log Reemployment Wage (No Skill Depreciation) using gamma* and k*')
xlabel('Months (t)')
legend('Regime 1','Regime 2')
hold off
saveas(fig6, '../Output/Fig6.fig')






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2.2


xi=[0.995, 150, 0.145, 4.1, 0.5, 12, 0];

sse(xi)

sse_obj2 = @(theta) sse2([xi(1), theta(1), theta(2), theta(3), xi(5), xi(6), xi(7)]);

options = optimoptions('fmincon','UseParallel',true);

theta2_0 = [150, .145, 4.1];
A = [];
b = [];
Aeq = [];
beq = [];
lb = [50 .01 1];
ub = [600 2 15];
nonlcon = [];
[theta2, fval]=fmincon(sse_obj2,theta2_0,A,b,Aeq,beq,lb,ub,nonlcon,options);

k2 = theta2(1)
gamma2 = theta2(2)
mu2 = theta2(3)




pre_wage = exp(4.15);
b_UI = pre_wage * 0.60; % UI benefits
b_UA = pre_wage * 0.30; % UA benefits
b1 = [ones(1,12).*b_UI ones(1,24).*b_UA];
b2 = [ones(1,18).*b_UI ones(1,18).*b_UA];
xn = [xi(1), theta2(1), theta2(2), theta2(3), xi(5), xi(6), xi(7)];
[s1_n,logphi1_n,haz1_n,logw_reemp1_n,surv1_n,D12,E_logw_reemp1_n]=solveModel(xn,b1);
[s2_n,logphi2_n,haz2_n,logw_reemp2_n,surv2_n,D18,E_logw_reemp2_n]=solveModel(xn,b2);


% density (surv * haz):
dens1 = haz1_n.*surv1_n;
dens2 = haz2_n.*surv2_n;

% Expected Reemployment Wage
LogPostWage12 = sum(dens1.*logw_reemp1_n)/sum(dens1);
LogPostWage18 = sum(dens2.*logw_reemp1_n)/sum(dens2);

% Compute extra Moments
dDdP = (D18-D12)/(18-12);
dWdP = (LogPostWage18 - LogPostWage12)/(18-12);

B12=sum(surv1_n(1:12));
B18=sum(surv2_n(1:18));



fig7 = figure;
subplot(2, 1 , 1)
plot(haz1_n)
hold on
plot(haz2_n)
title('Exit Hazard Path (No Skill Depreciation) using gamma* and k* and mu*')
xlabel('Months (t)')
legend('Regime 1','Regime 2')
hold off


subplot(2, 1, 2)
plot(logw_reemp1_n)
hold on
plot(logw_reemp2_n)
title('Log Reemployment Wage (No Skill Depreciation) using gamma* and k* and mu*')
xlabel('Months (t)')
legend('Regime 1','Regime 2')
hold off
saveas(fig7, '../Output/Fig7.fig')




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2.3
%See estimateModel_multinits

xi=[0.995, 150, 0.145, 4.1, 0.5, 12, 0];

sse(xi)

sse_obj3 = @(theta) sse3([xi(1), theta(1), theta(2), theta(3), theta(4), xi(6), xi(7)]);

options = optimoptions('fmincon','UseParallel',true);

theta3_0 = [150, .145, 4.1, .5];
A = [];
b = [];
Aeq = [];
beq = [];
lb = [50, .01, 1, .1];
ub = [600, 2, 15, 3];
nonlcon = [];
[theta3, fval]=fmincon(sse_obj3,theta3_0,A,b,Aeq,beq,lb,ub,nonlcon,options);

k3 = theta3(1)
gamma3 = theta3(2)
mu3 = theta3(3)
sigma3 = theta3(4)







pre_wage = exp(4.15);
b_UI = pre_wage * 0.60; % UI benefits
b_UA = pre_wage * 0.30; % UA benefits
b1 = [ones(1,12).*b_UI ones(1,24).*b_UA];
b2 = [ones(1,18).*b_UI ones(1,18).*b_UA];
xn = [xi(1), theta3(1), theta3(2), theta3(3), theta3(4), xi(6), xi(7)];
[s1_n,logphi1_n,haz1_n,logw_reemp1_n,surv1_n,D12,E_logw_reemp1_n]=solveModel(xn,b1);
[s2_n,logphi2_n,haz2_n,logw_reemp2_n,surv2_n,D18,E_logw_reemp2_n]=solveModel(xn,b2);


% density (surv * haz):
dens1 = haz1_n.*surv1_n;
dens2 = haz2_n.*surv2_n;

% Expected Reemployment Wage
LogPostWage12 = sum(dens1.*logw_reemp1_n)/sum(dens1);
LogPostWage18 = sum(dens2.*logw_reemp1_n)/sum(dens2);

% Compute extra Moments
dDdP = (D18-D12)/(18-12);
dWdP = (LogPostWage18 - LogPostWage12)/(18-12);

B12=sum(surv1_n(1:12));
B18=sum(surv2_n(1:18));

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

fig8 = figure;
subplot(2, 2, 1)
plot(haz1_n)
hold on
plot(haz2_n)
title('Exit Hazard Path (No Skill Depreciation) using gamma*, k*, mu* and sigma*')
xlabel('Months (t)')
legend('Regime 1','Regime 2')
hold off


subplot(2, 2, 2)
plot(logw_reemp1_n)
hold on
plot(logw_reemp2_n)
title('Log Reemployment Wage (No Skill Depreciation) using gamma*, k*, mu* and sigma*')
xlabel('Months (t)')
legend('Regime 1','Regime 2')
hold off


subplot(2, 2, 3)
plot(Hazard12_true)
hold on
plot(Hazard18_true)
title('Real Exit Hazard')
xlabel('Months (t)')
legend('Regime 1','Regime 2')
hold off


subplot(2, 2, 4)
plot(ReWage12_true)
hold on
plot(ReWage18_true)
title('Real Remployment Wage')
xlabel('Months (t)')
legend('Regime 1','Regime 2')
hold off
saveas(fig8, '../Output/Fig8.fig')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2.4


xi=[0.995, 150, 0.145, 4.1, 0.5, 12, 0];

sse(xi)

sse_obj4 = @(theta) sse3([xi(1), theta(1), theta(2), theta(3), theta(4), theta(5), theta(6)]);

options = optimoptions('fmincon','UseParallel',true);

theta4_0 = [150, .145, 4.1, .5, 12, 0];
A = [];
b = [];
Aeq = [];
beq = [];
lb = [50, .01, 1, .1, 1, -3];
ub = [600, 2, 15, 3, 30, 0];
nonlcon = [];
[theta4, fval]=fmincon(sse_obj4,theta4_0,A,b,Aeq,beq,lb,ub,nonlcon,options);

k4 = theta4(1)
gamma4 = theta4(2)
mu4 = theta4(3)
sigma4 = theta4(4)
kappa4 = theta4(5)
pi4 = theta4(6)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2.5

%See estimateModel_multilnits