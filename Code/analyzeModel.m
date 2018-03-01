function analyzeModel

close all

% Two UI regimes, corresponding roughly to the regime for
% unemployed < 42 years old and >= 42 years old in 
% Schmieder et al. (2016).
pre_wage = exp(4.15);
b_UI = pre_wage * 0.60; % UI benefits
b_UA = pre_wage * 0.30; % UA benefits
b1 = [ones(1,12).*b_UI ones(1,24).*b_UA];
b2 = [ones(1,18).*b_UI ones(1,18).*b_UA];

b1 = [ones(1,12).*190 ones(1,24).*90];
b2 = [ones(1,18).*190 ones(1,18).*90];

lastperiod=length(b1);

% Section 2.1
if 1
    % Model Parameters Section 2.1
    xi=[0.995, 150, 0.145, 4.1, 0.5, 12, 0];
    xi=[0.995, 150, 0.145, 5.995, 0.5, 12, 0];
    
    [s1,logphi1,haz1,logw1,surv1,D1,Ew1] = solveModel(xi,b1);
    [s2,logphi2,haz2,logw2,surv2,D2,Ew2] = solveModel(xi,b2);
    
    % Figures for Section 2.1
    plot(1:lastperiod, b1,'r',1:lastperiod, b2,'b')
    axis([0 lastperiod 0 (max([b1 b2])+50)]);
    legend('P=12','P=18'),...
        xlabel('Time','fontsize',14),...
        ylabel('','fontsize',14),...
        title('UI Benefit Paths','fontsize',18)
    
    print('-dpdf',fullfile('./figures_A/fig21_bpath.pdf'));

    plot(1:lastperiod, s1,'r',1:lastperiod, s2,'b')
    axis([0 lastperiod 0 (max([s1 s2])+0.02)]);    
    legend('P=12','P=18'),...
        xlabel('Time','fontsize',14),...
        ylabel('','fontsize',14),...
        title('Search Effort','fontsize',18)
    
    print('-dpdf',fullfile('./figures_A/fig21_s.pdf'));

    plot(1:lastperiod, logphi1,'r',1:lastperiod, logphi2,'b')
    axis([0 lastperiod ...
        (min([logphi1 logphi2])-0.1) (max([logphi1 logphi2])+0.1)]);
    legend('P=12','P=18'),...
        xlabel('Time','fontsize',14),...
        ylabel('','fontsize',14),...
        title('Log Reservation Wages','fontsize',18)
    
    print('-dpdf',fullfile('./figures_A/fig21_logphi.pdf'));

    plot(1:lastperiod, haz1,'r',1:lastperiod, haz2,'b')
    axis([0 lastperiod 0 (max([haz1 haz2])+0.02)]);  
    legend('P=12','P=18'),...
        xlabel('Time','fontsize',14),...
        ylabel('','fontsize',14),...
        title('Unemployment Exit Hazard','fontsize',18)
    
    print('-dpdf',fullfile('./figures_A/fig21_haz.pdf'));

    plot(1:lastperiod, logw1,'r',1:lastperiod, logw2,'b')
    axis([0 lastperiod ...
        (min([logw1 logw2])-0.1) (max([logw1 logw2])+0.1)]);
    legend('P=12','P=18'),...
        xlabel('Time','fontsize',14),...
        ylabel('','fontsize',14),...
        title('Log Reemployment Wages','fontsize',18)
    
    print('-dpdf',fullfile('./figures_A/fig21_logw_reemp.pdf'));
    
    % Calculate Elasticities and Marginal Effects
    D1
    dDdP = (D2-D1)/(18-12)
    dWdP = (Ew2-Ew1)/6
    dWdD = dWdP/dDdP
    
    eta_D_P = (log(D2)-log(D1))/(log(18)-log(12))
    eta_D_P = (D2-D1)/(18-12) * (18+12)/(D1+D2)

end

