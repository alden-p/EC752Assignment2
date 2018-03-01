function [dDdP, SSE, SSEstar, kstar, gammastar, D12, gridk, gridgamma] = calibrateModel3
clc;
clear;
close all;

% ===== Fixed Parameters =====
pre_wage = exp(4.15);
b_UI = pre_wage * 0.60; % UI benefits
b_UA = pre_wage * 0.30; % UA benefits
b1 = [ones(1,12).*b_UI ones(1,24).*b_UA];
b2 = [ones(1,18).*b_UI ones(1,18).*b_UA];

xi=[0.995, 150, 0.145, 4.1, 0.5, 12, 0];

% ===== Moments to Match from Schmieder et al. =====
D12_true=14.225;
D18_true=15.175;
B12_true=6.685;
B18_true=8.455;
LogPostWage12_true=4.0139;
LogPostWage18_true=4.0061;
dDdP_true = 0.16;
dWdP_true = -0.0013;



% ===== Part 1.3 =====
   
    % ===== Grid Search over K =====
    gridk = 50:25:600;
    gridgamma = 0.1:0.05:1;
    
    D12 = zeros(length(gridk), length(gridgamma));
    D18 = zeros(length(gridk), length(gridgamma));
    SSE = zeros(length(gridk), length(gridgamma));
    
    for i = 1:length(gridk)
        for j = 1:length(gridgamma)
        
        xi(2) = gridk(i);
        xi(3) = gridgamma(j);
        
        [s1,logphi1,haz1,logw1,surv1,D12(i, j)] = solveModel(xi,b1);
        [s2,logphi2,haz2,logw2,surv2,D18(i, j)] = solveModel(xi,b2);
        
        % Use the estimated moments to calculate the implied dD/dP:
        dDdP(i, j) = (D18(i, j)-D12(i, j))/6;
				
				% Calculate the squared deviation from the true moment
        SSE(i,j)= (dDdP(i, j) - dDdP_true)^2 + (D12(i,j) - D12_true)^2;
        
        end
    end
    
    [minssevec, minj] = min(SSE);
    
    [SSEstar, mini] = min(minssevec);
    
    kstar = gridk(mini);
    
    gammastar = gridgamma(minj(mini));


end
