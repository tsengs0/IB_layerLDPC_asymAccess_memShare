package ibRAM_config_pkg;

//--------------------------------------------------------------
// Configuration of the bank-interleaving type of IB-RAM macros
// 3bit quantisation
//--------------------------------------------------------------
// Bank interleaving w/ two banks for the 3-bit quantised IB LUTs
localparam Q3_BI1_BANK_INTERLEAVE_TYPE = 0; // 0: {bank_addr, page_addr}, 1: {page_addr, bank_addr}
localparam Q3_BI1_BANK_INTERLEAVE_NUM = 2; // # of the interleaving banks
localparam Q3_BI1_ADDR_WIDTH = 6; // bank_addr+page_addr
localparam Q3_BI1_BANK_ADDR_WIDTH = 1; // $clog2(BANK_INTERLEAVE_NUM);
localparam Q3_BI1_PAGE_ADDR_WIDTH = 5; //ADDR_WIDTH-BANK_ADDR_WIDTH;
localparam Q3_BI1_PAGE_SIZE = 4;
localparam Q3_BI1_WDATA_SIZE = 8; // PAGE_SIZE*BANK_INTERLEAVE_NUM;
localparam Q3_BI1_PAGE_NUM = 32;
localparam Q3_BI1_ASYNC_RD_EN = 1; // 0: synchronous read, 1: asynchronous read
//--------------------------------------------------------------
// Configuration of the bank-interleaving type of IB-RAM macros
// 4bit quantisation
//--------------------------------------------------------------
// Bank interleaving w/ two banks for the 4-bit quantised IB LUTs
localparam Q4_BI2_BANK_INTERLEAVE_TYPE = 0; // 0: {bank_addr, page_addr}, 1: {page_addr, bank_addr}
localparam Q4_BI2_BANK_INTERLEAVE_NUM = 2; // # of the interleaving banks
localparam Q4_BI2_ADDR_WIDTH = 6; // bank_addr+page_addr
localparam Q4_BI2_BANK_ADDR_WIDTH = 1; // $clog2(BANK_INTERLEAVE_NUM);
localparam Q4_BI2_PAGE_ADDR_WIDTH = 5; //ADDR_WIDTH-BANK_ADDR_WIDTH;
localparam Q4_BI2_PAGE_SIZE = 4;
localparam Q4_BI2_WDATA_SIZE = 8; // PAGE_SIZE*BANK_INTERLEAVE_NUM;
localparam Q4_BI2_PAGE_NUM = 32;
localparam Q4_BI2_ASYNC_RD_EN = 1; // 0: synchronous read, 1: asynchronous read

// Bank interleaving w/ four banks for the 4-bit quantised IB LUTs
localparam Q4_BI4_BANK_INTERLEAVE_TYPE = 0; // 0: {bank_addr, page_addr}, 1: {page_addr, bank_addr}
localparam Q4_BI4_BANK_INTERLEAVE_NUM = 4; // # of the interleaving banks
localparam Q4_BI4_ADDR_WIDTH = 8; // bank_addr+page_addr
localparam Q4_BI4_BANK_ADDR_WIDTH = 2; // $clog2(BANK_INTERLEAVE_NUM),
localparam Q4_BI4_PAGE_ADDR_WIDTH = 6; // ADDR_WIDTH-BANK_ADDR_WIDTH,
localparam Q4_BI4_PAGE_SIZE = 4;
localparam Q4_BI4_WDATA_SIZE = 16; // PAGE_SIZE*BANK_INTERLEAVE_NUM,
localparam Q4_BI4_PAGE_NUM = 64;
localparam Q4_BI4_ASYNC_RD_EN = 1; // 0: synchronous read, 1: asynchronous read
endpackage
