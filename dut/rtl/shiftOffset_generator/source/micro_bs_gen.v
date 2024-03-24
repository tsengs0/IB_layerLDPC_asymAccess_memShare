`timescale 1ns/1ps
/**
* Latest date: 19th July, 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: memShare_shiftOffset_gen
* # I/F
* 1) Output:
* 2) Input:
* 
* # Param

* # Description
    The module to generate the final shift factor of L2PA for V2C permutation
* # Dependencies
        memShare_config.vh

  # H/W utilisation on Xilinx 7-series FPGA
        1) SHIFT_OFFSET_CUMULATIVE_ADDR
            Ws=5
                Total LUT: 
                Logic LUT: 
                LUTRAM: 0
                FF: 
                I/O: ?

  # Not parameterised statement
        a) onehot2bin_offset
**/

module micro_bs_gen #(
    parameter SHARED_BANK_NUM = 5, //! Number of IB-LUTs joining a share group (GP2)
    parameter SHIFT_WIDTH = $clog2(SHARED_BANK_NUM)
) (
    output wire [SHIFT_WIDTH-1:0] shiftOffset_new_o, //! Equivalent to relative O^{shift}_{m}
    
    input wire [SHIFT_WIDTH-1:0] shiftOffset_past_i, //! Equivalent to relative O^{shift}_{m-1}
    input wire [SHIFT_WIDTH-1:0] l1pa_shift_shareGroup_i, //! Latest L1PA shift generated by memShare_control_wrapper 
    input wire [SHIFT_WIDTH-1:0] directRef_reconfig_i, //! Equivalent to W^{s}
    input wire sys_clk,
    input wire rstn
);
//-------------------------------------------------------
// Pipeline stage 0
//-------------------------------------------------------
// Binary-to-onehot encoding
wire [SHARED_BANK_NUM-1:0] shiftOffset_onhot_net; //! Onehot code of L1PA shift
reg [SHARED_BANK_NUM-1:0] shiftOffset_onhot_pipe0;
reg [SHIFT_WIDTH-1:0] l1pa_shift_pipe0;
reg [SHIFT_WIDTH-1:0] directRef_reconfig_pipe0;
genvar i;
generate
for(i=0; i<SHARED_BANK_NUM; i=i+1) begin: shiftOffset_bin2onehot_encBit
    assign shiftOffset_onhot_net[i] = (shiftOffset_past_i == i) ? 1'b1 : 1'b0;
end    
endgenerate
always @(posedge sys_clk) begin if(!rstn) shiftOffset_onhot_pipe0 <= 0; else shiftOffset_onhot_pipe0 <= shiftOffset_onhot_net; end
always @(posedge sys_clk) begin if(!rstn) l1pa_shift_pipe0 <= 0; else l1pa_shift_pipe0 <= l1pa_shift_shareGroup_i; end
always @(posedge sys_clk) begin if(!rstn) directRef_reconfig_pipe0 <= 0; else directRef_reconfig_pipe0 <= directRef_reconfig_i; end
//-------------------------------------------------------
// Pipeline stage 1
//-------------------------------------------------------
// Circular barrel shifter of length 5 where every input source is 1 bit wide
wire [SHARED_BANK_NUM-1:0] sw_out_net;
reg [SHARED_BANK_NUM-1:0] sw_out_pipe1;
reg [SHIFT_WIDTH-1:0] directRef_reconfig_pipe1;
generate
if(SHARED_BANK_NUM==3) begin
qsn_wrapper_len3_pipe0_q1 qsn3 (
    .sw_out_bit0(sw_out_net),
    .sys_clk(sys_clk),
    .rstn(rstn),
    .sw_in_bit0(shiftOffset_onhot_pipe0),
    .shift_factor(l1pa_shift_pipe0)
);
end
else if(SHARED_BANK_NUM==5) begin
qsn_wrapper_len5_pipe0_q1 qsn5 (
    .sw_out_bit0(sw_out_net),
    .sys_clk(sys_clk),
    .rstn(rstn),
    .sw_in_bit0(shiftOffset_onhot_pipe0),
    .shift_factor(l1pa_shift_pipe0)
);
end
else if(SHARED_BANK_NUM==9) begin
qsn_wrapper_len9_pipe1_q1 qsn9 (
    .sw_out_bit0(sw_out_net),
    .sys_clk(sys_clk),
    .rstn(rstn),
    .sw_in_bit0(shiftOffset_onhot_pipe0),
    .shift_factor(l1pa_shift_pipe0)
);
end
else if(SHARED_BANK_NUM==15) begin
qsn_wrapper_len15_pipe2_q1 qsn15 (
    .sw_out_bit0(sw_out_net),
    .sys_clk(sys_clk),
    .rstn(rstn),
    .sw_in_bit0(shiftOffset_onhot_pipe0),
    .shift_factor(l1pa_shift_pipe0)
);
end
else if(SHARED_BANK_NUM==17) begin
qsn_wrapper_len17_pipe2_q1 qsn17 (
    .sw_out_bit0(sw_out_net),
    .sys_clk(sys_clk),
    .rstn(rstn),
    .sw_in_bit0(shiftOffset_onhot_pipe0),
    .shift_factor(l1pa_shift_pipe0)
);
end
else if(SHARED_BANK_NUM==45) begin
qsn_wrapper_len45_pipe2_q1 qsn45 (
    .sw_out_bit0(sw_out_net),
    .sys_clk(sys_clk),
    .rstn(rstn),
    .sw_in_bit0(shiftOffset_onhot_pipe0),
    .shift_factor(l1pa_shift_pipe0)
);
end
else if(SHARED_BANK_NUM==51) begin
qsn_wrapper_len51_pipe2_q1 qsn51 (
    .sw_out_bit0(sw_out_net),
    .sys_clk(sys_clk),
    .rstn(rstn),
    .sw_in_bit0(shiftOffset_onhot_pipe0),
    .shift_factor(l1pa_shift_pipe0)
);
end
else begin
qsn_wrapper_len5_pipe0_q1  qsn5 (
    .sw_out_bit0(sw_out_net),
    .sys_clk(sys_clk),
    .rstn(rstn),
    .sw_in_bit0(shiftOffset_onhot_pipe0),
    .shift_factor(l1pa_shift_pipe0)
);
end
endgenerate
//qsn_wrapper_len5_pipe0_q1  qsn5 (
//    .sw_out_bit0(sw_out_net),
//    .sys_clk(sys_clk),
//    .rstn(rstn),
//    .sw_in_bit0(shiftOffset_onhot_pipe0),
//    .shift_factor(l1pa_shift_pipe0)
//);
always @(posedge sys_clk) begin if(!rstn) sw_out_pipe1 <= 0; else sw_out_pipe1 <= sw_out_net; end
always @(posedge sys_clk) begin if(!rstn) directRef_reconfig_pipe1 <= 0; else directRef_reconfig_pipe1 <= directRef_reconfig_pipe0; end
//-------------------------------------------------------
// Pipeline stage 2
// Component 1: Onehot-to-binary decoder
// Component 2: negation of shift offset in 2's complemnt formt
// Component 3: modulo-like operation w.r.t. W^{s}
//-------------------------------------------------------
reg [SHIFT_WIDTH-1:0] onehot2bin_offset;
reg [SHIFT_WIDTH:0] onehot2bin_offset_neg; //! negation of onehot2bin_offset 2's complement format
reg [SHIFT_WIDTH-1:0] modulo_shiftOffset;
generate
if(SHARED_BANK_NUM==3) begin
    always @(*) begin: onehot2bin_dec
        case(sw_out_pipe1[SHARED_BANK_NUM-1:0])
            3'd1: onehot2bin_offset = 0;
            3'd2: onehot2bin_offset = 1;
            3'd4: onehot2bin_offset = 2;
            default: onehot2bin_offset = 0;
        endcase
    end  
end
else if(SHARED_BANK_NUM==5) begin
    always @(*) begin: onehot2bin_dec
        case(sw_out_pipe1[SHARED_BANK_NUM-1:0])
            5'd1: onehot2bin_offset = 0;
            5'd2: onehot2bin_offset = 1;
            5'd4: onehot2bin_offset = 2;
            5'd8: onehot2bin_offset = 3;
            5'd16: onehot2bin_offset = 4;
            default: onehot2bin_offset = 0;
        endcase
    end
end
else if(SHARED_BANK_NUM==9) begin
    always @(*) begin: onehot2bin_dec
        case(sw_out_pipe1[SHARED_BANK_NUM-1:0])
            9'd1: onehot2bin_offset = 0;
            9'd2: onehot2bin_offset = 1;
            9'd4: onehot2bin_offset = 2;
            9'd8: onehot2bin_offset = 3;
            9'd16: onehot2bin_offset = 4;
            9'd32: onehot2bin_offset = 5;
            9'd64: onehot2bin_offset = 6;
            9'd128: onehot2bin_offset = 7;
            9'd256: onehot2bin_offset = 8;
            default: onehot2bin_offset = 0;
        endcase
    end
end
else if(SHARED_BANK_NUM==15) begin
    always @(*) begin: onehot2bin_dec
        case(sw_out_pipe1[SHARED_BANK_NUM-1:0])
            15'd1: onehot2bin_offset = 0;
            15'd2: onehot2bin_offset = 1;
            15'd4: onehot2bin_offset = 2;
            15'd8: onehot2bin_offset = 3;
            15'd16: onehot2bin_offset = 4;
            15'd32: onehot2bin_offset = 5;
            15'd64: onehot2bin_offset = 6;
            15'd128: onehot2bin_offset = 7;
            15'd256: onehot2bin_offset = 8;
            15'd512: onehot2bin_offset = 9;
            15'd1024: onehot2bin_offset = 10;
            15'd2048: onehot2bin_offset = 11;
            15'd4096: onehot2bin_offset = 12;
            15'd8192: onehot2bin_offset = 13;
            15'd16384: onehot2bin_offset = 14;
            default: onehot2bin_offset = 0;
        endcase
    end
end
else if(SHARED_BANK_NUM==17) begin
    always @(*) begin: onehot2bin_dec
        case(sw_out_pipe1[SHARED_BANK_NUM-1:0])
            17'd1: onehot2bin_offset = 0;
            17'd2: onehot2bin_offset = 1;
            17'd4: onehot2bin_offset = 2;
            17'd8: onehot2bin_offset = 3;
            17'd16: onehot2bin_offset = 4;
            17'd32: onehot2bin_offset = 5;
            17'd64: onehot2bin_offset = 6;
            17'd128: onehot2bin_offset = 7;
            17'd256: onehot2bin_offset = 8;
            17'd512: onehot2bin_offset = 9;
            17'd1024: onehot2bin_offset = 10;
            17'd2048: onehot2bin_offset = 11;
            17'd4096: onehot2bin_offset = 12;
            17'd8192: onehot2bin_offset = 13;
            17'd16384: onehot2bin_offset = 14;
            17'd32768: onehot2bin_offset = 15;
            17'd65536: onehot2bin_offset = 16;
            default: onehot2bin_offset = 0;
        endcase
    end
end
else if(SHARED_BANK_NUM==45) begin
    always @(*) begin: onehot2bin_dec
        case(sw_out_pipe1[SHARED_BANK_NUM-1:0])
            45'd1: onehot2bin_offset = 0;
            45'd2: onehot2bin_offset = 1;
            45'd4: onehot2bin_offset = 2;
            45'd8: onehot2bin_offset = 3;
            45'd16: onehot2bin_offset = 4;
            45'd32: onehot2bin_offset = 5;
            45'd64: onehot2bin_offset = 6;
            45'd128: onehot2bin_offset = 7;
            45'd256: onehot2bin_offset = 8;
            45'd512: onehot2bin_offset = 9;
            45'd1024: onehot2bin_offset = 10;
            45'd2048: onehot2bin_offset = 11;
            45'd4096: onehot2bin_offset = 12;
            45'd8192: onehot2bin_offset = 13;
            45'd16384: onehot2bin_offset = 14;
            45'd32768: onehot2bin_offset = 15;
            45'd65536: onehot2bin_offset = 16;
            45'd131072: onehot2bin_offset = 17;
            45'd262144: onehot2bin_offset = 18;
            45'd524288: onehot2bin_offset = 19;
            45'd1048576: onehot2bin_offset = 20;
            45'd2097152: onehot2bin_offset = 21;
            45'd4194304: onehot2bin_offset = 22;
            45'd8388608: onehot2bin_offset = 23;
            45'd16777216: onehot2bin_offset = 24;
            45'd33554432: onehot2bin_offset = 25;
            45'd67108864: onehot2bin_offset = 26;
            45'd134217728: onehot2bin_offset = 27;
            45'd268435456: onehot2bin_offset = 28;
            45'd536870912: onehot2bin_offset = 29;
            45'd1073741824: onehot2bin_offset = 30;
            45'd2147483648: onehot2bin_offset = 31;
            45'd4294967296: onehot2bin_offset = 32;
            45'd8589934592: onehot2bin_offset = 33;
            45'd17179869184: onehot2bin_offset = 34;
            45'd34359738368: onehot2bin_offset = 35;
            45'd68719476736: onehot2bin_offset = 36;
            45'd137438953472: onehot2bin_offset = 37;
            45'd274877906944: onehot2bin_offset = 38;
            45'd549755813888: onehot2bin_offset = 39;
            45'd1099511627776: onehot2bin_offset = 40;
            45'd2199023255552: onehot2bin_offset = 41;
            45'd4398046511104: onehot2bin_offset = 42;
            45'd8796093022208: onehot2bin_offset = 43;
            45'd17592186044416: onehot2bin_offset = 44;
            default: onehot2bin_offset = 0;
        endcase
    end
end
else if(SHARED_BANK_NUM==51) begin
    always @(*) begin: onehot2bin_dec
        case(sw_out_pipe1[SHARED_BANK_NUM-1:0])
            51'd1: onehot2bin_offset = 0;
            51'd2: onehot2bin_offset = 1;
            51'd4: onehot2bin_offset = 2;
            51'd8: onehot2bin_offset = 3;
            51'd16: onehot2bin_offset = 4;
            51'd32: onehot2bin_offset = 5;
            51'd64: onehot2bin_offset = 6;
            51'd128: onehot2bin_offset = 7;
            51'd256: onehot2bin_offset = 8;
            51'd512: onehot2bin_offset = 9;
            51'd1024: onehot2bin_offset = 10;
            51'd2048: onehot2bin_offset = 11;
            51'd4096: onehot2bin_offset = 12;
            51'd8192: onehot2bin_offset = 13;
            51'd16384: onehot2bin_offset = 14;
            51'd32768: onehot2bin_offset = 15;
            51'd65536: onehot2bin_offset = 16;
            51'd131072: onehot2bin_offset = 17;
            51'd262144: onehot2bin_offset = 18;
            51'd524288: onehot2bin_offset = 19;
            51'd1048576: onehot2bin_offset = 20;
            51'd2097152: onehot2bin_offset = 21;
            51'd4194304: onehot2bin_offset = 22;
            51'd8388608: onehot2bin_offset = 23;
            51'd16777216: onehot2bin_offset = 24;
            51'd33554432: onehot2bin_offset = 25;
            51'd67108864: onehot2bin_offset = 26;
            51'd134217728: onehot2bin_offset = 27;
            51'd268435456: onehot2bin_offset = 28;
            51'd536870912: onehot2bin_offset = 29;
            51'd1073741824: onehot2bin_offset = 30;
            51'd2147483648: onehot2bin_offset = 31;
            51'd4294967296: onehot2bin_offset = 32;
            51'd8589934592: onehot2bin_offset = 33;
            51'd17179869184: onehot2bin_offset = 34;
            51'd34359738368: onehot2bin_offset = 35;
            51'd68719476736: onehot2bin_offset = 36;
            51'd137438953472: onehot2bin_offset = 37;
            51'd274877906944: onehot2bin_offset = 38;
            51'd549755813888: onehot2bin_offset = 39;
            51'd1099511627776: onehot2bin_offset = 40;
            51'd2199023255552: onehot2bin_offset = 41;
            51'd4398046511104: onehot2bin_offset = 42;
            51'd8796093022208: onehot2bin_offset = 43;
            51'd17592186044416: onehot2bin_offset = 44;
            51'd35184372088832: onehot2bin_offset = 45;
            51'd70368744177664: onehot2bin_offset = 46;
            51'd140737488355328: onehot2bin_offset = 47;
            51'd281474976710656: onehot2bin_offset = 48;
            51'd562949953421312: onehot2bin_offset = 49;
            51'd1125899906842624: onehot2bin_offset = 50;
            default: onehot2bin_offset = 0;
        endcase
    end
end
else begin
    always @(*) begin: onehot2bin_dec
        case(sw_out_pipe1[SHARED_BANK_NUM-1:0])
            5'b0_0001: onehot2bin_offset = 0;
            5'b0_0010: onehot2bin_offset = 1;
            5'b0_0100: onehot2bin_offset = 2;
            5'b0_1000: onehot2bin_offset = 3;
            5'b1_0000: onehot2bin_offset = 4;
            default: onehot2bin_offset = 0;
        endcase
    end
end
endgenerate
//always @(*) begin: onehot2bin_dec
//    case(sw_out_pipe1[SHARED_BANK_NUM-1:0])
//        5'b0_0001: onehot2bin_offset = 0;
//        5'b0_0010: onehot2bin_offset = 1;
//        5'b0_0100: onehot2bin_offset = 2;
//        5'b0_1000: onehot2bin_offset = 3;
//        5'b1_0000: onehot2bin_offset = 4;
//        default: onehot2bin_offset = 0;
//    endcase
//end

always @(*) begin: negate_shiftOffset
    onehot2bin_offset_neg[SHIFT_WIDTH:0] = {1'b0, ~onehot2bin_offset[SHIFT_WIDTH-1:0]} + {{(SHIFT_WIDTH-1){1'b0}}, 1'b1};
end

always @(*) begin: modulo_like_Ws
    modulo_shiftOffset = directRef_reconfig_pipe1[SHIFT_WIDTH-1:0] + onehot2bin_offset_neg[SHIFT_WIDTH-1:0];
end
//-------------------------------------------------------
// Assignment for output port
//-------------------------------------------------------
assign shiftOffset_new_o[SHIFT_WIDTH-1:0] = modulo_shiftOffset[SHIFT_WIDTH-1:0];
endmodule