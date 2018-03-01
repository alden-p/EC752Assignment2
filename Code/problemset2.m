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

saveas(fig1, '../Output/Fig1.png')

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

saveas(fig2, '../Output/Fig1.png')

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
saveas(fig3, '../Output/Fig3.png')

fig4 = figure;
surf(GRIDK', GRIDGAMMA', D12)
colormap('jet')
title('D12')
xlabel('K')
ylabel('Gamma')
zlabel('D12')
saveas(fig4, '../Output/Fig4.png')

fig5 = figure;
surf(GRIDK', GRIDGAMMA', SSE)
colormap('jet')
title('SSE')
xlabel('K')
ylabel('Gamma')
zlabel('SSE')
saveas(fig5, '../Output/Fig5.png')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2.1



xi=[0.995, 150, 0.145, 4.1, 0.5, 12, 0];

sse(xi)

sse_obj = @(theta) sse([xi(1), theta(1), theta(2), xi(4), xi(5), xi(6), xi(7)]);

options = optimoptions('fmincon','UseParallel',true);

theta_0 = [150, 1.45];
A = [];
b = [];
Aeq = [];
beq = [];
lb = [.1 .1];
ub = [600 2];
nonlcon = [];
[theta, fval]=fmincon(sse_obj,theta_0,A,b,Aeq,beq,lb,ub,nonlcon,options);






