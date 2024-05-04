// Latest date: 1st May, 2024
// Developer: Bo-Yu Tseng
// Email: tsengs0@gamil.com
// Module name: msgPass_buffer_preloader
// 
// # I/F
// 1) Output:
//
// 2) Input:
//
// # Param
//
// # Description
//    A ROM/RAM preloader module for ease of the simulation
`include "generic_mem_preloader_config.vh"

class msgPass_buffer_preloader #(
    parameter int PAGE_NUM = 128,
    parameter int PAGE_SIZE = 15
);

logic [PAGE_SIZE-1:0] mem [0:PAGE_NUM-1];

task bin_load(input string filename);
    $readmemb(filename, mem);
endtask

task hex_load(input string filename);
    $readmemh(filename, mem);
endtask

task bin_view;
    $display("=============================");
    $display("Addr:\t\tValue [binary]");
    for(int i=0; i<PAGE_NUM; i++) $display("0x%08h:\t%b", i, mem[i]);
    $display("=============================");
endtask

task hex_view;
    $display("=============================");
    $display("Addr:\t\tValue [binary]");
    for(int i=0; i<PAGE_NUM; i++) $display("0x%08h:\t%h", i, mem[i]);
    $display("=============================");
endtask

// To force the DUT memory block getting initialised by the given dataset
task bypass_preload;
    for(int i=0; i<PAGE_NUM; i++) `MSGPASS_BUFF_PATH.`MSGPASS_BUFF_MEM_CELL[i] = mem[i];

    $display("The DUT memory block has been initialised as follows.");
    $display("=============================");
    $display("Addr:\t\tValue [binary]");
    for(int i=0; i<PAGE_NUM; i++) begin
        // To verify the consistency between the preload dataset and the actual initial values
        if(`MSGPASS_BUFF_PATH.`MSGPASS_BUFF_MEM_CELL[i] != mem[i])
          $display("#Inconsistent ---> 0x%08h:\t%h (preload), %h (actual initial value)", i, mem[i], `MSGPASS_BUFF_PATH.`MSGPASS_BUFF_MEM_CELL[i]);
        else
          $display("0x%08h:\t%b", i, `MSGPASS_BUFF_PATH.`MSGPASS_BUFF_MEM_CELL[i]);
    end
    $display("=============================");
endtask

// To watch the memory content inside the DUT memory block
task dut_mem_bin_view;
$display("The DUT memory block:");
$display("=============================");
$display("Addr:\t\tValue [binary]");
for(int i=0; i<PAGE_NUM; i++) $display("0x%08h:\t%b", i, `MSGPASS_BUFF_PATH.`MSGPASS_BUFF_MEM_CELL[i]);
$display("=============================");
endtask
endclass
