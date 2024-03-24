module qsn_controller_len15 #(
	parameter [$clog2(15)-1:0] PERMUTATION_LENGTH = 15
) (
	output wire [3:0] left_sel,
	output wire [3:0] right_sel,
	output wire [13:0] merge_sel,
	input wire [3:0] shift_factor,
	input wire rstn,
	input wire sys_clk
);

	wire shifter_nonzero;
	assign shifter_nonzero = (|shift_factor[3:0]);

	assign left_sel[3:0] = (shifter_nonzero == 1'b1) ? shift_factor[3:0] : 0;
	assign right_sel[3:0] = (shifter_nonzero == 1'b1) ? 15-shift_factor[3:0] : 0;
	assign merge_sel[13:0] = f(shift_factor[3:0]);
	function [13:0] f(input [3:0] shift_in);
		case(shift_in[3:0])
			1	:	 f[13:0] = 14'b11111111111111;
			2	:	 f[13:0] = 14'b01111111111111;
			3	:	 f[13:0] = 14'b00111111111111;
			4	:	 f[13:0] = 14'b00011111111111;
			5	:	 f[13:0] = 14'b00001111111111;
			6	:	 f[13:0] = 14'b00000111111111;
			7	:	 f[13:0] = 14'b00000011111111;
			8	:	 f[13:0] = 14'b00000001111111;
			9	:	 f[13:0] = 14'b00000000111111;
			10	:	 f[13:0] = 14'b00000000011111;
			11	:	 f[13:0] = 14'b00000000001111;
			12	:	 f[13:0] = 14'b00000000000111;
			13	:	 f[13:0] = 14'b00000000000011;
			14	:	 f[13:0] = 14'b00000000000001;
			default	:	f[13:0] = 0;
		endcase // shift_factor
	endfunction
endmodule