%% Step 1.1: Estimate Transition Probabilities

[p0_g1to3, p1_g1to3, p2_g1to3] = fun_transition_prob(state_1, state_2, state_3);
[p0_g4, p1_g4, p2_g4] = fun_transition_prob(state_4);
[p0_g1to4, p1_g1to4, p2_g1to4] = fun_transition_prob(state_1, state_2, state_3, state_4);




%% Estimate by minimizing the negative log-likelihood

startval = [10, 3.6];
lb = [0,0];
ub = [10000,10];

% opt = optimset('TolFun',1e-20,'TolX',1e-20,'MaxFunEvals',1000,'Display','iter');
[x] = fmincon(@(pars) fun_loglike(data_1to4, pars, p0_g1to4, p1_g1to4, 1e-3), startval, [], ...
                           [], [], [], lb, ub, []);