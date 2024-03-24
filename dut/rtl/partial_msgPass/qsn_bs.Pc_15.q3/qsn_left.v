module qsn_left_len15 (
	output wire [13:0] sw_out,

	input wire [14:0] sw_in,
	input wire [3:0] sel,
	input wire sys_clk,
	input wire rstn
);

	// Multiplexer Stage 3
	wire [6:0] mux_stage_3;
	assign mux_stage_3[0] = (sel[3] == 1'b1) ? sw_in[8] : sw_in[0];
	assign mux_stage_3[1] = (sel[3] == 1'b1) ? sw_in[9] : sw_in[1];
	assign mux_stage_3[2] = (sel[3] == 1'b1) ? sw_in[10] : sw_in[2];
	assign mux_stage_3[3] = (sel[3] == 1'b1) ? sw_in[11] : sw_in[3];
	assign mux_stage_3[4] = (sel[3] == 1'b1) ? sw_in[12] : sw_in[4];
	assign mux_stage_3[5] = (sel[3] == 1'b1) ? sw_in[13] : sw_in[5];
	assign mux_stage_3[6] = (sel[3] == 1'b1) ? sw_in[14] : sw_in[6];

	// Multiplexer Stage 2
	reg [10:0] mux_stage_2;
	always @(posedge sys_clk) begin if(!rstn) mux_stage_2[0] <= 0; else if(sel[2] == 1'b1) mux_stage_2[0] <= mux_stage_3[4]; else mux_stage_2[0] <= mux_stage_3[0]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_2[1] <= 0; else if(sel[2] == 1'b1) mux_stage_2[1] <= mux_stage_3[5]; else mux_stage_2[1] <= mux_stage_3[1]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_2[2] <= 0; else if(sel[2] == 1'b1) mux_stage_2[2] <= mux_stage_3[6]; else mux_stage_2[2] <= mux_stage_3[2]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_2[3] <= 0; else if(sel[2] == 1'b1) mux_stage_2[3] <= sw_in[7]; else mux_stage_2[3] <= mux_stage_3[3]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_2[4] <= 0; else if(sel[2] == 1'b1) mux_stage_2[4] <= sw_in[8]; else mux_stage_2[4] <= mux_stage_3[4]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_2[5] <= 0; else if(sel[2] == 1'b1) mux_stage_2[5] <= sw_in[9]; else mux_stage_2[5] <= mux_stage_3[5]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_2[6] <= 0; else if(sel[2] == 1'b1) mux_stage_2[6] <= sw_in[10]; else mux_stage_2[6] <= mux_stage_3[6]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_2[7] <= 0; else if(sel[2] == 1'b1) mux_stage_2[7] <= sw_in[11]; else mux_stage_2[7] <= sw_in[7]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_2[8] <= 0; else if(sel[2] == 1'b1) mux_stage_2[8] <= sw_in[12]; else mux_stage_2[8] <= sw_in[8]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_2[9] <= 0; else if(sel[2] == 1'b1) mux_stage_2[9] <= sw_in[13]; else mux_stage_2[9] <= sw_in[9]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_2[10] <= 0; else if(sel[2] == 1'b1) mux_stage_2[10] <= sw_in[14]; else mux_stage_2[10] <= sw_in[10]; end

	reg sw_in_11_reg0; 	always @(posedge sys_clk) begin if(!rstn) sw_in_11_reg0 <= 0; else sw_in_11_reg0 <= sw_in[11]; end
	reg sw_in_12_reg0; 	always @(posedge sys_clk) begin if(!rstn) sw_in_12_reg0 <= 0; else sw_in_12_reg0 <= sw_in[12]; end
	reg sw_in_13_reg0; 	always @(posedge sys_clk) begin if(!rstn) sw_in_13_reg0 <= 0; else sw_in_13_reg0 <= sw_in[13]; end
	reg sw_in_14_reg0; 	always @(posedge sys_clk) begin if(!rstn) sw_in_14_reg0 <= 0; else sw_in_14_reg0 <= sw_in[14]; end

	reg sel_1_reg0;
	always @(posedge sys_clk) begin if(!rstn) sel_1_reg0 <= 0; else sel_1_reg0 <= sel[1]; end	

	// Multiplexer Stage 1
	wire [12:0] mux_stage_1;
	assign mux_stage_1[0] = (sel_1_reg0 == 1'b1) ? mux_stage_2[2] : mux_stage_2[0];
	assign mux_stage_1[1] = (sel_1_reg0 == 1'b1) ? mux_stage_2[3] : mux_stage_2[1];
	assign mux_stage_1[2] = (sel_1_reg0 == 1'b1) ? mux_stage_2[4] : mux_stage_2[2];
	assign mux_stage_1[3] = (sel_1_reg0 == 1'b1) ? mux_stage_2[5] : mux_stage_2[3];
	assign mux_stage_1[4] = (sel_1_reg0 == 1'b1) ? mux_stage_2[6] : mux_stage_2[4];
	assign mux_stage_1[5] = (sel_1_reg0 == 1'b1) ? mux_stage_2[7] : mux_stage_2[5];
	assign mux_stage_1[6] = (sel_1_reg0 == 1'b1) ? mux_stage_2[8] : mux_stage_2[6];
	assign mux_stage_1[7] = (sel_1_reg0 == 1'b1) ? mux_stage_2[9] : mux_stage_2[7];
	assign mux_stage_1[8] = (sel_1_reg0 == 1'b1) ? mux_stage_2[10] : mux_stage_2[8];
	assign mux_stage_1[9] = (sel_1_reg0 == 1'b1) ? sw_in_11_reg0 : mux_stage_2[9];
	assign mux_stage_1[10] = (sel_1_reg0 == 1'b1) ? sw_in_12_reg0 : mux_stage_2[10];
	assign mux_stage_1[11] = (sel_1_reg0 == 1'b1) ? sw_in_13_reg0 : sw_in_11_reg0;
	assign mux_stage_1[12] = (sel_1_reg0 == 1'b1) ? sw_in_14_reg0 : sw_in_12_reg0;


	reg sel_0_reg0;
	always @(posedge sys_clk) begin if(!rstn) sel_0_reg0 <= 0; else sel_0_reg0 <= sel[0]; end	

	// Multiplexer Stage 0
	wire [13:0] mux_stage_0;
	assign mux_stage_0[0] = (sel_0_reg0 == 1'b1) ? mux_stage_1[1] : mux_stage_1[0];
	assign mux_stage_0[1] = (sel_0_reg0 == 1'b1) ? mux_stage_1[2] : mux_stage_1[1];
	assign mux_stage_0[2] = (sel_0_reg0 == 1'b1) ? mux_stage_1[3] : mux_stage_1[2];
	assign mux_stage_0[3] = (sel_0_reg0 == 1'b1) ? mux_stage_1[4] : mux_stage_1[3];
	assign mux_stage_0[4] = (sel_0_reg0 == 1'b1) ? mux_stage_1[5] : mux_stage_1[4];
	assign mux_stage_0[5] = (sel_0_reg0 == 1'b1) ? mux_stage_1[6] : mux_stage_1[5];
	assign mux_stage_0[6] = (sel_0_reg0 == 1'b1) ? mux_stage_1[7] : mux_stage_1[6];
	assign mux_stage_0[7] = (sel_0_reg0 == 1'b1) ? mux_stage_1[8] : mux_stage_1[7];
	assign mux_stage_0[8] = (sel_0_reg0 == 1'b1) ? mux_stage_1[9] : mux_stage_1[8];
	assign mux_stage_0[9] = (sel_0_reg0 == 1'b1) ? mux_stage_1[10] : mux_stage_1[9];
	assign mux_stage_0[10] = (sel_0_reg0 == 1'b1) ? mux_stage_1[11] : mux_stage_1[10];
	assign mux_stage_0[11] = (sel_0_reg0 == 1'b1) ? mux_stage_1[12] : mux_stage_1[11];
	assign mux_stage_0[12] = (sel_0_reg0 == 1'b1) ? sw_in_13_reg0 : mux_stage_1[12];
	assign mux_stage_0[13] = (sel_0_reg0 == 1'b1) ? sw_in_14_reg0 : sw_in_13_reg0;

	assign sw_out[13:0] = mux_stage_0[13:0];
endmodule