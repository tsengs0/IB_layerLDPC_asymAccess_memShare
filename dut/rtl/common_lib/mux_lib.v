module scalable_mux #(
	parameter BITWIDTH = 3
) (
	output wire [BITWIDTH-1:0] sw_out,
	input wire [BITWIDTH-1:0] sw_in_0,
	input wire [BITWIDTH-1:0] sw_in_1,
	input wire in_src
);

assign sw_out[BITWIDTH-1:0] = (in_src == 1'b0) ? sw_in_0[BITWIDTH-1:0] : sw_in_1[BITWIDTH-1:0];
endmodule

module scalable_mux_3_to_1 #(
	parameter BITWIDTH = 5
) (
	output wire [BITWIDTH-1:0] sw_out,
	input wire [BITWIDTH-1:0] sw_in_0,
	input wire [BITWIDTH-1:0] sw_in_1,
	input wire [BITWIDTH-1:0] sw_in_2,
	input wire [2:0] in_src
);

wire [BITWIDTH-1:0] temp_0 = (in_src[0] == 1'b1) ? sw_in_0[BITWIDTH-1:0] : {BITWIDTH{1'b0}};
wire [BITWIDTH-1:0] temp_1 = (in_src[1] == 1'b1) ? sw_in_1[BITWIDTH-1:0] : {BITWIDTH{1'b0}};
wire [BITWIDTH-1:0] temp_2 = (in_src[2] == 1'b1) ? sw_in_2[BITWIDTH-1:0] : {BITWIDTH{1'b0}};
assign sw_out[BITWIDTH-1:0] = temp_0[BITWIDTH-1:0]^temp_1[BITWIDTH-1:0]^temp_2[BITWIDTH-1:0];
endmodule