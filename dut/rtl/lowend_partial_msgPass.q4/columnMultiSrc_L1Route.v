/**
* Created date:
* Developer: Bo-Yu Tseng
* Email: tsengs0@gmail.com
* Module name: columnSingleSrc_L1Route

* # I/F
* 1) Output:

* 2) Input:
*
* # Param
*
* # Description
* To perform the (base matrix) column-wise 1st-level circular shifting opertion for passing CNU outgoing messages
* # Dependencies
*   1) devine.vh -> quantisatin bit with of messages
**/
`include "define.vh"
module columnMultiSrc_L1Route #(
  parameter QUAN_SIZE = 3,
  parameter STRIDE_UNIT_SIZE = 51,
  parameter STRIDE_WIDTH = 5,
  parameter BITWIDTH_SHIFT_FACTOR = $clog2(STRIDE_UNIT_SIZE-1)
) (
  //--------------
  // Output ports
  //--------------
  // Stride group 0
  output wire [STRIDE_UNIT_SIZE-1:0] stride0_out_bit0_o,
  output wire [STRIDE_UNIT_SIZE-1:0] stride0_out_bit1_o,
  output wire [STRIDE_UNIT_SIZE-1:0] stride0_out_bit2_o,
  // Stride group 1
  output wire [STRIDE_UNIT_SIZE-1:0] stride1_out_bit0_o,
  output wire [STRIDE_UNIT_SIZE-1:0] stride1_out_bit1_o,
  output wire [STRIDE_UNIT_SIZE-1:0] stride1_out_bit2_o,
  // Stride group 2
  output wire [STRIDE_UNIT_SIZE-1:0] stride2_out_bit0_o,
  output wire [STRIDE_UNIT_SIZE-1:0] stride2_out_bit1_o,
  output wire [STRIDE_UNIT_SIZE-1:0] stride2_out_bit2_o,
  // Stride group 3
  output wire [STRIDE_UNIT_SIZE-1:0] stride3_out_bit0_o,
  output wire [STRIDE_UNIT_SIZE-1:0] stride3_out_bit1_o,
  output wire [STRIDE_UNIT_SIZE-1:0] stride3_out_bit2_o,
  // Stride group 4
  output wire [STRIDE_UNIT_SIZE-1:0] stride4_out_bit0_o,
  output wire [STRIDE_UNIT_SIZE-1:0] stride4_out_bit1_o,
  output wire [STRIDE_UNIT_SIZE-1:0] stride4_out_bit2_o,
  `ifdef DECODER_4bit
    output wire [STRIDE_UNIT_SIZE-1:0] stride0_out_bit3_o,
    output wire [STRIDE_UNIT_SIZE-1:0] stride1_out_bit3_o,
    output wire [STRIDE_UNIT_SIZE-1:0] stride2_out_bit3_o,
    output wire [STRIDE_UNIT_SIZE-1:0] stride3_out_bit3_o,
    output wire [STRIDE_UNIT_SIZE-1:0] stride4_out_bit3_o,
  `endif
  //--------------
  // Input ports
  //--------------
  // Stride group 0
  input wire [STRIDE_UNIT_SIZE-1:0] stride0_in0_bit0_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride0_in0_bit1_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride0_in0_bit2_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride0_in1_bit0_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride0_in1_bit1_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride0_in1_bit2_i,

  // Stride group 1
  input wire [STRIDE_UNIT_SIZE-1:0] stride1_in0_bit0_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride1_in0_bit1_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride1_in0_bit2_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride1_in1_bit0_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride1_in1_bit1_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride1_in1_bit2_i,

  // Stride group 2
  input wire [STRIDE_UNIT_SIZE-1:0] stride2_in0_bit0_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride2_in0_bit1_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride2_in0_bit2_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride2_in1_bit0_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride2_in1_bit1_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride2_in1_bit2_i,
  // Stride group 3
  input wire [STRIDE_UNIT_SIZE-1:0] stride3_in0_bit0_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride3_in0_bit1_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride3_in0_bit2_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride3_in1_bit0_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride3_in1_bit1_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride3_in1_bit2_i,
  // Stride group 4
  input wire [STRIDE_UNIT_SIZE-1:0] stride4_in0_bit0_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride4_in0_bit1_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride4_in0_bit2_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride4_in1_bit0_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride4_in1_bit1_i,
  input wire [STRIDE_UNIT_SIZE-1:0] stride4_in1_bit2_i,
  `ifdef DECODER_4bit
    input wire [STRIDE_UNIT_SIZE-1:0] stride0_in0_bit3_i,
    input wire [STRIDE_UNIT_SIZE-1:0] stride1_in0_bit3_i,
    input wire [STRIDE_UNIT_SIZE-1:0] stride2_in0_bit3_i,
    input wire [STRIDE_UNIT_SIZE-1:0] stride3_in0_bit3_i,
    input wire [STRIDE_UNIT_SIZE-1:0] stride4_in0_bit3_i,

    input wire [STRIDE_UNIT_SIZE-1:0] stride0_in1_bit3_i,
    input wire [STRIDE_UNIT_SIZE-1:0] stride1_in1_bit3_i,
    input wire [STRIDE_UNIT_SIZE-1:0] stride2_in1_bit3_i,
    input wire [STRIDE_UNIT_SIZE-1:0] stride3_in1_bit3_i,
    input wire [STRIDE_UNIT_SIZE-1:0] stride4_in1_bit3_i,
  `endif

  // Control signals
  input wire sw_in_src_i, // input source selector for barrel shifters
  input wire [BITWIDTH_SHIFT_FACTOR-1:0] stride0_shift_factor_i,
  input wire [BITWIDTH_SHIFT_FACTOR-1:0] stride1_shift_factor_i,
  input wire [BITWIDTH_SHIFT_FACTOR-1:0] stride2_shift_factor_i,
  input wire [BITWIDTH_SHIFT_FACTOR-1:0] stride3_shift_factor_i,
  input wire [BITWIDTH_SHIFT_FACTOR-1:0] stride4_shift_factor_i,
  input wire sys_clk,
  input wire rstn
);

localparam LEFT_SEL_WIDTH = $clog2(STRIDE_UNIT_SIZE);
localparam RIGHT_SEL_WIDTH = $clog2(STRIDE_UNIT_SIZE);
//--------------------------
// Net and reg declarations
//--------------------------
wire [STRIDE_UNIT_SIZE-1:0] shared_sw_in_bit0_stride [0:STRIDE_WIDTH-1];
wire [STRIDE_UNIT_SIZE-1:0] shared_sw_in_bit1_stride [0:STRIDE_WIDTH-1];
wire [STRIDE_UNIT_SIZE-1:0] shared_sw_in_bit2_stride [0:STRIDE_WIDTH-1];
wire [BITWIDTH_SHIFT_FACTOR-1:0] shift_factor_stride [0:STRIDE_WIDTH-1];
`ifdef DECODER_4bit
  wire [STRIDE_UNIT_SIZE-1:0] shared_sw_in_bit3_stride [0:STRIDE_WIDTH-1];
