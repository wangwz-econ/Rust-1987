%% Test for transition probabilities calculation
data = data_4;
state_data  = data(:, 1);
choice_data = data(:, 2);

Nobs = size(data, 1);

state_data_lead = NaN(Nobs, 1);
state_data_lead(1:(Nobs-1)) = state_data(2:Nobs);

delta_state = state_data_lead - state_data;
delta_state(delta_state>2) = 2;
delta_state(delta_state<0) = NaN;

% bad transition probabilities calculation!
function [p_0, p_1, p_2] = fun_transition_prob(data)

state_data  = data(:, 1);
choice_data = data(:, 2);

Nobs = size(data, 1);

state_data_lead = NaN(Nobs, 1);
state_data_lead(1:(Nobs-1)) = state_data(2:Nobs);

delta_state = state_data_lead - state_data;
delta_state(delta_state>2) = 2;
delta_state(delta_state<0) = NaN;

% delta_state(choice_data ~= 0) = NaN;

N = size(data, 1) - sum( isnan(delta_state), 'all');
n_0 = sum(delta_state==0, 'all');
n_1 = sum(delta_state==1, 'all');
n_2 = sum(delta_state==2, 'all');

p_0 = n_0 / N;
p_1 = n_1 / N;
p_2 = n_2 / N;


end
%%
beta = 0.9999;
pars = [10.03904057, 2.61808055];
rc    = pars(1);
theta = pars(2);

p0 = p0_g1to4;
p1 = p1_g1to4;
p2 = 1 - p0 - p1;

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
    Fx_0(i, i) = p0;
    if i <= K - 1
        Fx_0(i, i+1) = p1;
    end
    if i <= K - 2
        Fx_0(i, i+2) = p2;
    end
end
Fx_0(K-1, K) = 1 - p0;
Fx_0(K, K)   = 1;

% Create matrix Fx_1 (90 by 90)
% (i,j) entry means the probability of state variable becoming j 
% when the state variable is i in period t and a_t=1
% Note that i does not affect the values in j in this replacement problem
Fx_1 = zeros(K, K);
Fx_1(:, 1) = p0;
Fx_1(:, 2) = p1;
Fx_1(:, 3) = p2;

%% Step 2: Obtain Conditional Choice Probabilities

tol = 1e-3;

% Iteration
Vbar = fun_inner_algo(Fx_1, Fx_0, u_0, u_1, beta, tol);

% Write the v(a,x)s
v_0 = u_0 + (beta .* (Fx_0 * Vbar));
v_1 = u_1 + (beta .* (Fx_1 * Vbar));

max_Vbar = max(Vbar);

ccp_1 = exp(v_1 - max_Vbar) ./ ( exp(v_0 - max_Vbar) + exp(v_1 - max_Vbar) );
ccp_0 = exp(v_0 - max_Vbar) ./ ( exp(v_0 - max_Vbar) + exp(v_1 - max_Vbar) );

%% Step 3: Form Log-Likelihood

state  = data(:, 1);
choice = data(:, 2);
N = size(state, 1);

state_lead = NaN(N, 1);
state_lead(1:N-1) = state(2:N);
delta_state = state_lead - state;
delta_state(delta_state>2) = 2;

logchoiceprob = sum(log(ccp_1( state(choice==1) )), 'all') + ...
                sum(log(ccp_0( state(choice==0) )), 'all');
% 
% transindex_0 = [sub2ind([K K], state(delta_state==0 & choice==0)', state(delta_state==0 & choice==0)'), ...
%                sub2ind([K K], state(delta_state==1 & choice==0)', state(delta_state==1 & choice==0)'+1), ...
%                sub2ind([K K], state(delta_state==2 & choice==0)', state(delta_state==2 & choice==0)'+2)];
% transindex_1 = [sub2ind([K K], state(delta_state==0 & choice==1)', state(delta_state==0 & choice==1)'), ...
%                sub2ind([K K], state(delta_state==1 & choice==1)', state(delta_state==1 & choice==1)'+1), ...
%                sub2ind([K K], state(delta_state==2 & choice==1)', state(delta_state==2 & choice==1)'+2)];
% logtransiprob = sum(log( Fx_0(transindex_0) ), 'all') + sum(log( Fx_1(transindex_1) ), 'all');
negloglike = - logchoiceprob ;
