// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Mon Oct 21 20:37:52 2024
// Host        : DESKTOP-DJHODC2 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {c:/Users/Chris/Desktop/Vivado
//               Projects/LFC_IMPLEMENTATION/LFC_IMPLEMENTATION.gen/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v}
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(std_clk, test_clk, reset, locked, sys_clk)
/* synthesis syn_black_box black_box_pad_pin="reset,locked,sys_clk" */
/* synthesis syn_force_seq_prim="std_clk" */
/* synthesis syn_force_seq_prim="test_clk" */;
  output std_clk /* synthesis syn_isclock = 1 */;
  output test_clk /* synthesis syn_isclock = 1 */;
  input reset;
  output locked;
  input sys_clk;
endmodule
