function [Vbar_1] = fun_inner_algo(Fx_1, Fx_0, u_0, u_1, beta, it_tol)

% Fist set up the ex ante value function as the static case
Vbar_1 = log(exp(u_0) + exp(u_1)); 
max_itdiff = 1;
it_counter = 0;

while max_itdiff > it_tol
    Vbar_0 = Vbar_1;

    Vbar_1 = fun_iteration(Vbar_0, Fx_1, Fx_0, u_0, u_1, beta);

    it_diff = abs(Vbar_1 - Vbar_0);
    max_itdiff = max(it_diff);
    display(max_itdiff);
        
    it_counter = it_counter + 1;
    display(it_counter);
end


end