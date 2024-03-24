`timescale 1ns/1ps
/**
* Latest date: 7th May., 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: cumulative_shift_gen (tentative)
* 
* # I/F
* 1) Output:
* 2) Input:
* 
* # Param

* # Description
    The module to generate the final shift factor of L2PA for V2C permutation
* # Dependencies
* 	None

  # H/W utilisation on Xilinx 7-series FPGA
        * Ws=5
            Total LUT: 10
            Logic LUT: 10
            LUTRAM: 0
            FF: 58
            I/O: ?
**/
//module cumulative_shift_gen #(
//    parameter SHARED_BANK_NUM = 5, //! Number of IB-LUTs joining a share group (GP2)
//    parameter SHIFT_WIDTH = $clog2(SHARED_BANK_NUM),
//    parameter REF_WIDTH = SHIFT_WIDTH, //! Upper bound, actual reference might be less, e.g. W^{s}
//    parameter FIRST_PIPE_STAGE = 7,
//    parameter SEC_PIPE_STAGE = 2
//) (
//    output wire [SHIFT_WIDTH-1:0] cumulative_shift_o,
//
//    input wire [SHIFT_WIDTH-1:0] shift_i,
//
//    // Reconfigurable signal(s)
//    input wire [REF_WIDTH-1:0] directRef_reconfig_i, //! Equivalent to W^{s}
//    input wire [REF_WIDTH-1:0] leqRef_reconfig_i, //! Equivalent to floor(W^{s}/2)
//
//    input wire sys_clk,
//    input wire rstn
//);
//
//// Pipeline registers
//reg [SHIFT_WIDTH-1:0] addRes_pipe [0:FIRST_PIPE_STAGE+SEC_PIPE_STAGE-1];
//
//wire [SHIFT_WIDTH-1:0] cumulative_shift;
//cumulative_update #(
//  .SHIFT_WIDTH(SHIFT_WIDTH),
//  .REF_WIDTH (REF_WIDTH)
//) cumulative_update_dut (
//  .cumulative_shift_o (cumulative_shift),
//  .shift_cur_i (shift_i),
//  .cumulative_shift_prev_i (addRes_pipe[FIRST_PIPE_STAGE-1]),
//  .directRef_reconfig_i (SHARED_BANK_NUM),//(directRef_reconfig_i),
//  .leqRef_reconfig_i (2),//(leqRef_reconfig_i),
//  .sys_clk (sys_clk),
//  .rstn  (rstn)
//);
//
//// Head of first pipeline groug
//always @(posedge sys_clk) if(!rstn) addRes_pipe[0] <= 0; else addRes_pipe[0] <= cumulative_shift[SHIFT_WIDTH-1:0];
//// Head of second pipeline groug
//always @(posedge sys_clk) if(!rstn) addRes_pipe[FIRST_PIPE_STAGE] <= 0; else addRes_pipe[FIRST_PIPE_STAGE] <= addRes_pipe[FIRST_PIPE_STAGE-1];
//generate
//    genvar i;
//    if(FIRST_PIPE_STAGE > 1) begin
//        for (i=1; i<FIRST_PIPE_STAGE; i=i+1) begin
//            always @(posedge sys_clk) if(!rstn) addRes_pipe[i] <= 0; else addRes_pipe[i] <= addRes_pipe[i-1];
//        end
//    end
//
//    if(SEC_PIPE_STAGE > 1) begin
//        for (i=FIRST_PIPE_STAGE+1; i<(FIRST_PIPE_STAGE+SEC_PIPE_STAGE); i=i+1) begin
//            always @(posedge sys_clk) if(!rstn) addRes_pipe[i] <= 0; else addRes_pipe[i] <= addRes_pipe[i-1];
//        end
//    end
//endgenerate
//assign cumulative_shift_o[SHIFT_WIDTH-1:0] = addRes_pipe[FIRST_PIPE_STAGE+SEC_PIPE_STAGE-1];
//endmodule

/**
* Latest date: 7th May., 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: cumulative_update
* 
* # I/F
* 1) Output:
* 2) Input:
* 
* # Param

* # Description
    Number of pipeline stages: 6
    The above stage number is to follow up the datapath cycles from L1PA->L2PA to C2V.MEM fecth.

* # Dependencies
* 	None

  # H/W utilisation on Xilinx 7-series FPGA
        * Ws=5
            Total LUT: 10
            Logic LUT: 10
            LUTRAM: 0
            FF: 40
            I/O: used as an interanl submodule, the I/O is thereby not evaluated.
**/
//module cumulative_update #(
//    parameter SHIFT_WIDTH = 3,
//    parameter REF_WIDTH = SHIFT_WIDTH // upper bound, actual reference might be less
//) (
//    output wire [SHIFT_WIDTH-1:0] cumulative_shift_o,
//
//    input wire [SHIFT_WIDTH-1:0] shift_cur_i,
//    input wire [SHIFT_WIDTH-1:0] cumulative_shift_prev_i,
//    input wire [REF_WIDTH-1:0] directRef_reconfig_i,
//    input wire [REF_WIDTH-1:0] leqRef_reconfig_i,
//
//    input wire sys_clk,
//    input wire rstn
//);
//
////-------------------------------------------------------
//// Pipeline stage 0
////-------------------------------------------------------
//wire isLeq_net0;
//reg isLeq_pipe0;
//reg [SHIFT_WIDTH-1:0] reverse_shift_pipe0;
//reg [SHIFT_WIDTH-1:0] curShift_pipe0;
//reg [SHIFT_WIDTH-1:0] accShift_pipe0;
//reg [REF_WIDTH-1:0] directRef_reconfig_pipe0;
//
//leq #(.TARGET_WIDTH (SHIFT_WIDTH), .REF_WIDTH (REF_WIDTH)) leq (.is_leq_o(isLeq_net0), .target_i(shift_cur_i), .ref_i(leqRef_reconfig_i));
//always @(posedge sys_clk) if(!rstn) isLeq_pipe0 <= 1'b0; else isLeq_pipe0 <= isLeq_net0;
//always @(posedge sys_clk) if(!rstn) reverse_shift_pipe0 <= 0; else reverse_shift_pipe0 <= directRef_reconfig_i - shift_cur_i;
//always @(posedge sys_clk) if(!rstn) curShift_pipe0 <= 0; else curShift_pipe0 <= shift_cur_i;
//always @(posedge sys_clk) if(!rstn) accShift_pipe0 <= 0; else accShift_pipe0 <= cumulative_shift_o;
//always @(posedge sys_clk) if(!rstn) directRef_reconfig_pipe0 <= 0; else directRef_reconfig_pipe0 <= directRef_reconfig_i;
////-------------------------------------------------------
//// Pipeline stage 1
////-------------------------------------------------------
//reg isLeq_pipe1;
//wire [SHIFT_WIDTH:0] reverse_shift_net1;
//reg [SHIFT_WIDTH:0] reverse_shift_pipe1;
//reg [SHIFT_WIDTH-1:0] curShift_pipe1;
//reg [SHIFT_WIDTH-1:0] accShift_pipe1;
//reg [REF_WIDTH-1:0] directRef_reconfig_pipe1;
//always @(posedge sys_clk) if(!rstn) isLeq_pipe1 <= 0; else isLeq_pipe1 <= isLeq_pipe0;
//always @(posedge sys_clk) if(!rstn) reverse_shift_pipe1 <= 0; else reverse_shift_pipe1 <= reverse_shfit_net1;
//assign reverse_shfit_net1 = ~{1'b0, reverse_shift_pipe0[SHIFT_WIDTH-1:0]}+1;
//always @(posedge sys_clk) if(!rstn) curShift_pipe1 <= 0; else curShift_pipe1 <= curShift_pipe0;
//always @(posedge sys_clk) if(!rstn) accShift_pipe1 <= 0; else accShift_pipe1 <= accShift_pipe0;
//always @(posedge sys_clk) if(!rstn) directRef_reconfig_pipe1 <= 0; else directRef_reconfig_pipe1 <= directRef_reconfig_pipe0;
////-------------------------------------------------------
//// Pipeline stage 2
////-------------------------------------------------------
//wire [SHIFT_WIDTH:0] reverse_shift_net2;
//reg [SHIFT_WIDTH:0] reverse_shift_pipe2;
//reg [SHIFT_WIDTH-1:0] accShift_pipe2;
//reg [REF_WIDTH-1:0] directRef_reconfig_pipe2;
//always @(posedge sys_clk) if(!rstn) reverse_shift_pipe2 <= 0; else reverse_shift_pipe2 <= reverse_shift_net2;
//assign reverse_shift_net2 = (isLeq_pipe1 == 1'b1) ? reverse_shift_pipe1 : {1'b0, curShift_pipe1[SHIFT_WIDTH-1:0]};
//always @(posedge sys_clk) if(!rstn) accShift_pipe2 <= 0; else accShift_pipe2 <= accShift_pipe1;
//always @(posedge sys_clk) if(!rstn) directRef_reconfig_pipe2 <= 0; else directRef_reconfig_pipe2 <= directRef_reconfig_pipe1;
////-------------------------------------------------------
//// Pipeline stage 3
////-------------------------------------------------------
//wire [SHIFT_WIDTH:0] accShift_net3;
//reg [SHIFT_WIDTH:0] accShift_pipe3;
//reg [REF_WIDTH-1:0] directRef_reconfig_pipe3;
//always @(posedge sys_clk) if(!rstn) accShift_pipe3 <= 0; else accShift_pipe3 <= accShift_net3;
//assign accShift_net3[SHIFT_WIDTH:0] = reverse_shift_pipe2[SHIFT_WIDTH:0] + {1'b0, accShift_pipe2[SHIFT_WIDTH-1:0]};
//always @(posedge sys_clk) if(!rstn) directRef_reconfig_pipe3 <= 0; else directRef_reconfig_pipe3 <= directRef_reconfig_pipe2;
////-------------------------------------------------------
//// Pipeline stage 4
////-------------------------------------------------------
//wire [SHIFT_WIDTH-1:0] accShift_net4;
//reg [SHIFT_WIDTH-1:0] accShift_pipe4;
//reg [SHIFT_WIDTH:0] accShift_old_pipe4;
//reg [REF_WIDTH-1:0] directRef_reconfig_pipe4;
//reg isNegative_pipe4;
//always @(posedge sys_clk) if(!rstn) isNegative_pipe4 <= 0; else isNegative_pipe4 <= accShift_pipe3[SHIFT_WIDTH]; // MSB of 2's complement format
//always @(posedge sys_clk) if(!rstn) accShift_pipe4 <= 0; else accShift_pipe4 <= accShift_net4;
//// Addition of magnitude values excluding the MSB as the sign bit of the 2's complement format
//assign accShift_net4[SHIFT_WIDTH-1:0] = accShift_pipe3[SHIFT_WIDTH-1:0] + directRef_reconfig_pipe3[SHIFT_WIDTH-1:0];
//always @(posedge sys_clk) if(!rstn) accShift_old_pipe4 <= 0; else accShift_old_pipe4[SHIFT_WIDTH-1:0] <= accShift_pipe3[SHIFT_WIDTH-1:0];
//always @(posedge sys_clk) if(!rstn) directRef_reconfig_pipe4 <= 0; else directRef_reconfig_pipe4 <= directRef_reconfig_pipe3; 
////-------------------------------------------------------
//// Pipeline stage 5
////-------------------------------------------------------
//wire [SHIFT_WIDTH-1:0] cumulative_shift_net5;
//wire [SHIFT_WIDTH-1:0] preprocess_v2cMsgPass;
//reg [SHIFT_WIDTH-1:0] cumulative_shift_pipe5;
//always @(posedge sys_clk) if(!rstn) cumulative_shift_pipe5 <= 0; else cumulative_shift_pipe5 <= cumulative_shift_net5;
//assign cumulative_shift_net5[SHIFT_WIDTH-1:0] = (isNegative_pipe4 == 1'b1) ? accShift_pipe4[SHIFT_WIDTH-1:0] : accShift_old_pipe4[SHIFT_WIDTH-1:0];
//assign preprocess_v2cMsgPass[SHIFT_WIDTH-1:0] = directRef_reconfig_pipe4[SHIFT_WIDTH-1:0] - cumulative_shift_net5[SHIFT_WIDTH-1:0];
////-------------------------------------------------------
//// Output port(s)
////-------------------------------------------------------
//assign cumulative_shift_o[SHIFT_WIDTH-1:0] = preprocess_v2cMsgPass[SHIFT_WIDTH-1:0]; //cumulative_shift_pipe5[SHIFT_WIDTH-1:0];
//endmodule

//module leq #(
//    parameter TARGET_WIDTH = 3,
//    parameter REF_WIDTH = 3 // upper bound, actual reference might be less
//) (
//    output wire is_leq_o,
//    input wire [TARGET_WIDTH-1:0] target_i,
//    input wire [REF_WIDTH-1:0] ref_i
//);
//
//assign is_leq_o = (target_i <= ref_i) ? 1'b1 : 1'b0;
//endmodule

`define RTL_TRIAL_1 // 1st implementation of shift offset generator
`define RTL_TRIAL_2 // 2nd implementation of shift offset generator

`ifdef RTL_TRIAL_1
module cumulative_shift_gen #(
    parameter SHARED_BANK_NUM = 5, //! Number of IB-LUTs joining a share group (GP2)
    parameter SHIFT_WIDTH = $clog2(SHARED_BANK_NUM),
    parameter REF_WIDTH = SHIFT_WIDTH, //! Upper bound, actual reference might be less, e.g. W^{s}
    parameter PIPELINE_STAGE = 2
) (
    output wire [SHIFT_WIDTH-1:0] shiftOffset_cur_o,
//    output wire [SHIFT_WIDTH-1:0] preprocessShift_o,

    input wire [SHIFT_WIDTH-1:0] shiftOffset_prev_i,
    input wire [SHIFT_WIDTH-1:0] shift_i,
    input wire shiftOffset_mask_i, // To mask the incoming O^{shift}_{m-1} by all-zero reset
                                   // at share memory allocatin for VN.f0
                                   // 0: not masked, 1: masked
    input wire is_vnLast_i,

    // Reconfigurable signal(s)
    input wire [REF_WIDTH-1:0] directRef_reconfig_i, //! Equivalent to W^{s}
    
    input wire sys_clk,
    input wire rstn
);

