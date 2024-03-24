module qsn_right_len17 (
	output wire [16:0] sw_out,

	input wire [16:0] sw_in,
	input wire [4:0] sel,
	input wire sys_clk,
	input wire rstn
);

	// Multiplexer Stage 4
	wire [0:0] mux_stage_4;
	assign mux_stage_4[0] = (sel[4] == 1'b1) ? sw_in[0] : sw_in[16];

	// Multiplexer Stage 3
	reg [8:0] mux_stage_3;
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[0] <= 0; else if(sel[3] == 1'b1) mux_stage_3[0] <= sw_in[8]; else mux_stage_3[0] <= mux_stage_4[0]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[1] <= 0; else if(sel[3] == 1'b1) mux_stage_3[1] <= sw_in[7]; else mux_stage_3[1] <= sw_in[15]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[2] <= 0; else if(sel[3] == 1'b1) mux_stage_3[2] <= sw_in[6]; else mux_stage_3[2] <= sw_in[14]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[3] <= 0; else if(sel[3] == 1'b1) mux_stage_3[3] <= sw_in[5]; else mux_stage_3[3] <= sw_in[13]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[4] <= 0; else if(sel[3] == 1'b1) mux_stage_3[4] <= sw_in[4]; else mux_stage_3[4] <= sw_in[12]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[5] <= 0; else if(sel[3] == 1'b1) mux_stage_3[5] <= sw_in[3]; else mux_stage_3[5] <= sw_in[11]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[6] <= 0; else if(sel[3] == 1'b1) mux_stage_3[6] <= sw_in[2]; else mux_stage_3[6] <= sw_in[10]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[7] <= 0; else if(sel[3] == 1'b1) mux_stage_3[7] <= sw_in[1]; else mux_stage_3[7] <= sw_in[9]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[8] <= 0; else if(sel[3] == 1'b1) mux_stage_3[8] <= sw_in[0]; else mux_stage_3[8] <= sw_in[8]; end

	reg sw_in_7_reg0; 	always @(posedge sys_clk) begin if(!rstn) sw_in_7_reg0 <= 0; else sw_in_7_reg0 <= sw_in[7]; end
	reg sw_in_6_reg0; 	always @(posedge sys_clk) begin if(!rstn) sw_in_6_reg0 <= 0; else sw_in_6_reg0 <= sw_in[6]; end
	reg sw_in_5_reg0; 	always @(posedge sys_clk) begin if(!rstn) sw_in_5_reg0 <= 0; else sw_in_5_reg0 <= sw_in[5]; end
	reg sw_in_4_reg0; 	always @(posedge sys_clk) begin if(!rstn) sw_in_4_reg0 <= 0; else sw_in_4_reg0 <= sw_in[4]; end
	reg sw_in_3_reg0; 	always @(posedge sys_clk) begin if(!rstn) sw_in_3_reg0 <= 0; else sw_in_3_reg0 <= sw_in[3]; end
	reg sw_in_2_reg0; 	always @(posedge sys_clk) begin if(!rstn) sw_in_2_reg0 <= 0; else sw_in_2_reg0 <= sw_in[2]; end
	reg sw_in_1_reg0; 	always @(posedge sys_clk) begin if(!rstn) sw_in_1_reg0 <= 0; else sw_in_1_reg0 <= sw_in[1]; end
	reg sw_in_0_reg0; 	always @(posedge sys_clk) begin if(!rstn) sw_in_0_reg0 <= 0; else sw_in_0_reg0 <= sw_in[0]; end

	reg sel_2_reg0;
	always @(posedge sys_clk) begin if(!rstn) sel_2_reg0 <= 0; else sel_2_reg0 <= sel[2]; end	

	// Multiplexer Stage 2
	wire [12:0] mux_stage_2;
	assign mux_stage_2[0] = (sel_2_reg0 == 1'b1) ? mux_stage_3[4] : mux_stage_3[0];
	assign mux_stage_2[1] = (sel_2_reg0 == 1'b1) ? mux_stage_3[5] : mux_stage_3[1];
	assign mux_stage_2[2] = (sel_2_reg0 == 1'b1) ? mux_stage_3[6] : mux_stage_3[2];
	assign mux_stage_2[3] = (sel_2_reg0 == 1'b1) ? mux_stage_3[7] : mux_stage_3[3];
	assign mux_stage_2[4] = (sel_2_reg0 == 1'b1) ? mux_stage_3[8] : mux_stage_3[4];
	assign mux_stage_2[5] = (sel_2_reg0 == 1'b1) ? sw_in_7_reg0 : mux_stage_3[5];
	assign mux_stage_2[6] = (sel_2_reg0 == 1'b1) ? sw_in_6_reg0 : mux_stage_3[6];
	assign mux_stage_2[7] = (sel_2_reg0 == 1'b1) ? sw_in_5_reg0 : mux_stage_3[7];
	assign mux_stage_2[8] = (sel_2_reg0 == 1'b1) ? sw_in_4_reg0 : mux_stage_3[8];
	assign mux_stage_2[9] = (sel_2_reg0 == 1'b1) ? sw_in_3_reg0 : sw_in_7_reg0;
	assign mux_stage_2[10] = (sel_2_reg0 == 1'b1) ? sw_in_2_reg0 : sw_in_6_reg0;
	assign mux_stage_2[11] = (sel_2_reg0 == 1'b1) ? sw_in_1_reg0 : sw_in_5_reg0;
	assign mux_stage_2[12] = (sel_2_reg0 == 1'b1) ? sw_in_0_reg0 : sw_in_4_reg0;


	reg sel_1_reg0;
	always @(posedge sys_clk) begin if(!rstn) sel_1_reg0 <= 0; else sel_1_reg0 <= sel[1]; end	

	// Multiplexer Stage 1
	wire [14:0] mux_stage_1;
	assign mux_stage_1[0] = (sel_1_reg0 == 1'b1) ? mux_stage_2[2] : mux_stage_2[0];
	assign mux_stage_1[1] = (sel_1_reg0 == 1'b1) ? mux_stage_2[3] : mux_stage_2[1];
	assign mux_stage_1[2] = (sel_1_reg0 == 1'b1) ? mux_stage_2[4] : mux_stage_2[2];
	assign mux_stage_1[3] = (sel_1_reg0 == 1'b1) ? mux_stage_2[5] : mux_stage_2[3];
	assign mux_stage_1[4] = (sel_1_reg0 == 1'b1) ? mux_stage_2[6] : mux_stage_2[4];
	assign mux_stage_1[5] = (sel_1_reg0 == 1'b1) ? mux_stage_2[7] : mux_stage_2[5];
	assign mux_stage_1[6] = (sel_1_reg0 == 1'b1) ? mux_stage_2[8] : mux_stage_2[6];
	assign mux_stage_1[7] = (sel_1_reg0 == 1'b1) ? mux_stage_2[9] : mux_stage_2[7];
	assign mux_stage_1[8] = (sel_1_reg0 == 1'b1) ? mux_stage_2[10] : mux_stage_2[8];
	assign mux_stage_1[9] = (sel_1_reg0 == 1'b1) ? mux_stage_2[11] : mux_stage_2[9];
	assign mux_stage_1[10] = (sel_1_reg0 == 1'b1) ? mux_stage_2[12] : mux_stage_2[10];
	assign mux_stage_1[11] = (sel_1_reg0 == 1'b1) ? sw_in_3_reg0 : mux_stage_2[11];
	assign mux_stage_1[12] = (sel_1_reg0 == 1'b1) ? sw_in_2_reg0 : mux_stage_2[12];
	assign mux_stage_1[13] = (sel_1_reg0 == 1'b1) ? sw_in_1_reg0 : sw_in_3_reg0;
	assign mux_stage_1[14] = (sel_1_reg0 == 1'b1) ? sw_in_0_reg0 : sw_in_2_reg0;


	reg sel_0_reg0;
	always @(posedge sys_clk) begin if(!rstn) sel_0_reg0 <= 0; else sel_0_reg0 <= sel[0]; end	

	// Multiplexer Stage 0
	wire [15:0] mux_stage_0;
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
	assign mux_stage_0[12] = (sel_0_reg0 == 1'b1) ? mux_stage_1[13] : mux_stage_1[12];
	assign mux_stage_0[13] = (sel_0_reg0 == 1'b1) ? mux_stage_1[14] : mux_stage_1[13];
	assign mux_stage_0[14] = (sel_0_reg0 == 1'b1) ? sw_in_1_reg0 : mux_stage_1[14];
	assign mux_stage_0[15] = (sel_0_reg0 == 1'b1) ? sw_in_0_reg0 : sw_in_1_reg0;

	assign sw_out[16:0] = {sw_in_0_reg0, mux_stage_0[15:0]};
endmodule