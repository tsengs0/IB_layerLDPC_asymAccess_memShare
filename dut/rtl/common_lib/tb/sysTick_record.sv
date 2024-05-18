module sysTick_record #(
    parameter SYSTICK_MAX_NUM = 500
) (
    input logic tick_en_i,
    input logic sys_clk,
    input logic rstn
);

localparam TICK_BITWIDTH = $clog2(SYSTICK_MAX_NUM);
//logic [TICK_BITWIDTH-1:0] sys_tick;
int sys_tick;
always @(posedge sys_clk) begin
    if(!rstn) sys_tick <= 0;
    else if(tick_en_i) sys_tick <= sys_tick+1;
    else sys_tick <= 0;
end
endmodule
