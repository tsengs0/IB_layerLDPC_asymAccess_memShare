`timescale 1ns/1ps

/**
* Latest date: 12th July, 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: memShare_regFile_wrapper
* 
* # I/F
* 1) Output:
*
* 2) Input:
*
* # Param

* # Description
        Register list:
            L1PA_SPR,
            L1PA_PSRA,
            L1PA_START,
            L1PA_END
* # Dependencies
    1) Preprocessor to add any new special function register
        ./memShare_config.vh
*
* # Remark
*	Type-0 Register: 7 bits wide
    Type-0 Register Array: 64 page
    Memory Cell: 64x7bit
*		LUT: 14
        Logic LUT: 8
        LUTRAM: 6
		FF: 3
        I/O: 22
        Freq: 400MHz
        WNS: +1.998 ns
        TNS: 0.0 ns
        WHS: +0.093 ns
        THS: 0.0 ns
        WPWS: 0.718 ns
        TPWS: 0.0 ns
**/
`include "memShare_config.vh"

module memShare_regFile_wrapper #(
    parameter SHIFT_BITWIDTH = 3,
    parameter DELTA_BITWIDTH = 3,
    parameter SEQ_PTR_BITWIDTH = 1, // Bit width of isGtr
    parameter SEQ_SIZE = 2, //! Maximum size of one L1PA shfit pattern sequence
    parameter TYPE0_ADDR_BITWIDTH = 5, //! page number: 32
    parameter TYPE0_REG_BITWIDTH = 7,
    parameter TYPE0_PAGE_NUM =32,
    parameter REGFILE_RD_CYCLE = 1
) (
    // Port 0
    output wire [SHIFT_BITWIDTH-1:0] l1pa_shift_port0_o,
    output wire [DELTA_BITWIDTH-1:0] shift_delta_port0_o,
    output wire isGtr_port0_o,
    input wire [TYPE0_ADDR_BITWIDTH-1:0] regType0_raddr_port0_i,

    input wire [TYPE0_ADDR_BITWIDTH-1:0] regType0_waddr_i,
    input wire [TYPE0_REG_BITWIDTH-1:0] regType0_wdata_i,
    input wire regType0_we_i,
    input wire sys_clk,
    input wire rstn,
    input wire deltaPipe_rstn
);

wire [SHIFT_BITWIDTH-1:0] l1pa_shift_net;
wire [DELTA_BITWIDTH-1:0] shift_delta_net;
wire isGtr_net;
wire [TYPE0_ADDR_BITWIDTH-1:0] regType0_raddr_net;
memShare_regFile_l1paDelta #(
    .SHIFT_BITWIDTH      (SHIFT_BITWIDTH     ),
    .DELTA_BITWIDTH      (DELTA_BITWIDTH     ),
    .SEQ_PTR_BITWIDTH    (SEQ_PTR_BITWIDTH   ), // Bit width of isGtr
    .SEQ_SIZE            (SEQ_SIZE           ), //! Maximum size of one L1PA shfit pattern sequence
    .TYPE0_ADDR_BITWIDTH (TYPE0_ADDR_BITWIDTH), //! page number: 32
    .TYPE0_PAGE_NUM      (TYPE0_PAGE_NUM     ),
    .REGFILE_RD_CYCLE    (REGFILE_RD_CYCLE   )
) l1pa_regFile_unit0 (
    .l1pa_shift_o     (l1pa_shift_net    ),
    .shift_delta_o    (shift_delta_net   ),
    .isGtr_o          (isGtr_net         ),
    .regType0_waddr_i (regType0_waddr_i),
    .regType0_wdata_i (regType0_wdata_i),
    .regType0_raddr_i (regType0_raddr_net),
    .regType0_we_i    (regType0_we_i   ),
    .sys_clk          (sys_clk         ),
    .rstn             (rstn            ),
    .deltaPipe_rstn   (deltaPipe_rstn  )
);
assign regType0_raddr_net = regType0_raddr_port0_i;

// Port 0
assign l1pa_shift_port0_o = l1pa_shift_net;
assign shift_delta_port0_o = shift_delta_net;
assign isGtr_port0_o = isGtr_net;
endmodule

