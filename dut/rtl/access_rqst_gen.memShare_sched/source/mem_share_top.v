`define VN_F0_EVAL
`define Q_4BIT


`ifdef VN_F0_EVAL
`ifdef Q_4_BIT

module mem_share_top_vnu3_f0 #(
	parameter SHARED_GROUP_SIZE = 2, // the number of requestors in one sharing group 
	parameter SHARED_BANK_NUM = 4, // the number of shared column-bank memories/IB-LUTs
	parameter RQST_FLAG = 1'b1, // either Assertion or Deassertion stands for a access request
	parameter COL_ADDR_BITWIDTH = 3,
	parameter ROW_ADDR_BITWIDTH = 4,
	parameter BITWIDTH = 4,
	parameter WCL = 2,

	parameter PARALLELISM_COL_4_6 = 2,
	parameter PARALLELISM_COL_5_7 = 1,
	parameter ENTRY_ADDR = 7
) (
	output wire [BITWIDTH-1:0] Dout_vnu_0,
	output wire [BITWIDTH-1:0] Dout_vnu_1,

	// Requested Column Addresses
	input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_1,
	input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_2,

	// Requested Row Addresses
	input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_1,
	input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_2,
	input wire rd_multi_iter_offset, // one LUTRAM contains two iterations' corresponding dataset

	// LUT-Update Signals
    input wire [BITWIDTH-1:0] wr_Din_high_group,
    input wire [BITWIDTH-1:0] wr_Din_low_group,
    input wire [ENTRY_ADDR-1:0] write_addr, 
   	input wire we,

	input wire write_clk,
	input wire read_clk,
	input rstn
);


wire [ROW_ADDR_BITWIDTH-1:0] mem_addrIn_interconnect [0:(SHARED_GROUP_SIZE+((SHARED_GROUP_SIZE/2)*3))-1];
vn_f0_mem_share_ctrl_4bit #(
		.SHARED_GROUP_SIZE(SHARED_GROUP_SIZE),
		.SHARED_BANK_NUM(SHARED_BANK_NUM),
		.RQST_FLAG(RQST_FLAG),
		.COL_ADDR_BITWIDTH(COL_ADDR_BITWIDTH),
		.ROW_ADDR_BITWIDTH(ROW_ADDR_BITWIDTH),
		.BITWIDTH(BITWIDTH)
) inst_mem_share_ctrl_4bit (
		// Column-8and 10 row addresses for granted rquestors
		.grant_rqstAddr_col_8_10_parallel_1 (mem_addrIn_interconnect[0]),
		.grant_rqstAddr_col_8_10_parallel_2 (mem_addrIn_interconnect[1]),

		// Column-9 and 11 row addresses for granted rquestors
		// Column-12 and 13 row addresses for granted rquestors
		// Column-14 and 15 row addresses for granted rquestors
		.grant_rqstAddr_col_9_11_parallel_1  (mem_addrIn_interconnect[2]),
		.grant_rqstAddr_col_12_13_parallel_1 (mem_addrIn_interconnect[3]),
		.grant_rqstAddr_col_14_15_parallel_1 (mem_addrIn_interconnect[4]),


		// Requested Column Addresses
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_1,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_2,

		// Requested Row Addresses
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_1,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_2,


		input wire sys_clk,
		input rstn
);

reg sw_sel_rqst_1;
reg [WCL-1:0] sw_sel_rqst_2;
initial begin
	sw_sel_rqst_1 <= 0;
	sw_sel_rqst_2 <= 0;
end
always @(posedge read_clk) begin
	if(~rstn) begin
		sw_sel_rqst_1 <= 0;
	end 
	else begin
		sw_sel_rqst_1 <= col_addr_rqst_1[COL_ADDR_BITWIDTH-1:0];
	end
end

