module arbiter_1 (
	output wire grant_1,

	input wire rqst_1,
	input wire rqst_2
);

/*
	Arbiter 1
	R1 R2 | G1
    ----------
     0	0 |	x (0)
     0	1 |	1
     1	0 | 0
     1	1 | 0
*/
assign grant_1 = (~rqst_1) && rqst_2;
endmodule

module arbiter_2 (
	output reg grant_2,

	input wire rqst_1,
	input wire rqst_2,
	input wire grant_prev
);

/*
	Arbiter 2
	G R1 R2 | G1
    ----------
    0 0	0 	| x (0)
    0 0	1 	| 1
    0 1	0 	| 0
    0 1	1 	| 0
   ===========
    1 0	0 	| x (0)
    1 0	1 	| 1
    1 1	0 	| x (0)
    1 1	1 	| 1
*/
always @(*) begin
	case({grant_prev, rqst_1, rqst_2})
		3'b0_01 : grant_2 = 1'b1;
		3'b1_01 : grant_2 = 1'b1;
		3'b1_11 : grant_2 = 1'b1;
		default : grant_2 = 1'b0;
	endcase
end
endmodule

module arbiter_system_parallelism_1 #(
	parameter COL_PARALLELISM = 1,
	parameter SHARED_GROUP_SIZE = 4
) (
	output wire grant_0,
	output wire grant_1,
	output wire grant_2,
	input wire [SHARED_GROUP_SIZE-1:0] rqst_in
);

arbiter_1 u0 (.grant_1(grant_0), .rqst_1(rqst_in[0]), .rqst_2(rqst_in[1]));
arbiter_2 u1 (.grant_2(grant_1), .grant_prev(grant_0), .rqst_1(rqst_in[1]), .rqst_2(rqst_in[2]));
arbiter_2 u2 (.grant_2(grant_2), .grant_prev(grant_1), .rqst_1(rqst_in[2]), .rqst_2(rqst_in[3]));
endmodule

module arbiter_system_parallelism_2 #(
	parameter COL_PARALLELISM = 2,
	parameter SHARED_GROUP_SIZE = 4
) (
	output wire grant,
	input wire [SHARED_GROUP_SIZE-1:0] rqst_in
);

arbiter_1 u0 (.grant_1(grant), .rqst_1(rqst_in[2]), .rqst_2(rqst_in[3]));
endmodule

module arbiter_system_parallelism_2 #(
	parameter COL_PARALLELISM = 2,
	parameter SHARED_GROUP_SIZE = 4
) (
	output wire grant,
	input wire [SHARED_GROUP_SIZE-1:0] rqst_in
);

arbiter_1 u0 (.grant_1(grant), .rqst_1(rqst_in[2]), .rqst_2(rqst_in[3]));
endmodule