/**
* Latest date: 12th July, 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: memShare_regFile_l2paDisable
* 
* # I/F
* 1) Output:
*
* 2) Input:
*
* # Param

* # Description
        Register list:
            L1PA_SPR,
            L1PA_PSRA,
            L1PA_START,
            L1PA_END
* # Dependencies
    1) Preprocessor to add any new special function register
        ./memShare_config.vh
*
* # Remark
*	Type-0 Register: 7 bits wide
    Type-0 Register Array: 64 page
    Memory Cell: 64x7bit
*		LUT: 14
        Logic LUT: 8
        LUTRAM: 6
		FF: 3
        I/O: 22
        Freq: 400MHz
        WNS: +1.998 ns
        TNS: 0.0 ns
        WHS: +0.093 ns
        THS: 0.0 ns
        WPWS: 0.718 ns
        TPWS: 0.0 ns
**/
`include "memShare_config.vh"

module memShare_regFile_l1paDelta #(
    parameter SHIFT_BITWIDTH = 3,
    parameter DELTA_BITWIDTH = 3,
    parameter SEQ_PTR_BITWIDTH = 1, // Bit width of isGtr
    parameter SEQ_SIZE = 2, //! Maximum size of one L1PA shfit pattern sequence
    parameter TYPE0_ADDR_BITWIDTH = 5, //! page number: 32
    parameter TYPE0_REG_BITWIDTH = 7,
    parameter TYPE0_PAGE_NUM =32,
    parameter REGFILE_RD_CYCLE = 1
) (
    output wire [SHIFT_BITWIDTH-1:0] l1pa_shift_o,
    output wire [DELTA_BITWIDTH-1:0] shift_delta_o,
    output wire isGtr_o,

    input wire [TYPE0_ADDR_BITWIDTH-1:0] regType0_waddr_i,
    input wire [TYPE0_REG_BITWIDTH-1:0] regType0_wdata_i,
    input wire [TYPE0_ADDR_BITWIDTH-1:0] regType0_raddr_i,
    input wire regType0_we_i,

    input wire sys_clk,
    input wire rstn,
    input wire deltaPipe_rstn
);
//---------------------------------------------
// Type 0 register array:
// Instantiation of single-port RAM
//---------------------------------------------
localparam REGFILE_PAGE_SIZE = TYPE0_REG_BITWIDTH;//(SHIFT_BITWIDTH+DELTA_BITWIDTH+SEQ_PTR_BITWIDTH);
wire [REGFILE_PAGE_SIZE-1:0] rdata_net;
wire [TYPE0_ADDR_BITWIDTH-1:0] regType0_access_addr;
rdAsync_lutMem_1bankX1port #(
    .QUAN_SIZE(REGFILE_PAGE_SIZE),
    .PAGE_NUM(TYPE0_PAGE_NUM),
    .ADDR_BITWIDTH(TYPE0_ADDR_BITWIDTH)
) lutMem_1bankX1port_regType0 (
    .read_page_o   (rdata_net),
    .write_data_i  (regType0_wdata_i),
    .access_addr_i (regType0_access_addr),
    .we_i          (regType0_we_i),
    .sys_clk       (sys_clk)
);
assign regType0_access_addr = (regType0_we_i == 1'b1) ? regType0_waddr_i : regType0_raddr_i;
//---------------------------------------------
// Slice stage of L1PA and L2PA type-0 registers
//---------------------------------------------
genvar i;
generate;
    // FF slicing for L1PA type-0 registers
    // Note that the instance "lutMem_1bankX1port_regType0" is an read-asynchronous write-synchronous type
    if(REGFILE_RD_CYCLE == 0) begin
        assign l1pa_shift_o = rdata_net[`L1PA_SHIFT_SEGMENT_MSB:`L1PA_SHIFT_SEGMENT_LSB];                   
        assign shift_delta_o = rdata_net[`L1PA_SHIFT_DELTA_SEGMENT_MSB:`L1PA_SHIFT_DELTA_SEGMENT_LSB];
        assign isGtr_o = rdata_net[0];
    end
    else if(REGFILE_RD_CYCLE == 1) begin
        reg [SHIFT_BITWIDTH-1:0] l1pa_shift_pipe0;
        reg [DELTA_BITWIDTH-1:0] shift_delta_pipe0;
        reg [REGFILE_RD_CYCLE-1:0] isGtr_pipe0;
        always @(posedge sys_clk) begin if(!rstn) l1pa_shift_pipe0 <= 0; else l1pa_shift_pipe0 <= rdata_net[`L1PA_SHIFT_SEGMENT_MSB:`L1PA_SHIFT_SEGMENT_LSB]; end
/*Special care!*/ always @(posedge sys_clk) begin if(!deltaPipe_rstn) shift_delta_pipe0 <= 0; else shift_delta_pipe0 <= rdata_net[`L1PA_SHIFT_DELTA_SEGMENT_MSB:`L1PA_SHIFT_DELTA_SEGMENT_LSB]; end
        always @(posedge sys_clk) begin if(!rstn) isGtr_pipe0 <= 0; else isGtr_pipe0 <= rdata_net[0]; end

        assign l1pa_shift_o = l1pa_shift_pipe0;
        assign shift_delta_o = shift_delta_pipe0;
        assign isGtr_o = isGtr_pipe0;
    end
    else begin
        reg [SHIFT_BITWIDTH-1:0] l1pa_shift_pipeN  [0:REGFILE_RD_CYCLE-1];
        reg [DELTA_BITWIDTH-1:0] shift_delta_pipeN [0:REGFILE_RD_CYCLE-1];
        reg [REGFILE_RD_CYCLE-1:0] isGtr_pipeN;
        reg [REGFILE_RD_CYCLE-2:0] deltaPipe_rstn_pipeN;
        for(i=0; i<REGFILE_RD_CYCLE; i=i+1) begin
            if(i==0) begin
                always @(posedge sys_clk) begin if(!rstn) l1pa_shift_pipeN[0] <= 0; else l1pa_shift_pipeN[0] <= rdata_net[`L1PA_SHIFT_SEGMENT_MSB:`L1PA_SHIFT_SEGMENT_LSB]; end
                always @(posedge sys_clk) begin if(!rstn) shift_delta_pipeN[0] <= 0; else shift_delta_pipeN[0] <= rdata_net[`L1PA_SHIFT_DELTA_SEGMENT_MSB:`L1PA_SHIFT_DELTA_SEGMENT_LSB]; end
                always @(posedge sys_clk) begin if(!rstn) isGtr_pipeN[0] <= 0; else isGtr_pipeN[0] <= rdata_net[0]; end
                always @(posedge sys_clk) begin deltaPipe_rstn_pipeN[0] <= deltaPipe_rstn; end
            end
            else if(i == (REGFILE_RD_CYCLE-1)) begin
                always @(posedge sys_clk) begin if(!rstn) l1pa_shift_pipeN[i] <= 0; else l1pa_shift_pipeN[i] <= l1pa_shift_pipeN[i-1]; end
                always @(posedge sys_clk) begin if(!deltaPipe_rstn_pipeN[i-1]) shift_delta_pipeN[i] <= 0; else shift_delta_pipeN[i] <= shift_delta_pipeN[i-1]; end
                always @(posedge sys_clk) begin if(!rstn) isGtr_pipeN[i] <= 0; else isGtr_pipeN[i] <= isGtr_pipeN[i-1]; end
            end
            else begin
                always @(posedge sys_clk) begin if(!rstn) l1pa_shift_pipeN[i] <= 0; else l1pa_shift_pipeN[i] <= l1pa_shift_pipeN[i-1]; end
                always @(posedge sys_clk) begin if(!rstn) shift_delta_pipeN[i] <= 0; else shift_delta_pipeN[i] <= shift_delta_pipeN[i-1]; end
                always @(posedge sys_clk) begin if(!rstn) isGtr_pipeN[i] <= 0; else isGtr_pipeN[i] <= isGtr_pipeN[i-1]; end
                always @(posedge sys_clk) begin deltaPipe_rstn_pipeN[i] <= deltaPipe_rstn_pipeN[i-1]; end
            end
        end

        assign l1pa_shift_o = l1pa_shift_pipeN[REGFILE_RD_CYCLE-1];
        assign shift_delta_o = shift_delta_pipeN[REGFILE_RD_CYCLE-1];
        assign isGtr_o = isGtr_pipeN[REGFILE_RD_CYCLE-1];
    end
endgenerate
endmodule

/**
* Latest date: 25th Feb., 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: memShare_regFile_l2paDisable
* 
* # I/F
* 1) Output:
*
* 2) Input:
*
* # Param

* # Description
        Register list:
            L1PA_SPR,
            L1PA_PSRA,
            L1PA_START,
            L1PA_END
* # Dependencies
    1) Preprocessor to add any new special function register
        ./memShare_config.vh
*
* # Remark
*	Type-0 Register: 7 bits wide
    Type-0 Register Array: 64 page
    Memory Cell: 64x7bit
*		LUT: 14
        Logic LUT: 8
        LUTRAM: 6
		FF: 3
        I/O: 22
        Freq: 400MHz
        WNS: +1.998 ns
        TNS: 0.0 ns
        WHS: +0.093 ns
        THS: 0.0 ns
        WPWS: 0.718 ns
        TPWS: 0.0 ns
**/

//module memShare_regFile_l2paDisable #(
//    parameter L1PA_REG_BITWIDTH = 3,
//    parameter L1PA_ENDFLAG_WIDTH = 2,
//`ifdef MEMSHARE_SCHED_SOL_1
//    parameter TYPE0_REG_BITWIDTH = L1PA_ENDFLAG_WIDTH+(L1PA_REG_BITWIDTH),
//`endif // MEMSHARE_SCHED_SOL_1
//`ifdef MEMSHARE_SCHED_SOL_2
//    parameter GP_ELEMENT_ROW_ADDR_WIDTH = `GP_ELEMENT_ROW_ADDR_WIDTH,
//    parameter TYPE0_REG_BITWIDTH = `TYPE0_REG_BITWIDTH,
//`endif // MEMSHARE_SCHED_SOL_2
//    parameter TYPE0_ADDR_BITWIDTH = 5+2, //! page number: 128
//    parameter TYPE0_PAGE_NUM =128,
//    parameter L1PA_PIPE_NUM = 1
//) (
//    output wire [L1PA_ENDFLAG_WIDTH-1:0]L1PA_isEnd_o,
//    output wire [L1PA_REG_BITWIDTH-1:0] L1PA_SPR_o,
//`ifdef MEMSHARE_SCHED_SOL_2
//    output wire [GP_ELEMENT_ROW_ADDR_WIDTH-1:0] regType0_rowOffset_o,
//`endif // MEMSHARE_SCHED_SOL_2
//
//    input wire [TYPE0_ADDR_BITWIDTH-1:0] regType0_waddr_i,
//    input wire [TYPE0_REG_BITWIDTH-1:0] regType0_wdata_i,
//    input wire [TYPE0_ADDR_BITWIDTH-1:0] regType0_raddr_i,
//    input wire regType0_we_i,
//
//    input wire sys_clk,
//    input wire rstn
//);
//
////---------------------------------------------
//// Type 0 register array:
//// Instantiation of single-port RAM
////---------------------------------------------
//`ifdef MEMSHARE_SCHED_SOL_1
//    localparam TYPE0_L1PA_SEGMENT_LSB = 0;
//    localparam TYPE0_L1PA_SEGMENT_MSB = L1PA_REG_BITWIDTH+TYPE0_L1PA_SEGMENT_LSB-1;
//    localparam L1PA_FLAG_LSB = TYPE0_L1PA_SEGMENT_MSB+1;
//    localparam L1PA_FLAG_MSB = L1PA_FLAG_LSB+L1PA_ENDFLAG_WIDTH-1;
//
//    wire [TYPE0_ADDR_BITWIDTH-1:0] regType0_access_addr;
//    wire [TYPE0_REG_BITWIDTH-1:0] regType0_rdata_temp;
//    wire [L1PA_REG_BITWIDTH-1:0] L1PA_SPR_temp;
//    wire [L1PA_ENDFLAG_WIDTH-1:0] L1PA_isEnd_temp;
//`endif // `ifdef MEMSHARE_SCHED_SOL_1
//`ifdef MEMSHARE_SCHED_SOL_2
//    localparam ROW_OFFSET_SEGMENT_LSB = 0;
//    localparam ROW_OFFSET_SEGMENT_MSB = GP_ELEMENT_ROW_ADDR_WIDTH-1;
//    localparam TYPE0_L1PA_SEGMENT_LSB = ROW_OFFSET_SEGMENT_MSB+1;
//    localparam TYPE0_L1PA_SEGMENT_MSB = L1PA_REG_BITWIDTH+TYPE0_L1PA_SEGMENT_LSB-1;
//    localparam L1PA_FLAG_LSB = TYPE0_L1PA_SEGMENT_MSB+1;
//    localparam L1PA_FLAG_MSB = L1PA_FLAG_LSB+L1PA_ENDFLAG_WIDTH-1;
//
//    wire [TYPE0_ADDR_BITWIDTH-1:0] regType0_access_addr;
//    wire [TYPE0_REG_BITWIDTH-1:0] regType0_rdata_temp;
//    wire [GP_ELEMENT_ROW_ADDR_WIDTH-1:0] regType0_rowOffset_temp;
//    wire [L1PA_REG_BITWIDTH-1:0] L1PA_SPR_temp;
//    wire [L1PA_ENDFLAG_WIDTH-1:0] L1PA_isEnd_temp;
//`endif // `ifdef MEMSHARE_SCHED_SOL_2
//lutMem_1bankX1port #(
//    .QUAN_SIZE(TYPE0_REG_BITWIDTH),
//    .PAGE_NUM(TYPE0_PAGE_NUM),
//    .ADDR_BITWIDTH(TYPE0_ADDR_BITWIDTH)
//) lutMem_1bankX1port_regType0 (
//    .read_page_o   (regType0_rdata_temp),
//    .write_data_i  (regType0_wdata_i),
//    .access_addr_i (regType0_access_addr),
//    .we_i          (regType0_we_i),
//    .sys_clk       (sys_clk)
//);
//assign regType0_access_addr = (regType0_we_i==1'b1) ? regType0_waddr_i : regType0_raddr_i;
//assign L1PA_SPR_temp = regType0_rdata_temp[TYPE0_L1PA_SEGMENT_MSB:TYPE0_L1PA_SEGMENT_LSB];
//assign L1PA_isEnd_temp = regType0_rdata_temp[L1PA_FLAG_MSB:L1PA_FLAG_LSB];
//`ifdef MEMSHARE_SCHED_SOL_2
//    assign regType0_rowOffset_temp[GP_ELEMENT_ROW_ADDR_WIDTH-1:0] = regType0_rdata_temp[ROW_OFFSET_SEGMENT_MSB:ROW_OFFSET_SEGMENT_LSB];
//    assign regType0_rowOffset_o = regType0_rowOffset_temp;
//`endif // MEMSHARE_SCHED_SOL_2
////---------------------------------------------
//// Slice stage of L1PA and L2PA type-0 registers
////---------------------------------------------
//genvar i;
//generate;
//    // FF slicing for L1PA type-0 registers
//    if(L1PA_PIPE_NUM == 1) begin
//        assign L1PA_SPR_o = L1PA_SPR_temp;
//        assign L1PA_isEnd_o = L1PA_isEnd_temp;
//    end
//    else begin
//        reg [L1PA_REG_BITWIDTH-1:0] L1PA_SPR_pipe [0:L1PA_PIPE_NUM-2];
//        reg [L1PA_ENDFLAG_WIDTH-1:0] L1PA_isEnd_pipe [0:L1PA_PIPE_NUM-2];      
//        for(i=0; i<L1PA_PIPE_NUM-1; i=i+1) begin
//            if(i==0) begin
//                always @(posedge sys_clk) begin if(!rstn) L1PA_SPR_pipe[0] <= 0; else L1PA_SPR_pipe[0] <= L1PA_SPR_temp; end
//                always @(posedge sys_clk) begin if(!rstn) L1PA_isEnd_pipe[0] <= 0; else L1PA_isEnd_pipe[0] <= L1PA_isEnd_temp; end
//            end
//            else begin
//                always @(posedge sys_clk) begin if(!rstn) L1PA_SPR_pipe[i] <= 0; else L1PA_SPR_pipe[i] <= L1PA_SPR_pipe[i-1]; end
//                always @(posedge sys_clk) begin if(!rstn) L1PA_isEnd_pipe[i] <= 0; else L1PA_isEnd_pipe[i] <= L1PA_isEnd_pipe[i-1]; end
//            end
//        end
//
//        assign L1PA_SPR_o = L1PA_SPR_pipe[L1PA_PIPE_NUM-2];
//        assign L1PA_isEnd_o = L1PA_isEnd_pipe[L1PA_PIPE_NUM-2]; 
//    end
//endgenerate
//endmodule