always @(posedge read_clk) begin
	if(~rstn) begin
		sw_sel_rqst_2 <= 0;
	end
	else begin
		sw_sel_rqst_2[WCL-1:0] <= {sw_sel_rqst_2[0], 1'b0};
	end
end
///////////////////////////////////////////////////////////////////////////////////
// Memory Instantiation
wire [BITWIDTH-1:0] Dout_high_group [0:PARALLELISM_COL_4_6-1];
wire [BITWIDTH-1:0] Dout_low_group [0:PARALLELISM_COL_5_7-1];
vn_f0_mem_share_group_2 #(
	.PARALLELISM_COL_4_6 (PARALLELISM_COL_4_6),
	.PARALLELISM_COL_5_7 (PARALLELISM_COL_5_7),
	.QUAN_SIZE (BITWIDTH),
	.ENTRY_ADDR (ENTRY_ADDR)
) mem_u0(
    .Dout_high_group0 (Dout_high_group[0]),
    .Dout_high_group1 (Dout_high_group[1]),
    .Dout_low_group0 (Dout_low_group[0]),

    .read_addr_high_group_0 ({rd_multi_iter_offset, mem_addrIn_interconnect[0]}),
    .read_addr_high_group_1 ({rd_multi_iter_offset, mem_addrIn_interconnect[1]}),
    .read_addr_low_group_0  ({rd_multi_iter_offset, mem_addrIn_interconnect[2]}),
 
    .wr_Din_high_group (wr_Din_high_group[BITWIDTH-1:0]),
    .wr_Din_low_group  (wr_Din_low_group [BITWIDTH-1:0]),
    .write_addr (write_addr[ENTRY_ADDR-1:0]),      
    .we (we),
	.write_clk (write_clk)
);
///////////////////////////////////////////////////////////////////////////////////
// Memory Data Output Switching Network
wire [SHARED_GROUP_SIZE-1:0] sw_sel;
assign sw_sel[0] = sw_sel_rqst_1;
assign sw_sel[1] = sw_sel_rqst_2[WCL-1];
wire [BITWIDTH-1:0] mem_switch_out [0:SHARED_GROUP_SIZE-1];
assign Dout_vnu_0[BITWIDTH-1:0] = mem_switch_out[0];
assign Dout_vnu_1[BITWIDTH-1:0] = mem_switch_out[1];
genvar i;
generate
	for(i=0;i<SHARED_GROUP_SIZE;i=i+1) begin : mem_dout_switch_inst
		mem_out_switch #(
			.SHARED_BANK_NUM (SHARED_BANK_NUM), // the number of requestors in one sharing group 
			.BITWIDTH        (BITWIDTH       )
		) mem_out_switch_u (
			.Dout (mem_switch_out[i]),

			.Din0 (Dout_high_group[i]),
			.Din1 (Dout_low_group[i%PARALLELISM_COL_5_7]),
			.sel (sw_sel[i])
		);
	end
endgenerate
endmodule

