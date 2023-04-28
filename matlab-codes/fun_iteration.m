function [Vbar_iplus1] = fun_iteration(Vbar_i, Fx_1, Fx_0, u_0, u_1, beta)

% Underlying equation:
% Given an initial estimate of Vbar_i, we first obtain the conditional value function:
% v\left(x_t, 1\right) = u(x_t, 1) + \beta * \left( \sum_{j =0,1,2} p_j * \overline{V}(j+1) \right),
% v\left(x_t, 0\right) = u(x_t, 0) + \beta * \left( \sum_{j =0,1,2} p_j * \overline{V}(x_t+j) \right).
% Then, we get the next period estimate of Vbar_iplus1 according to:
% \overline{V}(x_t)= \ln \left( e^{v\left(x_t, 1\right)} + e^{v\left(x_t, 0\right)}\right).

% Inputs: 
% Vbar_i, a 90 by 1 vector, ex ante value function in iteration i 
% Fx_1 and Fx_0, transition probabilities when a=1 and a=0
% u_0 and u_1, utilities when a=1 and a=0
% beta, discount factor

% Outputs:
% Vbar_iplus1, a 90 by 1 vector, ex ante value function in iteration i+1 

v_cond_0 = u_0 + (beta .* (Fx_0 * Vbar_i)); % ex ante value function v(a,x) when a=0
v_cond_1 = u_1 + (beta .* (Fx_1 * Vbar_i)); % ex ante value function v(a,x) when a=1

sum_v_cond = exp(v_cond_1 - Vbar_i) + exp(v_cond_0 - Vbar_i);

Vbar_iplus1 = log(sum_v_cond) + Vbar_i;


end