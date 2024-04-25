`timescale 1ns/1ps
// Project: access_rqst_gen.memShare_sched
// File: memShare_config_pkg.sv
// Package: memShare_config_pkg
// Developer: Bo-Yu Tseng
// Email: tsengs0@gamil.com
//
// # Description
// Configuration package to flexibly modify the the design rules, pipeline scheduling 
// strategy, etc. for the SCU.memShare(). Note that the "memShare_config.vh" is the 
// legacy configuration file which is planned to be merged into this package in the future.
//
// # Dependencies
// 	None
// ----------------------------------------------------------------------------------------
//  # History
//  Date            Revision    Description                 Editor
//  13.April.2024   v0.01       First created               Bo-Yu Tseng
// ----------------------------------------------------------------------------------------

package memShare_config_pkg;

localparam MAX_ALLOC_SEQ_NUM = 2; // maximum number of allocation seuqences for a set of request patterns

// Arrival requestor profiling
localparam ARR_RQST_TRACK_DEPTH = 4; // No specific rule to determine the depth
localparam READ_2SEQ_TRACK_DEPTH = ARR_RQST_TRACK_DEPTH;
localparam MEMSHARE_DRC_NUM = 3; // # of the DRCs in the underlying SCU.memShare()
typedef enum {
    MEMSHARE_DRC1 = 0,
    MEMSHARE_DRC2 = 1,
    MEMSHARE_DRC3 = 2  
} memShare_drc_index;
endpackage