`else // Q_3_BIT

module mem_share_top_vnu3_f0 #(
	parameter SHARED_GROUP_SIZE = 2, // the number of requestors in one sharing group 
	parameter SHARED_BANK_NUM = 2, // the number of shared column-bank memories/IB-LUTs
	parameter RQST_FLAG = 1'b1, // either Assertion or Deassertion stands for a access request
	parameter COL_ADDR_BITWIDTH = 1,
	parameter ROW_ADDR_BITWIDTH = 4,
	parameter BITWIDTH = 3,
	parameter WCL = 2,

	parameter PARALLELISM_COL_4_6 = 2,
	parameter PARALLELISM_COL_5_7 = 1,
	parameter ENTRY_ADDR = 5
) (
	output wire [BITWIDTH-1:0] Dout_vnu_0,
	output wire [BITWIDTH-1:0] Dout_vnu_1,

	// Requested Column Addresses
	input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_1,
	input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_2,

	// Requested Row Addresses
	input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_1,
	input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_2,
	input wire rd_multi_iter_offset, // one LUTRAM contains two iterations' corresponding dataset

	// LUT-Update Signals
    input wire [BITWIDTH-1:0] wr_Din_high_group,
    input wire [BITWIDTH-1:0] wr_Din_low_group,
    input wire [ENTRY_ADDR-1:0] write_addr, 
   	input wire we,

	input wire write_clk,
	input wire read_clk,
	input rstn
);


wire [ROW_ADDR_BITWIDTH-1:0] mem_addrIn_interconnect [0:(SHARED_GROUP_SIZE+(SHARED_GROUP_SIZE/2))-1];
vn_f0_mem_share_ctrl_3bit #(
		.SHARED_GROUP_SIZE(SHARED_GROUP_SIZE),
		.SHARED_BANK_NUM(SHARED_BANK_NUM),
		.RQST_FLAG(RQST_FLAG),
		.COL_ADDR_BITWIDTH(COL_ADDR_BITWIDTH),
		.ROW_ADDR_BITWIDTH(ROW_ADDR_BITWIDTH),
		.BITWIDTH(BITWIDTH)
) inst_mem_share_ctrl_3bit (
		// Column-4 and 6 row addresses for granted rquestors
		.grant_rqstAddr_col_4_6_parallel_1 (mem_addrIn_interconnect[0]),
		.grant_rqstAddr_col_4_6_parallel_2 (mem_addrIn_interconnect[1]),

		// Column-5 and 7 row addresses for granted rquestors
		.grant_rqstAddr_col_5_7_parallel_1 (mem_addrIn_interconnect[2]),


		// Requested Column Addresses
		.col_addr_rqst_1 (col_addr_rqst_1[COL_ADDR_BITWIDTH-1:0]),
		.col_addr_rqst_2 (col_addr_rqst_2[COL_ADDR_BITWIDTH-1:0]),

		// Requested Row Addresses
		.row_addr_rqst_1 (row_addr_rqst_1[ROW_ADDR_BITWIDTH-1:0]),
		.row_addr_rqst_2 (row_addr_rqst_2[ROW_ADDR_BITWIDTH-1:0]),

		.sys_clk (read_clk),
		.rstn (rstn)
);


reg sw_sel_rqst_1;
reg [WCL-1:0] sw_sel_rqst_2;
initial begin
	sw_sel_rqst_1 <= 0;
	sw_sel_rqst_2 <= 0;
end
always @(posedge read_clk) begin
	if(~rstn) begin
		sw_sel_rqst_1 <= 0;
	end 
	else begin
		sw_sel_rqst_1 <= col_addr_rqst_1[COL_ADDR_BITWIDTH-1:0];
	end
end

always @(posedge read_clk) begin
	if(~rstn) begin
		sw_sel_rqst_2 <= 0;
	end
	else begin
		sw_sel_rqst_2[WCL-1:0] <= {sw_sel_rqst_2[0], 1'b0};
	end
end
///////////////////////////////////////////////////////////////////////////////////
// Memory Instantiation
wire [BITWIDTH-1:0] Dout_high_group [0:PARALLELISM_COL_4_6-1];
wire [BITWIDTH-1:0] Dout_low_group [0:PARALLELISM_COL_5_7-1];
vn_f0_mem_share_group_2 #(
	.PARALLELISM_COL_4_6 (PARALLELISM_COL_4_6),
	.PARALLELISM_COL_5_7 (PARALLELISM_COL_5_7),
	.QUAN_SIZE (BITWIDTH),
	.ENTRY_ADDR (ENTRY_ADDR)
) mem_u0(
    .Dout_high_group0 (Dout_high_group[0]),
    .Dout_high_group1 (Dout_high_group[1]),
    .Dout_low_group0 (Dout_low_group[0]),

    .read_addr_high_group_0 ({rd_multi_iter_offset, mem_addrIn_interconnect[0]}),
    .read_addr_high_group_1 ({rd_multi_iter_offset, mem_addrIn_interconnect[1]}),
    .read_addr_low_group_0  ({rd_multi_iter_offset, mem_addrIn_interconnect[2]}),
 
    .wr_Din_high_group (wr_Din_high_group[BITWIDTH-1:0]),
    .wr_Din_low_group  (wr_Din_low_group [BITWIDTH-1:0]),
    .write_addr (write_addr[ENTRY_ADDR-1:0]),      
    .we (we),
	.write_clk (write_clk)
);
///////////////////////////////////////////////////////////////////////////////////
// Memory Data Output Switching Network
wire [SHARED_GROUP_SIZE-1:0] sw_sel;
assign sw_sel[0] = sw_sel_rqst_1;
assign sw_sel[1] = sw_sel_rqst_2[WCL-1];
wire [BITWIDTH-1:0] mem_switch_out [0:SHARED_GROUP_SIZE-1];
assign Dout_vnu_0[BITWIDTH-1:0] = mem_switch_out[0];
assign Dout_vnu_1[BITWIDTH-1:0] = mem_switch_out[1];
genvar i;
generate
	for(i=0;i<SHARED_GROUP_SIZE;i=i+1) begin : mem_dout_switch_inst
		mem_out_switch #(
			.SHARED_BANK_NUM (SHARED_BANK_NUM), // the number of requestors in one sharing group 
			.BITWIDTH        (BITWIDTH       )
		) mem_out_switch_u (
			.Dout (mem_switch_out[i]),

			.Din0 (Dout_high_group[i]),
			.Din1 (Dout_low_group[i%PARALLELISM_COL_5_7]),
			.sel (sw_sel[i])
		);
	end
endgenerate
endmodule
`endif

