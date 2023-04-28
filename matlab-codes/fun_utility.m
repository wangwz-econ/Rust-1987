function utility = fun_utility(a, x, pars)
  rc = pars(1);           % Replacement cost
  theta1_1 = pars(2);     % Maintenance cost paramater with a linear cost function
  
  if a == 0
      utility = - (0.001 * theta1_1) .* x;
  elseif a == 1
      utility = - rc + 0 .* x;
  else
      error('a should be 0 or 1')
  end

end