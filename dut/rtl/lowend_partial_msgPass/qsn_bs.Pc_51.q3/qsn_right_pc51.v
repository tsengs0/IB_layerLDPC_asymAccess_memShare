module qsn_right_len51 (
	output wire [50:0] sw_out,

	input wire [50:0] sw_in,
	input wire [5:0] sel,
	input wire sys_clk,
	input wire rstn
);

	// Multiplexer Stage 5
	wire [18:0] mux_stage_5;
	assign mux_stage_5[0] = (sel[5] == 1'b1) ? sw_in[18] : sw_in[50];
	assign mux_stage_5[1] = (sel[5] == 1'b1) ? sw_in[17] : sw_in[49];
	assign mux_stage_5[2] = (sel[5] == 1'b1) ? sw_in[16] : sw_in[48];
	assign mux_stage_5[3] = (sel[5] == 1'b1) ? sw_in[15] : sw_in[47];
	assign mux_stage_5[4] = (sel[5] == 1'b1) ? sw_in[14] : sw_in[46];
	assign mux_stage_5[5] = (sel[5] == 1'b1) ? sw_in[13] : sw_in[45];
	assign mux_stage_5[6] = (sel[5] == 1'b1) ? sw_in[12] : sw_in[44];
	assign mux_stage_5[7] = (sel[5] == 1'b1) ? sw_in[11] : sw_in[43];
	assign mux_stage_5[8] = (sel[5] == 1'b1) ? sw_in[10] : sw_in[42];
	assign mux_stage_5[9] = (sel[5] == 1'b1) ? sw_in[9] : sw_in[41];
	assign mux_stage_5[10] = (sel[5] == 1'b1) ? sw_in[8] : sw_in[40];
	assign mux_stage_5[11] = (sel[5] == 1'b1) ? sw_in[7] : sw_in[39];
	assign mux_stage_5[12] = (sel[5] == 1'b1) ? sw_in[6] : sw_in[38];
	assign mux_stage_5[13] = (sel[5] == 1'b1) ? sw_in[5] : sw_in[37];
	assign mux_stage_5[14] = (sel[5] == 1'b1) ? sw_in[4] : sw_in[36];
	assign mux_stage_5[15] = (sel[5] == 1'b1) ? sw_in[3] : sw_in[35];
	assign mux_stage_5[16] = (sel[5] == 1'b1) ? sw_in[2] : sw_in[34];
	assign mux_stage_5[17] = (sel[5] == 1'b1) ? sw_in[1] : sw_in[33];
	assign mux_stage_5[18] = (sel[5] == 1'b1) ? sw_in[0] : sw_in[32];

	// Multiplexer Stage 4
	wire [34:0] mux_stage_4;
	assign mux_stage_4[0] = (sel[4] == 1'b1) ? mux_stage_5[16] : mux_stage_5[0];
	assign mux_stage_4[1] = (sel[4] == 1'b1) ? mux_stage_5[17] : mux_stage_5[1];
	assign mux_stage_4[2] = (sel[4] == 1'b1) ? mux_stage_5[18] : mux_stage_5[2];
	assign mux_stage_4[3] = (sel[4] == 1'b1) ? sw_in[31] : mux_stage_5[3];
	assign mux_stage_4[4] = (sel[4] == 1'b1) ? sw_in[30] : mux_stage_5[4];
	assign mux_stage_4[5] = (sel[4] == 1'b1) ? sw_in[29] : mux_stage_5[5];
	assign mux_stage_4[6] = (sel[4] == 1'b1) ? sw_in[28] : mux_stage_5[6];
	assign mux_stage_4[7] = (sel[4] == 1'b1) ? sw_in[27] : mux_stage_5[7];
	assign mux_stage_4[8] = (sel[4] == 1'b1) ? sw_in[26] : mux_stage_5[8];
	assign mux_stage_4[9] = (sel[4] == 1'b1) ? sw_in[25] : mux_stage_5[9];
	assign mux_stage_4[10] = (sel[4] == 1'b1) ? sw_in[24] : mux_stage_5[10];
	assign mux_stage_4[11] = (sel[4] == 1'b1) ? sw_in[23] : mux_stage_5[11];
	assign mux_stage_4[12] = (sel[4] == 1'b1) ? sw_in[22] : mux_stage_5[12];
	assign mux_stage_4[13] = (sel[4] == 1'b1) ? sw_in[21] : mux_stage_5[13];
	assign mux_stage_4[14] = (sel[4] == 1'b1) ? sw_in[20] : mux_stage_5[14];
	assign mux_stage_4[15] = (sel[4] == 1'b1) ? sw_in[19] : mux_stage_5[15];
	assign mux_stage_4[16] = (sel[4] == 1'b1) ? sw_in[18] : mux_stage_5[16];
	assign mux_stage_4[17] = (sel[4] == 1'b1) ? sw_in[17] : mux_stage_5[17];
	assign mux_stage_4[18] = (sel[4] == 1'b1) ? sw_in[16] : mux_stage_5[18];
	assign mux_stage_4[19] = (sel[4] == 1'b1) ? sw_in[15] : sw_in[31];
	assign mux_stage_4[20] = (sel[4] == 1'b1) ? sw_in[14] : sw_in[30];
	assign mux_stage_4[21] = (sel[4] == 1'b1) ? sw_in[13] : sw_in[29];
	assign mux_stage_4[22] = (sel[4] == 1'b1) ? sw_in[12] : sw_in[28];
	assign mux_stage_4[23] = (sel[4] == 1'b1) ? sw_in[11] : sw_in[27];
	assign mux_stage_4[24] = (sel[4] == 1'b1) ? sw_in[10] : sw_in[26];
	assign mux_stage_4[25] = (sel[4] == 1'b1) ? sw_in[9] : sw_in[25];
	assign mux_stage_4[26] = (sel[4] == 1'b1) ? sw_in[8] : sw_in[24];
	assign mux_stage_4[27] = (sel[4] == 1'b1) ? sw_in[7] : sw_in[23];
	assign mux_stage_4[28] = (sel[4] == 1'b1) ? sw_in[6] : sw_in[22];
	assign mux_stage_4[29] = (sel[4] == 1'b1) ? sw_in[5] : sw_in[21];
	assign mux_stage_4[30] = (sel[4] == 1'b1) ? sw_in[4] : sw_in[20];
	assign mux_stage_4[31] = (sel[4] == 1'b1) ? sw_in[3] : sw_in[19];
	assign mux_stage_4[32] = (sel[4] == 1'b1) ? sw_in[2] : sw_in[18];
	assign mux_stage_4[33] = (sel[4] == 1'b1) ? sw_in[1] : sw_in[17];
	assign mux_stage_4[34] = (sel[4] == 1'b1) ? sw_in[0] : sw_in[16];

	// Multiplexer Stage 3
	reg [42:0] mux_stage_3;
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[0] <= 0; else if(sel[3] == 1'b1) mux_stage_3[0] <= mux_stage_4[8]; else mux_stage_3[0] <= mux_stage_4[0]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[1] <= 0; else if(sel[3] == 1'b1) mux_stage_3[1] <= mux_stage_4[9]; else mux_stage_3[1] <= mux_stage_4[1]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[2] <= 0; else if(sel[3] == 1'b1) mux_stage_3[2] <= mux_stage_4[10]; else mux_stage_3[2] <= mux_stage_4[2]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[3] <= 0; else if(sel[3] == 1'b1) mux_stage_3[3] <= mux_stage_4[11]; else mux_stage_3[3] <= mux_stage_4[3]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[4] <= 0; else if(sel[3] == 1'b1) mux_stage_3[4] <= mux_stage_4[12]; else mux_stage_3[4] <= mux_stage_4[4]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[5] <= 0; else if(sel[3] == 1'b1) mux_stage_3[5] <= mux_stage_4[13]; else mux_stage_3[5] <= mux_stage_4[5]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[6] <= 0; else if(sel[3] == 1'b1) mux_stage_3[6] <= mux_stage_4[14]; else mux_stage_3[6] <= mux_stage_4[6]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[7] <= 0; else if(sel[3] == 1'b1) mux_stage_3[7] <= mux_stage_4[15]; else mux_stage_3[7] <= mux_stage_4[7]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[8] <= 0; else if(sel[3] == 1'b1) mux_stage_3[8] <= mux_stage_4[16]; else mux_stage_3[8] <= mux_stage_4[8]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[9] <= 0; else if(sel[3] == 1'b1) mux_stage_3[9] <= mux_stage_4[17]; else mux_stage_3[9] <= mux_stage_4[9]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[10] <= 0; else if(sel[3] == 1'b1) mux_stage_3[10] <= mux_stage_4[18]; else mux_stage_3[10] <= mux_stage_4[10]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[11] <= 0; else if(sel[3] == 1'b1) mux_stage_3[11] <= mux_stage_4[19]; else mux_stage_3[11] <= mux_stage_4[11]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[12] <= 0; else if(sel[3] == 1'b1) mux_stage_3[12] <= mux_stage_4[20]; else mux_stage_3[12] <= mux_stage_4[12]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[13] <= 0; else if(sel[3] == 1'b1) mux_stage_3[13] <= mux_stage_4[21]; else mux_stage_3[13] <= mux_stage_4[13]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[14] <= 0; else if(sel[3] == 1'b1) mux_stage_3[14] <= mux_stage_4[22]; else mux_stage_3[14] <= mux_stage_4[14]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[15] <= 0; else if(sel[3] == 1'b1) mux_stage_3[15] <= mux_stage_4[23]; else mux_stage_3[15] <= mux_stage_4[15]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[16] <= 0; else if(sel[3] == 1'b1) mux_stage_3[16] <= mux_stage_4[24]; else mux_stage_3[16] <= mux_stage_4[16]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[17] <= 0; else if(sel[3] == 1'b1) mux_stage_3[17] <= mux_stage_4[25]; else mux_stage_3[17] <= mux_stage_4[17]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[18] <= 0; else if(sel[3] == 1'b1) mux_stage_3[18] <= mux_stage_4[26]; else mux_stage_3[18] <= mux_stage_4[18]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[19] <= 0; else if(sel[3] == 1'b1) mux_stage_3[19] <= mux_stage_4[27]; else mux_stage_3[19] <= mux_stage_4[19]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[20] <= 0; else if(sel[3] == 1'b1) mux_stage_3[20] <= mux_stage_4[28]; else mux_stage_3[20] <= mux_stage_4[20]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[21] <= 0; else if(sel[3] == 1'b1) mux_stage_3[21] <= mux_stage_4[29]; else mux_stage_3[21] <= mux_stage_4[21]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[22] <= 0; else if(sel[3] == 1'b1) mux_stage_3[22] <= mux_stage_4[30]; else mux_stage_3[22] <= mux_stage_4[22]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[23] <= 0; else if(sel[3] == 1'b1) mux_stage_3[23] <= mux_stage_4[31]; else mux_stage_3[23] <= mux_stage_4[23]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[24] <= 0; else if(sel[3] == 1'b1) mux_stage_3[24] <= mux_stage_4[32]; else mux_stage_3[24] <= mux_stage_4[24]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[25] <= 0; else if(sel[3] == 1'b1) mux_stage_3[25] <= mux_stage_4[33]; else mux_stage_3[25] <= mux_stage_4[25]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[26] <= 0; else if(sel[3] == 1'b1) mux_stage_3[26] <= mux_stage_4[34]; else mux_stage_3[26] <= mux_stage_4[26]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[27] <= 0; else if(sel[3] == 1'b1) mux_stage_3[27] <= sw_in[15]; else mux_stage_3[27] <= mux_stage_4[27]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[28] <= 0; else if(sel[3] == 1'b1) mux_stage_3[28] <= sw_in[14]; else mux_stage_3[28] <= mux_stage_4[28]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[29] <= 0; else if(sel[3] == 1'b1) mux_stage_3[29] <= sw_in[13]; else mux_stage_3[29] <= mux_stage_4[29]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[30] <= 0; else if(sel[3] == 1'b1) mux_stage_3[30] <= sw_in[12]; else mux_stage_3[30] <= mux_stage_4[30]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[31] <= 0; else if(sel[3] == 1'b1) mux_stage_3[31] <= sw_in[11]; else mux_stage_3[31] <= mux_stage_4[31]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[32] <= 0; else if(sel[3] == 1'b1) mux_stage_3[32] <= sw_in[10]; else mux_stage_3[32] <= mux_stage_4[32]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[33] <= 0; else if(sel[3] == 1'b1) mux_stage_3[33] <= sw_in[9]; else mux_stage_3[33] <= mux_stage_4[33]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[34] <= 0; else if(sel[3] == 1'b1) mux_stage_3[34] <= sw_in[8]; else mux_stage_3[34] <= mux_stage_4[34]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[35] <= 0; else if(sel[3] == 1'b1) mux_stage_3[35] <= sw_in[7]; else mux_stage_3[35] <= sw_in[15]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[36] <= 0; else if(sel[3] == 1'b1) mux_stage_3[36] <= sw_in[6]; else mux_stage_3[36] <= sw_in[14]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[37] <= 0; else if(sel[3] == 1'b1) mux_stage_3[37] <= sw_in[5]; else mux_stage_3[37] <= sw_in[13]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[38] <= 0; else if(sel[3] == 1'b1) mux_stage_3[38] <= sw_in[4]; else mux_stage_3[38] <= sw_in[12]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[39] <= 0; else if(sel[3] == 1'b1) mux_stage_3[39] <= sw_in[3]; else mux_stage_3[39] <= sw_in[11]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[40] <= 0; else if(sel[3] == 1'b1) mux_stage_3[40] <= sw_in[2]; else mux_stage_3[40] <= sw_in[10]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[41] <= 0; else if(sel[3] == 1'b1) mux_stage_3[41] <= sw_in[1]; else mux_stage_3[41] <= sw_in[9]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_3[42] <= 0; else if(sel[3] == 1'b1) mux_stage_3[42] <= sw_in[0]; else mux_stage_3[42] <= sw_in[8]; end

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
	wire [46:0] mux_stage_2;
	assign mux_stage_2[0] = (sel_2_reg0 == 1'b1) ? mux_stage_3[4] : mux_stage_3[0];
	assign mux_stage_2[1] = (sel_2_reg0 == 1'b1) ? mux_stage_3[5] : mux_stage_3[1];
	assign mux_stage_2[2] = (sel_2_reg0 == 1'b1) ? mux_stage_3[6] : mux_stage_3[2];
	assign mux_stage_2[3] = (sel_2_reg0 == 1'b1) ? mux_stage_3[7] : mux_stage_3[3];
	assign mux_stage_2[4] = (sel_2_reg0 == 1'b1) ? mux_stage_3[8] : mux_stage_3[4];
	assign mux_stage_2[5] = (sel_2_reg0 == 1'b1) ? mux_stage_3[9] : mux_stage_3[5];
	assign mux_stage_2[6] = (sel_2_reg0 == 1'b1) ? mux_stage_3[10] : mux_stage_3[6];
	assign mux_stage_2[7] = (sel_2_reg0 == 1'b1) ? mux_stage_3[11] : mux_stage_3[7];
	assign mux_stage_2[8] = (sel_2_reg0 == 1'b1) ? mux_stage_3[12] : mux_stage_3[8];
	assign mux_stage_2[9] = (sel_2_reg0 == 1'b1) ? mux_stage_3[13] : mux_stage_3[9];
	assign mux_stage_2[10] = (sel_2_reg0 == 1'b1) ? mux_stage_3[14] : mux_stage_3[10];
	assign mux_stage_2[11] = (sel_2_reg0 == 1'b1) ? mux_stage_3[15] : mux_stage_3[11];
	assign mux_stage_2[12] = (sel_2_reg0 == 1'b1) ? mux_stage_3[16] : mux_stage_3[12];
	assign mux_stage_2[13] = (sel_2_reg0 == 1'b1) ? mux_stage_3[17] : mux_stage_3[13];
	assign mux_stage_2[14] = (sel_2_reg0 == 1'b1) ? mux_stage_3[18] : mux_stage_3[14];
	assign mux_stage_2[15] = (sel_2_reg0 == 1'b1) ? mux_stage_3[19] : mux_stage_3[15];
	assign mux_stage_2[16] = (sel_2_reg0 == 1'b1) ? mux_stage_3[20] : mux_stage_3[16];
	assign mux_stage_2[17] = (sel_2_reg0 == 1'b1) ? mux_stage_3[21] : mux_stage_3[17];
	assign mux_stage_2[18] = (sel_2_reg0 == 1'b1) ? mux_stage_3[22] : mux_stage_3[18];
	assign mux_stage_2[19] = (sel_2_reg0 == 1'b1) ? mux_stage_3[23] : mux_stage_3[19];
	assign mux_stage_2[20] = (sel_2_reg0 == 1'b1) ? mux_stage_3[24] : mux_stage_3[20];
	assign mux_stage_2[21] = (sel_2_reg0 == 1'b1) ? mux_stage_3[25] : mux_stage_3[21];
	assign mux_stage_2[22] = (sel_2_reg0 == 1'b1) ? mux_stage_3[26] : mux_stage_3[22];
	assign mux_stage_2[23] = (sel_2_reg0 == 1'b1) ? mux_stage_3[27] : mux_stage_3[23];
	assign mux_stage_2[24] = (sel_2_reg0 == 1'b1) ? mux_stage_3[28] : mux_stage_3[24];
	assign mux_stage_2[25] = (sel_2_reg0 == 1'b1) ? mux_stage_3[29] : mux_stage_3[25];
	assign mux_stage_2[26] = (sel_2_reg0 == 1'b1) ? mux_stage_3[30] : mux_stage_3[26];
	assign mux_stage_2[27] = (sel_2_reg0 == 1'b1) ? mux_stage_3[31] : mux_stage_3[27];
	assign mux_stage_2[28] = (sel_2_reg0 == 1'b1) ? mux_stage_3[32] : mux_stage_3[28];
	assign mux_stage_2[29] = (sel_2_reg0 == 1'b1) ? mux_stage_3[33] : mux_stage_3[29];
	assign mux_stage_2[30] = (sel_2_reg0 == 1'b1) ? mux_stage_3[34] : mux_stage_3[30];
	assign mux_stage_2[31] = (sel_2_reg0 == 1'b1) ? mux_stage_3[35] : mux_stage_3[31];
	assign mux_stage_2[32] = (sel_2_reg0 == 1'b1) ? mux_stage_3[36] : mux_stage_3[32];
	assign mux_stage_2[33] = (sel_2_reg0 == 1'b1) ? mux_stage_3[37] : mux_stage_3[33];
	assign mux_stage_2[34] = (sel_2_reg0 == 1'b1) ? mux_stage_3[38] : mux_stage_3[34];
	assign mux_stage_2[35] = (sel_2_reg0 == 1'b1) ? mux_stage_3[39] : mux_stage_3[35];
	assign mux_stage_2[36] = (sel_2_reg0 == 1'b1) ? mux_stage_3[40] : mux_stage_3[36];
	assign mux_stage_2[37] = (sel_2_reg0 == 1'b1) ? mux_stage_3[41] : mux_stage_3[37];
	assign mux_stage_2[38] = (sel_2_reg0 == 1'b1) ? mux_stage_3[42] : mux_stage_3[38];
	assign mux_stage_2[39] = (sel_2_reg0 == 1'b1) ? sw_in_7_reg0 : mux_stage_3[39];
	assign mux_stage_2[40] = (sel_2_reg0 == 1'b1) ? sw_in_6_reg0 : mux_stage_3[40];
	assign mux_stage_2[41] = (sel_2_reg0 == 1'b1) ? sw_in_5_reg0 : mux_stage_3[41];
	assign mux_stage_2[42] = (sel_2_reg0 == 1'b1) ? sw_in_4_reg0 : mux_stage_3[42];
	assign mux_stage_2[43] = (sel_2_reg0 == 1'b1) ? sw_in_3_reg0 : sw_in_7_reg0;
	assign mux_stage_2[44] = (sel_2_reg0 == 1'b1) ? sw_in_2_reg0 : sw_in_6_reg0;
	assign mux_stage_2[45] = (sel_2_reg0 == 1'b1) ? sw_in_1_reg0 : sw_in_5_reg0;
	assign mux_stage_2[46] = (sel_2_reg0 == 1'b1) ? sw_in_0_reg0 : sw_in_4_reg0;


	reg sel_1_reg0;
	always @(posedge sys_clk) begin if(!rstn) sel_1_reg0 <= 0; else sel_1_reg0 <= sel[1]; end	

	// Multiplexer Stage 1
	wire [48:0] mux_stage_1;
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
	assign mux_stage_1[11] = (sel_1_reg0 == 1'b1) ? mux_stage_2[13] : mux_stage_2[11];
	assign mux_stage_1[12] = (sel_1_reg0 == 1'b1) ? mux_stage_2[14] : mux_stage_2[12];
	assign mux_stage_1[13] = (sel_1_reg0 == 1'b1) ? mux_stage_2[15] : mux_stage_2[13];
	assign mux_stage_1[14] = (sel_1_reg0 == 1'b1) ? mux_stage_2[16] : mux_stage_2[14];
	assign mux_stage_1[15] = (sel_1_reg0 == 1'b1) ? mux_stage_2[17] : mux_stage_2[15];
	assign mux_stage_1[16] = (sel_1_reg0 == 1'b1) ? mux_stage_2[18] : mux_stage_2[16];
	assign mux_stage_1[17] = (sel_1_reg0 == 1'b1) ? mux_stage_2[19] : mux_stage_2[17];
	assign mux_stage_1[18] = (sel_1_reg0 == 1'b1) ? mux_stage_2[20] : mux_stage_2[18];
	assign mux_stage_1[19] = (sel_1_reg0 == 1'b1) ? mux_stage_2[21] : mux_stage_2[19];
	assign mux_stage_1[20] = (sel_1_reg0 == 1'b1) ? mux_stage_2[22] : mux_stage_2[20];
	assign mux_stage_1[21] = (sel_1_reg0 == 1'b1) ? mux_stage_2[23] : mux_stage_2[21];
	assign mux_stage_1[22] = (sel_1_reg0 == 1'b1) ? mux_stage_2[24] : mux_stage_2[22];
	assign mux_stage_1[23] = (sel_1_reg0 == 1'b1) ? mux_stage_2[25] : mux_stage_2[23];
	assign mux_stage_1[24] = (sel_1_reg0 == 1'b1) ? mux_stage_2[26] : mux_stage_2[24];
	assign mux_stage_1[25] = (sel_1_reg0 == 1'b1) ? mux_stage_2[27] : mux_stage_2[25];
	assign mux_stage_1[26] = (sel_1_reg0 == 1'b1) ? mux_stage_2[28] : mux_stage_2[26];
	assign mux_stage_1[27] = (sel_1_reg0 == 1'b1) ? mux_stage_2[29] : mux_stage_2[27];
	assign mux_stage_1[28] = (sel_1_reg0 == 1'b1) ? mux_stage_2[30] : mux_stage_2[28];
	assign mux_stage_1[29] = (sel_1_reg0 == 1'b1) ? mux_stage_2[31] : mux_stage_2[29];
	assign mux_stage_1[30] = (sel_1_reg0 == 1'b1) ? mux_stage_2[32] : mux_stage_2[30];
	assign mux_stage_1[31] = (sel_1_reg0 == 1'b1) ? mux_stage_2[33] : mux_stage_2[31];
	assign mux_stage_1[32] = (sel_1_reg0 == 1'b1) ? mux_stage_2[34] : mux_stage_2[32];
	assign mux_stage_1[33] = (sel_1_reg0 == 1'b1) ? mux_stage_2[35] : mux_stage_2[33];
	assign mux_stage_1[34] = (sel_1_reg0 == 1'b1) ? mux_stage_2[36] : mux_stage_2[34];
	assign mux_stage_1[35] = (sel_1_reg0 == 1'b1) ? mux_stage_2[37] : mux_stage_2[35];
	assign mux_stage_1[36] = (sel_1_reg0 == 1'b1) ? mux_stage_2[38] : mux_stage_2[36];
	assign mux_stage_1[37] = (sel_1_reg0 == 1'b1) ? mux_stage_2[39] : mux_stage_2[37];
	assign mux_stage_1[38] = (sel_1_reg0 == 1'b1) ? mux_stage_2[40] : mux_stage_2[38];
	assign mux_stage_1[39] = (sel_1_reg0 == 1'b1) ? mux_stage_2[41] : mux_stage_2[39];
	assign mux_stage_1[40] = (sel_1_reg0 == 1'b1) ? mux_stage_2[42] : mux_stage_2[40];
	assign mux_stage_1[41] = (sel_1_reg0 == 1'b1) ? mux_stage_2[43] : mux_stage_2[41];
	assign mux_stage_1[42] = (sel_1_reg0 == 1'b1) ? mux_stage_2[44] : mux_stage_2[42];
	assign mux_stage_1[43] = (sel_1_reg0 == 1'b1) ? mux_stage_2[45] : mux_stage_2[43];
	assign mux_stage_1[44] = (sel_1_reg0 == 1'b1) ? mux_stage_2[46] : mux_stage_2[44];
	assign mux_stage_1[45] = (sel_1_reg0 == 1'b1) ? sw_in_3_reg0 : mux_stage_2[45];
	assign mux_stage_1[46] = (sel_1_reg0 == 1'b1) ? sw_in_2_reg0 : mux_stage_2[46];
	assign mux_stage_1[47] = (sel_1_reg0 == 1'b1) ? sw_in_1_reg0 : sw_in_3_reg0;
	assign mux_stage_1[48] = (sel_1_reg0 == 1'b1) ? sw_in_0_reg0 : sw_in_2_reg0;


	reg sel_0_reg0;
	always @(posedge sys_clk) begin if(!rstn) sel_0_reg0 <= 0; else sel_0_reg0 <= sel[0]; end	

	// Multiplexer Stage 0
	wire [49:0] mux_stage_0;
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
	assign mux_stage_0[14] = (sel_0_reg0 == 1'b1) ? mux_stage_1[15] : mux_stage_1[14];
	assign mux_stage_0[15] = (sel_0_reg0 == 1'b1) ? mux_stage_1[16] : mux_stage_1[15];
	assign mux_stage_0[16] = (sel_0_reg0 == 1'b1) ? mux_stage_1[17] : mux_stage_1[16];
	assign mux_stage_0[17] = (sel_0_reg0 == 1'b1) ? mux_stage_1[18] : mux_stage_1[17];
	assign mux_stage_0[18] = (sel_0_reg0 == 1'b1) ? mux_stage_1[19] : mux_stage_1[18];
	assign mux_stage_0[19] = (sel_0_reg0 == 1'b1) ? mux_stage_1[20] : mux_stage_1[19];
	assign mux_stage_0[20] = (sel_0_reg0 == 1'b1) ? mux_stage_1[21] : mux_stage_1[20];
	assign mux_stage_0[21] = (sel_0_reg0 == 1'b1) ? mux_stage_1[22] : mux_stage_1[21];
	assign mux_stage_0[22] = (sel_0_reg0 == 1'b1) ? mux_stage_1[23] : mux_stage_1[22];
	assign mux_stage_0[23] = (sel_0_reg0 == 1'b1) ? mux_stage_1[24] : mux_stage_1[23];
	assign mux_stage_0[24] = (sel_0_reg0 == 1'b1) ? mux_stage_1[25] : mux_stage_1[24];
	assign mux_stage_0[25] = (sel_0_reg0 == 1'b1) ? mux_stage_1[26] : mux_stage_1[25];
	assign mux_stage_0[26] = (sel_0_reg0 == 1'b1) ? mux_stage_1[27] : mux_stage_1[26];
	assign mux_stage_0[27] = (sel_0_reg0 == 1'b1) ? mux_stage_1[28] : mux_stage_1[27];
	assign mux_stage_0[28] = (sel_0_reg0 == 1'b1) ? mux_stage_1[29] : mux_stage_1[28];
	assign mux_stage_0[29] = (sel_0_reg0 == 1'b1) ? mux_stage_1[30] : mux_stage_1[29];
	assign mux_stage_0[30] = (sel_0_reg0 == 1'b1) ? mux_stage_1[31] : mux_stage_1[30];
	assign mux_stage_0[31] = (sel_0_reg0 == 1'b1) ? mux_stage_1[32] : mux_stage_1[31];
	assign mux_stage_0[32] = (sel_0_reg0 == 1'b1) ? mux_stage_1[33] : mux_stage_1[32];
	assign mux_stage_0[33] = (sel_0_reg0 == 1'b1) ? mux_stage_1[34] : mux_stage_1[33];
	assign mux_stage_0[34] = (sel_0_reg0 == 1'b1) ? mux_stage_1[35] : mux_stage_1[34];
	assign mux_stage_0[35] = (sel_0_reg0 == 1'b1) ? mux_stage_1[36] : mux_stage_1[35];
	assign mux_stage_0[36] = (sel_0_reg0 == 1'b1) ? mux_stage_1[37] : mux_stage_1[36];
	assign mux_stage_0[37] = (sel_0_reg0 == 1'b1) ? mux_stage_1[38] : mux_stage_1[37];
	assign mux_stage_0[38] = (sel_0_reg0 == 1'b1) ? mux_stage_1[39] : mux_stage_1[38];
	assign mux_stage_0[39] = (sel_0_reg0 == 1'b1) ? mux_stage_1[40] : mux_stage_1[39];
	assign mux_stage_0[40] = (sel_0_reg0 == 1'b1) ? mux_stage_1[41] : mux_stage_1[40];
	assign mux_stage_0[41] = (sel_0_reg0 == 1'b1) ? mux_stage_1[42] : mux_stage_1[41];
	assign mux_stage_0[42] = (sel_0_reg0 == 1'b1) ? mux_stage_1[43] : mux_stage_1[42];
	assign mux_stage_0[43] = (sel_0_reg0 == 1'b1) ? mux_stage_1[44] : mux_stage_1[43];
	assign mux_stage_0[44] = (sel_0_reg0 == 1'b1) ? mux_stage_1[45] : mux_stage_1[44];
	assign mux_stage_0[45] = (sel_0_reg0 == 1'b1) ? mux_stage_1[46] : mux_stage_1[45];
	assign mux_stage_0[46] = (sel_0_reg0 == 1'b1) ? mux_stage_1[47] : mux_stage_1[46];
	assign mux_stage_0[47] = (sel_0_reg0 == 1'b1) ? mux_stage_1[48] : mux_stage_1[47];
	assign mux_stage_0[48] = (sel_0_reg0 == 1'b1) ? sw_in_1_reg0 : mux_stage_1[48];
	assign mux_stage_0[49] = (sel_0_reg0 == 1'b1) ? sw_in_0_reg0 : sw_in_1_reg0;

	assign sw_out[50:0] = {sw_in_0_reg0, mux_stage_0[49:0]};
endmodule