
function estimateModel_multiInits

clc;
clear;
close all;


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

Moments_true = [D12_true, D18_true, B12_true, B18_true, ...
    LogPostWage12_true, LogPostWage18_true, dDdP_true, dWdP_true]

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


% ==================================================
% ==================== Part 2.5 ====================
% ==================================================

% ===== Solve Model with Heterogeneity =====
    function [s1,logphi1,haz_agg,w_reemp_agg,survival,D] = solveModelAggr(xi_hetero,b)

        xi = xi_hetero(1:7);
        p = xi_hetero(8);
        k2 = xi_hetero(9);
        % Type 1
        [s1,logphi1,haz1,w_reemp1,surv1,D1] = solveModel(xi,b);
        
        % Type 2
        xi(2)=k2;
        [s2,logphi2,haz2,w_reemp2,surv2,D2] = solveModel(xi,b);
        
        %Aggregate Survival
        survival = p.*surv1 + (1-p).*surv2;
        
        %Calculate share of each type left at beginning in unemp
        weight1 = XXXXX % fill in the omega from the problem set
        weight2 = XXXXX 
        
        %Calculate aggregate hazard and average reemployment wage of leavers
        haz_agg = XXXXX;
        w_reemp_agg = XXXXXX;
        
        D = XXXX;
    end