% Section 2.2
if 1 
    % Model Parameters Section 2.2
    xi=[0.995, 150, 0.145, 4.1, 0.5, 12, -0.008];  
    xi=[0.995, 150, 0.145, 5.995, 0.5, 12, -0.008]
    
    [s1,logphi1,haz1,logw1,surv1,D1,Ew1] = solveModel(xi,b1);
    [s2,logphi2,haz2,logw2,surv2,D2,Ew2] = solveModel(xi,b2);
    
    % Figures for Section 2.2
    plot(1:lastperiod, b1,'r',1:lastperiod, b2,'b')
    axis([0 lastperiod 0 (max([b1 b2])+50)]);
    legend('P=12','P=18'),...
        xlabel('Time','fontsize',14),...
        ylabel('','fontsize',14),...
        title('UI Benefit Paths','fontsize',18)
    
    print('-dpdf',fullfile('./figures_A/fig22_bpath.pdf'));

    plot(1:lastperiod, s1,'r',1:lastperiod, s2,'b')
    axis([0 lastperiod 0 (max([s1 s2])+0.02)]);    
    legend('P=12','P=18'),...
        xlabel('Time','fontsize',14),...
        ylabel('','fontsize',14),...
        title('Search Effort','fontsize',18)
    
    print('-dpdf',fullfile('./figures_A/fig22_s.pdf'));

    plot(1:lastperiod, logphi1,'r',1:lastperiod, logphi2,'b')
    axis([0 lastperiod ...
        (min([logphi1 logphi2])-0.1) (max([logphi1 logphi2])+0.1)]);
    legend('P=12','P=18'),...
        xlabel('Time','fontsize',14),...
        ylabel('','fontsize',14),...
        title('Log Reservation Wages','fontsize',18)
    
    print('-dpdf',fullfile('./figures_A/fig22_logphi.pdf'));

    plot(1:lastperiod, haz1,'r',1:lastperiod, haz2,'b')
    axis([0 lastperiod 0 (max([haz1 haz2])+0.02)]);  
    legend('P=12','P=18'),...
        xlabel('Time','fontsize',14),...
        ylabel('','fontsize',14),...
        title('Unemployment Exit Hazard','fontsize',18)
    
    print('-dpdf',fullfile('./figures_A/fig22_haz.pdf'));

    plot(1:lastperiod, logw1,'r',1:lastperiod, logw2,'b')
    axis([0 lastperiod ...
        (min([logw1 logw2])-0.1) (max([logw1 logw2])+0.1)]);
    legend('P=12','P=18'),...
        xlabel('Time','fontsize',14),...
        ylabel('','fontsize',14),...
        title('Log Reemployment Wages','fontsize',18)
    
    print('-dpdf',fullfile('./figures_A/fig22_logw_reemp.pdf'));

    % Calculate Elasticities and Marginal Effects
    dDdP = (D2-D1)/(18-12)
    dWdP = (Ew2-Ew1)/6
    dWdD = dWdP/dDdP
    
    eta_D_P = (log(D2)-log(D1))/(log(18)-log(12))
    eta_D_P = (D2-D1)/(18-12) * (18+12)/(D1+D2)
end


% Section 2.4
if 1 
    % Model Parameters Section 2.4
%     xi=[0.995, 150, 0.145, 4.1, 0, 96, -0.008];  
%     
%     b1 = [ones(1,12).*b_UI ones(1,84).*b_UA];
%     b2 = [ones(1,18).*b_UI ones(1,78).*b_UA];
%     lastperiod=length(b1);
    
    xi=[0.995, 360, 0.11, 4.1, 0, 96, -0.008];   
    
    b1 = [ones(1,12).*b_UI ones(1,84).*b_UA];
    b2 = [ones(1,18).*b_UI ones(1,78).*b_UA];
    lastperiod=length(b1);
    
    [s1,logphi1,haz1,logw1,surv1,D1,Ew1] = solveModel(xi,b1);
    [s2,logphi2,haz2,logw2,surv2,D2,Ew2] = solveModel(xi,b2);
    
    % Figures for Section 2.4
    plot(1:lastperiod, s1,'r',1:lastperiod, s2,'b')
    axis([0 lastperiod 0 (max([s1 s2])+0.02)]);    
    legend('P=12','P=18'),...
        xlabel('Time','fontsize',14),...
        ylabel('','fontsize',14),...
        title('Search Effort','fontsize',18)
    
    print('-dpdf',fullfile('./figures_A/fig24_s.pdf'));

    plot(1:lastperiod, logphi1,'r',1:lastperiod, logphi2,'b')
    axis([0 lastperiod ...
        (min([logphi1 logphi2])-0.1) (max([logphi1 logphi2])+0.1)]);
    legend('P=12','P=18'),...
        xlabel('Time','fontsize',14),...
        ylabel('','fontsize',14),...
        title('Log Reservation Wages','fontsize',18)
    
    print('-dpdf',fullfile('./figures_A/fig24_logphi.pdf'));

    plot(1:lastperiod, haz1,'r',1:lastperiod, haz2,'b')
    axis([0 lastperiod 0 (max([haz1 haz2])+0.02)]);  
    legend('P=12','P=18'),...
        xlabel('Time','fontsize',14),...
        ylabel('','fontsize',14),...
        title('Unemployment Exit Hazard','fontsize',18)
    
    print('-dpdf',fullfile('./figures_A/fig24_haz.pdf'));

    plot(1:lastperiod, logw1,'r',1:lastperiod, logw2,'b')
    axis([0 lastperiod ...
        (min([logw1 logw2])-0.1) (max([logw1 logw2])+0.1)]);
    legend('P=12','P=18'),...
        xlabel('Time','fontsize',14),...
        ylabel('','fontsize',14),...
        title('Log Reemployment Wages','fontsize',18)
    
    print('-dpdf',fullfile('./figures_A/fig24_logw_reemp.pdf'));

    % Calculate Elasticities and Marginal Effects
    D1
    dDdP = (D2-D1)/(18-12)
    dWdP = (Ew2-Ew1)/6
    
    dWdD = dWdP/dDdP
        
    eta_D_P = (log(D2)-log(D1))/(log(18)-log(12))
    eta_D_P = (D2-D1)/(18-12) * (18+12)/(D1+D2)
    
    
end

end