`else // VN_F1_EVAL

`ifdef Q_4_BIT

`else // Q_3_BIT

module mem_share_top_vnu3_f1 #(
	parameter SHARED_GROUP_SIZE = 6, // the number of requestors in one sharing group 
	parameter SHARED_BANK_NUM = 2, // the number of shared column-bank memories/IB-LUTs
	parameter RQST_FLAG = 1'b1, // either Assertion or Deassertion stands for a access request
	parameter COL_ADDR_BITWIDTH = 1,
	parameter ROW_ADDR_BITWIDTH = 4,
	parameter BITWIDTH = 3,
	parameter WCL = 2,

	parameter PARALLELISM_COL_4_6 = 6,
	parameter PARALLELISM_COL_5_7 = 3,
	parameter ENTRY_ADDR = 5
) (
	output wire [BITWIDTH-1:0] Dout_vnu_0,
	output wire [BITWIDTH-1:0] Dout_vnu_1,
	output wire [BITWIDTH-1:0] Dout_vnu_2,
	output wire [BITWIDTH-1:0] Dout_vnu_3,
	output wire [BITWIDTH-1:0] Dout_vnu_4,
	output wire [BITWIDTH-1:0] Dout_vnu_5,

	// Requested Column Addresses
	input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_1,
	input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_2,
	input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_3,
	input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_4,
	input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_5,
	input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_6,
	// Requested Row Addresses
	input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_1,
	input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_2,
	input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_3,
	input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_4,
	input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_5,
	input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_6,
	input wire rd_multi_iter_offset, // one LUTRAM contains two iterations' corresponding dataset

	// LUT-Update Signals
    input wire [BITWIDTH-1:0] wr_Din_high_group,
    input wire [BITWIDTH-1:0] wr_Din_low_group,
    input wire [ENTRY_ADDR-1:0] write_addr, 
   	input wire we,

	input wire write_clk,
	input wire read_clk,
	input rstn
);


wire [ROW_ADDR_BITWIDTH-1:0] mem_addrIn_interconnect [0:(SHARED_GROUP_SIZE+(SHARED_GROUP_SIZE/2))-1];
vn_f1_mem_share_ctrl_3bit #(
		.SHARED_GROUP_SIZE(SHARED_GROUP_SIZE),
		.SHARED_BANK_NUM(SHARED_BANK_NUM),
		.RQST_FLAG(RQST_FLAG),
		.COL_ADDR_BITWIDTH(COL_ADDR_BITWIDTH),
		.ROW_ADDR_BITWIDTH(ROW_ADDR_BITWIDTH),
		.BITWIDTH(BITWIDTH)
) inst_mem_share_ctrl_3bit (
		// Column-4 and 6 row addresses for granted rquestors
		.grant_rqstAddr_col_4_6_parallel_1 (mem_addrIn_interconnect[0]),
		.grant_rqstAddr_col_4_6_parallel_2 (mem_addrIn_interconnect[1]),
		.grant_rqstAddr_col_4_6_parallel_3 (mem_addrIn_interconnect[2]),
		.grant_rqstAddr_col_4_6_parallel_4 (mem_addrIn_interconnect[3]),
		.grant_rqstAddr_col_4_6_parallel_5 (mem_addrIn_interconnect[4]),
		.grant_rqstAddr_col_4_6_parallel_6 (mem_addrIn_interconnect[5]),
		// Column-5 and 7 row addresses for granted rquestors
		.grant_rqstAddr_col_5_7_parallel_1 (mem_addrIn_interconnect[6]),
		.grant_rqstAddr_col_5_7_parallel_2 (mem_addrIn_interconnect[7]),
		.grant_rqstAddr_col_5_7_parallel_3 (mem_addrIn_interconnect[8]),

		// Requested Column Addresses
		.col_addr_rqst_1 (col_addr_rqst_1[COL_ADDR_BITWIDTH-1:0]),
		.col_addr_rqst_2 (col_addr_rqst_2[COL_ADDR_BITWIDTH-1:0]),
		.col_addr_rqst_3 (col_addr_rqst_3[COL_ADDR_BITWIDTH-1:0]),
		.col_addr_rqst_4 (col_addr_rqst_4[COL_ADDR_BITWIDTH-1:0]),
		.col_addr_rqst_5 (col_addr_rqst_5[COL_ADDR_BITWIDTH-1:0]),
		.col_addr_rqst_6 (col_addr_rqst_6[COL_ADDR_BITWIDTH-1:0]),
		// Requested Row Addresses
		.row_addr_rqst_1 (row_addr_rqst_1[ROW_ADDR_BITWIDTH-1:0]),
		.row_addr_rqst_2 (row_addr_rqst_2[ROW_ADDR_BITWIDTH-1:0]),
		.row_addr_rqst_3 (row_addr_rqst_3[ROW_ADDR_BITWIDTH-1:0]),
		.row_addr_rqst_4 (row_addr_rqst_4[ROW_ADDR_BITWIDTH-1:0]),
		.row_addr_rqst_5 (row_addr_rqst_5[ROW_ADDR_BITWIDTH-1:0]),
		.row_addr_rqst_6 (row_addr_rqst_6[ROW_ADDR_BITWIDTH-1:0]),

		.sys_clk (read_clk),
		.rstn (rstn)
);


reg sw_sel_rqst_1, sw_sel_rqst_3, sw_sel_rqst_5;
reg [WCL-1:0] sw_sel_rqst_2, sw_sel_rqst_4, sw_sel_rqst_6;
initial begin
	sw_sel_rqst_1 <= 0;
	sw_sel_rqst_2 <= 0;
	sw_sel_rqst_3 <= 0;
	sw_sel_rqst_4 <= 0;
	sw_sel_rqst_5 <= 0;
	sw_sel_rqst_6 <= 0;
end
always @(posedge read_clk) begin
	if(~rstn) begin
		sw_sel_rqst_1 <= 0;
		sw_sel_rqst_3 <= 0;
		sw_sel_rqst_5 <= 0;
	end 
	else begin
		sw_sel_rqst_1 <= col_addr_rqst_1[COL_ADDR_BITWIDTH-1:0];
		sw_sel_rqst_3 <= col_addr_rqst_3[COL_ADDR_BITWIDTH-1:0];
		sw_sel_rqst_5 <= col_addr_rqst_5[COL_ADDR_BITWIDTH-1:0];
	end
end

always @(posedge read_clk) begin
	if(~rstn) begin
		sw_sel_rqst_2 <= 0;
		sw_sel_rqst_4 <= 0;
		sw_sel_rqst_6 <= 0;
	end
	else begin
		sw_sel_rqst_2[WCL-1:0] <= {sw_sel_rqst_2[0], 1'b0};
		sw_sel_rqst_4[WCL-1:0] <= {sw_sel_rqst_4[0], 1'b0};
		sw_sel_rqst_6[WCL-1:0] <= {sw_sel_rqst_6[0], 1'b0};
	end
end
///////////////////////////////////////////////////////////////////////////////////
// Memory Instantiation
wire [BITWIDTH-1:0] Dout_high_group [0:PARALLELISM_COL_4_6-1];
wire [BITWIDTH-1:0] Dout_low_group [0:PARALLELISM_COL_5_7-1];
vn_f1_mem_share_group_6 #(
	.PARALLELISM_COL_4_6 (PARALLELISM_COL_4_6),
	.PARALLELISM_COL_5_7 (PARALLELISM_COL_5_7),
	.QUAN_SIZE (BITWIDTH),
	.ENTRY_ADDR (ENTRY_ADDR)
) mem_u0(
    .Dout_high_group0 (Dout_high_group[0]),
    .Dout_high_group1 (Dout_high_group[1]),
    .Dout_high_group2 (Dout_high_group[2]),
    .Dout_high_group3 (Dout_high_group[3]),
    .Dout_high_group4 (Dout_high_group[4]),
    .Dout_high_group5 (Dout_high_group[5]),
    .Dout_low_group0 (Dout_low_group[0]),
    .Dout_low_group1 (Dout_low_group[1]),
    .Dout_low_group2 (Dout_low_group[2]),

    .read_addr_high_group_0 ({rd_multi_iter_offset, mem_addrIn_interconnect[0]}),
    .read_addr_high_group_1 ({rd_multi_iter_offset, mem_addrIn_interconnect[1]}),
    .read_addr_high_group_2 ({rd_multi_iter_offset, mem_addrIn_interconnect[2]}),
    .read_addr_high_group_3 ({rd_multi_iter_offset, mem_addrIn_interconnect[3]}),
    .read_addr_high_group_4 ({rd_multi_iter_offset, mem_addrIn_interconnect[4]}),
    .read_addr_high_group_5 ({rd_multi_iter_offset, mem_addrIn_interconnect[5]}),
    .read_addr_low_group_0  ({rd_multi_iter_offset, mem_addrIn_interconnect[6]}),
    .read_addr_low_group_1  ({rd_multi_iter_offset, mem_addrIn_interconnect[7]}),
    .read_addr_low_group_2  ({rd_multi_iter_offset, mem_addrIn_interconnect[8]}),
 
    .wr_Din_high_group (wr_Din_high_group[BITWIDTH-1:0]),
    .wr_Din_low_group  (wr_Din_low_group [BITWIDTH-1:0]),
    .write_addr (write_addr[ENTRY_ADDR-1:0]),      
    .we (we),
	.write_clk (write_clk)
);
///////////////////////////////////////////////////////////////////////////////////
// Memory Data Output Switching Network
wire [SHARED_GROUP_SIZE-1:0] sw_sel;
assign sw_sel[0] = sw_sel_rqst_1;
assign sw_sel[1] = sw_sel_rqst_3;
assign sw_sel[2] = sw_sel_rqst_5;
assign sw_sel[3] = sw_sel_rqst_2[WCL-1];
assign sw_sel[4] = sw_sel_rqst_4[WCL-1];
assign sw_sel[5] = sw_sel_rqst_6[WCL-1];
wire [BITWIDTH-1:0] mem_switch_out [0:SHARED_GROUP_SIZE-1];
assign Dout_vnu_0[BITWIDTH-1:0] = mem_switch_out[0];
assign Dout_vnu_1[BITWIDTH-1:0] = mem_switch_out[1];
assign Dout_vnu_2[BITWIDTH-1:0] = mem_switch_out[2];
assign Dout_vnu_3[BITWIDTH-1:0] = mem_switch_out[3];
assign Dout_vnu_4[BITWIDTH-1:0] = mem_switch_out[4];
assign Dout_vnu_5[BITWIDTH-1:0] = mem_switch_out[5];
genvar i;
generate
	for(i=0;i<SHARED_GROUP_SIZE;i=i+1) begin : mem_dout_switch_inst
		mem_out_switch #(
			.SHARED_BANK_NUM (SHARED_BANK_NUM), // the number of requestors in one sharing group 
			.BITWIDTH        (BITWIDTH       )
		) mem_out_switch_u (
			.Dout (mem_switch_out[i]),

			.Din0 (Dout_high_group[i]),
			.Din1 (Dout_low_group[i%PARALLELISM_COL_5_7]),
			.sel (sw_sel[i])
		);
	end
endgenerate
endmodule
`endif

`endif