//-----------------------------------
// Pipeline stage 0
// Calculation of O^{shfit}_{m} = O^{shfit}_{m-1} + s_{m} ( mod W^{s} )
//-----------------------------------
wire [SHIFT_WIDTH*2-1:0] cumulative_temp;
wire [SHIFT_WIDTH*2:0] ref_neg;
wire [SHIFT_WIDTH*2:0] cumulative_temp_subRes;
wire [SHIFT_WIDTH-1:0] shiftOffsetPrev_mask;
wire isLess_ref;
wire [SHIFT_WIDTH-1:0] shiftOffset_cur_net;
reg [SHIFT_WIDTH-1:0] shiftOffset_cur_pipe0;
reg [REF_WIDTH-1:0] directRef_reconfig_pipe0;
reg is_vnLast_pipe0;

// Calculation of O^{shift}_{m-1} + s_{m}
assign shiftOffsetPrev_mask[SHIFT_WIDTH-1:0] = {SHIFT_WIDTH{~shiftOffset_mask_i}} & shiftOffset_prev_i[SHIFT_WIDTH-1:0];
assign cumulative_temp[SHIFT_WIDTH*2-1:0] = {{SHIFT_WIDTH{1'b0}}, shiftOffsetPrev_mask[SHIFT_WIDTH-1:0]} + {{SHIFT_WIDTH{1'b0}}, shift_i[SHIFT_WIDTH-1:0]};
// Is O^{shift}_{m-1} + s_{m} < W^{s} ?
assign isLess_ref = (cumulative_temp < directRef_reconfig_i) ? 1'b1 : 1'b0;
// Negation of W^{s}
assign ref_neg[SHIFT_WIDTH*2:0] = {1'b1, ~{SHIFT_WIDTH{1'b0}}, ~directRef_reconfig_i[REF_WIDTH-1:0]} + 1;
// Calculation of O^{shift}_{m-1} + s_{m} - W^{s} as psudo-modulo operation
assign cumulative_temp_subRes[SHIFT_WIDTH*2:0] = {1'b0, cumulative_temp[SHIFT_WIDTH*2-1:0]} + ref_neg[SHIFT_WIDTH*2:0];
assign shiftOffset_cur_net[SHIFT_WIDTH-1:0] = (isLess_ref == 1'b1) ? cumulative_temp[SHIFT_WIDTH-1:0] : cumulative_temp_subRes[SHIFT_WIDTH-1:0];

always @(posedge sys_clk) begin if(!rstn) shiftOffset_cur_pipe0 <= 0; else shiftOffset_cur_pipe0 <= shiftOffset_cur_net; end
always @(posedge sys_clk) begin if(!rstn) directRef_reconfig_pipe0 <= 0; else directRef_reconfig_pipe0 <= directRef_reconfig_i; end
always @(posedge sys_clk) begin if(!rstn) is_vnLast_pipe0 <= 0; else is_vnLast_pipe0 <= is_vnLast_i; end
//-----------------------------------
// Pipeline stage 1
// Calculation of S^{pre}_{v2c}
//-----------------------------------
// Calculation of shift control signal for preprocessing of V2C permutation
wire [SHIFT_WIDTH:0] shiftOffset_cur_neg;
wire [SHIFT_WIDTH:0] preprocessShift_temp;
wire [SHIFT_WIDTH-1:0] preprocessShift_net;
reg [SHIFT_WIDTH-1:0] shiftOffset_cur_pipe1;
reg [SHIFT_WIDTH-1:0] preprocessShift_pipe1;
reg is_vnLast_pipe1;

// Negation of O^{shfit}_{m} calculated from the previous pipeline stage
assign shiftOffset_cur_neg[SHIFT_WIDTH:0] = {1'b1, ~shiftOffset_cur_pipe0[SHIFT_WIDTH-1:0]} + 1'b1;
assign preprocessShift_temp[SHIFT_WIDTH:0] = {1'b0, directRef_reconfig_pipe0[SHIFT_WIDTH-1:0]} + shiftOffset_cur_neg[SHIFT_WIDTH:0];
assign preprocessShift_net[SHIFT_WIDTH-1:0] = (shiftOffset_cur_o > 0) ? preprocessShift_temp[SHIFT_WIDTH-1:0] : {SHIFT_WIDTH{1'b0}};

always @(posedge sys_clk) begin if(!rstn) shiftOffset_cur_pipe1 <= 0; else shiftOffset_cur_pipe1 <= shiftOffset_cur_pipe0; end
always @(posedge sys_clk) begin if(!rstn) preprocessShift_pipe1 <= 0; else preprocessShift_pipe1 <= preprocessShift_net; end
always @(posedge sys_clk) begin if(!rstn) is_vnLast_pipe1 <= 0; else is_vnLast_pipe1 <= is_vnLast_pipe0; end
//-----------------------------------
// Glue of output ports
//-----------------------------------
assign shiftOffset_cur_o = (is_vnLast_pipe1 == 1'b1) ? preprocessShift_pipe1 : shiftOffset_cur_pipe1;
//assign shiftOffset_cur_o = shiftOffset_cur_pipe1;
//assign preprocessShift_o = preprocessShift_pipe1;
endmodule
`endif // RTL_TRIAL_1

`ifdef RTL_TRIAL_2

`endif // RTL_TRIAL_2