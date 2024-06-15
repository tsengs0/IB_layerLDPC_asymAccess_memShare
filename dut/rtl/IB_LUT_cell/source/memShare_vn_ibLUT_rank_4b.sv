// Project: IB-RAM implementation for the IB-RAM column-bank sharing scheme
// File: memShare_vn_ibLUT_rank_4b.sv
// Module: memShare_vn_ibLUT_rank_4b
// Developer: Bo-Yu Tseng
// Email: tsengs0@gamil.com
//
// # Description
// A wrapper of IB-RAM blocks gathers the memory instances for all VNs in a share group.

// # Dependencies
// memShare_config_pkg.sv
// ibRAM_config_pkg.sv

// # Resource utilisation:
// Xilinx:
//  6-input logic LUT: 1
//  6-input LUTRAM: 56
//  FF: 0
// ----------------------------------------------------------------------------------------
//  # History
//  Date            Revision    Description                 Editor
//  9.June.2024     v0.01       First created               Bo-Yu Tseng
// ----------------------------------------------------------------------------------------

`ifdef MEMSHARE_VN_IBRAM_BANK_INTERLEAVE
module memShare_vn_ibLUT_rank_4b
    import memShare_config_pkg::*;
    import ibRAM_config_pkg::*;
#(
    // Choose the max(GP1_COL_SEL_WIDTH, GP2_COL_SEL_WIDTH) for each element in a rank
    // zero padding for GP1 element whilst exact fit for GP2 element
    parameter RANK_COL_ADDR_WIDTH = GP2_COL_SEL_WIDTH*SHARE_GROUP_SIZE,

    parameter BANK_INTERLEAVE_EN = 1
)(
    output logic [(QUAN_SIZE*SHARE_GROUP_SIZE)-1:0] v2c_msg_vec_o,

    input logic [RANK_COL_ADDR_WIDTH-1:0] memShare_colSel_vec_i, // Bit width based on the 
    input logic [(QUAN_SIZE*SHARE_GROUP_SIZE)-1:0] c2v_msg_vec_i,
    input logic [(Q4_BI4_WDATA_SIZE*SHARE_GROUP_SIZE)-1:0] remap_dataIn_vec_i,
    input logic nRemap_en_i, // active LOW
    input logic read_clk,
    input logic write_clk,
    input logic rstn // active LOW
);

// ----------------------------------------------------------------------------------
// Local nets, parameters, etc.
// ----------------------------------------------------------------------------------
logic [QUAN_SIZE-1:0] v2c_msg_out [0:SHARE_GROUP_SIZE-1];
logic [GP2_RAM_ADDR_WIDTH-1:0] ib_ram_addr [0:SHARE_GROUP_SIZE-1]; // To choose the max(GP1_COL_SEL_WIDTH, GP2_COL_SEL_WIDTH)
logic [Q4_BI4_WDATA_SIZE-1:0] remap_dataIn [0:SHARE_GROUP_SIZE-1];
// ----------------------------------------------------------------------------------
// Share group wrapper
// ----------------------------------------------------------------------------------
genvar group_id;
generate;
for(group_id=0; group_id<SHARE_GROUP_SIZE; group_id=group_id+1) begin: share_group_wrapper
    if(SHARE_COL_CONFIG[group_id]==1) begin // VN configured as GP2 IB-RAM
        memShare_vn_ibLUT_multibank_4b # (
            .SHARE_GROUP(2),
            .ADDR_WIDTH(ibRAM_config_pkg::Q4_BI4_ADDR_WIDTH),
            .VN_LOAD_CYCLE(GP2_VN_LOAD_CYCLE),
            .MSG_WIDTH(QUAN_SIZE),
            .REMAP_DATAIN_WIDTH (ibRAM_config_pkg::Q4_BI4_WDATA_SIZE),
            .BANK_INTERLEAVE_NUM (ibRAM_config_pkg::Q4_BI4_BANK_INTERLEAVE_NUM)
        ) vn_ib_ram (
            .msgOut_o(v2c_msg_out[group_id][QUAN_SIZE-1:0]),
            .remap_dataIn_i(remap_dataIn[group_id][Q4_BI4_WDATA_SIZE-1:0]),
            .map_remap_addr_i(ib_ram_addr[group_id][GP2_RAM_ADDR_WIDTH-1:0]),
            .remap_en_n(nRemap_en_i),
            .sys_clk(read_clk),
            .rstn(rstn)
        );
    end
    else begin // VN configured as GP1 IB-RAM
        memShare_vn_ibLUT_multibank_4b # (
            .SHARE_GROUP(1),
            .ADDR_WIDTH(ibRAM_config_pkg::Q4_BI2_ADDR_WIDTH),
            .VN_LOAD_CYCLE(GP1_VN_LOAD_CYCLE),
            .MSG_WIDTH(QUAN_SIZE),
            .REMAP_DATAIN_WIDTH (ibRAM_config_pkg::Q4_BI2_WDATA_SIZE),
            .BANK_INTERLEAVE_NUM (ibRAM_config_pkg::Q4_BI2_BANK_INTERLEAVE_NUM)
        ) vn_ib_ram (
            .msgOut_o(v2c_msg_out[group_id][QUAN_SIZE-1:0]),
            .remap_dataIn_i(remap_dataIn[group_id][Q4_BI4_WDATA_SIZE-1:0]),
            .map_remap_addr_i(ib_ram_addr[group_id][GP1_RAM_ADDR_WIDTH-1:0]),
            .remap_en_n(nRemap_en_i),
            .sys_clk(read_clk),
            .rstn(rstn)
        );
    end

    assign ib_ram_addr[group_id][GP2_RAM_ADDR_WIDTH-1:0] = {
        memShare_colSel_vec_i[(group_id+1)*GP2_COL_SEL_WIDTH-1:group_id*GP2_COL_SEL_WIDTH],
        c2v_msg_vec_i[(group_id+1)*QUAN_SIZE-1:group_id*QUAN_SIZE]
    };
    assign v2c_msg_vec_o[(group_id+1)*QUAN_SIZE-1:group_id*QUAN_SIZE] = v2c_msg_out[group_id][QUAN_SIZE-1:0];
    assign remap_dataIn[group_id][Q4_BI4_WDATA_SIZE-1:0] = remap_dataIn_vec_i[(group_id+1)*Q4_BI4_WDATA_SIZE-1:group_id*Q4_BI4_WDATA_SIZE];
end
endgenerate
endmodule
`else // MEMSHARE_VN_IBRAM_BANK_INTERLEAVE not defined
module memShare_vn_ibLUT_rank_4b
    import memShare_config_pkg::*;