/**
* Latest date: 25th Feb., 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: memShare_regFile_l2paEnable
* 
* # I/F
* 1) Output:
*
* 2) Input:
*
* # Param

* # Description
        Register list:
            L1PA_SPR,
            L1PA_PSRA,
            L2PA_PSRA,
            L1PA_START,
            L1PA_END,
            L2PA_START,
            L2PA_END,
* # Dependencies
    1) Preprocessor to add any new special function register
        ./memShare_regList.vh
*
* # Remark
*	Type-0 Register: 7 bits wide
    Type-0 Register Array: 64 page
    Memory Cell: 64x7bit
*		LUT: 11
        Logic LUT: 4
        LUTRAM: 7
		FF: 13
        I/O: 30
        Freq: 400MHz
        WNS: +1.895 ns
        TNS: 0.0 ns
        WHS: +0.070 ns
        THS: 0.0 ns
        WPWS: 0.718 ns
        TPWS: 0.0 ns
**/
//module memShare_regFile_l2paEnable #(
//    parameter L1PA_REG_BITWIDTH = 2,
//    parameter L2PA_REG_BITWIDTH = 0,//4,
//    parameter L1PA_ENDFLAG_WIDTH = 1,
//    parameter L2PA_ENDFLAG_WIDTH = 0,
//    parameter TYPE0_REG_BITWIDTH = L1PA_ENDFLAG_WIDTH+L2PA_ENDFLAG_WIDTH+(L1PA_REG_BITWIDTH+L2PA_REG_BITWIDTH),
//    parameter TYPE0_ADDR_BITWIDTH = 5+2, //! page number: 128
//    parameter TYPE0_PAGE_NUM =128,
//    parameter L1PA_PIPE_NUM = 1,
//    parameter L2PA_PIPE_NUM = 2
//) (
//    output wire L1PA_isEnd_o,
//    output wire [L1PA_REG_BITWIDTH-1:0] L1PA_SPR_o,
//    output wire L2PA_isEnd_o,
//    output wire [L2PA_REG_BITWIDTH-1:0] L2PA_LPR_o,
//
//    input wire [TYPE0_ADDR_BITWIDTH-1:0] regType0_waddr_i,
//    input wire [TYPE0_REG_BITWIDTH-1:0] regType0_wdata_i,
//    input wire [TYPE0_ADDR_BITWIDTH-1:0] regType0_raddr_i,
//    input wire regType0_we_i,
//
//    input wire sys_clk,
//    input wire rstn
//);
//
////---------------------------------------------
//// Type 0 register array:
//// Instantiation of single-port RAM
////---------------------------------------------
//localparam TYPE0_L2PA_SEGMENT_LSB = 0;
//localparam TYPE0_L2PA_SEGMENT_MSB = L2PA_REG_BITWIDTH+TYPE0_L2PA_SEGMENT_LSB-1;
//localparam TYPE0_L1PA_SEGMENT_LSB = TYPE0_L2PA_SEGMENT_MSB+1;
//localparam TYPE0_L1PA_SEGMENT_MSB = L1PA_REG_BITWIDTH+TYPE0_L1PA_SEGMENT_LSB-1;
//localparam L1PA_FLAG_MSB = TYPE0_L1PA_SEGMENT_MSB+1;
//wire [TYPE0_ADDR_BITWIDTH-1:0] regType0_access_addr;
//wire [TYPE0_REG_BITWIDTH-1:0] regType0_rdata_temp;
//wire [L1PA_REG_BITWIDTH-1:0] L1PA_SPR_temp;
//wire [L2PA_REG_BITWIDTH-1:0] L2PA_LPR_temp;
//wire L1PA_isEnd_temp, L2PA_isEnd_temp;
//lutMem_1bankX1port #(
//    .QUAN_SIZE(TYPE0_REG_BITWIDTH),
//    .PAGE_NUM(TYPE0_PAGE_NUM),
//    .ADDR_BITWIDTH(TYPE0_ADDR_BITWIDTH)
//) lutMem_1bankX1port_regType0 (
//    .read_page_o   (regType0_rdata_temp),
//    .write_data_i  (regType0_wdata_i),
//    .access_addr_i (regType0_access_addr),
//    .we_i          (regType0_we_i),
//    .sys_clk       (sys_clk)
//);
//assign regType0_access_addr = (regType0_we_i==1'b1) ? regType0_waddr_i : regType0_raddr_i;
//assign L1PA_SPR_temp = regType0_rdata_temp[TYPE0_L1PA_SEGMENT_MSB:TYPE0_L1PA_SEGMENT_LSB];
//assign L1PA_isEnd_temp = regType0_rdata_temp[L1PA_FLAG_MSB];
//assign L2PA_LPR_temp = regType0_rdata_temp[TYPE0_L2PA_SEGMENT_MSB:TYPE0_L2PA_SEGMENT_LSB];
//assign L2PA_isEnd_temp = regType0_rdata_temp[L1PA_FLAG_MSB];
//
////---------------------------------------------
//// Slice stage of L1PA and L2PA type-0 registers
////---------------------------------------------
//genvar i;
//generate;
//    // FF slicing for L1PA type-0 registers
//    if(L1PA_PIPE_NUM == 1) begin
//        assign L1PA_SPR_o = L1PA_SPR_temp;
//        assign L1PA_isEnd_o = L1PA_isEnd_temp;
//    end
//    else begin
//        reg [L1PA_REG_BITWIDTH-1:0] L1PA_SPR_pipe [0:L1PA_PIPE_NUM-2];
//        reg [L1PA_PIPE_NUM-2:0] L1PA_isEnd_pipe;      
//        for(i=0; i<L1PA_PIPE_NUM-1; i=i+1) begin
//            if(i==0) begin
//                always @(posedge sys_clk) begin if(!rstn) L1PA_SPR_pipe[0] <= 0; else L1PA_SPR_pipe[0] <= L1PA_SPR_temp; end
//                always @(posedge sys_clk) begin if(!rstn) L1PA_isEnd_pipe[0] <= 0; else L1PA_isEnd_pipe[0] <= L1PA_isEnd_temp; end
//            end
//            else begin
//                always @(posedge sys_clk) begin if(!rstn) L1PA_SPR_pipe[i] <= 0; else L1PA_SPR_pipe[i] <= L1PA_SPR_pipe[i-1]; end
//                always @(posedge sys_clk) begin if(!rstn) L1PA_isEnd_pipe[i] <= 0; else L1PA_isEnd_pipe[i] <= L1PA_isEnd_pipe[i-1]; end
//            end
//        end
//
//        assign L1PA_SPR_o = L1PA_SPR_pipe[L1PA_PIPE_NUM-2];
//        assign L1PA_isEnd_o = L1PA_isEnd_pipe[L1PA_PIPE_NUM-2]; 
//    end
//
//    // FF slicing for L2PA type-0 registers
//    if(L2PA_PIPE_NUM == 1) begin
//        assign L2PA_SPR_o = L2PA_LPR_temp;
//        assign L2PA_isEnd_o = L2PA_isEnd_temp;
//    end
//    else begin
//        reg [L2PA_REG_BITWIDTH-1:0] L2PA_LPR_pipe [0:L2PA_PIPE_NUM-2];
//        reg [L2PA_PIPE_NUM-2:0] L2PA_isEnd_pipe;      
//        for(i=0; i<L2PA_PIPE_NUM-1; i=i+1) begin
//            if(i==0) begin
//                always @(posedge sys_clk) begin if(!rstn) L2PA_LPR_pipe[0] <= 0; else L2PA_LPR_pipe[0] <= L2PA_LPR_temp; end
//                always @(posedge sys_clk) begin if(!rstn) L2PA_isEnd_pipe[0] <= 0; else L2PA_isEnd_pipe[0] <= L2PA_isEnd_temp; end
//            end
//            else begin
//                always @(posedge sys_clk) begin if(!rstn) L2PA_LPR_pipe[i] <= 0; else L2PA_LPR_pipe[i] <= L2PA_LPR_pipe[i-1]; end
//                always @(posedge sys_clk) begin if(!rstn) L2PA_isEnd_pipe[i] <= 0; else L2PA_isEnd_pipe[i] <= L2PA_isEnd_pipe[i-1]; end
//            end
//        end
//
//        assign L2PA_LPR_o = L2PA_LPR_pipe[L2PA_PIPE_NUM-2];
//        assign L2PA_isEnd_o = L2PA_isEnd_pipe[L2PA_PIPE_NUM-2]; 
//    end    
//endgenerate
//endmodule