% ===== ojbectiveFunction (SSE) =====
    function [SSE, Moments_hat] = objFun(paramsToOptimizeArg)
        
        paramv = parsInit;
        paramv([paramsToUse])=paramsToOptimizeArg;
        
        % Evaluate Model under the two UI regimes given xi
        [s1,logphi1,haz1,logw1,surv1,D12] = solveModelAggr(paramv,b1);
        [s2,logphi2,haz2,logw2,surv2,D18] = solveModelAggr(paramv,b2);
        
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
        
        Moments_hat = [D12, D18, B12, B18, ...
            LogPostWage12, LogPostWage18, dDdP, dWdP];
        
        % Compute squared deviations from moments to match
        SSE_wage = sum((ReWage12_true-logw1(1:25)).^2) ...
            + sum((ReWage18_true-logw2(1:25)).^2);
        SSE_haz = sum((Hazard12_true-haz1(1:31)).^2) ...
            + sum((Hazard18_true-haz2(1:31)).^2);
        
        SSE =  500 * SSE_haz + SSE_wage;
        
    end

    % Generate random initial starting values lying within the bounds defined by lb and ub
    function [searchInits] = getSearchInits_benchmark(noSearchInits)
        lb_short = lb_rep([paramsToUse]);
        ub_short = ub_rep([paramsToUse]);
        lb=repmat(lb_short',1,noSearchInits);
        ub=repmat(ub_short',1,noSearchInits);
        searchInits=lb+(ub-lb).*rand(noOfParams,noSearchInits);
    end


    % Lower and upper bound of parameter space (note that S cannot be < 0)
    % delta, k, gamma, mu, sigma, S, pi, p, k2
    lb_rep = [0.1, 0.1, 0.1, 0.1, 0, 0,  -1, 0, 0.1];
    ub_rep = [1,   1000, 10, 10, 1, 300,  1, 1, 1000];
    
    % Initial value for fmincon
    %     x0=[1 0.7148    4.120   0.5 12 0 .5 10];
    
    
    % Number of Initial values:
    noSearchInits = 20;
    
    % Here you can set which parameters the algorithm uses, 
    % e.g. paramsToUse = [2]
    % only estimates the cost of the first type
    paramsToUse = [2 3 4 5 6 7 8 9];
%     paramsToUse = [2 3 8 9];

		% This is the vector of benchmark parameters, if a parameter is not 
		% estimated, the corresponding value from this vector is taken.
    parsInit = [0.995, 2, 0.145, 4.1, 0.5, 12, 0, 0.5, 10];
    noOfParams = length(paramsToUse);
    searchInits = getSearchInits_benchmark(noSearchInits);
    
    paramHats=zeros(noOfParams,noSearchInits);
    sse= repmat(-9999,1,noSearchInits);
    converged=repmat(-9999,1,noSearchInits);
    exitFlag=repmat(-9999,1,noSearchInits); 
    
    % To use parallel computing, makes sure parallel pool is not running
    delete(gcp('nocreate'))
    parpool;
    for j = 1:noSearchInits
        tic
        j
        
        x0 = searchInits(:,j);
        lb_res = lb(:,j);
        ub_res = ub(:,j);
        
        % If you do not want to use parallel computing
        options = optimset('Display', 'iter','Algorithm','interior-point');
        
        % To use parallel computing with older versions of Matlab (e.g. 2013)
        options = optimset('Display', 'iter','Algorithm','interior-point','UseParallel','always');
        
        % To use parallel computing with older versions of Matlab (e.g. 2015)
        %  options = optimset('Display', 'iter','Algorithm','interior-point','UseParallel',true);

        try
       	 [paramHats(:,j), sse(j), exitFlag(j),outputf(j)] = ...
        	    fmincon(@objFun,x0,[],[],[],[],lb_res,ub_res,[],options)
        catch
       	 warning('Problem in fmincon');
         disp('Initial Values: ');
         disp(x0);
         exitFlag(j) = -1;
         
        end
        
        converged(j)=-9999;
        if (exitFlag(j) <= 0)
            converged(j)=0;
        end
        if (exitFlag(j) > 0)
            converged(j)=1;
        end
        
        toc
        elapsed_time_full(1,j) = toc/60;
    end
    
    searchInits=searchInits';
    paramHats=paramHats';
    
    %% display some information about the estimates
    noOfAcceptableSolutions=sum(converged); % converged estimates
    disp('Converged solutions:  '); disp(noOfAcceptableSolutions);
    convergedParamHats=repmat(-9999,noOfAcceptableSolutions,noOfParams);
    convergedInits=repmat(-9999,noOfAcceptableSolutions,noOfParams);
    convergedSse=repmat(-9999,noOfAcceptableSolutions,1);
    convergedflags=repmat(-9999,noOfAcceptableSolutions,1);
    elapsed_time=repmat(-9999,noOfAcceptableSolutions,1);
    sorter=repmat(-9999,noOfAcceptableSolutions,1);
    
    %We only care about the estimates that converged
    j=0;
    sorter_temp = [1:noSearchInits];
    for i=1:noSearchInits
        if converged(i)==1
            j=j+1;
            convergedParamHats(j,:)=paramHats(i,:);
            convergedInits(j,:)=searchInits(i,:);
            convergedSse(j)=sse(i);
            convergedflags(j) = exitFlag(i);
            %outputfmincon(j) = outputf(i);
            elapsed_time(j) = elapsed_time_full(i);
            sorter(j) = sorter_temp(i);
        end
    end
    sseParams=[convergedSse convergedParamHats convergedInits convergedflags elapsed_time sorter];
    sseParamsSorted=sortrows(sseParams);
    convergedSse=sseParamsSorted(:,1);
    convergedParamHats=sseParamsSorted(:,2:noOfParams+1);
    convergedInits=sseParamsSorted(:,noOfParams+2:noOfParams+1+noOfParams);
    convergedflags=sseParamsSorted(:,noOfParams+noOfParams+2:noOfParams+noOfParams+2);
    elapsed_time=sseParamsSorted(:,noOfParams+noOfParams+3:noOfParams+noOfParams+3);
    sorter=sseParamsSorted(:,noOfParams+noOfParams+4:noOfParams+noOfParams+4);
    outputfmincon = outputf(sorter);
    
    %Number of estimates within the desired SSE range
    %     noSmallSSE=sum(convergedSse<maxSSE);
    %Estimate with the smallest SSE
    
    bestEstimate=convergedParamHats(1,:)
    % SSE = convergedSse(1)
    
    xi_hetero_star = parsInit;
    xi_hetero_star([paramsToUse])=bestEstimate;
    xi_hetero_star


    


end
