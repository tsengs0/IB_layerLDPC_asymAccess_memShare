//`define BEYOND_TECH_SPEC
`define XILINX_LUTRAM_TECH

`ifdef BEYOND_TECH_SPEC
module mem_out_switch #(
	parameter SHARED_BANK_NUM = 4, // the number of requestors in one sharing group 
	parameter BITWIDTH = 3
) (
	output reg [BITWIDTH-1:0] Dout,

	input wire [BITWIDTH-1:0] Din0,
	input wire [BITWIDTH-1:0] Din1,
	input wire [BITWIDTH-1:0] Din2,
	input wire [BITWIDTH-1:0] Din3,
	input wire [$clog2(SHARED_BANK_NUM)-1:0] sel
);

always @(*) begin
	case(sel)
		0: Dout[BITWIDTH-1:0] = Din0[BITWIDTH-1:0];
		1: Dout[BITWIDTH-1:0] = Din1[BITWIDTH-1:0];
		2: Dout[BITWIDTH-1:0] = Din2[BITWIDTH-1:0];
		3: Dout[BITWIDTH-1:0] = Din3[BITWIDTH-1:0];
		default: Dout[BITWIDTH-1:0] = Din0[BITWIDTH-1:0];
	endcase
end
endmodule
`elsif XILINX_LUTRAM_TECH
module mem_out_switch #(
	parameter SHARED_BANK_NUM = 2, // the number of requestors in one sharing group 
	parameter BITWIDTH = 3
) (
	output reg [BITWIDTH-1:0] Dout,

	input wire [BITWIDTH-1:0] Din0,
	input wire [BITWIDTH-1:0] Din1,
	input wire [$clog2(SHARED_BANK_NUM)-1:0] sel
);

always @(*) begin
	case(sel)
		0: Dout[BITWIDTH-1:0] = Din0[BITWIDTH-1:0];
		1: Dout[BITWIDTH-1:0] = Din1[BITWIDTH-1:0];
		default: Dout[BITWIDTH-1:0] = Din0[BITWIDTH-1:0];
	endcase
end
endmodule

module mem_out_switch_group4 #(
	parameter SHARED_BANK_NUM = 4, // the number of requestors in one sharing group 
	parameter BITWIDTH = 3
) (
	output reg [BITWIDTH-1:0] Dout,

	input wire [BITWIDTH-1:0] Din0,
	input wire [BITWIDTH-1:0] Din1,
	input wire [BITWIDTH-1:0] Din2,
	input wire [BITWIDTH-1:0] Din3,
	input wire [$clog2(SHARED_BANK_NUM)-1:0] sel
);

always @(*) begin
	case(sel)
		0: Dout[BITWIDTH-1:0] = Din0[BITWIDTH-1:0];
		1: Dout[BITWIDTH-1:0] = Din1[BITWIDTH-1:0];
		2: Dout[BITWIDTH-1:0] = Din2[BITWIDTH-1:0];
		3: Dout[BITWIDTH-1:0] = Din3[BITWIDTH-1:0];
		default: Dout[BITWIDTH-1:0] = Din0[BITWIDTH-1:0];
	endcase
end
endmodule
`else
module mem_out_switch #(
	parameter SHARED_BANK_NUM = 4, // the number of requestors in one sharing group 
	parameter BITWIDTH = 3
) (
	output reg [BITWIDTH-1:0] Dout,

	input wire [BITWIDTH-1:0] Din0,
	input wire [BITWIDTH-1:0] Din1,
	input wire [BITWIDTH-1:0] Din2,
	input wire [BITWIDTH-1:0] Din3,
	input wire [$clog2(SHARED_BANK_NUM)-1:0] sel
);

always @(*) begin
	case(sel)
		0: Dout[BITWIDTH-1:0] = Din0[BITWIDTH-1:0];
		1: Dout[BITWIDTH-1:0] = Din1[BITWIDTH-1:0];
		2: Dout[BITWIDTH-1:0] = Din2[BITWIDTH-1:0];
		3: Dout[BITWIDTH-1:0] = Din3[BITWIDTH-1:0];
		default: Dout[BITWIDTH-1:0] = Din0[BITWIDTH-1:0];
	endcase
end
endmodule
`endif
