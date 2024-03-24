interface cumulative_shift_gen_if #(
    parameter SHIFT_WIDTH,
    parameter REF_WIDTH
);

logic [SHIFT_WIDTH-1:0] cumulative_shift_o;
logic [SHIFT_WIDTH-1:0] shift_i;
// Reconfigurable signal(s)
logic  [REF_WIDTH-1:0] directRef_reconfig_i; //! Equivalent to W^{s}
logic [REF_WIDTH-1:0] leqRef_reconfig_i; //! Equivalent to floor(W^{s}/2)
logic sys_clk;
logic rstn;

modport design (output cumulative_shift_o, input shift_i, directRef_reconfig_i, leqRef_reconfig_i, sys_clk, rstn);
endinterface