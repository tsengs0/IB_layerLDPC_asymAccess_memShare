// Project: IB-RAM implementation for the IB-RAM column-bank sharing scheme
// File: memShare_vn_group.sv
// Module: memShare_vn_group
// Developer: Bo-Yu Tseng
// Email: tsengs0@gamil.com
//
// # Description
// A wrapper module which represents the shared group of W^{s} VNUs

// # Dependencies
// 	ibRAM_config_pkg.sv

// # Resource utilisation:
// Xilinx:
//  6-input logic LUT: 
//  6-input LUTRAM:
//  FF: 
// ----------------------------------------------------------------------------------------
//  # History
//  Date            Revision    Description                 Editor
//  16.July.2024   v0.01       First created               Bo-Yu Tseng
// ----------------------------------------------------------------------------------------

module memShare_vn_group
    import memShare_config_pkg::*;
#(
    parameter V2C_WIDTH = MSGPASS_BUFF_RQST_WIDTH,
    parameter V2C_VEC_WIDTH = SHARE_GROUP_SIZE*V2C_WIDTH,
    parameter C2V_WIDTH = MSGPASS_BUFF_RQST_WIDTH,
    parameter C2V_VEC_WIDTH = SHARE_GROUP_SIZE*C2V_WIDTH,
    parameter V2C_SIGN_BUF_DEPTH = 2,

    // Choose the max(GP1_COL_SEL_WIDTH, GP2_COL_SEL_WIDTH) for each element in a rank
    // zero padding for GP1 element whilst exact fit for GP2 element
    parameter RANK_COL_ADDR_WIDTH = GP2_COL_SEL_WIDTH*SHARE_GROUP_SIZE,
    parameter IBRAM_REMAP_VEC_WIDTH = QUAN_SIZE*SHARE_GROUP_SIZE
)(
    output logic [V2C_VEC_WIDTH-1:0] v2c_msg_vec_o, // Intermediate/final V2C vector

    // The shifted messages from L2PA where the shifter is controlled by the SCU.memShare() 
    input logic [SHARE_GROUP_SIZE-1]:0] shifted_v2c_sign_vec_i,
    input logc [C2V_ADDR_VEC_WIDTH-1:0] shifted_c2v_v2c_i

    // I/F of the IB-RAM rank
    input logic [RANK_COL_ADDR_WIDTH-1:0] memShare_colSel_vec_i, // Bit width based on the 
    input logic [IBRAM_REMAP_VEC_WIDTH-1:0] remap_dataIn_vec_i,
    input logic nRemap_en_i, // active LOW

    input logic read_clk,
    input logic write_clk,
    input rstn // active LOW
);

genvar rqst_id;
//---------------------------------------------------------------
// Datapath stage 0: 
// Symmetry-aware conversion of the row addresses according to
// the given check-to-variable messages
//---------------------------------------------------------------
logic [C2V_WIDTH-1:0] row_addr_vec_dp0 [0:SHARE_GROUP_SIZE-1];
logic [C2V_VEC_WIDTH-1:0] symConv_rowAddr_vec_dp0;
generate;
for(rqst_id=0; rqst_id<SHARE_GROUP_SIZE; rqst_id=rqst_id+1) begin: c2v_symConv_rank
    ibLUT_c2v_symConv # (.MSG_WIDTH(C2V_WIDTH)) ibLUT_c2v_symConv (
        .symConv_msg_o  (symConv_rowAddr_vec_dp0[(rqst_id+1)*C2V_WIDTH-1:rqst*C2V_WIDTH]),
        .raw_v2c_sign_i (shifted_v2c_sign_vec_i[rqst_id]),
        .raw_c2v_msg_i  (row_addr_vec[rqst_id])
    );
    assign row_addr_vec_dp0[rqst_id] = shifted_c2v_v2c_i[(rqst_id+1)*C2V_WIDTH-1:rqst*C2V_WIDTH];
end
endgenerate

// Buffering the sign bits of channel messages or intermediate V2C messages for 
// subsequent symmetry-to-Integer conversion at the last datapath stage
logic [SHARE_GROUP_SIZE-1:0] v2c_signVec_bufferRD;
pipeReg_insert # (
    .BITWIDTH(SHARE_GROUP_SIZE),
    .PIPELINE_STAGE(V2C_SIGN_BUF_DEPTH)
) shift_v2c_sign_buffer (
    .pipe_reg_o    (v2c_signVec_bufferRD[SHARE_GROUP_SIZE-1:0]),
    .sig_net_i     (shifted_v2c_sign_vec_i[SHARE_GROUP_SIZE-1:0]),
    .pipeLoad_en_i (1'b1),
    .sys_clk       (read_clk),
    .rstn          (rstn)
);
//---------------------------------------------------------------
// Datapath stage 1: 
// IB-LUT mapping operation
//---------------------------------------------------------------
logic [V2C_VEC_WIDTH-1:0] v2c_msg_vec_dp1; // "dp": DataPath
memShare_vn_ibLUT_rank_4b # (
    .RANK_COL_ADDR_WIDTH(RANK_COL_WIDTH),
    .BANK_INTERLEAVE_EN(0)
) memblk (
    .v2c_msg_vec_o(v2c_msg_vec_dp1),
    .memShare_colSel_vec_i(memShare_colSel_vec_i),
    .c2v_msg_vec_i(symConv_rowAddr_vec_dp0),
    .remap_dataIn_vec_i(remap_dataIn_vec_i),
    .nRemap_en_i(nRemap_en_i),
    .read_clk(read_clk),
    .write_clk(write_clk),
    .rstn(rstn)
);
//---------------------------------------------------------------
// Datapath stage 2:
// Symmetricy-to-Integer (signed) conversion to recover the format
// of the permuted V2C message from the the L2PA
//---------------------------------------------------------------
logic [V2C_WIDTH-1:0] map_v2c_vec_dp2 [0:SHARE_GROUP_SIZE-1];
logic [V2C_VEC_WIDTH-1:0] sym2int_v2c_vec_dp2;
generate;
for(rqst_id=0; rqst_id<SHARE_GROUP_SIZE; rqst_id=rqst_id+1) begin: v2c_sym2int_rank
    ibLUT_v2c_sym2int # (.MSG_WIDTH(V2C_WIDTH)) ibLUT_v2c_sym2int (
        .sym2int_msg_o  (sym2int_v2c_vec_dp2[(rqst_id+1)*V2C_WIDTH-1:rqst_id*V2C_WIDTH]),
        .raw_v2c_sign_i (v2c_signVec_bufferRD[rqst_id]),
        .map_v2c_i      (map_v2c_vec_dp2[rqst_id])
    );
    assign map_v2c_vec_dp2[rqst_id] = v2c_msg_vec_dp1[(rqst_id+1)*V2C_WIDTH-1:rqst_id*V2C_WIDTH];
end
endgenerate

//---------------------------------------------------------------
// Output port(s)
//---------------------------------------------------------------
assign v2c_msg_vec_o[V2C_VEC_WIDTH-1:0] = sym2int_v2c_vec_dp2[V2C_VEC_WIDTH-1:0];
endmodule
