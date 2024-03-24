`timescale 1ns/1ps
/**
* Latest date: 21st May., 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: share2to5_vn_lut_merge2
* 
* # I/F
* 1) Output:
        lut_data0_o
        lut_data1_o
        lut_data2_o
        lut_data3_o
        lut_data4_o
* 2) Input:
        read_addr0_i
        read_addr1_i
        read_addr2_i
        read_addr3_i
        read_addr4_i
        gp1_write_addr_i
        gp2_write_addr_i
        gp1_lut_in_i
        gp2_lut_in_i
        we_i
        read_clk
        write_clk
        rstn
* # Param
    // Basic configuration of memory cells
        QUAN_SIZE
        BANK_INTERLEAVE
        PRELOAD_SET_NUM. The number of preload sets stored in the underlying memory cell
        GP1_RD_ADDR_WIDTH
        GP1_WR_ADDR_WIDTH
        GP1_WR_WIDTH
        GP1_ENTRY_NUM
        GP2_RD_ADDR_WIDTH
        GP2_WR_ADDR_WIDTH
        GP2_WR_WIDTH.
        GP2_ENTRY_NUM.

    // Configuration of shared column
        GROUP_NUM. Shared group size
        SHARE_COL_CONFIG.'1': shared column
        RD_ADDR4_WIDTH
        RD_ADDR3_WIDTH
        RD_ADDR2_WIDTH
        RD_ADDR1_WIDTH
        RD_ADDR0_WIDTH
* # Description

* # Dependencies
*
* # Remark
		LUT: ?      (PRELOAD_SET_NUM=2); 32 (PRELOAD_SET_NUM=1) 
        Logic LUT: 0 (PRELOAD_SET_NUM=2); 0  (PRELOAD_SET_NUM=1) 
        LUTRAM: ?   (PRELOAD_SET_NUM=2); 32 (PRELOAD_SET_NUM=1) -> it is notable that each of them costs 4 LUTRAMs. 
		FF: 0        (PRELOAD_SET_NUM=2); 0  (PRELOAD_SET_NUM=1) 
        I/O: ?      (PRELOAD_SET_NUM=2); 50 (PRELOAD_SET_NUM=1) 
        Freq: 400MHz
        WNS:  ns
        TNS:  ns
        WHS:  ns
        THS:  ns
        WPWS: ns
        TPWS: ns
**/
module share2to5_vn_lut_F0F1merge_3b #(
    // Basic configuration of memory cells
    parameter QUAN_SIZE = 3,
    parameter BANK_INTERLEAVE = 1,
    parameter PRELOAD_SET_NUM = 1, //! The number of preload sets stored in the underlying memory cell
    parameter GP1_RD_ADDR_WIDTH = 5,
    parameter GP1_WR_ADDR_WIDTH = 5,
    parameter GP1_WR_WIDTH = QUAN_SIZE*BANK_INTERLEAVE,
    parameter GP1_ENTRY_NUM = (8*2*2), // To merge decomposed 2-input IB-LUT f0 and f1
    parameter GP2_RD_ADDR_WIDTH = 6,
    parameter GP2_WR_ADDR_WIDTH = 6,
    parameter GP2_WR_WIDTH = QUAN_SIZE*BANK_INTERLEAVE,
    parameter GP2_ENTRY_NUM = (8*4*2), // To merge decomposed 2-input IB-LUT f0 and f1

    // Configuration of shared column
    parameter GROUP_NUM = 5, //! Shared group size
    parameter [GROUP_NUM-1:0] SHARE_COL_CONFIG = 5'b10100, //! '1': shared column
    parameter RD_ADDR4_WIDTH = GP2_RD_ADDR_WIDTH,
    parameter RD_ADDR3_WIDTH = GP1_RD_ADDR_WIDTH,
    parameter RD_ADDR2_WIDTH = GP2_RD_ADDR_WIDTH,
    parameter RD_ADDR1_WIDTH = GP1_RD_ADDR_WIDTH,
    parameter RD_ADDR0_WIDTH = GP1_RD_ADDR_WIDTH
) (
    output wire [QUAN_SIZE-1:0] lut_data0_o,
    output wire [QUAN_SIZE-1:0] lut_data1_o,
    output wire [QUAN_SIZE-1:0] lut_data2_o,
    output wire [QUAN_SIZE-1:0] lut_data3_o,
    output wire [QUAN_SIZE-1:0] lut_data4_o,

    input wire [RD_ADDR0_WIDTH-1:0] read_addr0_i,
    input wire [RD_ADDR1_WIDTH-1:0] read_addr1_i,
    input wire [RD_ADDR2_WIDTH-1:0] read_addr2_i,
    input wire [RD_ADDR3_WIDTH-1:0] read_addr3_i,
    input wire [RD_ADDR4_WIDTH-1:0] read_addr4_i,
    input wire [GP1_WR_ADDR_WIDTH-1:0] gp1_write_addr_i,
    input wire [GP2_WR_ADDR_WIDTH-1:0] gp2_write_addr_i,
    input wire [GP1_WR_WIDTH-1:0] gp1_lut_in_i,
    input wire [GP2_WR_WIDTH-1:0] gp2_lut_in_i,

    input wire we_i,
    input wire read_clk,
    input wire write_clk,
    input wire rstn
);
//-------------------------------------------------------
// Local parameters and bus concatenation
// The following settings ought to be modified manually.
localparam GP1_PAGE_NUM = GP1_ENTRY_NUM*PRELOAD_SET_NUM;
localparam GP2_PAGE_NUM = GP2_ENTRY_NUM*PRELOAD_SET_NUM;
//-------------------------------------------------------
// Instantiation of memory cell of group element 0
// DO NOT TOUCH THE FOLLOWING CODE.
generate;
    if(SHARE_COL_CONFIG[0]==1'b1) begin // GP2
        share2to5_gp2_vn_lut_3b #(
            .MSG_BITWIDTH(QUAN_SIZE),
            .VN_LOAD_CYCLE(GP2_PAGE_NUM),
            .RD_BITWIDTH(QUAN_SIZE),
            .RD_ADDR_BITWIDTH(GP2_RD_ADDR_WIDTH),
            .WR_BITWIDTH(GP2_WR_WIDTH),
            .WR_ADDR_BITWIDTH (GP2_WR_ADDR_WIDTH)
          ) ib_col_3b_u0 (
            .lut_data0 (lut_data0_o),
            .read_addr0 (read_addr0_i),
            .lut_in (gp2_lut_in_i),
            .write_addr (gp2_write_addr_i),
            .we (we_i),
            .sys_clk (write_clk),
            .rstn  (rstn)
          );
    end
    else begin // GP1
        share2to5_gp1_vn_lut_3b #(
            .MSG_BITWIDTH(QUAN_SIZE),
            .VN_LOAD_CYCLE(GP1_PAGE_NUM),
            .RD_BITWIDTH(QUAN_SIZE),
            .RD_ADDR_BITWIDTH(GP1_RD_ADDR_WIDTH),
            .WR_BITWIDTH(GP1_WR_WIDTH),
            .WR_ADDR_BITWIDTH (GP1_WR_ADDR_WIDTH)
          ) ib_col_3b_u0 (
            .lut_data0 (lut_data0_o),
            .read_addr0 (read_addr0_i),
            .lut_in (gp1_lut_in_i),
            .write_addr (gp1_write_addr_i),
            .we (we_i),
            .sys_clk (write_clk),
            .rstn  (rstn)
          );
    end
endgenerate
//-------------------------------------------------------
// Instantiation of memory cell of group element 1
// DO NOT TOUCH THE FOLLOWING CODE.
generate;
    if(SHARE_COL_CONFIG[1]==1'b1) begin // GP2
        share2to5_gp2_vn_lut_3b #(
            .MSG_BITWIDTH(QUAN_SIZE),
            .VN_LOAD_CYCLE(GP2_PAGE_NUM),
            .RD_BITWIDTH(QUAN_SIZE),
            .RD_ADDR_BITWIDTH(GP2_RD_ADDR_WIDTH),
            .WR_BITWIDTH(GP2_WR_WIDTH),
            .WR_ADDR_BITWIDTH (GP2_WR_ADDR_WIDTH)
          ) ib_col_3b_u1 (
            .lut_data0 (lut_data1_o),
            .read_addr0 (read_addr1_i),
            .lut_in (gp2_lut_in_i),
            .write_addr (gp2_write_addr_i),
            .we (we_i),
            .sys_clk (write_clk),
            .rstn  (rstn)
          );
    end
    else begin // GP1
        share2to5_gp1_vn_lut_3b #(
            .MSG_BITWIDTH(QUAN_SIZE),
            .VN_LOAD_CYCLE(GP1_PAGE_NUM),
            .RD_BITWIDTH(QUAN_SIZE),
            .RD_ADDR_BITWIDTH(GP1_RD_ADDR_WIDTH),
            .WR_BITWIDTH(GP1_WR_WIDTH),
            .WR_ADDR_BITWIDTH (GP1_WR_ADDR_WIDTH)
          ) ib_col_3b_u1 (
            .lut_data0 (lut_data1_o),
            .read_addr0 (read_addr1_i),
            .lut_in (gp1_lut_in_i),
            .write_addr (gp1_write_addr_i),
            .we (we_i),
            .sys_clk (write_clk),
            .rstn  (rstn)
          );
    end
endgenerate
//-------------------------------------------------------
// Instantiation of memory cell of group element 2
// DO NOT TOUCH THE FOLLOWING CODE.
generate;
    if(SHARE_COL_CONFIG[2]==1'b1) begin // GP2
        share2to5_gp2_vn_lut_3b #(
            .MSG_BITWIDTH(QUAN_SIZE),
            .VN_LOAD_CYCLE(GP2_PAGE_NUM),
            .RD_BITWIDTH(QUAN_SIZE),
            .RD_ADDR_BITWIDTH(GP2_RD_ADDR_WIDTH),
            .WR_BITWIDTH(GP2_WR_WIDTH),
            .WR_ADDR_BITWIDTH (GP2_WR_ADDR_WIDTH)
          ) ib_col_3b_u2 (
            .lut_data0 (lut_data2_o),
            .read_addr0 (read_addr2_i),
            .lut_in (gp2_lut_in_i),
            .write_addr (gp2_write_addr_i),
            .we (we_i),
            .sys_clk (write_clk),
            .rstn  (rstn)
          );
    end
    else begin // GP1
        share2to5_gp1_vn_lut_3b #(
            .MSG_BITWIDTH(QUAN_SIZE),
            .VN_LOAD_CYCLE(GP1_PAGE_NUM),
            .RD_BITWIDTH(QUAN_SIZE),
            .RD_ADDR_BITWIDTH(GP1_RD_ADDR_WIDTH),
            .WR_BITWIDTH(GP1_WR_WIDTH),
            .WR_ADDR_BITWIDTH (GP1_WR_ADDR_WIDTH)
          ) ib_col_3b_u2 (
            .lut_data0 (lut_data2_o),
            .read_addr0 (read_addr2_i),
            .lut_in (gp1_lut_in_i),
            .write_addr (gp1_write_addr_i),
            .we (we_i),
            .sys_clk (write_clk),
            .rstn  (rstn)
          );
    end
endgenerate
//-------------------------------------------------------
// Instantiation of memory cell of group element 3
// DO NOT TOUCH THE FOLLOWING CODE.
generate;
    if(SHARE_COL_CONFIG[3]==1'b1) begin // GP2
        share2to5_gp2_vn_lut_3b #(
            .MSG_BITWIDTH(QUAN_SIZE),
            .VN_LOAD_CYCLE(GP2_PAGE_NUM),
            .RD_BITWIDTH(QUAN_SIZE),
            .RD_ADDR_BITWIDTH(GP2_RD_ADDR_WIDTH),
            .WR_BITWIDTH(GP2_WR_WIDTH),
            .WR_ADDR_BITWIDTH (GP2_WR_ADDR_WIDTH)
          ) ib_col_3b_u3 (
            .lut_data0 (lut_data3_o),
            .read_addr0 (read_addr3_i),
            .lut_in (gp2_lut_in_i),
            .write_addr (gp2_write_addr_i),
            .we (we_i),
            .sys_clk (write_clk),
            .rstn  (rstn)
          );
    end
    else begin // GP1
        share2to5_gp1_vn_lut_3b #(
            .MSG_BITWIDTH(QUAN_SIZE),
            .VN_LOAD_CYCLE(GP1_PAGE_NUM),
            .RD_BITWIDTH(QUAN_SIZE),
            .RD_ADDR_BITWIDTH(GP1_RD_ADDR_WIDTH),
            .WR_BITWIDTH(GP1_WR_WIDTH),
            .WR_ADDR_BITWIDTH (GP1_WR_ADDR_WIDTH)
          ) ib_col_3b_u3 (
            .lut_data0 (lut_data3_o),
            .read_addr0 (read_addr3_i),
            .lut_in (gp1_lut_in_i),
            .write_addr (gp1_write_addr_i),
            .we (we_i),
            .sys_clk (write_clk),
            .rstn  (rstn)
          );
    end
endgenerate
//-------------------------------------------------------
// Instantiation of memory cell of group element 4
// DO NOT TOUCH THE FOLLOWING CODE.
generate;
    if(SHARE_COL_CONFIG[4]==1'b1) begin // GP2
        share2to5_gp2_vn_lut_3b #(
            .MSG_BITWIDTH(QUAN_SIZE),
            .VN_LOAD_CYCLE(GP2_PAGE_NUM),
            .RD_BITWIDTH(QUAN_SIZE),
            .RD_ADDR_BITWIDTH(GP2_RD_ADDR_WIDTH),
            .WR_BITWIDTH(GP2_WR_WIDTH),
            .WR_ADDR_BITWIDTH (GP2_WR_ADDR_WIDTH)
          ) ib_col_3b_u4 (
            .lut_data0 (lut_data4_o),
            .read_addr0 (read_addr4_i),
            .lut_in (gp2_lut_in_i),
            .write_addr (gp2_write_addr_i),
            .we (we_i),
            .sys_clk (write_clk),
            .rstn  (rstn)
          );
    end
    else begin // GP1
        share2to5_gp1_vn_lut_3b #(
            .MSG_BITWIDTH(QUAN_SIZE),
            .VN_LOAD_CYCLE(GP1_PAGE_NUM),
            .RD_BITWIDTH(QUAN_SIZE),
            .RD_ADDR_BITWIDTH(GP1_RD_ADDR_WIDTH),
            .WR_BITWIDTH(GP1_WR_WIDTH),
            .WR_ADDR_BITWIDTH (GP1_WR_ADDR_WIDTH)
          ) ib_col_3b_u4 (
            .lut_data0 (lut_data4_o),
            .read_addr0 (read_addr4_i),
            .lut_in (gp1_lut_in_i),
            .write_addr (gp1_write_addr_i),
            .we (we_i),
            .sys_clk (write_clk),
            .rstn  (rstn)
          );
    end
endgenerate
endmodule