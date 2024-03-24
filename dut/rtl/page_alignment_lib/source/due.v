/* 
In case of Z=765, to evaluate all factor of Z. That is,
3, 5, 9, 15, 17, 45, 51, 85, 153, 255
*/
`include "define.vh"
module design_under_area_evaluation #(
    parameter QUAN_SIZE = 3,
    parameter TRIAL0 = 3,
    parameter TRIAL1 = 5,
    parameter TRIAL2 = 9,
    parameter TRIAL3 = 15,
    parameter TRIAL4 = 17,
    parameter TRIAL5 = 45,
    parameter TRIAL6 = 51,
    parameter TRIAL7 = 85,
    parameter TRIAL8 = 153,
    parameter TRIAL9 = 255
) (
    output wire [TRIAL0-1:0] trial0_q4_l2paOut_bit3_o,
    output wire [TRIAL0-1:0] trial0_q4_l2paOut_bit2_o,
    output wire [TRIAL0-1:0] trial0_q4_l2paOut_bit1_o,
    output wire [TRIAL0-1:0] trial0_q4_l2paOut_bit0_o,
    input wire  [TRIAL0-1:0] trial0_q4_l1paOut_bit3_i,  
    input wire  [TRIAL0-1:0] trial0_q4_l1paOut_bit2_i,
    input wire  [TRIAL0-1:0] trial0_q4_l1paOut_bit1_i,
    input wire  [TRIAL0-1:0] trial0_q4_l1paOut_bit0_i,
    input wire  [TRIAL0-1:0] trial0_q4_shiftROM_load_en_i,
    output wire [TRIAL1-1:0] trial1_q4_l2paOut_bit3_o,
    output wire [TRIAL1-1:0] trial1_q4_l2paOut_bit2_o,
    output wire [TRIAL1-1:0] trial1_q4_l2paOut_bit1_o,
    output wire [TRIAL1-1:0] trial1_q4_l2paOut_bit0_o,
    input wire  [TRIAL1-1:0] trial1_q4_l1paOut_bit3_i,  
    input wire  [TRIAL1-1:0] trial1_q4_l1paOut_bit2_i,
    input wire  [TRIAL1-1:0] trial1_q4_l1paOut_bit1_i,
    input wire  [TRIAL1-1:0] trial1_q4_l1paOut_bit0_i,
    input wire  [TRIAL1-1:0] trial1_q4_shiftROM_load_en_i,
    output wire [TRIAL2-1:0] trial2_q4_l2paOut_bit3_o,
    output wire [TRIAL2-1:0] trial2_q4_l2paOut_bit2_o,
    output wire [TRIAL2-1:0] trial2_q4_l2paOut_bit1_o,
    output wire [TRIAL2-1:0] trial2_q4_l2paOut_bit0_o,
    input wire  [TRIAL2-1:0] trial2_q4_l1paOut_bit3_i,  
    input wire  [TRIAL2-1:0] trial2_q4_l1paOut_bit2_i,
    input wire  [TRIAL2-1:0] trial2_q4_l1paOut_bit1_i,
    input wire  [TRIAL2-1:0] trial2_q4_l1paOut_bit0_i,
    input wire  [TRIAL2-1:0] trial2_q4_shiftROM_load_en_i,
    output wire [TRIAL3-1:0] trial3_q4_l2paOut_bit3_o,
    output wire [TRIAL3-1:0] trial3_q4_l2paOut_bit2_o,
    output wire [TRIAL3-1:0] trial3_q4_l2paOut_bit1_o,
    output wire [TRIAL3-1:0] trial3_q4_l2paOut_bit0_o,
    input wire  [TRIAL3-1:0] trial3_q4_l1paOut_bit3_i,  
    input wire  [TRIAL3-1:0] trial3_q4_l1paOut_bit2_i,
    input wire  [TRIAL3-1:0] trial3_q4_l1paOut_bit1_i,
    input wire  [TRIAL3-1:0] trial3_q4_l1paOut_bit0_i,
    input wire  [TRIAL3-1:0] trial3_q4_shiftROM_load_en_i,
    output wire [TRIAL4-1:0] trial4_q4_l2paOut_bit3_o,
    output wire [TRIAL4-1:0] trial4_q4_l2paOut_bit2_o,
    output wire [TRIAL4-1:0] trial4_q4_l2paOut_bit1_o,
    output wire [TRIAL4-1:0] trial4_q4_l2paOut_bit0_o,
    input wire  [TRIAL4-1:0] trial4_q4_l1paOut_bit3_i,  
    input wire  [TRIAL4-1:0] trial4_q4_l1paOut_bit2_i,
    input wire  [TRIAL4-1:0] trial4_q4_l1paOut_bit1_i,
    input wire  [TRIAL4-1:0] trial4_q4_l1paOut_bit0_i,
    input wire  [TRIAL4-1:0] trial4_q4_shiftROM_load_en_i,
    output wire [TRIAL5-1:0] trial5_q4_l2paOut_bit3_o,
    output wire [TRIAL5-1:0] trial5_q4_l2paOut_bit2_o,
    output wire [TRIAL5-1:0] trial5_q4_l2paOut_bit1_o,
    output wire [TRIAL5-1:0] trial5_q4_l2paOut_bit0_o,
    input wire  [TRIAL5-1:0] trial5_q4_l1paOut_bit3_i,  
    input wire  [TRIAL5-1:0] trial5_q4_l1paOut_bit2_i,
    input wire  [TRIAL5-1:0] trial5_q4_l1paOut_bit1_i,
    input wire  [TRIAL5-1:0] trial5_q4_l1paOut_bit0_i,
    input wire  [TRIAL5-1:0] trial5_q4_shiftROM_load_en_i,
    output wire [TRIAL6-1:0] trial6_q4_l2paOut_bit3_o,
    output wire [TRIAL6-1:0] trial6_q4_l2paOut_bit2_o,
    output wire [TRIAL6-1:0] trial6_q4_l2paOut_bit1_o,
    output wire [TRIAL6-1:0] trial6_q4_l2paOut_bit0_o,
    input wire  [TRIAL6-1:0] trial6_q4_l1paOut_bit3_i,  
    input wire  [TRIAL6-1:0] trial6_q4_l1paOut_bit2_i,
    input wire  [TRIAL6-1:0] trial6_q4_l1paOut_bit1_i,
    input wire  [TRIAL6-1:0] trial6_q4_l1paOut_bit0_i,
    input wire  [TRIAL6-1:0] trial6_q4_shiftROM_load_en_i,
    output wire [TRIAL7-1:0] trial7_q4_l2paOut_bit3_o,
    output wire [TRIAL7-1:0] trial7_q4_l2paOut_bit2_o,
    output wire [TRIAL7-1:0] trial7_q4_l2paOut_bit1_o,
    output wire [TRIAL7-1:0] trial7_q4_l2paOut_bit0_o,
    input wire  [TRIAL7-1:0] trial7_q4_l1paOut_bit3_i,  
    input wire  [TRIAL7-1:0] trial7_q4_l1paOut_bit2_i,
    input wire  [TRIAL7-1:0] trial7_q4_l1paOut_bit1_i,
    input wire  [TRIAL7-1:0] trial7_q4_l1paOut_bit0_i,
    input wire  [TRIAL7-1:0] trial7_q4_shiftROM_load_en_i,
    output wire [TRIAL8-1:0] trial8_q4_l2paOut_bit3_o,
    output wire [TRIAL8-1:0] trial8_q4_l2paOut_bit2_o,
    output wire [TRIAL8-1:0] trial8_q4_l2paOut_bit1_o,
    output wire [TRIAL8-1:0] trial8_q4_l2paOut_bit0_o,
    input wire  [TRIAL8-1:0] trial8_q4_l1paOut_bit3_i,  
    input wire  [TRIAL8-1:0] trial8_q4_l1paOut_bit2_i,
    input wire  [TRIAL8-1:0] trial8_q4_l1paOut_bit1_i,
    input wire  [TRIAL8-1:0] trial8_q4_l1paOut_bit0_i,
    input wire  [TRIAL8-1:0] trial8_q4_shiftROM_load_en_i,
    output wire [TRIAL9-1:0] trial9_q4_l2paOut_bit3_o,
    output wire [TRIAL9-1:0] trial9_q4_l2paOut_bit2_o,
    output wire [TRIAL9-1:0] trial9_q4_l2paOut_bit1_o,
    output wire [TRIAL9-1:0] trial9_q4_l2paOut_bit0_o,
    input wire  [TRIAL9-1:0] trial9_q4_l1paOut_bit3_i,  
    input wire  [TRIAL9-1:0] trial9_q4_l1paOut_bit2_i,
    input wire  [TRIAL9-1:0] trial9_q4_l1paOut_bit1_i,
    input wire  [TRIAL9-1:0] trial9_q4_l1paOut_bit0_i,
    input wire  [TRIAL9-1:0] trial9_q4_shiftROM_load_en_i,

    // Layer status control
    input wire isMsgPass_i, //! Current L2PA usage is for V2C/C2V permutation
   

    input wire rstn,
    input wire sys_clk
);

l2pa_logic #(
    .SHIFT_LENGTH (TRIAL0),
    .QUAN_SIZE (QUAN_SIZE)
) l2pa_strideWidth_3 (
    .l2paOut_bit2_o (trial0_q4_l2paOut_bit2_o[TRIAL0-1:0]),
    .l2paOut_bit1_o (trial0_q4_l2paOut_bit1_o[TRIAL0-1:0]),
    .l2paOut_bit0_o (trial0_q4_l2paOut_bit0_o[TRIAL0-1:0]),
  `ifdef DECODER_4bit
    .l2paOut_bit3_o (trial0_q4_l2paOut_bit3_o[TRIAL0-1:0]),
  `endif // DECODER_4bit
    .l1paOut_bit2_i (trial0_q4_l1paOut_bit2_i),
    .l1paOut_bit1_i (trial0_q4_l1paOut_bit1_i),
    .l1paOut_bit0_i (trial0_q4_l1paOut_bit0_i),
  `ifdef DECODER_4bit
    .l1paOut_bit3_i (trial0_q4_l1paOut_bit3_i),
  `endif // DECODER_4bit
    .isMsgPass_i (isMsgPass_i),
    .shiftROM_load_en_i (trial0_q4_shiftROM_load_en_i[TRIAL0-1:0]),
    .rstn (rstn),
    .sys_clk  (sys_clk)
  );
l2pa_logic #(
    .SHIFT_LENGTH (TRIAL1),
    .QUAN_SIZE (QUAN_SIZE)
) l2pa_strideWidth_5 (
    .l2paOut_bit2_o (trial1_q4_l2paOut_bit2_o[TRIAL1-1:0]),
    .l2paOut_bit1_o (trial1_q4_l2paOut_bit1_o[TRIAL1-1:0]),
    .l2paOut_bit0_o (trial1_q4_l2paOut_bit0_o[TRIAL1-1:0]),
  `ifdef DECODER_4bit
    .l2paOut_bit3_o (trial1_q4_l2paOut_bit3_o[TRIAL1-1:0]),
  `endif // DECODER_4bit
    .l1paOut_bit2_i (trial1_q4_l1paOut_bit2_i),
    .l1paOut_bit1_i (trial1_q4_l1paOut_bit1_i),
    .l1paOut_bit0_i (trial1_q4_l1paOut_bit0_i),
  `ifdef DECODER_4bit
    .l1paOut_bit3_i (trial1_q4_l1paOut_bit3_i),
  `endif // DECODER_4bit
    .isMsgPass_i (isMsgPass_i),
    .shiftROM_load_en_i (trial1_q4_shiftROM_load_en_i[TRIAL1-1:0]),
    .rstn (rstn),
    .sys_clk  (sys_clk)
  );
l2pa_logic #(
    .SHIFT_LENGTH (TRIAL2),
    .QUAN_SIZE (QUAN_SIZE)
) l2pa_strideWidth_9 (
    .l2paOut_bit2_o (trial2_q4_l2paOut_bit2_o[TRIAL2-1:0]),
    .l2paOut_bit1_o (trial2_q4_l2paOut_bit1_o[TRIAL2-1:0]),
    .l2paOut_bit0_o (trial2_q4_l2paOut_bit0_o[TRIAL2-1:0]),
  `ifdef DECODER_4bit
    .l2paOut_bit3_o (trial2_q4_l2paOut_bit3_o[TRIAL2-1:0]),
  `endif // DECODER_4bit
    .l1paOut_bit2_i (trial2_q4_l1paOut_bit2_i),
    .l1paOut_bit1_i (trial2_q4_l1paOut_bit1_i),
    .l1paOut_bit0_i (trial2_q4_l1paOut_bit0_i),
  `ifdef DECODER_4bit
    .l1paOut_bit3_i (trial2_q4_l1paOut_bit3_i),
  `endif // DECODER_4bit
    .isMsgPass_i (isMsgPass_i),
    .shiftROM_load_en_i (trial2_q4_shiftROM_load_en_i[TRIAL2-1:0]),
    .rstn (rstn),
    .sys_clk  (sys_clk)
  );
l2pa_logic #(
    .SHIFT_LENGTH (TRIAL3),
    .QUAN_SIZE (QUAN_SIZE)
) l2pa_strideWidth_15 (
    .l2paOut_bit2_o (trial3_q4_l2paOut_bit2_o[TRIAL3-1:0]),
    .l2paOut_bit1_o (trial3_q4_l2paOut_bit1_o[TRIAL3-1:0]),
    .l2paOut_bit0_o (trial3_q4_l2paOut_bit0_o[TRIAL3-1:0]),
  `ifdef DECODER_4bit
    .l2paOut_bit3_o (trial3_q4_l2paOut_bit3_o[TRIAL3-1:0]),
  `endif // DECODER_4bit
    .l1paOut_bit2_i (trial3_q4_l1paOut_bit2_i),
    .l1paOut_bit1_i (trial3_q4_l1paOut_bit1_i),
    .l1paOut_bit0_i (trial3_q4_l1paOut_bit0_i),
  `ifdef DECODER_4bit
    .l1paOut_bit3_i (trial3_q4_l1paOut_bit3_i),
  `endif // DECODER_4bit
    .isMsgPass_i (isMsgPass_i),
    .shiftROM_load_en_i (trial3_q4_shiftROM_load_en_i[TRIAL3-1:0]),
    .rstn (rstn),
    .sys_clk  (sys_clk)
  );
l2pa_logic #(
    .SHIFT_LENGTH (TRIAL4),
    .QUAN_SIZE (QUAN_SIZE)
) l2pa_strideWidth_17 (
    .l2paOut_bit2_o (trial4_q4_l2paOut_bit2_o[TRIAL4-1:0]),
    .l2paOut_bit1_o (trial4_q4_l2paOut_bit1_o[TRIAL4-1:0]),
    .l2paOut_bit0_o (trial4_q4_l2paOut_bit0_o[TRIAL4-1:0]),
  `ifdef DECODER_4bit
    .l2paOut_bit3_o (trial4_q4_l2paOut_bit3_o[TRIAL4-1:0]),
  `endif // DECODER_4bit
    .l1paOut_bit2_i (trial4_q4_l1paOut_bit2_i),
    .l1paOut_bit1_i (trial4_q4_l1paOut_bit1_i),
    .l1paOut_bit0_i (trial4_q4_l1paOut_bit0_i),
  `ifdef DECODER_4bit
    .l1paOut_bit3_i (trial4_q4_l1paOut_bit3_i),
  `endif // DECODER_4bit
    .isMsgPass_i (isMsgPass_i),
    .shiftROM_load_en_i (trial4_q4_shiftROM_load_en_i[TRIAL4-1:0]),
    .rstn (rstn),
    .sys_clk  (sys_clk)
  );
l2pa_logic #(
    .SHIFT_LENGTH (TRIAL5),
    .QUAN_SIZE (QUAN_SIZE)
) l2pa_strideWidth_45 (
    .l2paOut_bit2_o (trial5_q4_l2paOut_bit2_o[TRIAL5-1:0]),
    .l2paOut_bit1_o (trial5_q4_l2paOut_bit1_o[TRIAL5-1:0]),
    .l2paOut_bit0_o (trial5_q4_l2paOut_bit0_o[TRIAL5-1:0]),
  `ifdef DECODER_4bit
    .l2paOut_bit3_o (trial5_q4_l2paOut_bit3_o[TRIAL5-1:0]),
  `endif // DECODER_4bit
    .l1paOut_bit2_i (trial5_q4_l1paOut_bit2_i),
    .l1paOut_bit1_i (trial5_q4_l1paOut_bit1_i),
    .l1paOut_bit0_i (trial5_q4_l1paOut_bit0_i),
  `ifdef DECODER_4bit
    .l1paOut_bit3_i (trial5_q4_l1paOut_bit3_i),
  `endif // DECODER_4bit
    .isMsgPass_i (isMsgPass_i),
    .shiftROM_load_en_i (trial5_q4_shiftROM_load_en_i[TRIAL5-1:0]),
    .rstn (rstn),
    .sys_clk  (sys_clk)
  );
l2pa_logic #(
    .SHIFT_LENGTH (TRIAL6),
    .QUAN_SIZE (QUAN_SIZE)
) l2pa_strideWidth_51 (
    .l2paOut_bit2_o (trial6_q4_l2paOut_bit2_o[TRIAL6-1:0]),
    .l2paOut_bit1_o (trial6_q4_l2paOut_bit1_o[TRIAL6-1:0]),
    .l2paOut_bit0_o (trial6_q4_l2paOut_bit0_o[TRIAL6-1:0]),
  `ifdef DECODER_4bit
    .l2paOut_bit3_o (trial6_q4_l2paOut_bit3_o[TRIAL6-1:0]),
  `endif // DECODER_4bit
    .l1paOut_bit2_i (trial6_q4_l1paOut_bit2_i),
    .l1paOut_bit1_i (trial6_q4_l1paOut_bit1_i),
    .l1paOut_bit0_i (trial6_q4_l1paOut_bit0_i),
  `ifdef DECODER_4bit
    .l1paOut_bit3_i (trial6_q4_l1paOut_bit3_i),
  `endif // DECODER_4bit
    .isMsgPass_i (isMsgPass_i),
    .shiftROM_load_en_i (trial6_q4_shiftROM_load_en_i[TRIAL6-1:0]),
    .rstn (rstn),
    .sys_clk  (sys_clk)
  );
l2pa_logic #(
    .SHIFT_LENGTH (TRIAL7),
    .QUAN_SIZE (QUAN_SIZE)
) l2pa_strideWidth_85 (
    .l2paOut_bit2_o (trial7_q4_l2paOut_bit2_o[TRIAL7-1:0]),
    .l2paOut_bit1_o (trial7_q4_l2paOut_bit1_o[TRIAL7-1:0]),
    .l2paOut_bit0_o (trial7_q4_l2paOut_bit0_o[TRIAL7-1:0]),
  `ifdef DECODER_4bit
    .l2paOut_bit3_o (trial7_q4_l2paOut_bit3_o[TRIAL7-1:0]),
  `endif // DECODER_4bit
    .l1paOut_bit2_i (trial7_q4_l1paOut_bit2_i),
    .l1paOut_bit1_i (trial7_q4_l1paOut_bit1_i),
    .l1paOut_bit0_i (trial7_q4_l1paOut_bit0_i),
  `ifdef DECODER_4bit
    .l1paOut_bit3_i (trial7_q4_l1paOut_bit3_i),
  `endif // DECODER_4bit
    .isMsgPass_i (isMsgPass_i),
    .shiftROM_load_en_i (trial7_q4_shiftROM_load_en_i[TRIAL7-1:0]),
    .rstn (rstn),
    .sys_clk  (sys_clk)
  );
l2pa_logic #(
    .SHIFT_LENGTH (TRIAL8),
    .QUAN_SIZE (QUAN_SIZE)
) l2pa_strideWidth_153 (
    .l2paOut_bit2_o (trial8_q4_l2paOut_bit2_o[TRIAL8-1:0]),
    .l2paOut_bit1_o (trial8_q4_l2paOut_bit1_o[TRIAL8-1:0]),
    .l2paOut_bit0_o (trial8_q4_l2paOut_bit0_o[TRIAL8-1:0]),
  `ifdef DECODER_4bit
    .l2paOut_bit3_o (trial8_q4_l2paOut_bit3_o[TRIAL8-1:0]),
  `endif // DECODER_4bit
    .l1paOut_bit2_i (trial8_q4_l1paOut_bit2_i),
    .l1paOut_bit1_i (trial8_q4_l1paOut_bit1_i),
    .l1paOut_bit0_i (trial8_q4_l1paOut_bit0_i),
  `ifdef DECODER_4bit
    .l1paOut_bit3_i (trial8_q4_l1paOut_bit3_i),
  `endif // DECODER_4bit
    .isMsgPass_i (isMsgPass_i),
    .shiftROM_load_en_i (trial8_q4_shiftROM_load_en_i[TRIAL8-1:0]),
    .rstn (rstn),
    .sys_clk  (sys_clk)
  );
l2pa_logic #(
    .SHIFT_LENGTH (TRIAL9),
    .QUAN_SIZE (QUAN_SIZE)
) l2pa_strideWidth_255 (
    .l2paOut_bit2_o (trial9_q4_l2paOut_bit2_o[TRIAL9-1:0]),
    .l2paOut_bit1_o (trial9_q4_l2paOut_bit1_o[TRIAL9-1:0]),
    .l2paOut_bit0_o (trial9_q4_l2paOut_bit0_o[TRIAL9-1:0]),
  `ifdef DECODER_4bit
    .l2paOut_bit3_o (trial9_q4_l2paOut_bit3_o[TRIAL9-1:0]),
  `endif // DECODER_4bit
    .l1paOut_bit2_i (trial9_q4_l1paOut_bit2_i),
    .l1paOut_bit1_i (trial9_q4_l1paOut_bit1_i),
    .l1paOut_bit0_i (trial9_q4_l1paOut_bit0_i),
  `ifdef DECODER_4bit
    .l1paOut_bit3_i (trial9_q4_l1paOut_bit3_i),
  `endif // DECODER_4bit
    .isMsgPass_i (isMsgPass_i),
    .shiftROM_load_en_i (trial9_q4_shiftROM_load_en_i[TRIAL9-1:0]),
    .rstn (rstn),
    .sys_clk  (sys_clk)
  );
endmodule

 