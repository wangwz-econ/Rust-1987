function [p_0, p_1, p_2] = fun_transition_prob(data)

state_data  = data(:, 1);
choice_data = data(:, 2);

state_data_lead = NaN(size(data, 1), 1);
state_data_lead(1:end-1) = state_data(2:end);

delta_state = state_data_lead - state_data;
delta_state(delta_state>2) = 2;

% delta_state(choice_data ~= 0) = NaN;

N = size(data, 1) - sum( isnan(delta_state), 'all');
n_0 = sum(delta_state==0, 'all');
n_1 = sum(delta_state==1, 'all');
n_2 = sum(delta_state==2, 'all');

p_0 = n_0 / N;
p_1 = n_1 / N;
p_2 = n_2 / N;


end