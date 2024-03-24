//`define MARCH_2021
`define APRIL_2021

`ifdef MARCH_2021
module pend_queue_parallelism_1 #(
	parameter DEPTH = 4, // the size of the pending queue
	parameter BITWIDTH = 3, // the bitwidth of each element inside the queue
	parameter COL_PARALLELISM = 1
) (
	output wire [BITWIDTH-1:0] pop_dout,

	input wire [BITWIDTH-1:0] rqst_in1,
	input wire [BITWIDTH-1:0] rqst_in2,
	input wire [BITWIDTH-1:0] rqst_in3,
	input wire [BITWIDTH-1:0] rqst_in4,
	input wire [DEPTH-COL_PARALLELISM-1:0] arbitration_in,
	input wire sys_clk,
	input wire rstn,
	input wire [DEPTH-1:0] we
);

wire [BITWIDTH-1:0] rqst_vec [0:DEPTH-1];
assign rqst_vec[0] = rqst_in1[BITWIDTH-1:0];
assign rqst_vec[1] = rqst_in2[BITWIDTH-1:0];
assign rqst_vec[2] = rqst_in3[BITWIDTH-1:0];
assign rqst_vec[3] = rqst_in4[BITWIDTH-1:0];

reg [BITWIDTH-1:0] queue [0:DEPTH-1];
wire [BITWIDTH-1:0] enqueue_Din [0:DEPTH-1];
genvar i;
generate
	for(i=0;i<DEPTH-COL_PARALLELISM;i=i+1) begin : queue_inst
		assign enqueue_Din[i] = (arbitration_in[i] == 0) ? rqst_vec[i] : rqst_vec[i+1];

		always @(posedge sys_clk) begin
			if(rstn == 1'b0 ) queue[i] <= 0;
			else if(we[i] == 1'b1) queue[i] <= enqueue_Din[i];
			else queue[i] <= queue[i+1];
		end 
	end
endgenerate

// The last element is not contended multiple requestors
assign enqueue_Din[DEPTH-1] = rqst_vec[DEPTH-1];
always @(posedge sys_clk) begin
	if(rstn == 1'b0 ) queue[DEPTH-1] <= 0;
	else if(we[DEPTH-1] == 1'b1) queue[DEPTH-1] <= enqueue_Din[DEPTH-1];
	else queue[DEPTH-1] <= queue[DEPTH-1];
end

assign pop_dout[BITWIDTH-1:0] = queue[0]; // always pop out the element at head of queue 
endmodule

module pend_queue_parallelism_2 #(
	parameter DEPTH = 4, // the size of the pending queue
	parameter BITWIDTH = 3, // the bitwidth of each element inside the queue
	parameter COL_PARALLELISM = 2
) (
	output wire [BITWIDTH-1:0] pop_dout_0,
	output wire [BITWIDTH-1:0] pop_dout_1,

	input wire [BITWIDTH-1:0] rqst_in1,
	input wire [BITWIDTH-1:0] rqst_in2,
	input wire [BITWIDTH-1:0] rqst_in3,
	input wire [BITWIDTH-1:0] rqst_in4,
	input wire arbitration_in,
	input wire sys_clk,
	input wire rstn,
	input wire [DEPTH-1:0] we
);

wire [BITWIDTH-1:0] rqst_vec [0:DEPTH-1];
assign rqst_vec[0] = rqst_in1[BITWIDTH-1:0];
assign rqst_vec[1] = rqst_in2[BITWIDTH-1:0];
assign rqst_vec[2] = rqst_in3[BITWIDTH-1:0];
assign rqst_vec[3] = rqst_in4[BITWIDTH-1:0];

reg [BITWIDTH-1:0] queue [0:DEPTH-1];
wire [BITWIDTH-1:0] enqueue_Din [0:DEPTH-1];
genvar i;
generate
	for(i=0;i<COL_PARALLELISM;i=i+1) begin : queue_inst0
		assign enqueue_Din[i] = rqst_vec[i];

		always @(posedge sys_clk) begin
			if(rstn == 1'b0 ) queue[i] <= 0;
			else if(we[i] == 1'b1) queue[i] <= enqueue_Din[i];
			else queue[i] <= queue[i+COL_PARALLELISM];
		end 
	end

	for(i=COL_PARALLELISM;i<DEPTH-1;i=i+1) begin : queue_inst1
		assign enqueue_Din[i] = (arbitration_in == 0) ? rqst_vec[i] : rqst_vec[i+1];

		always @(posedge sys_clk) begin
			if(rstn == 1'b0 ) queue[i] <= 0;
			else if(we[i] == 1'b1) queue[i] <= enqueue_Din[i];
			else queue[i] <= queue[i+1];
		end 
	end
endgenerate

// The last element is not contended multiple requestors
assign enqueue_Din[DEPTH-1] = rqst_vec[DEPTH-1];
always @(posedge sys_clk) begin
	if(rstn == 1'b0 ) queue[DEPTH-1] <= 0;
	else if(we[DEPTH-1] == 1'b1) queue[DEPTH-1] <= enqueue_Din[DEPTH-1];
	else queue[DEPTH-1] <= queue[DEPTH-1];
end

assign pop_dout_0[BITWIDTH-1:0] = queue[0]; // always pop out the first element from head of queue 
assign pop_dout_1[BITWIDTH-1:0] = queue[1]; // always pop out the second element from head of queue 
endmodule

module pend_queue_parallelism_3 #(
	parameter DEPTH = 4, // the size of the pending queue
	parameter BITWIDTH = 3, // the bitwidth of each element inside the queue
	parameter COL_PARALLELISM = 3
) (
	output wire [BITWIDTH-1:0] pop_dout_0,
	output wire [BITWIDTH-1:0] pop_dout_1,
	output wire [BITWIDTH-1:0] pop_dout_2,

	input wire [BITWIDTH-1:0] rqst_in1,
	input wire [BITWIDTH-1:0] rqst_in2,
	input wire [BITWIDTH-1:0] rqst_in3,
	input wire [BITWIDTH-1:0] rqst_in4,
	//input wire [DEPTH-COL_PARALLELISM-1:0] arbitration_in,
	input wire sys_clk,
	input wire rstn,
	input wire [DEPTH-1:0] we
);

wire [BITWIDTH-1:0] rqst_vec [0:DEPTH-1];
assign rqst_vec[0] = rqst_in1[BITWIDTH-1:0];
assign rqst_vec[1] = rqst_in2[BITWIDTH-1:0];
assign rqst_vec[2] = rqst_in3[BITWIDTH-1:0];
assign rqst_vec[3] = rqst_in4[BITWIDTH-1:0];

reg [BITWIDTH-1:0] queue [0:DEPTH-1];
wire [BITWIDTH-1:0] enqueue_Din [0:DEPTH-1];

// Only the head ought to be right shifted
assign enqueue_Din[0] = rqst_vec[0];
always @(posedge sys_clk) begin
	if(rstn == 1'b0 ) queue[0] <= 0;
	else if(we[0] == 1'b1) queue[0] <= enqueue_Din[0];
	else queue[i] <= queue[COL_PARALLELISM];
end 

genvar i;
generate
	for(i=1;i<COL_PARALLELISM;i=i+1) begin : queue_inst
		assign enqueue_Din[i] = rqst_vec[i];

		always @(posedge sys_clk) begin
			if(rstn == 1'b0 ) queue[i] <= 0;
			else if(we[i] == 1'b1) queue[i] <= enqueue_Din[i];
			else queue[i] <= queue[i];
		end 
	end
endgenerate

// The last element is not contended multiple requestors
assign enqueue_Din[DEPTH-1] = rqst_vec[DEPTH-1];
always @(posedge sys_clk) begin
	if(rstn == 1'b0 ) queue[DEPTH-1] <= 0;
	else if(we[DEPTH-1] == 1'b1) queue[DEPTH-1] <= enqueue_Din[DEPTH-1];
	else queue[DEPTH-1] <= queue[DEPTH-1];
end

assign pop_dout_0[BITWIDTH-1:0] = queue[0]; // always pop out the first element from head of queue 
assign pop_dout_1[BITWIDTH-1:0] = queue[1]; // always pop out the second element from head of queue 
assign pop_dout_2[BITWIDTH-1:0] = queue[2]; // always pop out the third element from head of queue 
endmodule

module pend_queue_parallelism_4 #(
	parameter DEPTH = 4, // the size of the pending queue
	parameter BITWIDTH = 3, // the bitwidth of each element inside the queue
	parameter COL_PARALLELISM = 4
) (
	output wire [BITWIDTH-1:0] pop_dout_0,
	output wire [BITWIDTH-1:0] pop_dout_1,
	output wire [BITWIDTH-1:0] pop_dout_2,
	output wire [BITWIDTH-1:0] pop_dout_3,

	input wire [BITWIDTH-1:0] rqst_in1,
	input wire [BITWIDTH-1:0] rqst_in2,
	input wire [BITWIDTH-1:0] rqst_in3,
	input wire [BITWIDTH-1:0] rqst_in4,
	//input wire [DEPTH-COL_PARALLELISM-1:0] arbitration_in,
	input wire sys_clk,
	input wire rstn,
	input wire [DEPTH-1:0] we
);

wire [BITWIDTH-1:0] rqst_vec [0:DEPTH-1];
assign rqst_vec[0] = rqst_in1[BITWIDTH-1:0];
assign rqst_vec[1] = rqst_in2[BITWIDTH-1:0];
assign rqst_vec[2] = rqst_in3[BITWIDTH-1:0];
assign rqst_vec[3] = rqst_in4[BITWIDTH-1:0];

reg [BITWIDTH-1:0] queue [0:DEPTH-1];
wire [BITWIDTH-1:0] enqueue_Din [0:DEPTH-1];
genvar i;
generate
	for(i=0;i<COL_PARALLELISM;i=i+1) begin : queue_inst
		assign enqueue_Din[i] = rqst_vec[i];

		always @(posedge sys_clk) begin
			if(rstn == 1'b0 ) queue[i] <= 0;
			else if(we[i] == 1'b1) queue[i] <= enqueue_Din[i];
			else queue[i] <= queue[i];
		end 
	end
endgenerate

assign pop_dout_0[BITWIDTH-1:0] = queue[0]; // always pop out the first element from head of queue 
assign pop_dout_1[BITWIDTH-1:0] = queue[1]; // always pop out the second element from head of queue 
assign pop_dout_2[BITWIDTH-1:0] = queue[2]; // always pop out the second element from head of queue 
assign pop_dout_3[BITWIDTH-1:0] = queue[3]; // always pop out the second element from head of queue 
endmodule
`else // `ifdef APRIL_2021
// One rquestor in the group sharing a single column bank
module pend_queue_group_1 #(
	parameter BITWIDTH = 3 // the bitwidth of each element inside the queue
) (
	output wire [BITWIDTH-1:0] pop_dout_0,

	input wire [BITWIDTH-1:0] rqst_in1,
	input wire sys_clk,
	input wire rstn,
	input wire we
);

reg [BITWIDTH-1:0] queue;
always @(posedge sys_clk) begin
	if(rstn == 1'b0 ) queue <= 0;
	else if(we == 1'b1) queue <= rqst_in1;
	else queue <= queue;
end 
assign pop_dout_0[BITWIDTH-1:0] = queue; // always pop out the first element from head of queue 
endmodule

// Two rquestor in the group sharing a single column bank
module pend_queue_group_2 #(
	parameter DEPTH = 2,
	parameter BITWIDTH = 3 // the bitwidth of each element inside the queue
) (
	output wire [BITWIDTH-1:0] pop_dout_0,

	input wire [BITWIDTH-1:0] rqst_in1,
	input wire [BITWIDTH-1:0] rqst_in2,
	input wire sys_clk,
	input wire rstn,
	input wire [DEPTH-1:0] we
);

wire [BITWIDTH-1:0] rqst_vec [0:DEPTH-1];
assign rqst_vec[0] = rqst_in1[BITWIDTH-1:0];
assign rqst_vec[1] = rqst_in2[BITWIDTH-1:0];

reg [BITWIDTH-1:0] queue [0:DEPTH-1];
always @(posedge sys_clk) begin
	if(rstn == 1'b0 ) queue[0] <= 0;
	else if(we[0] == 1'b1) queue[0] <= rqst_vec[0];
	else queue[0] <= queue[1];
end
always @(posedge sys_clk) begin
	if(rstn == 1'b0 ) queue[1] <= 0;
	else if(we[1] == 1'b1) queue[1] <= rqst_vec[1];
	else queue[1] <= queue[1];
end 
assign pop_dout_0[BITWIDTH-1:0] = queue[0]; // always pop out the first element from head of queue 
endmodule
/*-----------Template---------------------------------------------------------------------------*/
/* K rquestor in the group sharing a single column bank
module pend_queue_group_k #(
	parameter DEPTH = 3,
	parameter BITWIDTH = 3 // the bitwidth of each element inside the queue
) (
	output wire [BITWIDTH-1:0] pop_dout_0,

	input wire [BITWIDTH-1:0] rqst_in1,
	input wire [BITWIDTH-1:0] rqst_in2,
	input wire [BITWIDTH-1:0] rqst_in3,
	input wire sys_clk,
	input wire rstn,
	input wire [DEPTH-1:0] we
);

wire [BITWIDTH-1:0] rqst_vec [0:DEPTH-1];
assign rqst_vec[0] = rqst_in1[BITWIDTH-1:0];
assign rqst_vec[1] = rqst_in2[BITWIDTH-1:0];
assign rqst_vec[2] = rqst_in3[BITWIDTH-1:0];

reg [BITWIDTH-1:0] queue [0:DEPTH-1];
genvar i;
generate
	for(i=0;i<DEPTH-1;i=i+1) begin : queue_inst
		always @(posedge sys_clk) begin
			if(rstn == 1'b0 ) queue[i] <= 0;
			else if(we[i] == 1'b1) queue[i] <= rqst_vec[i];
			else queue[i] <= queue[i+1];
		end 
	end
endgenerate
// The last element of queue
always @(posedge sys_clk) begin
	if(rstn == 1'b0 ) queue[DEPTH-1] <= 0;
	else if(we[DEPTH-1] == 1'b1) queue[DEPTH-1] <= rqst_vec[DEPTH-1];
	else queue[DEPTH-1] <= queue[DEPTH-1];
end 
assign pop_dout_0[BITWIDTH-1:0] = queue[0]; // always pop out the first element from head of queue 
endmodule
*/
`endif