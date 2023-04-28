function [p0, p1, p2, varargout] = fun_transition_prob(varargin)

n = nargin;
n_it = n;
i = 1;

while n_it > 0

    state = varargin{i};
    obs = size(state, 1);
    state_lead = NaN(size(state));
    state_lead(1:(obs-1), :) = state(2:obs, :);
    
    delta_state = state_lead - state;
    delta_state(delta_state>2) = 2;
    delta_state(delta_state<0) = NaN;

    varargout{i} = reshape(delta_state, [], 1);

    n_it = n_it - 1;
    i = i + 1;

end

delta_state_all = [];
for j = 1:n
    delta_state_all = [delta_state_all; varargout{j}];
end

N = size(delta_state_all, 1) - sum( isnan(delta_state_all), 'all');
n_0 = sum(delta_state_all==0, 'all');
n_1 = sum(delta_state_all==1, 'all');
n_2 = sum(delta_state_all==2, 'all');

p0 = n_0 / N;
p1 = n_1 / N;
p2 = n_2 / N;

end