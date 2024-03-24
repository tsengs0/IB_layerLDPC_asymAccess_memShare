module qsn_controller_len17 #(
	parameter [$clog2(17)-1:0] PERMUTATION_LENGTH = 17
) (
	output wire [4:0] left_sel,
	output wire [4:0] right_sel,
	output wire [15:0] merge_sel,
	input wire [4:0] shift_factor,
	input wire rstn,
	input wire sys_clk
);

	wire shifter_nonzero;
	assign shifter_nonzero = (|shift_factor[4:0]);

	assign left_sel[4:0] = (shifter_nonzero == 1'b1) ? shift_factor[4:0] : 0;
	assign right_sel[4:0] = (shifter_nonzero == 1'b1) ? 17-shift_factor[4:0] : 0;
	assign merge_sel[15:0] = f(shift_factor[4:0]);
	function [15:0] f(input [4:0] shift_in);
		case(shift_in[4:0])
			1	:	 f[15:0] = 16'b1111111111111111;
			2	:	 f[15:0] = 16'b0111111111111111;
			3	:	 f[15:0] = 16'b0011111111111111;
			4	:	 f[15:0] = 16'b0001111111111111;
			5	:	 f[15:0] = 16'b0000111111111111;
			6	:	 f[15:0] = 16'b0000011111111111;
			7	:	 f[15:0] = 16'b0000001111111111;
			8	:	 f[15:0] = 16'b0000000111111111;
			9	:	 f[15:0] = 16'b0000000011111111;
			10	:	 f[15:0] = 16'b0000000001111111;
			11	:	 f[15:0] = 16'b0000000000111111;
			12	:	 f[15:0] = 16'b0000000000011111;
			13	:	 f[15:0] = 16'b0000000000001111;
			14	:	 f[15:0] = 16'b0000000000000111;
			15	:	 f[15:0] = 16'b0000000000000011;
			16	:	 f[15:0] = 16'b0000000000000001;
			default	:	f[15:0] = 0;
		endcase // shift_factor
	endfunction
endmodule