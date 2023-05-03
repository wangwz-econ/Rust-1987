%% Try to encapsulate the data preparation process into a class

classdef cls_Data

  properties
    fileloc
    Nrows
    Ncols
  end

  methods
    function data = cls_Data(fileloc, Nrows, Ncols)
      data.fileloc = fileloc;
      data.Nrows = Nrows;
      data.Ncols = Ncols;
    end

    function [matrix] = data_input(data)
      filename = data.fileloc;
      T = data.Nrows;
      N = data.Ncols;

      fid = fopen(filename, 'r');
      fname = fopen(fid);
      if fid == -1
        fprintf('File %s open not successful! \n', fname)
      else
        fprintf('File %s open successful! \n', fname)
        matrix = fscanf(fid, '%f', [T N]);
        closeresult = fclose(fid);
        if closeresult == 0
          fprintf('File %s close successful! \n', fname)
        end
      end
    end

    function [choice, state, bus_info] = data_preparation(data)
      % Inputs: object data
      % Intermediaries: group_data - (T+11) by N matrix with the first 11 rows 
      %            containing bus history, obtained from data_input method.
      % Return: cleaned group_data (non-discretized), choice, and bus information

      group_data = data_input(data);

      bus_number = group_data(1,:);
      month_purchased = group_data(2,:);
      year_purchased = group_data(3,:);
      replace_month_1 = group_data(4,:);
      replace_year_1 = group_data(5,:);
      replace_mile_1 = group_data(6,:);
      replace_month_2 = group_data(7,:);
      replace_year_2 = group_data(8,:);
      replace_mile_2 = group_data(9,:);
      begin_month = group_data(10,:);
      begin_year = group_data(11,:);
      bus_info = cat(1, bus_number, month_purchased, year_purchased, ...
        replace_month_1, replace_year_1, replace_mile_1, ...
        replace_month_2, replace_year_2, replace_mile_2, ...
        begin_month, begin_year);

      group_data(1:11, :) = [];
      T = size(group_data, 1);
      N = size(group_data, 2);
      choice = zeros(T, N);
      state  = group_data;

      for bus = 1:N
        if replace_month_1(bus) > 0
          replace_index_1 = find( group_data(:,bus) >  replace_mile_1(bus) );
          % find - given a vector, it returns the linear indices of which
          % values are greater than 0.
          mile_r1 = replace_index_1(1);
          % find the first index of which the mile usage > mile_replacement_1
          choice(mile_r1, bus) = 1;
          for t = (mile_r1+1):T
            state(t, bus) = group_data(t, bus) - group_data(mile_r1, bus);
          end
        end

        if replace_month_2(bus) > 0
          replace_index_2 = find( group_data(:,bus) >  replace_mile_2(bus) );
          mile_r2 = replace_index_2(1);
          choice(mile_r2, bus) = 1;
          for t = (mile_r2+1):T
            state(t, bus) = group_data(t, bus) - group_data(mile_r2, bus);
          end
        end
      end
    end

    function [final_data] = data_output(data)
      [choice, state] = data_preparation(data);
      reshape_state = reshape(state, [], 1);
      reshape_choice = reshape(choice, [], 1);
      final_data = [reshape_state, reshape_choice];
    end
  end

end
