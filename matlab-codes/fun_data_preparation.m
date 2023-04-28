function [choice, state] = fun_data_preparation(group_data)


replace_month_1 = group_data(4,:);
replace_year_1 = group_data(5,:);
replace_mile_1 = group_data(6,:);
replace_month_2 = group_data(7,:);
replace_year_2 = group_data(8,:);
replace_mile_2 = group_data(9,:);
begin_month = group_data(10,:);
begin_year = group_data(11,:);

group_data(1:11, :) = [];

T = size(group_data, 1);
N = size(group_data, 2);
choice = zeros(T, N);
state  = group_data;

for bus = 1:N

    if replace_month_1(bus) > 0
        replace_index_1 = find( group_data(:,bus) >  replace_mile_1(bus) );
        mile_r1 = replace_index_1(1);
        choice(mile_r1, bus) = 1;
    
        for j = mile_r1:T
            state(j, bus) = group_data(j, bus) - replace_mile_1(bus);
        end
    
        if replace_month_2(bus) > 0
            replace_index_2 = find( group_data(:,bus) >  replace_mile_2(bus) );
            mile_r2 = replace_index_2(1);
            choice(mile_r2, bus) = 1;
    
            for j = mile_r2:T
                state(j, bus) = group_data(j, bus) - replace_mile_2(bus);
            end

        end

    end

end

state = floor(state ./ 5000) + 1;

end