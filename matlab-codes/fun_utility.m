function utility = fun_utility(a, x, rc, theta)
    
  if a == 0
      utility = - (0.001 * theta) .* x;
  elseif a == 1
      utility = - rc + 0 .* x;
  else
      error('a should be 0 or 1')
  end

end