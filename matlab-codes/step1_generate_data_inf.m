

%% Parametrization
clear all
% Initialise parameter values
% Parameter values taken from group 4 estimates of table IX in Rust (1987)
% beta      = 0.9999;              % discount factor
% rc        = 9.7558;              % replacement cost
% theta1_1  = 2.6275;              % linear cost function
% p_x0      = 0.3489;              % prob of making [0-5000) miles
% p_x1      = 0.6394;              % prob of making [5000-10000) miles
% p_x2      = 1- p_x0 - p_x1;      % prob of making [10000-15000) miles 

tol = 1e-3;                        % Tolerance

pars = [10.03904057; 2.61808055; 0.344593776486257; 0.624530814868628];
rc = pars(1);                 % replacement cost
theta1_1 = pars(2);           % maintenance cost parameter in a linear cost function  
p_x0 = pars(3);               % transition probabilities
p_x1 = pars(4);               % transition probabilities
p_x2 = 1 - p_x1 - p_x0;       % transition probabilities

beta = 0.9999;                % discount factor

% Set up discretised state space of x, 90 possible states
x_grid = (1:1:90)'; % 90 by 1
K = length(x_grid); % cardinality of state variable space

% Vector of costs in each period, for each choice
u_1 = fun_utility(1, x_grid, pars); % u(a,x) when a=1 (90 by 1)
u_0 = fun_utility(0, x_grid, pars); % u(a,x) when a=0 (90 by 1)

% Create transition matrix Fx_0 (90 by 90)
% (i,j) entry means the probability of state variable becoming j 
% when the state variable is i in period t and a_t=0
Fx_0 = zeros(K, K);
for i = 1:K
    Fx_0(i, i) = p_x0;
    if i <= K - 1
        Fx_0(i, i+1) = p_x1;
    end
    if i <= K - 2
        Fx_0(i, i+2) = p_x2;
    end
end
Fx_0(K-1, K) = 1 - p_x0;
Fx_0(K, K)   = 1;

% Create matrix Fx_1 (90 by 90)
% (i,j) entry means the probability of state variable becoming j 
% when the state variable is i in period t and a_t=1
% Note that i does not affect the values in j in this replacement problem
Fx_1 = zeros(K, K);
Fx_1(:, 1) = p_x0;
Fx_1(:, 2) = p_x1;
Fx_1(:, 3) = p_x2;

%% Obtain Conditional Choice Probabilities

% Iteration
Vbar = fun_inner_algo(Fx_1, Fx_0, u_0, u_1, beta, tol);

% Write the v(a,x)s
v_0 = u_0 + (beta .* (Fx_0 * Vbar));
v_1 = u_1 + (beta .* (Fx_1 * Vbar));

max_Vbar = max(Vbar);

ccp_1 = exp(v_1 - max_Vbar) ./ (exp(v_0 - max_Vbar) + exp(v_1 - max_Vbar));
ccp_0 = exp(v_0 - max_Vbar) ./ (exp(v_0 - max_Vbar) + exp(v_1 - max_Vbar));

