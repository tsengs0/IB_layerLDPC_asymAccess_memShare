Ws=5;

for O_prev = 0:1:(Ws-1)
  for O_m = 0:1:(Ws-1)
    for Sm = 0:1:(Ws-1)
      if(O_prev <= floor(Ws/2))
        leq = 1;
      else
        leq = 0;
      endif
      
      temp = Ws - O_prev;
      temp = temp * (-1);
      
      if(leq == 1)
        O_dut = temp;
      else
        O_dut = O_prev;
      endif 
      
      temp = O_dut + O_prev;
      
      if(temp < 0)
        O_new = temp + Ws;
      else
        O_new = temp;
      endif
      
      %% Scoreboard
      norm = mod(O_prev + Sm, Ws);
      if(O_new ~= norm)
        fprintf("Norm: %d, O_new: %d\r\n", norm, O_new);
      endif 
       
    endfor
  endfor
endfor