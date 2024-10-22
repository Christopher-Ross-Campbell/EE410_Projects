`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2024 08:35:09 PM
// Design Name: 
// Module Name: tb_Design_Source
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_top_module;
    // Inputs to the DUT
    reg reset;
    reg sys_clk;

    // Outputs from the DUT
    wire [63:0] freq;

    // Internal wires to monitor all signals
    wire std_clk;
    wire test_clk;
    wire gate_s;
    wire gate_a;
    wire gate_a_stand;
    wire gate_a_test;
    wire gate_a_fall_s;
    wire gate_a_fall_t;
    wire [28:0] counter;
    wire [1:0] state;
    wire [31:0] cnt_clk_std_reg;
    wire [31:0] cnt_clk_test_reg;
    wire calc_flag;
    wire calc_flag_reg;
    wire [63:0] freq_reg;

    // Instantiate the DUT
    top_module dut (
        .reset(reset),
        .sys_clk(sys_clk),
        .freq(freq)
    );

    // Monitor internal signals
    assign std_clk = dut.u_clock_gen.std_clk;
    assign test_clk = dut.u_clock_gen.test_clk;
    assign gate_s = dut.u_gate_s.gate_s;
    assign gate_a = dut.u_gate_a.gate_a;
    assign gate_a_stand = dut.u_gate_a_stand.gate_a_stand;
    assign gate_a_test = dut.u_gate_a_test.gate_a_test;
    assign gate_a_fall_s = dut.u_gate_a_fall_s.gate_a_fall_s;
    assign gate_a_fall_t = dut.u_gate_a_fall_t.gate_a_fall_t;
    assign counter = dut.u_gate_s.counter;
    assign state = dut.u_gate_s.state;
    assign cnt_clk_std_reg = dut.u_count_clk_std.cnt_clk_std_reg;
    assign cnt_clk_test_reg = dut.u_count_clk_test.cnt_clk_test_reg;
    assign calc_flag = dut.u_calc_flag.calc_flag;
    assign calc_flag_reg = dut.u_calc_flag_reg.calc_flag_reg;
    assign freq_reg = dut.u_calc_flag.freq_reg;

    // Clock generation
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;  // 100 MHz clock
    end

    // Test sequence
    initial begin
        $monitor("Time=%0t reset=%b freq=%0d std_clk=%b test_clk=%b gate_s=%b gate_a=%b gate_a_stand=%b gate_a_test=%b counter=%d state=%b",
                 $time, reset, freq, std_clk, test_clk, gate_s, gate_a, gate_a_stand, gate_a_test, counter, state);

        // Apply reset
        reset = 1;
        #50 reset = 0;

        // Run for some time to observe behavior
        #1000000;

        // Finish simulation
        $finish;
    end
endmodule
