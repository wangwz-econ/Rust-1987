%% Step 1.1: Estimate Transition Probabilities

[p0_g1to3, p1_g1to3, p2_g1to3] = fun_transition_prob(group_1, group_2, group_3);
[p0_g4, p1_g4, p2_g4] = fun_transition_prob(group_4);
[p0_g1to4, p1_g1to4, p2_g1to4] = fun_transition_prob(group_1, group_2, group_3, group_4);


%% Step 1.2: Estimate by minimizing the negative log-likelihood

startval = [9.75, 2.6];
lb = [0,0];
ub = [10000,10];

pars = struct("rc", {}, "theta", {}, "p0", {}, "p1", {}, "K", {});
    
pars(1).rc = 10;
pars(1).theta = 3.6;
pars(1).p0 = p0_g1to4;
pars(1).p1 = p1_g1to4;
pars(1).K = 90;


formin_g1to4 = @ (y) fun_formin(data_1to4, y(1), y(2), p0_g1to4, p1_g1to4, 90, 1e-3, 1e+6, 0.999);

% opt = optimset('TolFun',1e-20,'TolX',1e-20,'MaxFunEvals',1000,'Display','iter');

[x] = fmincon(formin_g1to4, startval, [], [], [], [], lb, ub, []);


% collect the varying parameters and estimated parameters into a structure
% and then get -1 * loglikelihood

function [negloglike] = fun_formin(data, rc, theta, p0, p1, K, tol, max_it, beta)

    pars = struct("rc", {}, "theta", {}, "p0", {}, "p1", {}, "K", {});
    
    pars(1).rc = rc;
    pars(1).theta = theta;
    pars(1).p0 = p0;
    pars(1).p1 = p1;
    pars(1).K = K;
    
    negloglike = fun_loglike(data, pars, tol, max_it, beta);
    
end
