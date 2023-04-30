%% Data Input and Preparation

clear all

% Input data and reshape the column vector to a matrix
% See Part 4 in file https://editorialexpress.com/jrust/nfxp.pdf for data
% description and details
[group_1_raw] = fun_data_input("..\data\g870.asc", 36, 15);
[group_2_raw] = fun_data_input("..\data\rt50.asc", 60, 4);
[group_3_raw] = fun_data_input("..\data\t8h203.asc", 81, 48);
[group_4_raw] = fun_data_input("..\data\a530875.asc", 128, 37);
% [group_5] = fun_data_input("a530874.asc", 137, 12);
% [group_6] = fun_data_input("a452374.asc", 137, 10);
% [group_7] = fun_data_input("a530872.asc", 137, 18);
% [group_8] = fun_data_input("a452372.asc", 137, 18);

% Extract bus replacement information 
% The first 11 rows represent bus history, see part 1 in 
% https://notes.quantecon.org/submission/6234fe0f96e1ce001b61fad8
[choice_1, group_1, bus_info_1] = fun_data_preparation(group_1_raw);
[choice_2, group_2, bus_info_2] = fun_data_preparation(group_2_raw);
[choice_3, group_3, bus_info_3] = fun_data_preparation(group_3_raw);
[choice_4, group_4, bus_info_4] = fun_data_preparation(group_4_raw);

% For comparison with python data cleaning codes
% writematrix(group_1, "group_1.csv")
% writematrix(group_2, "group_2.csv")
% writematrix(group_3, "group_3.csv")
% writematrix(group_4, "group_4.csv")

group_1 = floor(group_1 / 5000);
group_2 = floor(group_2 / 5000);
group_3 = floor(group_3 / 5000);
group_4 = floor(group_4 / 5000);


% Reshape dataset: which bus is it does not matter!
% data_j, TN by 2 matrix, contains group j's state variable (column 1) 
% and choice variable (column 2)
data_1 = fun_data_reshape(choice_1, group_1);
data_2 = fun_data_reshape(choice_2, group_2);
data_3 = fun_data_reshape(choice_3, group_3);
data_4 = fun_data_reshape(choice_4, group_4);
data_1to3 = [data_1; data_2; data_3];
data_1to4 = [data_1to3; data_4];