`endif
wire [STRIDE_UNIT_SIZE-1:0] sw_out_bit [0:STRIDE_WIDTH-1][0:QUAN_SIZE-1];
genvar stride_unit_id;
generate
  for(stride_unit_id=0; stride_unit_id<STRIDE_WIDTH; stride_unit_id=stride_unit_id+1) begin : strideBs_group_inst
    wire [LEFT_SEL_WIDTH-1:0]  left_sel;
    wire [RIGHT_SEL_WIDTH-1:0]  right_sel;
    wire [STRIDE_UNIT_SIZE-2:0] merge_sel;
    qsn_top_len51 vnu_qsn_top_len51_u0 (
      .sw_out_bit0 (sw_out_bit[stride_unit_id][0]),
      .sw_out_bit1 (sw_out_bit[stride_unit_id][1]),
      .sw_out_bit2 (sw_out_bit[stride_unit_id][2]),
    `ifdef DECODER_4bit
      .sw_out_bit3 (sw_out_bit[stride_unit_id][3]),
    `endif

      .sys_clk     (sys_clk),
      .rstn    (rstn),

      .sw_in_bit0  (shared_sw_in_bit0_stride[stride_unit_id]),
      .sw_in_bit1  (shared_sw_in_bit1_stride[stride_unit_id]),
      .sw_in_bit2  (shared_sw_in_bit2_stride[stride_unit_id]),
      `ifdef DECODER_4bit
        .sw_in_bit3  (shared_sw_in_bit3_stride[stride_unit_id]),
      `endif

      .left_sel    (left_sel),
      .right_sel   (right_sel),
      .merge_sel   (merge_sel)
    );

    qsn_controller_len51 #(
      .PERMUTATION_LENGTH(STRIDE_UNIT_SIZE)
    ) vnu_qsn_controller_len51_u0 (
      .left_sel     (left_sel ),
      .right_sel    (right_sel),
      .merge_sel    (merge_sel),
      .shift_factor (shift_factor_stride[stride_unit_id]), // offset shift factor of submatrix_1
      .rstn         (rstn),
      .sys_clk      (sys_clk)
    );
  end
endgenerate
//------------------------------------------------------------------------------
// Glue logic of multiplexing between two input sources to barrel shifters
//------------------------------------------------------------------------------
// Stride group 0
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride0_shared_sw_in_bit0 (.sw_out(shared_sw_in_bit0_stride[/*stride0*/0]), .sw_in_0(stride0_in0_bit0_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride0_in1_bit0_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride0_shared_sw_in_bit1 (.sw_out(shared_sw_in_bit1_stride[/*stride0*/0]), .sw_in_0(stride0_in0_bit1_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride0_in1_bit1_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride0_shared_sw_in_bit2 (.sw_out(shared_sw_in_bit2_stride[/*stride0*/0]), .sw_in_0(stride0_in0_bit2_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride0_in1_bit2_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
`ifdef DECODER_4bit
  scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride0_shared_sw_in_bit3 (.sw_out(shared_sw_in_bit3_stride[/*stride0*/0]), .sw_in_0(stride0_in0_bit3_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride0_in1_bit3_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
`endif

// Stride group 1
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride1_shared_sw_in_bit0 (.sw_out(shared_sw_in_bit0_stride[/*stride0*/1]), .sw_in_0(stride1_in0_bit0_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride1_in1_bit0_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride1_shared_sw_in_bit1 (.sw_out(shared_sw_in_bit1_stride[/*stride0*/1]), .sw_in_0(stride1_in0_bit1_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride1_in1_bit1_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride1_shared_sw_in_bit2 (.sw_out(shared_sw_in_bit2_stride[/*stride0*/1]), .sw_in_0(stride1_in0_bit2_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride1_in1_bit2_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
`ifdef DECODER_4bit
  scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride1_shared_sw_in_bit3 (.sw_out(shared_sw_in_bit3_stride[/*stride0*/1]), .sw_in_0(stride1_in0_bit3_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride1_in1_bit3_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
`endif

// Stride group 2
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride2_shared_sw_in_bit0 (.sw_out(shared_sw_in_bit0_stride[/*stride0*/2]), .sw_in_0(stride2_in0_bit0_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride2_in1_bit0_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride2_shared_sw_in_bit1 (.sw_out(shared_sw_in_bit1_stride[/*stride0*/2]), .sw_in_0(stride2_in0_bit1_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride2_in1_bit1_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride2_shared_sw_in_bit2 (.sw_out(shared_sw_in_bit2_stride[/*stride0*/2]), .sw_in_0(stride2_in0_bit2_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride2_in1_bit2_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
`ifdef DECODER_4bit
  scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride2_shared_sw_in_bit3 (.sw_out(shared_sw_in_bit3_stride[/*stride0*/2]), .sw_in_0(stride2_in0_bit3_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride2_in1_bit3_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
`endif

// Stride group 3
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride3_shared_sw_in_bit0 (.sw_out(shared_sw_in_bit0_stride[/*stride0*/3]), .sw_in_0(stride3_in0_bit0_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride3_in1_bit0_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride3_shared_sw_in_bit1 (.sw_out(shared_sw_in_bit1_stride[/*stride0*/3]), .sw_in_0(stride3_in0_bit1_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride3_in1_bit1_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride3_shared_sw_in_bit2 (.sw_out(shared_sw_in_bit2_stride[/*stride0*/3]), .sw_in_0(stride3_in0_bit2_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride3_in1_bit2_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
`ifdef DECODER_4bit
  scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride3_shared_sw_in_bit3 (.sw_out(shared_sw_in_bit3_stride[/*stride0*/3]), .sw_in_0(stride3_in0_bit3_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride3_in1_bit3_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
`endif

// Stride group 4
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride4_shared_sw_in_bit0 (.sw_out(shared_sw_in_bit0_stride[/*stride0*/4]), .sw_in_0(stride4_in0_bit0_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride4_in1_bit0_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride4_shared_sw_in_bit1 (.sw_out(shared_sw_in_bit1_stride[/*stride0*/4]), .sw_in_0(stride4_in0_bit1_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride4_in1_bit1_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride4_shared_sw_in_bit2 (.sw_out(shared_sw_in_bit2_stride[/*stride0*/4]), .sw_in_0(stride4_in0_bit2_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride4_in1_bit2_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
`ifdef DECODER_4bit
  scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride4_shared_sw_in_bit3 (.sw_out(shared_sw_in_bit3_stride[/*stride0*/4]), .sw_in_0(stride4_in0_bit3_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride4_in1_bit3_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
`endif
//------------------------------------------------------------------------------
// Stride group 0~(`QUAN_SIZE-1)
// Nets as input sources to circular shifters
assign shift_factor_stride[0] = stride0_shift_factor_i[BITWIDTH_SHIFT_FACTOR-1:0];
assign shift_factor_stride[1] = stride1_shift_factor_i[BITWIDTH_SHIFT_FACTOR-1:0];
assign shift_factor_stride[2] = stride2_shift_factor_i[BITWIDTH_SHIFT_FACTOR-1:0];
assign shift_factor_stride[3] = stride3_shift_factor_i[BITWIDTH_SHIFT_FACTOR-1:0];
assign shift_factor_stride[4] = stride4_shift_factor_i[BITWIDTH_SHIFT_FACTOR-1:0];
// Nets as output sources from circular shifters
assign stride0_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_0*/0][0];
assign stride0_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_0*/0][1];
assign stride0_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_0*/0][2];
assign stride1_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_1*/1][0];
assign stride1_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_1*/1][1];
assign stride1_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_1*/1][2];
assign stride2_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_2*/2][0];
assign stride2_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_2*/2][1];
assign stride2_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_2*/2][2];
assign stride3_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_3*/3][0];
assign stride3_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_3*/3][1];
assign stride3_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_3*/3][2];
assign stride4_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_4*/4][0];
assign stride4_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_4*/4][1];
assign stride4_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_4*/4][2];
`ifdef DECODER_4bit
  assign sw_in_bit3_stride[0] = stride0_bit3_i[STRIDE_UNIT_SIZE-1:0];
  assign sw_in_bit3_stride[1] = stride1_bit3_i[STRIDE_UNIT_SIZE-1:0];
  assign sw_in_bit3_stride[2] = stride2_bit3_i[STRIDE_UNIT_SIZE-1:0];
  assign sw_in_bit3_stride[3] = stride3_bit3_i[STRIDE_UNIT_SIZE-1:0];
  assign sw_in_bit3_stride[4] = stride4_bit3_i[STRIDE_UNIT_SIZE-1:0];
  assign stride0_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_0*/0][3];
  assign stride1_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_1*/1][3];
  assign stride2_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_2*/2][3];
  assign stride3_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_3*/3][3];
  assign stride4_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_4*/4][3];
`endif
endmodule