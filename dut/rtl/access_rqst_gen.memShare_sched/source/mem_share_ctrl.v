//`define BEYOND_TECH_SPEC
`define XILINX_LUTRAM_TECH
//`define MARCH_2021
`define APRIL_2021

`ifdef MARCH_2021

`ifdef BEYOND_TECH_SPEC
	module mem_share_ctrl_3bit #(
		parameter SHARED_GROUP_SIZE = 4, // the number of requestors in one sharing group 
		parameter SHARED_BANK_NUM = 4, // the number of shared column-bank memories/IB-LUTs
		parameter RQST_FLAG = 1'b1, // either Assertion or Deassertion stands for a access request
		parameter COL_ADDR_BITWIDTH = 2,
		parameter ROW_ADDR_BITWIDTH = 3,
		parameter BITWIDTH = 3
	) (
		// Column-4 row addresses for granted rquestors
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_parallel_0,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_parallel_1,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_parallel_2,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_parallel_3,
		// Column-5 row addresses for granted rquestors
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_5_parallel_0,
		// Column-6 row addresses for granted rquestors
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_6_parallel_0,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_6_parallel_1,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_6_parallel_2,
		// Column-7 row addresses for granted rquestors
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_7_parallel_0,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_7_parallel_1,

		// Requested Column Addresses
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_1,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_2,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_3,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_4,
		// Requested Row Addresses
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_1,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_2,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_3,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_4,

		input wire sys_clk,
		input rstn
	);

	wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst [0:SHARED_GROUP_SIZE-1];
	assign col_addr_rqst[0] =  col_addr_rqst_1[COL_ADDR_BITWIDTH-1:0];
	assign col_addr_rqst[1] =  col_addr_rqst_2[COL_ADDR_BITWIDTH-1:0];
	assign col_addr_rqst[2] =  col_addr_rqst_3[COL_ADDR_BITWIDTH-1:0];
	assign col_addr_rqst[3] =  col_addr_rqst_4[COL_ADDR_BITWIDTH-1:0];

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instantiation of Access-Request Command Generation
	wire [SHARED_BANK_NUM-1:0] rqst_cmd [0:SHARED_GROUP_SIZE-1];
	wire [SHARED_GROUP_SIZE-1:0] pendingQueue_we [0:SHARED_BANK_NUM-1];
	genvar i, j;
	generate
		for(i=0;i<SHARED_GROUP_SIZE;i=i+1) begin : share_group_inst
			access_rqst_gen #(
				.SHARED_BANK_NUM	(SHARED_BANK_NUM), // the number of shared column-bank memories/IB-LUTs
				.RQST_FLAG          (RQST_FLAG), // either Assertion or Deassertion stands for a access request
				.RQST_ADDR_BITWIDTH (COL_ADDR_BITWIDTH)
			) access_rqst_gen_u0 (
				.rqst_flag (rqst_cmd[i]),
				.rqst_addr (col_addr_rqst[i])
			);
		end

		for(j=0;j<SHARED_BANK_NUM;j=j+1) begin : we_sig_inst
			assign pendingQueue_we[j] = {rqst_cmd[SHARED_GROUP_SIZE-1][j], rqst_cmd[SHARED_GROUP_SIZE-2][j], rqst_cmd[SHARED_GROUP_SIZE-3][j], rqst_cmd[SHARED_GROUP_SIZE-4][j]};
		end
	endgenerate
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Arbitration Signals Generation
	wire [2:0] grant_col_5;
	wire grant_col_7;
	arbiter_system_parallelism_1 #(
		.COL_PARALLELISM   (1),
		.SHARED_GROUP_SIZE (4)
	) arbiter_col_5 (
		.grant_0 (grant_col_5[0]),
		.grant_1 (grant_col_5[1]),
		.grant_2 (grant_col_5[2]),
		.rqst_in (pendingQueue_we[1])
	);

	arbiter_system_parallelism_2 #(
		.COL_PARALLELISM   (2),
		.SHARED_GROUP_SIZE (4)
	) arbiter_col_7 (
		.grant (grant_col_7),
		.rqst_in (pendingQueue_we[3])
	);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instantiation of Pending Queues
	// Pending Queue - Column 4
	pend_queue_parallelism_4 #(
		.DEPTH (SHARED_GROUP_SIZE), // the size of the pending queue
		.BITWIDTH (ROW_ADDR_BITWIDTH), // the bitwidth of each element inside the queue
		.COL_PARALLELISM (4)
	) pend_queue_col_4 (
		.pop_dout_0 (grant_rqstAddr_col_4_parallel_0[ROW_ADDR_BITWIDTH-1:0]),
		.pop_dout_1 (grant_rqstAddr_col_4_parallel_1[ROW_ADDR_BITWIDTH-1:0]),
		.pop_dout_2 (grant_rqstAddr_col_4_parallel_2[ROW_ADDR_BITWIDTH-1:0]),
		.pop_dout_3 (grant_rqstAddr_col_4_parallel_3[ROW_ADDR_BITWIDTH-1:0]),

		.rqst_in1 (row_addr_rqst_1),
		.rqst_in2 (row_addr_rqst_2),
		.rqst_in3 (row_addr_rqst_3),
		.rqst_in4 (row_addr_rqst_4),

		//.arbitration_in (),
		.sys_clk (sys_clk),
		.rstn (rstn),
		.we (pendingQueue_we[0])
	);
	// Pending Queue - Column 5
	pend_queue_parallelism_1 #(
		.DEPTH (SHARED_GROUP_SIZE), // the size of the pending queue
		.BITWIDTH (ROW_ADDR_BITWIDTH), // the bitwidth of each element inside the queue
		.COL_PARALLELISM (1)
	) pend_queue_col_5 (
		.pop_dout (grant_rqstAddr_col_5_parallel_0[ROW_ADDR_BITWIDTH-1:0]),

		.rqst_in1 (row_addr_rqst_1),
		.rqst_in2 (row_addr_rqst_2),
		.rqst_in3 (row_addr_rqst_3),
		.rqst_in4 (row_addr_rqst_4),

		.arbitration_in (grant_col_5[2:0]),
		.sys_clk (sys_clk),
		.rstn (rstn),
		.we (pendingQueue_we[1])
	);
	// Pending Queue - Column 6
	pend_queue_parallelism_3 #(
		.DEPTH (SHARED_GROUP_SIZE), // the size of the pending queue
		.BITWIDTH (ROW_ADDR_BITWIDTH), // the bitwidth of each element inside the queue
		.COL_PARALLELISM (3)
	) pend_queue_col_6 (
		.pop_dout_0 (grant_rqstAddr_col_6_parallel_0[ROW_ADDR_BITWIDTH-1:0]),
		.pop_dout_1 (grant_rqstAddr_col_6_parallel_1[ROW_ADDR_BITWIDTH-1:0]),
		.pop_dout_2 (grant_rqstAddr_col_6_parallel_2[ROW_ADDR_BITWIDTH-1:0]),

		.rqst_in1 (row_addr_rqst_1),
		.rqst_in2 (row_addr_rqst_2),
		.rqst_in3 (row_addr_rqst_3),
		.rqst_in4 (row_addr_rqst_4),

		//.arbitration_in (),
		.sys_clk (sys_clk),
		.rstn (rstn),
		.we (pendingQueue_we[2])
	);
	// Pending Queue - Column 7
	pend_queue_parallelism_2 #(
		.DEPTH (SHARED_GROUP_SIZE), // the size of the pending queue
		.BITWIDTH (ROW_ADDR_BITWIDTH), // the bitwidth of each element inside the queue
		.COL_PARALLELISM (2)
	) pend_queue_col_7 (
		.pop_dout_0 (grant_rqstAddr_col_7_parallel_0[ROW_ADDR_BITWIDTH-1:0]),
		.pop_dout_1 (grant_rqstAddr_col_7_parallel_1[ROW_ADDR_BITWIDTH-1:0]),

		.rqst_in1 (row_addr_rqst_1),
		.rqst_in2 (row_addr_rqst_2),
		.rqst_in3 (row_addr_rqst_3),
		.rqst_in4 (row_addr_rqst_4),

		.arbitration_in (grant_col_7),
		.sys_clk (sys_clk),
		.rstn (rstn),
		.we (pendingQueue_we[3])
	);
	endmodule
`elsif XILINX_LUTRAM_TECH
	module mem_share_ctrl_3bit #(
		parameter SHARED_GROUP_SIZE = 4, // the number of requestors in one sharing group 
		parameter SHARED_BANK_NUM = 2, // the number of shared column-bank memories/IB-LUTs
		parameter RQST_FLAG = 1'b1, // either Assertion or Deassertion stands for a access request
		parameter COL_ADDR_BITWIDTH = 1, // Only the LSB is enough after K-Map optimisation
		parameter ROW_ADDR_BITWIDTH = 4,
		parameter BITWIDTH = 3
	) (
		// Column-4 and 6 row addresses for granted rquestors
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_6_parallel_0,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_6_parallel_1,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_6_parallel_2,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_6_parallel_3,
		// Column-5 and 7 row addresses for granted rquestors
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_5_7_parallel_0,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_5_7_parallel_1,

		// Requested Column Addresses
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_1,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_2,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_3,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_4,
		// Requested Row Addresses
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_1,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_2,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_3,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_4,

		input wire sys_clk,
		input rstn
	);

	wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst [0:SHARED_GROUP_SIZE-1];
	assign col_addr_rqst[0] =  col_addr_rqst_1[COL_ADDR_BITWIDTH-1:0];
	assign col_addr_rqst[1] =  col_addr_rqst_2[COL_ADDR_BITWIDTH-1:0];
	assign col_addr_rqst[2] =  col_addr_rqst_3[COL_ADDR_BITWIDTH-1:0];
	assign col_addr_rqst[3] =  col_addr_rqst_4[COL_ADDR_BITWIDTH-1:0];

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instantiation of Access-Request Command Generation
	wire [SHARED_BANK_NUM-1:0] rqst_cmd [0:SHARED_GROUP_SIZE-1];
	wire [SHARED_GROUP_SIZE-1:0] pendingQueue_we [0:SHARED_BANK_NUM-1];
	genvar i, j;
	generate
		for(i=0;i<SHARED_GROUP_SIZE;i=i+1) begin : share_group_inst
			access_rqst_gen #(
				.SHARED_BANK_NUM	(SHARED_BANK_NUM), // the number of shared column-bank memories/IB-LUTs
				.RQST_FLAG          (RQST_FLAG), // either Assertion or Deassertion stands for a access request
				.RQST_ADDR_BITWIDTH (COL_ADDR_BITWIDTH)
			) access_rqst_gen_u0 (
				.rqst_flag (rqst_cmd[i]),
				.rqst_addr (col_addr_rqst[i])
			);
		end

		for(j=0;j<SHARED_BANK_NUM;j=j+1) begin : we_sig_inst
			assign pendingQueue_we[j] = {rqst_cmd[SHARED_GROUP_SIZE-1][j], rqst_cmd[SHARED_GROUP_SIZE-2][j], rqst_cmd[SHARED_GROUP_SIZE-3][j], rqst_cmd[SHARED_GROUP_SIZE-4][j]};
		end
	endgenerate
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Arbitration Signals Generation
	wire grant_col_5_7;
	arbiter_system_parallelism_2 #(
		.COL_PARALLELISM   (2),
		.SHARED_GROUP_SIZE (SHARED_GROUP_SIZE)
	) arbiter_col_5_7 (
		.grant (grant_col_5_7),
		.rqst_in (pendingQueue_we[1])
	);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instantiation of Pending Queues
	// Pending Queue - Column 4
	pend_queue_parallelism_4 #(
		.DEPTH (SHARED_GROUP_SIZE), // the size of the pending queue
		.BITWIDTH (ROW_ADDR_BITWIDTH), // the bitwidth of each element inside the queue
		.COL_PARALLELISM (4)
	) pend_queue_col_4_6 (
		.pop_dout_0 (grant_rqstAddr_col_4_6_parallel_0[ROW_ADDR_BITWIDTH-1:0]),
		.pop_dout_1 (grant_rqstAddr_col_4_6_parallel_1[ROW_ADDR_BITWIDTH-1:0]),
		.pop_dout_2 (grant_rqstAddr_col_4_6_parallel_2[ROW_ADDR_BITWIDTH-1:0]),
		.pop_dout_3 (grant_rqstAddr_col_4_6_parallel_3[ROW_ADDR_BITWIDTH-1:0]),

		.rqst_in1 (row_addr_rqst_1),
		.rqst_in2 (row_addr_rqst_2),
		.rqst_in3 (row_addr_rqst_3),
		.rqst_in4 (row_addr_rqst_4),

		//.arbitration_in (),
		.sys_clk (sys_clk),
		.rstn (rstn),
		.we (pendingQueue_we[0])
	);
	// Pending Queue - Column 7
	pend_queue_parallelism_2 #(
		.DEPTH (SHARED_GROUP_SIZE), // the size of the pending queue
		.BITWIDTH (ROW_ADDR_BITWIDTH), // the bitwidth of each element inside the queue
		.COL_PARALLELISM (2)
	) pend_queue_col_5_7 (
		.pop_dout_0 (grant_rqstAddr_col_5_7_parallel_0[ROW_ADDR_BITWIDTH-1:0]),
		.pop_dout_1 (grant_rqstAddr_col_5_7_parallel_1[ROW_ADDR_BITWIDTH-1:0]),

		.rqst_in1 (row_addr_rqst_1),
		.rqst_in2 (row_addr_rqst_2),
		.rqst_in3 (row_addr_rqst_3),
		.rqst_in4 (row_addr_rqst_4),

		.arbitration_in (grant_col_5_7),
		.sys_clk (sys_clk),
		.rstn (rstn),
		.we (pendingQueue_we[1])
	);
	endmodule
