function [matrix] = fun_data_input(filename, T, N)

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