%% Data Input and Preparation

clear all

% Input data and reshape the column vector to a matrix
% See Part 4 in file https://editorialexpress.com/jrust/nfxp.pdf for data
% description and details
[group_1] = fun_data_input("..\data\g870.asc", 36, 15);
[group_2] = fun_data_input("..\data\rt50.asc", 60, 4);
[group_3] = fun_data_input("..\data\t8h203.asc", 81, 48);
[group_4] = fun_data_input("..\data\a530875.asc", 128, 37);
% [group_5] = fun_data_input("a530874.asc", 137, 12);
% [group_6] = fun_data_input("a452374.asc", 137, 10);
% [group_7] = fun_data_input("a530872.asc", 137, 18);
% [group_8] = fun_data_input("a452372.asc", 137, 18);

% Extract bus replacement information and discretize the state variable
% The first 11 rows represent bus history, see part 1 in 
% https://notes.quantecon.org/submission/6234fe0f96e1ce001b61fad8
[choice_1, state_1] = fun_data_preparation(group_1);
[choice_2, state_2] = fun_data_preparation(group_2);
[choice_3, state_3] = fun_data_preparation(group_3);
[choice_4, state_4] = fun_data_preparation(group_4);

% Reshape dataset: which bus is it does not matter!
% data_j, TN by 2 matrix, contains group j's state variable (column 1) 
% and choice variable (column 2)
data_1 = fun_data_reshape(choice_1, state_1);
data_2 = fun_data_reshape(choice_2, state_2);
data_3 = fun_data_reshape(choice_3, state_3);
data_4 = fun_data_reshape(choice_4, state_4);
data_1to3 = [data_1; data_2; data_3];
data_1to4 = [data_1to3; data_4];