/*
           0  : read_addr = {1'd1, 6'd0}; // 
           1  : read_addr = {1'd1, 6'd4}; // 
           2  : read_addr = {1'd1, 6'd3}; // 
           3  : read_addr = {1'd1, 6'd2}; // 
           4  : read_addr = {1'd1, 6'd4}; // 
           5  : read_addr = {1'd1, 6'd3}; // 
           6  : read_addr = {1'd0, 6'd1}; //
           7  : read_addr = {1'd1, 6'd2};
           8  : read_addr = {1'd1, 6'd2};//
           9  : read_addr = {1'd1, 6'd4};//
           10 : read_addr = {1'd0, 6'd0};//
           11 : read_addr = {1'd1, 6'd2};
           12 : read_addr = {1'd0, 6'd0};//
           13 : read_addr = {1'd1, 6'd1};
           14 : read_addr = {1'd1, 6'd1};//
           15 : read_addr = {1'd1, 6'd3};//
           16 : read_addr = {1'd0, 6'd0};//
           17 : read_addr = {1'd1, 6'd1};
           18 : read_addr = {1'd1, 6'd0};//
           19 : read_addr = {1'd0, 6'd0};//
           20 : read_addr = {1'd1, 6'd1};
           21 : read_addr = {1'd0, 6'd1};//
           22 : read_addr = {1'd1, 6'd2};
           23 : read_addr = {1'd0, 6'd1};//
           24 : read_addr = {1'd1, 6'd2};
           25 : read_addr = {1'd0, 6'd2};//
           26 : read_addr = {1'd1, 6'd3};
           27 : read_addr = {1'd0, 6'd1};//
           28 : read_addr = {1'd1, 6'd2};
           29 : read_addr = {1'd0, 6'd0};//
           30 : read_addr = {1'd1, 6'd2};
           31 : read_addr = {1'd0, 6'd0};//
           32 : read_addr = {1'd1, 6'd4};
           33 : read_addr = {1'd0, 6'd0};//
           34 : read_addr = {1'd1, 6'd1};
           35 : read_addr = {1'd0, 6'd0};//
           36 : read_addr = {1'd1, 6'd1};
           37 : read_addr = {1'd0, 6'd0};//
           38 : read_addr = {1'd1, 6'd1};
           39 : read_addr = {1'd0, 6'd0};//
           40 : read_addr = {1'd1, 6'd1};
           41 : read_addr = {1'd0, 6'd1};//
           42 : read_addr = {1'd1, 6'd2};
           43 : read_addr = {1'd0, 6'd2};//
           44 : read_addr = {1'd1, 6'd3};
           45 : read_addr = {1'd0, 6'd3};//
           46 : read_addr = {1'd1, 6'd4};
           47 : read_addr = {1'd0, 6'd0};//
           48 : read_addr = {1'd1, 6'd4};
           49 : read_addr = {1'd0, 6'd0};//
           50 : read_addr = {1'd1, 6'd1};
           51 : read_addr = {1'd0, 6'd0};//
           52 : read_addr = {1'd0, 6'd1};
           53 : read_addr = {1'd1, 6'd2};
*/