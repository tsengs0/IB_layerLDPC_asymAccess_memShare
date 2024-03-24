module qsn_controller_len3 #(
	parameter [$clog2(3)-1:0] PERMUTATION_LENGTH = 3
) (
	output wire [1:0] left_sel,
	output wire [1:0] right_sel,
	output wire [1:0] merge_sel,
	input wire [1:0] shift_factor,
	input wire rstn,
	input wire sys_clk
);

	wire shifter_nonzero;
	assign shifter_nonzero = (|shift_factor[1:0]);

	assign left_sel[1:0] = (shifter_nonzero == 1'b1) ? shift_factor[1:0] : 0;
	assign right_sel[1:0] = (shifter_nonzero == 1'b1) ? 3-shift_factor[1:0] : 0;
	assign merge_sel[1:0] = f(shift_factor[1:0]);
	function [1:0] f(input [1:0] shift_in);
		case(shift_in[1:0])
			1	:	 f[1:0] = 2'b11;
			2	:	 f[1:0] = 2'b01;
			default	:	f[1:0] = 0;
		endcase // shift_factor
	endfunction
endmodule