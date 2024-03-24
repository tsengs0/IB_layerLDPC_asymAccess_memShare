Ws = 5;

for O_prev = 0:1:(Ws-1)
  for O_m = 0:1:(Ws-1)
    for Sm = 0:1:(Ws-1)
      temp = O_prev + Sm;
      if(temp < Ws)
        O_new = temp;
      else
        O_new = temp - Ws;
      endif
      
      %% Scoreboard
      norm = mod(O_prev + Sm, Ws);
      if(O_new ~= norm)
        fprintf("ERROR\tNorm: %d, O_new: %d\r\n", norm, O_new);
      else
        fprintf("Correct\tNorm: %d, O_new: %d\r\n", norm, O_new);
      endif  
      
    endfor
  endfor
endfor