`else
	module mem_share_ctrl_3bit #(
		parameter SHARED_GROUP_SIZE = 4, // the number of requestors in one sharing group 
		parameter SHARED_BANK_NUM = 4, // the number of shared column-bank memories/IB-LUTs
		parameter RQST_FLAG = 1'b1, // either Assertion or Deassertion stands for a access request
		parameter COL_ADDR_BITWIDTH = 2,
		parameter ROW_ADDR_BITWIDTH = 3,
		parameter BITWIDTH = 3
	) (
		// Column-4 row addresses for granted rquestors
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_parallel_0,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_parallel_1,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_parallel_2,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_parallel_3,
		// Column-5 row addresses for granted rquestors
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_5_parallel_0,
		// Column-6 row addresses for granted rquestors
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_6_parallel_0,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_6_parallel_1,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_6_parallel_2,
		// Column-7 row addresses for granted rquestors
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_7_parallel_0,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_7_parallel_1,

		// Requested Column Addresses
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_1,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_2,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_3,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_4,
		// Requested Row Addresses
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_1,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_2,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_3,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_4,

		input wire sys_clk,
		input rstn
	);

	wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst [0:SHARED_GROUP_SIZE-1];
	assign col_addr_rqst[0] =  col_addr_rqst_1[COL_ADDR_BITWIDTH-1:0];
	assign col_addr_rqst[1] =  col_addr_rqst_2[COL_ADDR_BITWIDTH-1:0];
	assign col_addr_rqst[2] =  col_addr_rqst_3[COL_ADDR_BITWIDTH-1:0];
	assign col_addr_rqst[3] =  col_addr_rqst_4[COL_ADDR_BITWIDTH-1:0];

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instantiation of Access-Request Command Generation
	wire [SHARED_BANK_NUM-1:0] rqst_cmd [0:SHARED_GROUP_SIZE-1];
	wire [SHARED_GROUP_SIZE-1:0] pendingQueue_we [0:SHARED_BANK_NUM-1];
	genvar i, j;
	generate
		for(i=0;i<SHARED_GROUP_SIZE;i=i+1) begin : share_group_inst
			access_rqst_gen #(
				.SHARED_BANK_NUM	(SHARED_BANK_NUM), // the number of shared column-bank memories/IB-LUTs
				.RQST_FLAG          (RQST_FLAG), // either Assertion or Deassertion stands for a access request
				.RQST_ADDR_BITWIDTH (COL_ADDR_BITWIDTH)
			) access_rqst_gen_u0 (
				.rqst_flag (rqst_cmd[i]),
				.rqst_addr (col_addr_rqst[i])
			);
		end

		for(j=0;j<SHARED_BANK_NUM;j=j+1) begin : we_sig_inst
			assign pendingQueue_we[j] = {rqst_cmd[SHARED_GROUP_SIZE-1][j], rqst_cmd[SHARED_GROUP_SIZE-2][j], rqst_cmd[SHARED_GROUP_SIZE-3][j], rqst_cmd[SHARED_GROUP_SIZE-4][j]};
		end
	endgenerate
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Arbitration Signals Generation
	wire [2:0] grant_col_5;
	wire grant_col_7;
	arbiter_system_parallelism_1 #(
		.COL_PARALLELISM   (1),
		.SHARED_GROUP_SIZE (4)
	) arbiter_col_5 (
		.grant_0 (grant_col_5[0]),
		.grant_1 (grant_col_5[1]),
		.grant_2 (grant_col_5[2]),
		.rqst_in (pendingQueue_we[1])
	);

	arbiter_system_parallelism_2 #(
		.COL_PARALLELISM   (2),
		.SHARED_GROUP_SIZE (4)
	) arbiter_col_7 (
		.grant (grant_col_7),
		.rqst_in (pendingQueue_we[3])
	);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instantiation of Pending Queues
	// Pending Queue - Column 4
	pend_queue_parallelism_4 #(
		.DEPTH (SHARED_GROUP_SIZE), // the size of the pending queue
		.BITWIDTH (ROW_ADDR_BITWIDTH), // the bitwidth of each element inside the queue
		.COL_PARALLELISM (4)
	) pend_queue_col_4 (
		.pop_dout_0 (grant_rqstAddr_col_4_parallel_0[ROW_ADDR_BITWIDTH-1:0]),
		.pop_dout_1 (grant_rqstAddr_col_4_parallel_1[ROW_ADDR_BITWIDTH-1:0]),
		.pop_dout_2 (grant_rqstAddr_col_4_parallel_2[ROW_ADDR_BITWIDTH-1:0]),
		.pop_dout_3 (grant_rqstAddr_col_4_parallel_3[ROW_ADDR_BITWIDTH-1:0]),

		.rqst_in1 (row_addr_rqst_1),
		.rqst_in2 (row_addr_rqst_2),
		.rqst_in3 (row_addr_rqst_3),
		.rqst_in4 (row_addr_rqst_4),

		//.arbitration_in (),
		.sys_clk (sys_clk),
		.rstn (rstn),
		.we (pendingQueue_we[0])
	);
	// Pending Queue - Column 5
	pend_queue_parallelism_1 #(
		.DEPTH (SHARED_GROUP_SIZE), // the size of the pending queue
		.BITWIDTH (ROW_ADDR_BITWIDTH), // the bitwidth of each element inside the queue
		.COL_PARALLELISM (1)
	) pend_queue_col_5 (
		.pop_dout (grant_rqstAddr_col_5_parallel_0[ROW_ADDR_BITWIDTH-1:0]),

		.rqst_in1 (row_addr_rqst_1),
		.rqst_in2 (row_addr_rqst_2),
		.rqst_in3 (row_addr_rqst_3),
		.rqst_in4 (row_addr_rqst_4),

		.arbitration_in (grant_col_5[2:0]),
		.sys_clk (sys_clk),
		.rstn (rstn),
		.we (pendingQueue_we[1])
	);
	// Pending Queue - Column 6
	pend_queue_parallelism_3 #(
		.DEPTH (SHARED_GROUP_SIZE), // the size of the pending queue
		.BITWIDTH (ROW_ADDR_BITWIDTH), // the bitwidth of each element inside the queue
		.COL_PARALLELISM (3)
	) pend_queue_col_6 (
		.pop_dout_0 (grant_rqstAddr_col_6_parallel_0[ROW_ADDR_BITWIDTH-1:0]),
		.pop_dout_1 (grant_rqstAddr_col_6_parallel_1[ROW_ADDR_BITWIDTH-1:0]),
		.pop_dout_2 (grant_rqstAddr_col_6_parallel_2[ROW_ADDR_BITWIDTH-1:0]),

		.rqst_in1 (row_addr_rqst_1),
		.rqst_in2 (row_addr_rqst_2),
		.rqst_in3 (row_addr_rqst_3),
		.rqst_in4 (row_addr_rqst_4),

		//.arbitration_in (),
		.sys_clk (sys_clk),
		.rstn (rstn),
		.we (pendingQueue_we[2])
	);
	// Pending Queue - Column 7
	pend_queue_parallelism_2 #(
		.DEPTH (SHARED_GROUP_SIZE), // the size of the pending queue
		.BITWIDTH (ROW_ADDR_BITWIDTH), // the bitwidth of each element inside the queue
		.COL_PARALLELISM (2)
	) pend_queue_col_7 (
		.pop_dout_0 (grant_rqstAddr_col_7_parallel_0[ROW_ADDR_BITWIDTH-1:0]),
		.pop_dout_1 (grant_rqstAddr_col_7_parallel_1[ROW_ADDR_BITWIDTH-1:0]),

		.rqst_in1 (row_addr_rqst_1),
		.rqst_in2 (row_addr_rqst_2),
		.rqst_in3 (row_addr_rqst_3),
		.rqst_in4 (row_addr_rqst_4),

		.arbitration_in (grant_col_7),
		.sys_clk (sys_clk),
		.rstn (rstn),
		.we (pendingQueue_we[3])
	);
	endmodule
`endif