#(
    // Choose the max(GP1_COL_SEL_WIDTH, GP2_COL_SEL_WIDTH) for each element in a rank
    // zero padding for GP1 element whilst exact fit for GP2 element
    parameter RANK_COL_ADDR_WIDTH = GP2_COL_SEL_WIDTH*SHARE_GROUP_SIZE,

    parameter BANK_INTERLEAVE_EN = 1
)(
    output logic [(QUAN_SIZE*SHARE_GROUP_SIZE)-1:0] v2c_msg_vec_o,

    input logic [RANK_COL_ADDR_WIDTH-1:0] memShare_colSel_vec_i, // Bit width based on the 
    input logic [(QUAN_SIZE*SHARE_GROUP_SIZE)-1:0] c2v_msg_vec_i,
    input logic [(QUAN_SIZE*SHARE_GROUP_SIZE)-1:0] remap_dataIn_vec_i,
    input logic nRemap_en_i, // active LOW
    input logic read_clk,
    input logic write_clk,
    input logic rstn // active LOW
);

// ----------------------------------------------------------------------------------
// Local nets, parameters, etc.
// ----------------------------------------------------------------------------------
logic [QUAN_SIZE-1:0] v2c_msg_out [0:SHARE_GROUP_SIZE-1];
logic [GP2_RAM_ADDR_WIDTH-1:0] ib_ram_addr [0:SHARE_GROUP_SIZE-1]; // To choose the max(GP1_COL_SEL_WIDTH, GP2_COL_SEL_WIDTH)
logic [QUAN_SIZE-1:0] remap_dataIn [0:SHARE_GROUP_SIZE-1];
// ----------------------------------------------------------------------------------
// Share group wrapper
// ----------------------------------------------------------------------------------
genvar group_id;
generate;
for(group_id=0; group_id<SHARE_GROUP_SIZE; group_id=group_id+1) begin: share_group_wrapper
    if(SHARE_COL_CONFIG[group_id]==1) begin // VN configured as GP2 IB-RAM
        memShare_vn_ibLUT # (
            .ADDR_WIDTH(GP2_RAM_ADDR_WIDTH),
            .VN_LOAD_CYCLE(GP2_VN_LOAD_CYCLE),
            .MSG_WIDTH(QUAN_SIZE),
            .SHARE_GROUP(2)
        ) vn_ib_ram (
            .msgOut_o(v2c_msg_out[group_id][QUAN_SIZE-1:0]),
            .remap_dataIn_i(remap_dataIn[group_id][QUAN_SIZE-1:0]),
            .map_remap_addr_i(ib_ram_addr[group_id][GP2_RAM_ADDR_WIDTH-1:0]),
            .remap_en_n(nRemap_en_i),
            .sys_clk(read_clk),
            .rstn(rstn)
        );
    end
    else begin // VN configured as GP1 IB-RAM
        memShare_vn_ibLUT # (
            .ADDR_WIDTH(GP1_RAM_ADDR_WIDTH),
            .VN_LOAD_CYCLE(GP1_VN_LOAD_CYCLE),
            .MSG_WIDTH(QUAN_SIZE),
            .SHARE_GROUP(1)
        ) vn_ib_ram (
            .msgOut_o(v2c_msg_out[group_id][QUAN_SIZE-1:0]),
            .remap_dataIn_i(remap_dataIn[group_id][QUAN_SIZE-1:0]),
            .map_remap_addr_i(ib_ram_addr[group_id][GP1_RAM_ADDR_WIDTH-1:0]),
            .remap_en_n(nRemap_en_i),
            .sys_clk(read_clk),
            .rstn(rstn)
        );
    end

    assign ib_ram_addr[group_id][GP2_RAM_ADDR_WIDTH-1:0] = {
        memShare_colSel_vec_i[(group_id+1)*GP2_COL_SEL_WIDTH-1:group_id*GP2_COL_SEL_WIDTH],
        c2v_msg_vec_i[(group_id+1)*QUAN_SIZE-1:group_id*QUAN_SIZE]
    };
    assign v2c_msg_vec_o[(group_id+1)*QUAN_SIZE-1:group_id*QUAN_SIZE] = v2c_msg_out[group_id][QUAN_SIZE-1:0];
    assign remap_dataIn[group_id][QUAN_SIZE-1:0] = remap_dataIn_vec_i[(group_id+1)*QUAN_SIZE-1:group_id*QUAN_SIZE];
end
endgenerate
endmodule
`endif // MEMSHARE_VN_IBRAM_BANK_INTERLEAVE
