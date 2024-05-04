module sysTick_record #(
    parameter SYSTICK_MAX_NUM = 500
) (
    input logic sys_clk,
    input logic rstn
);

localparam TICK_BITWIDTH = $clog2(SYSTICK_MAX_NUM);
logic [TICK_BITWIDTH-1:0] sys_tick;
always @(posedge sys_clk) if(!rstn) sys_tick <= 0; else sys_tick <= sys_tick+1;
endmodule