`else // ifdef APRIL_2021
module vn_f0_mem_share_ctrl_3bit #(
		parameter SHARED_GROUP_SIZE = 2, // the number of requestors in one sharing group 
		parameter SHARED_BANK_NUM = 2, // the number of shared column-bank memories/IB-LUTs
		parameter RQST_FLAG = 1'b1, // either Assertion or Deassertion stands for a access request
		parameter COL_ADDR_BITWIDTH = 1, // Only the LSB is enough after K-Map optimisation
		parameter ROW_ADDR_BITWIDTH = 4,
		parameter BITWIDTH = 3
) (
		// Column-4 and 6 row addresses for granted rquestors
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_6_parallel_1,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_6_parallel_2,

		// Column-5 and 7 row addresses for granted rquestors
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_5_7_parallel_1,


		// Requested Column Addresses
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_1,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_2,

		// Requested Row Addresses
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_1,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_2,


		input wire sys_clk,
		input rstn
);

	wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_6_parallel [0:SHARED_GROUP_SIZE-1];
	assign grant_rqstAddr_col_4_6_parallel[0] = grant_rqstAddr_col_4_6_parallel_1[ROW_ADDR_BITWIDTH-1:0];
	assign grant_rqstAddr_col_4_6_parallel[1] = grant_rqstAddr_col_4_6_parallel_2[ROW_ADDR_BITWIDTH-1:0];
	wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_5_7_parallel [0:(SHARED_GROUP_SIZE/2)-1];
	assign grant_rqstAddr_col_5_7_parallel[0] = grant_rqstAddr_col_5_7_parallel_1[ROW_ADDR_BITWIDTH-1:0];
	wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst [0:SHARED_GROUP_SIZE-1];
	assign row_addr_rqst[0] =  row_addr_rqst_1[COL_ADDR_BITWIDTH-1:0];
	assign row_addr_rqst[1] =  row_addr_rqst_2[COL_ADDR_BITWIDTH-1:0];
	wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst [0:SHARED_GROUP_SIZE-1];
	assign col_addr_rqst[0] =  col_addr_rqst_1[COL_ADDR_BITWIDTH-1:0];
	assign col_addr_rqst[1] =  col_addr_rqst_2[COL_ADDR_BITWIDTH-1:0];

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instantiation of Access-Request Command Generation
	wire [SHARED_BANK_NUM-1:0] rqst_cmd [0:SHARED_GROUP_SIZE-1];
	wire [SHARED_GROUP_SIZE-1:0] pendingQueue_we [0:SHARED_BANK_NUM-1];
	genvar i, j;
	generate
		for(i=0;i<SHARED_GROUP_SIZE;i=i+1) begin : share_group_inst
			access_rqst_gen #(
				.SHARED_BANK_NUM	(SHARED_BANK_NUM), // the number of shared column-bank memories/IB-LUTs
				.RQST_FLAG          (RQST_FLAG), // either Assertion or Deassertion stands for a access request
				.RQST_ADDR_BITWIDTH (COL_ADDR_BITWIDTH)
			) access_rqst_gen_u0 (
				.rqst_flag (rqst_cmd[i]),
				.rqst_addr (col_addr_rqst[i])
			);
		end

		for(j=0;j<SHARED_BANK_NUM;j=j+1) begin : we_sig_inst
			assign pendingQueue_we[j] = {
											rqst_cmd[SHARED_GROUP_SIZE-1][j], 
											rqst_cmd[SHARED_GROUP_SIZE-2][j]
										};
		end
	endgenerate
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instantiation of Pending Queues
	generate
		// Pending Queue - Column 4 and 6
		for(i=0;i<SHARED_GROUP_SIZE;i=i+1) begin : share_group_queue_inst0
			pend_queue_group_1 #(
				.BITWIDTH (BITWIDTH) // the bitwidth of each element inside the queue
			) pend_queue_col_4_6(
				.pop_dout_0 (grant_rqstAddr_col_4_6_parallel[i]),
			
				.rqst_in1 (row_addr_rqst[i]),
				.sys_clk  (sys_clk),
				.rstn     (rstn),
				.we       (pendingQueue_we[0])
			);
		end

		// Pending Queue - Column 5 and 7
		for(i=0;i<(SHARED_GROUP_SIZE/2);i=i+1) begin : share_group_queue_inst1
			pend_queue_group_2 #(
				.DEPTH (2),
				.BITWIDTH (BITWIDTH) // the bitwidth of each element inside the queue
			) pend_queue_col_5_7(
				.pop_dout_0 (grant_rqstAddr_col_5_7_parallel[i]),
			
				.rqst_in1 (row_addr_rqst[i*2]),
				.rqst_in2 (row_addr_rqst[i*2+1]),
				.sys_clk (sys_clk),
				.rstn (rstn),
				.we (pendingQueue_we[1])
			);
		end
	endgenerate
endmodule

module vn_f1_mem_share_ctrl_3bit #(
		parameter SHARED_GROUP_SIZE = 6, // the number of requestors in one sharing group 
		parameter SHARED_BANK_NUM = 2, // the number of shared column-bank memories/IB-LUTs
		parameter RQST_FLAG = 1'b1, // either Assertion or Deassertion stands for a access request
		parameter COL_ADDR_BITWIDTH = 1, // Only the LSB is enough after K-Map optimisation
		parameter ROW_ADDR_BITWIDTH = 4,
		parameter BITWIDTH = 3
) (
		// Column-4 and 6 row addresses for granted rquestors
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_6_parallel_1,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_6_parallel_2,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_6_parallel_3,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_6_parallel_4,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_6_parallel_5,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_6_parallel_6,
		// Column-5 and 7 row addresses for granted rquestors
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_5_7_parallel_1,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_5_7_parallel_2,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_5_7_parallel_3,

		// Requested Column Addresses
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_1,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_2,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_3,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_4,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_5,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_6,
		// Requested Row Addresses
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_1,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_2,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_3,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_4,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_5,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_6,

		input wire sys_clk,
		input rstn
);

	wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_6_parallel [0:SHARED_GROUP_SIZE-1];
	assign grant_rqstAddr_col_4_6_parallel[0] = grant_rqstAddr_col_4_6_parallel_1[ROW_ADDR_BITWIDTH-1:0];
	assign grant_rqstAddr_col_4_6_parallel[1] = grant_rqstAddr_col_4_6_parallel_2[ROW_ADDR_BITWIDTH-1:0];
	assign grant_rqstAddr_col_4_6_parallel[2] = grant_rqstAddr_col_4_6_parallel_3[ROW_ADDR_BITWIDTH-1:0];
	assign grant_rqstAddr_col_4_6_parallel[3] = grant_rqstAddr_col_4_6_parallel_4[ROW_ADDR_BITWIDTH-1:0];
	assign grant_rqstAddr_col_4_6_parallel[4] = grant_rqstAddr_col_4_6_parallel_5[ROW_ADDR_BITWIDTH-1:0];
	assign grant_rqstAddr_col_4_6_parallel[5] = grant_rqstAddr_col_4_6_parallel_6[ROW_ADDR_BITWIDTH-1:0];
	wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_5_7_parallel [0:(SHARED_GROUP_SIZE/2)-1];
	assign grant_rqstAddr_col_5_7_parallel[0] = grant_rqstAddr_col_5_7_parallel_1[ROW_ADDR_BITWIDTH-1:0];
	assign grant_rqstAddr_col_5_7_parallel[1] = grant_rqstAddr_col_5_7_parallel_2[ROW_ADDR_BITWIDTH-1:0];
	assign grant_rqstAddr_col_5_7_parallel[2] = grant_rqstAddr_col_5_7_parallel_3[ROW_ADDR_BITWIDTH-1:0];
	wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst [0:SHARED_GROUP_SIZE-1];
	assign row_addr_rqst[0] =  row_addr_rqst_1[COL_ADDR_BITWIDTH-1:0];
	assign row_addr_rqst[1] =  row_addr_rqst_2[COL_ADDR_BITWIDTH-1:0];
	assign row_addr_rqst[2] =  row_addr_rqst_3[COL_ADDR_BITWIDTH-1:0];
	assign row_addr_rqst[3] =  row_addr_rqst_4[COL_ADDR_BITWIDTH-1:0];
	assign row_addr_rqst[4] =  row_addr_rqst_5[COL_ADDR_BITWIDTH-1:0];
	assign row_addr_rqst[5] =  row_addr_rqst_6[COL_ADDR_BITWIDTH-1:0];
	wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst [0:SHARED_GROUP_SIZE-1];
	assign col_addr_rqst[0] =  col_addr_rqst_1[COL_ADDR_BITWIDTH-1:0];
	assign col_addr_rqst[1] =  col_addr_rqst_2[COL_ADDR_BITWIDTH-1:0];
	assign col_addr_rqst[2] =  col_addr_rqst_3[COL_ADDR_BITWIDTH-1:0];
	assign col_addr_rqst[3] =  col_addr_rqst_4[COL_ADDR_BITWIDTH-1:0];
	assign col_addr_rqst[4] =  col_addr_rqst_5[COL_ADDR_BITWIDTH-1:0];
	assign col_addr_rqst[5] =  col_addr_rqst_6[COL_ADDR_BITWIDTH-1:0];

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instantiation of Access-Request Command Generation
	wire [SHARED_BANK_NUM-1:0] rqst_cmd [0:SHARED_GROUP_SIZE-1];
	wire [SHARED_GROUP_SIZE-1:0] pendingQueue_we [0:SHARED_BANK_NUM-1];
	genvar i, j;
	generate
		for(i=0;i<SHARED_GROUP_SIZE;i=i+1) begin : share_group_inst
			access_rqst_gen #(
				.SHARED_BANK_NUM	(SHARED_BANK_NUM), // the number of shared column-bank memories/IB-LUTs
				.RQST_FLAG          (RQST_FLAG), // either Assertion or Deassertion stands for a access request
				.RQST_ADDR_BITWIDTH (COL_ADDR_BITWIDTH)
			) access_rqst_gen_u0 (
				.rqst_flag (rqst_cmd[i]),
				.rqst_addr (col_addr_rqst[i])
			);
		end

		for(j=0;j<SHARED_BANK_NUM;j=j+1) begin : we_sig_inst
			assign pendingQueue_we[j] = {
											rqst_cmd[SHARED_GROUP_SIZE-1][j], 
											rqst_cmd[SHARED_GROUP_SIZE-2][j], 
											rqst_cmd[SHARED_GROUP_SIZE-3][j], 
											rqst_cmd[SHARED_GROUP_SIZE-4][j],
											rqst_cmd[SHARED_GROUP_SIZE-5][j],
											rqst_cmd[SHARED_GROUP_SIZE-6][j]
										};
		end
	endgenerate
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instantiation of Pending Queues
	generate
		// Pending Queue - Column 4 and 6
		for(i=0;i<SHARED_GROUP_SIZE;i=i+1) begin : share_group_queue_inst0
			pend_queue_group_1 #(
				.BITWIDTH (BITWIDTH) // the bitwidth of each element inside the queue
			) pend_queue_col_4_6(
				.pop_dout_0 (grant_rqstAddr_col_4_6_parallel[i]),
			
				.rqst_in1 (row_addr_rqst[i]),
				.sys_clk  (sys_clk),
				.rstn     (rstn),
				.we       (pendingQueue_we[0])
			);
		end

		// Pending Queue - Column 5 and 7
		for(i=0;i<(SHARED_GROUP_SIZE/2);i=i+1) begin : share_group_queue_inst1
			pend_queue_group_2 #(
				.DEPTH (2),
				.BITWIDTH (BITWIDTH) // the bitwidth of each element inside the queue
			) pend_queue_col_5_7(
				.pop_dout_0 (grant_rqstAddr_col_5_7_parallel[i]),
			
				.rqst_in1 (row_addr_rqst[i*2]),
				.rqst_in2 (row_addr_rqst[i*2+1]),
				.sys_clk (sys_clk),
				.rstn (rstn),
				.we (pendingQueue_we[1])
			);
		end
	endgenerate
endmodule
/////////////////////////////////////////////////////////////////////////////////////////////////////
// 4-bit
module vn_f0_mem_share_ctrl_4bit #(
		parameter SHARED_GROUP_SIZE = 2, // the number of requestors in one sharing group 
		parameter SHARED_BANK_NUM = 4, // the number of shared column-bank memories/IB-LUTs
		parameter RQST_FLAG = 1'b1, // either Assertion or Deassertion stands for a access request
		parameter COL_ADDR_BITWIDTH = 3, // Only the LSB is enough after K-Map optimisation
		parameter ROW_ADDR_BITWIDTH = 4,
		parameter BITWIDTH = 4
) (
		// Column-8and 10 row addresses for granted rquestors
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_8_10_parallel_1,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_8_10_parallel_2,

		// Column-9 and 11 row addresses for granted rquestors
		// Column-12 and 13 row addresses for granted rquestors
		// Column-14 and 15 row addresses for granted rquestors
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_9_11_parallel_1,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_12_13_parallel_1,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_14_15_parallel_1,


		// Requested Column Addresses
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_1,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_2,

		// Requested Row Addresses
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_1,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_2,


		input wire sys_clk,
		input rstn
);

	wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_8_10_parallel [0:SHARED_GROUP_SIZE-1];
	assign grant_rqstAddr_col_8_10_parallel[0] = grant_rqstAddr_col_8_10_parallel_1[ROW_ADDR_BITWIDTH-1:0];
	assign grant_rqstAddr_col_8_10_parallel[1] = grant_rqstAddr_col_8_10_parallel_2[ROW_ADDR_BITWIDTH-1:0];
	wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_9_11_parallel [0:(SHARED_GROUP_SIZE/2)-1];
	assign grant_rqstAddr_col_9_11_parallel[0] = grant_rqstAddr_col_9_11_parallel_1[ROW_ADDR_BITWIDTH-1:0];
	wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_12_13_parallel [0:(SHARED_GROUP_SIZE/2)-1];
	assign grant_rqstAddr_col_9_11_parallel[0] = grant_rqstAddr_col_12_13_parallel_1[ROW_ADDR_BITWIDTH-1:0];
	wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_14_15_parallel [0:(SHARED_GROUP_SIZE/2)-1];
	assign grant_rqstAddr_col_9_11_parallel[0] = grant_rqstAddr_col_14_15_parallel_1[ROW_ADDR_BITWIDTH-1:0];

	wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst [0:SHARED_GROUP_SIZE-1];
	assign row_addr_rqst[0] =  row_addr_rqst_1[COL_ADDR_BITWIDTH-1:0];
	assign row_addr_rqst[1] =  row_addr_rqst_2[COL_ADDR_BITWIDTH-1:0];
	wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst [0:SHARED_GROUP_SIZE-1];
	assign col_addr_rqst[0] =  col_addr_rqst_1[COL_ADDR_BITWIDTH-1:0];
	assign col_addr_rqst[1] =  col_addr_rqst_2[COL_ADDR_BITWIDTH-1:0];

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instantiation of Access-Request Command Generation
	wire [SHARED_BANK_NUM-1:0] rqst_cmd [0:SHARED_GROUP_SIZE-1];
	wire [SHARED_GROUP_SIZE-1:0] pendingQueue_we [0:SHARED_BANK_NUM-1];
	genvar i, j;
	generate
		for(i=0;i<SHARED_GROUP_SIZE;i=i+1) begin : share_group_inst
			access_rqst_gen_4bit #(
							.SHARED_BANK_NUM	(SHARED_BANK_NUM), // the number of shared column-bank memories/IB-LUTs
							.RQST_FLAG          (RQST_FLAG), // either Assertion or Deassertion stands for a access request
							.RQST_ADDR_BITWIDTH (COL_ADDR_BITWIDTH)
			) access_rqst_gen_u0(
							.rqst_flag (rqst_cmd[i]),
							.rqst_addr (col_addr_rqst[i])
			);
		end

		for(j=0;j<SHARED_BANK_NUM;j=j+1) begin : we_sig_inst
			assign pendingQueue_we[j] = {
											rqst_cmd[SHARED_GROUP_SIZE-1][j], 
											rqst_cmd[SHARED_GROUP_SIZE-2][j]
										};
		end
	endgenerate
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instantiation of Pending Queues
	generate
		// Pending Queue - Column 8 and 10
		for(i=0;i<SHARED_GROUP_SIZE;i=i+1) begin : share_group_queue_inst0
			pend_queue_group_1 #(
				.BITWIDTH (BITWIDTH) // the bitwidth of each element inside the queue
			) pend_queue_col_8_10(
				.pop_dout_0 (grant_rqstAddr_col_8_10_parallel[i]),
			
				.rqst_in1 (row_addr_rqst[i]),
				.sys_clk  (sys_clk),
				.rstn     (rstn),
				.we       (pendingQueue_we[0])
			);
		end

		// Pending Queue - Column 9 and 11
		for(i=0;i<(SHARED_GROUP_SIZE/2);i=i+1) begin : share_group_queue_inst1
			pend_queue_group_2 #(
				.DEPTH (2),
				.BITWIDTH (BITWIDTH) // the bitwidth of each element inside the queue
			) pend_queue_col_9_11(
				.pop_dout_0 (grant_rqstAddr_col_9_11_parallel[i]),
			
				.rqst_in1 (row_addr_rqst[i*2]),
				.rqst_in2 (row_addr_rqst[i*2+1]),
				.sys_clk (sys_clk),
				.rstn (rstn),
				.we (pendingQueue_we[1])
			);
		// Pending Queue - Column 12 and 13
		for(i=0;i<(SHARED_GROUP_SIZE/2);i=i+1) begin : share_group_queue_inst1
			pend_queue_group_2 #(
				.DEPTH (2),
				.BITWIDTH (BITWIDTH) // the bitwidth of each element inside the queue
			) pend_queue_col_12_13(
				.pop_dout_0 (grant_rqstAddr_col_12_13_parallel[i]),
			
				.rqst_in1 (row_addr_rqst[i*2]),
				.rqst_in2 (row_addr_rqst[i*2+1]),
				.sys_clk (sys_clk),
				.rstn (rstn),
				.we (pendingQueue_we[1])
			);
		// Pending Queue - Column 14 and 15
		for(i=0;i<(SHARED_GROUP_SIZE/2);i=i+1) begin : share_group_queue_inst1
			pend_queue_group_2 #(
				.DEPTH (2),
				.BITWIDTH (BITWIDTH) // the bitwidth of each element inside the queue
			) pend_queue_col_14_15(
				.pop_dout_0 (grant_rqstAddr_col_14_15_parallel[i]),
			
				.rqst_in1 (row_addr_rqst[i*2]),
				.rqst_in2 (row_addr_rqst[i*2+1]),
				.sys_clk (sys_clk),
				.rstn (rstn),
				.we (pendingQueue_we[1])
			);
		end
	endgenerate
endmodule

module vn_f1_mem_share_ctrl_4bit #(
		parameter SHARED_GROUP_SIZE = 6, // the number of requestors in one sharing group 
		parameter SHARED_BANK_NUM = 2, // the number of shared column-bank memories/IB-LUTs
		parameter RQST_FLAG = 1'b1, // either Assertion or Deassertion stands for a access request
		parameter COL_ADDR_BITWIDTH = 3, // Only the LSB is enough after K-Map optimisation
		parameter ROW_ADDR_BITWIDTH = 4,
		parameter BITWIDTH = 3
) (
		// Column-4 and 6 row addresses for granted rquestors
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_6_parallel_1,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_6_parallel_2,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_6_parallel_3,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_6_parallel_4,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_6_parallel_5,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_6_parallel_6,
		// Column-5 and 7 row addresses for granted rquestors
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_5_7_parallel_1,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_5_7_parallel_2,
		output wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_5_7_parallel_3,

		// Requested Column Addresses
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_1,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_2,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_3,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_4,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_5,
		input wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst_6,
		// Requested Row Addresses
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_1,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_2,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_3,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_4,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_5,
		input wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst_6,

		input wire sys_clk,
		input rstn
);

	wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_4_6_parallel [0:SHARED_GROUP_SIZE-1];
	assign grant_rqstAddr_col_4_6_parallel[0] = grant_rqstAddr_col_4_6_parallel_1[ROW_ADDR_BITWIDTH-1:0];
	assign grant_rqstAddr_col_4_6_parallel[1] = grant_rqstAddr_col_4_6_parallel_2[ROW_ADDR_BITWIDTH-1:0];
	assign grant_rqstAddr_col_4_6_parallel[2] = grant_rqstAddr_col_4_6_parallel_3[ROW_ADDR_BITWIDTH-1:0];
	assign grant_rqstAddr_col_4_6_parallel[3] = grant_rqstAddr_col_4_6_parallel_4[ROW_ADDR_BITWIDTH-1:0];
	assign grant_rqstAddr_col_4_6_parallel[4] = grant_rqstAddr_col_4_6_parallel_5[ROW_ADDR_BITWIDTH-1:0];
	assign grant_rqstAddr_col_4_6_parallel[5] = grant_rqstAddr_col_4_6_parallel_6[ROW_ADDR_BITWIDTH-1:0];
	wire [ROW_ADDR_BITWIDTH-1:0] grant_rqstAddr_col_5_7_parallel [0:(SHARED_GROUP_SIZE/2)-1];
	assign grant_rqstAddr_col_5_7_parallel[0] = grant_rqstAddr_col_5_7_parallel_1[ROW_ADDR_BITWIDTH-1:0];
	assign grant_rqstAddr_col_5_7_parallel[1] = grant_rqstAddr_col_5_7_parallel_2[ROW_ADDR_BITWIDTH-1:0];
	assign grant_rqstAddr_col_5_7_parallel[2] = grant_rqstAddr_col_5_7_parallel_3[ROW_ADDR_BITWIDTH-1:0];
	wire [ROW_ADDR_BITWIDTH-1:0] row_addr_rqst [0:SHARED_GROUP_SIZE-1];
	assign row_addr_rqst[0] =  row_addr_rqst_1[COL_ADDR_BITWIDTH-1:0];
	assign row_addr_rqst[1] =  row_addr_rqst_2[COL_ADDR_BITWIDTH-1:0];
	assign row_addr_rqst[2] =  row_addr_rqst_3[COL_ADDR_BITWIDTH-1:0];
	assign row_addr_rqst[3] =  row_addr_rqst_4[COL_ADDR_BITWIDTH-1:0];
	assign row_addr_rqst[4] =  row_addr_rqst_5[COL_ADDR_BITWIDTH-1:0];
	assign row_addr_rqst[5] =  row_addr_rqst_6[COL_ADDR_BITWIDTH-1:0];
	wire [COL_ADDR_BITWIDTH-1:0] col_addr_rqst [0:SHARED_GROUP_SIZE-1];
	assign col_addr_rqst[0] =  col_addr_rqst_1[COL_ADDR_BITWIDTH-1:0];
	assign col_addr_rqst[1] =  col_addr_rqst_2[COL_ADDR_BITWIDTH-1:0];
	assign col_addr_rqst[2] =  col_addr_rqst_3[COL_ADDR_BITWIDTH-1:0];
	assign col_addr_rqst[3] =  col_addr_rqst_4[COL_ADDR_BITWIDTH-1:0];
	assign col_addr_rqst[4] =  col_addr_rqst_5[COL_ADDR_BITWIDTH-1:0];
	assign col_addr_rqst[5] =  col_addr_rqst_6[COL_ADDR_BITWIDTH-1:0];

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instantiation of Access-Request Command Generation
	wire [SHARED_BANK_NUM-1:0] rqst_cmd [0:SHARED_GROUP_SIZE-1];
	wire [SHARED_GROUP_SIZE-1:0] pendingQueue_we [0:SHARED_BANK_NUM-1];
	genvar i, j;
	generate
		for(i=0;i<SHARED_GROUP_SIZE;i=i+1) begin : share_group_inst
			access_rqst_gen #(
				.SHARED_BANK_NUM	(SHARED_BANK_NUM), // the number of shared column-bank memories/IB-LUTs
				.RQST_FLAG          (RQST_FLAG), // either Assertion or Deassertion stands for a access request
				.RQST_ADDR_BITWIDTH (COL_ADDR_BITWIDTH)
			) access_rqst_gen_u0 (
				.rqst_flag (rqst_cmd[i]),
				.rqst_addr (col_addr_rqst[i])
			);
		end

		for(j=0;j<SHARED_BANK_NUM;j=j+1) begin : we_sig_inst
			assign pendingQueue_we[j] = {
											rqst_cmd[SHARED_GROUP_SIZE-1][j], 
											rqst_cmd[SHARED_GROUP_SIZE-2][j], 
											rqst_cmd[SHARED_GROUP_SIZE-3][j], 
											rqst_cmd[SHARED_GROUP_SIZE-4][j],
											rqst_cmd[SHARED_GROUP_SIZE-5][j],
											rqst_cmd[SHARED_GROUP_SIZE-6][j]
										};
		end
	endgenerate
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Instantiation of Pending Queues
	generate
		// Pending Queue - Column 4 and 6
		for(i=0;i<SHARED_GROUP_SIZE;i=i+1) begin : share_group_queue_inst0
			pend_queue_group_1 #(
				.BITWIDTH (BITWIDTH) // the bitwidth of each element inside the queue
			) pend_queue_col_4_6(
				.pop_dout_0 (grant_rqstAddr_col_4_6_parallel[i]),
			
				.rqst_in1 (row_addr_rqst[i]),
				.sys_clk  (sys_clk),
				.rstn     (rstn),
				.we       (pendingQueue_we[0])
			);
		end

		// Pending Queue - Column 5 and 7
		for(i=0;i<(SHARED_GROUP_SIZE/2);i=i+1) begin : share_group_queue_inst1
			pend_queue_group_2 #(
				.DEPTH (2),
				.BITWIDTH (BITWIDTH) // the bitwidth of each element inside the queue
			) pend_queue_col_5_7(
				.pop_dout_0 (grant_rqstAddr_col_5_7_parallel[i]),
			
				.rqst_in1 (row_addr_rqst[i*2]),
				.rqst_in2 (row_addr_rqst[i*2+1]),
				.sys_clk (sys_clk),
				.rstn (rstn),
				.we (pendingQueue_we[1])
			);
		end
	endgenerate
endmodule
`endif