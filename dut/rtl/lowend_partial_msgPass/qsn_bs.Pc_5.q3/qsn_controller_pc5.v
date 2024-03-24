module qsn_controller_len5 #(
	parameter [$clog2(5)-1:0] PERMUTATION_LENGTH = 5
) (
	output wire [2:0] left_sel,
	output wire [2:0] right_sel,
	output wire [3:0] merge_sel,
	input wire [2:0] shift_factor,
	input wire rstn,
	input wire sys_clk
);

	wire shifter_nonzero;
	assign shifter_nonzero = (|shift_factor[2:0]);

	assign left_sel[2:0] = (shifter_nonzero == 1'b1) ? shift_factor[2:0] : 0;
	assign right_sel[2:0] = (shifter_nonzero == 1'b1) ? 5-shift_factor[2:0] : 0;
	assign merge_sel[3:0] = f(shift_factor[2:0]);
	function [3:0] f(input [2:0] shift_in);
		case(shift_in[2:0])
			1	:	 f[3:0] = 4'b1111;
			2	:	 f[3:0] = 4'b0111;
			3	:	 f[3:0] = 4'b0011;
			4	:	 f[3:0] = 4'b0001;
			default	:	f[3:0] = 0;
		endcase // shift_factor
	endfunction
endmodule