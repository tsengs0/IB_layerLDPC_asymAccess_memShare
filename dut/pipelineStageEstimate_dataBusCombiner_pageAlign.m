function pipelineStageEstimate_dataBusCombiner_pageAlign(Z, Pc);
   row_chunk_num=ceil(Z/Pc);
   
   stride_width_vec=[1:1:row_chunk_num]
   y_base=zeros(1, size(stride_width_vec, 2))
   for i=1:1:size(stride_width_vec, 2)
      y_base(i)=51;
   end
   
   y=zeros(1, size(stride_width_vec, 2))
   for i=1:1:size(stride_width_vec, 2)
      y(i)=(stride_width_vec(i)-1)*(Z/(stride_width_vec(i)*Pc));
   end
   
   plot(stride_width_vec, y_base, '-*r', stride_width_vec, y, '-^b'); grid; xlabel('stride width (parallelism of P_{c}-wide BSs for one BaseMatrix column)'); ylabel('Estimation of pipelining latency [stage]'); legend('P_{c}-wide parallelism out of Z', 'P_{c}-wide x stride_width parallelm out of Z');

endfunction