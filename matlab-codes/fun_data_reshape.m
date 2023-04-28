function [data] = fun_data_reshape(choice, state)
    reshape_state = reshape(state, [], 1);
    reshape_choice = reshape(choice, [], 1);
    data = [reshape_state, reshape_choice];
end