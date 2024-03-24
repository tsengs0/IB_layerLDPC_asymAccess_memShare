function [O_new, S_pre] = shiftOffset_gen_sol2(Ws, O_prev, Sm)
for O_prev = 0:1:(Ws-1)
  temp = O_prev + Sm;
  if(temp < Ws)
    O_new = temp;
  else
    O_new = temp - Ws;
  endif

  S_pre_temp = Ws - O_new;
  if(S_pre_temp > 0)
    S_pre = S_pre_temp;
  else
    S_pre = 0;
  end
end
