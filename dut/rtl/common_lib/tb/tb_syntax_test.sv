module tb_syntax_test;

generic_mem_preloader#(.PAGE_NUM(5), .PAGE_SIZE(14)) rom_loader;

initial begin
    rom_loader = new();

    rom_loader.bin_load("./rom_config.bin");
    rom_loader.bin_view;
    $finish;
end
endmodule
