`timescale 1ns/1ps
/**
* Latest date: 9th July, 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: memShare_rfmu
* 
* # I/F
* 1) Output: (not maintained yet)

* 2) Input: (not maintained yet)

* # Param (not maintained yet)

* # Description


* # Dependencies
*
* # Remark
		LUT: 2
        Logic LUT: 2 
        LUTRAM: 0
		FF: 3
        I/O: 23
        Freq: 400MHz
        WNS:  ns
        TNS:  ns
        WHS:  ns
        THS:  ns
        WPWS: ns
        TPWS: ns
**/
module resource_virtualiser_template #(
    parameter VIRTUAL_NUM = 2,
    parameter PORT_BITWIDTH = 5
) (
    output wire [PORT_BITWIDTH-1:0] virDout_port0_o,
    output wire [PORT_BITWIDTH-1:0] virDout_port1_o,
    input wire [PORT_BITWIDTH-1:0] virDin_port0_i,
    input wire [PORT_BITWIDTH-1:0] virDin_port1_i,
    input wire virDin_load_i,
    input wire virSched_en_i,

    output wire [PORT_BITWIDTH-1:0] phyDin_src_o,
    input wire [PORT_BITWIDTH-1:0] phyDout_fb_i,
    
    input wire rstn,
    input wire sys_clk
);

//-------------------------------------------------------
// Virtual Buffer
//-------------------------------------------------------
reg [PORT_BITWIDTH-1:0] virtual_buffer [0:VIRTUAL_NUM-1];
always @(posedge sys_clk) begin 
    if(!rstn) begin
        virtual_buffer[0] <= 0;
        virtual_buffer[1] <= 0;
    end
    else if(virDin_load_i == 1'b1) begin
        virtual_buffer[0] <= virDin_port0_i;
        virtual_buffer[1] <= virDin_port1_i;
    end
    else begin
        virtual_buffer[0] <= virtual_buffer[0];
        virtual_buffer[1] <= virtual_buffer[1];
    end
end
//-------------------------------------------------------
// Virtualisation scheduling
//-------------------------------------------------------
reg [VIRTUAL_NUM-1:0] sched_cnt;
generate
if(VIRTUAL_NUM == 2) begin
    always @(posedge sys_clk) begin 
        if(virSched_en_i == 1'b0)
            sched_cnt <= 1; 
        else if(virSched_en_i == 1'b1)
            sched_cnt[VIRTUAL_NUM-1:0] <= {sched_cnt[VIRTUAL_NUM-2], 1'b0};
        else
            sched_cnt[VIRTUAL_NUM-1:0] <= sched_cnt[VIRTUAL_NUM-1:0];
    end
end
else begin // VIRTUAL_NUM > 2
    always @(posedge sys_clk) begin 
        if(virSched_en_i == 1'b0)
            sched_cnt <= 1; 
        else if(virSched_en_i == 1'b1)
            sched_cnt[VIRTUAL_NUM-1:0] <= {sched_cnt[VIRTUAL_NUM-2:0], 1'b0};
        else
            sched_cnt[VIRTUAL_NUM-1:0] <= sched_cnt[VIRTUAL_NUM-1:0];
    end
end
endgenerate
// Fixed-priority scheduling policy
reg [PORT_BITWIDTH-1:0] phyDin_src_temp;
always @(posedge sys_clk) begin
    if(!rstn)
        phyDin_src_temp <= 0;
    else if(virSched_en_i[])
end
endmodule