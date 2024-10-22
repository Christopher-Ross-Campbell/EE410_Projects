`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2024 08:34:06 PM
// Design Name: 
// Module Name: Design_Source
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


module top_module(
    input wire reset,
    input wire sys_clk,
    output wire [63:0] freq
    );

    // Wires for interconnecting modules
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
    
    // Clock generation module instantiation
    clock_gen u_clock_gen (
        .reset(reset),
        .sys_clk(sys_clk),
        .std_clk(std_clk),
        .test_clk(test_clk)
    );

    // GATE_S module instantiation (Standard Gate generation)
    GATE_S u_gate_s (
        .std_clk(std_clk),
        .reset(reset),
        .gate_s(gate_s),
        .counter(counter),
        .state(state)
    );

    // GATE_A module instantiation (Test gate generation)
    GATE_A u_gate_a (
        .gate_s(gate_s),
        .reset(reset),
        .test_clk(test_clk),
        .gate_a(gate_a)
    );

    // GATE_A_Stand module instantiation
    GATE_A_Stand u_gate_a_stand (
        .std_clk(std_clk),
        .reset(reset),
        .gate_a(gate_a),
        .gate_a_stand(gate_a_stand)
    );

    // GATE_A_Test module instantiation
    GATE_A_Test u_gate_a_test (
        .test_clk(test_clk),
        .reset(reset),
        .gate_a(gate_a),
        .gate_a_test(gate_a_test)
    );

    // GATE_A_Fall_S module instantiation
    GATE_A_Fall_S u_gate_a_fall_s (
        .gate_a(gate_a),
        .gate_a_stand(gate_a_stand),
        .gate_a_fall_s(gate_a_fall_s)
    );

    // GATE_A_Fall_T module instantiation
    GATE_A_Fall_T u_gate_a_fall_t (
        .gate_a(gate_a),
        .gate_a_test(gate_a_test),
        .gate_a_fall_t(gate_a_fall_t)
    );

    // COUNT_CLK_STD module instantiation
    COUNT_CLK_STD u_count_clk_std (
        .std_clk(std_clk),
        .reset(reset),
        .gate_a(gate_a),
        .gate_a_fall_s(gate_a_fall_s),
        .cnt_clk_std_reg(cnt_clk_std_reg),
        .s_counter()
    );

    // COUNT_CLK_TEST module instantiation
    COUNT_CLK_TEST u_count_clk_test (
        .test_clk(test_clk),
        .reset(reset),
        .gate_a(gate_a),
        .gate_a_fall_t(gate_a_fall_t),
        .cnt_clk_test_reg(cnt_clk_test_reg),
        .t_counter()
    );

    // CALC_FLAG module instantiation
    CALC_FLAG u_calc_flag (
        .std_clk(std_clk),
        .reset(reset),
        .counter(counter),
        .cnt_clk_test_reg(cnt_clk_test_reg),
        .cnt_clk_std_reg(cnt_clk_std_reg),
        .calc_flag(calc_flag),
        .freq_reg(freq_reg)
    );

    // CALC_FLAG_REG module instantiation
    CALC_FLAG_REG u_calc_flag_reg (
        .std_clk(std_clk),
        .reset(reset),
        .calc_flag(calc_flag),
        .calc_flag_reg(calc_flag_reg)
    );

    // GET_FREQ module instantiation
    GET_FREQ u_get_freq (
        .std_clk(std_clk),
        .reset(reset),
        .calc_flag_reg(calc_flag_reg),
        .freq_reg(freq_reg),
        .freq(freq)
    );

    // PROBE module instantiation
    PROBE u_probe (
        .sys_clk(sys_clk),
        .freq(freq)
    );

endmodule

module clock_gen( //Generates standard and test clock signals
    input wire reset,
    input wire sys_clk,
    output wire std_clk,
    output wire test_clk
    );
    
   clk_wiz_0 instance_name
   (
    // Clock out ports
    .std_clk(std_clk),     // output std_clk
    .test_clk(test_clk),     // output test_clk
    // Status and control signals
    .reset(reset), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .sys_clk(sys_clk)      // input sys_clk
    );

endmodule
    
module GATE_S(  //Generates standard gate
    input wire std_clk,      
    input wire reset,      // Reset signal
    output reg gate_s,      // Output signal
    output reg [28:0] counter, 
    output reg [1:0] state  
    );
    
    // State 
    localparam STATE_LOW_0_25  = 2'b00;
    localparam STATE_HIGH_1    = 2'b01;
    localparam STATE_LOW_0_25_END = 2'b10;

    // Constants for time intervals (in clock cycles)
    localparam CNT_RISE_MAX  = 75_000_000;  // 0.25 seconds
    localparam CNT_HIGH_MAX = 375_000_000; // 0.25 + 1.0 seconds
    localparam CNT_GATE_MAX  = 450_000_000; // 1.5 seconds

    // Counter and gate_s control logic
    always @(posedge std_clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            gate_s <= 1'b0;
        end
        else begin
            // Increment the counter
            if (counter < CNT_GATE_MAX - 1) begin
                counter <= counter + 1;
            end else begin
                counter <= 0;  // Reset counter after 1.5 seconds
            end

            // Control gate_s output
            if (counter < CNT_RISE_MAX) begin
                gate_s <= 1'b0;  // Low for the first 0.25 seconds
                state <= STATE_LOW_0_25;
            end
            else if (counter < CNT_HIGH_MAX) begin
                gate_s <= 1'b1;  // High for the middle 1 second
                state <= STATE_HIGH_1;
            end
            else begin
                gate_s <= 1'b0;  // Low for the last 0.25 seconds
                state <= STATE_LOW_0_25_END;
            end
        end
    end
endmodule

module GATE_A ( //generate gate_a
    input wire gate_s,      
    input wire reset,      
    input wire test_clk,    
    output reg gate_a    
);

always @(posedge test_clk or posedge reset) begin
    if (reset) begin
        gate_a <= 0;      // Reset output signal to 0
    end else begin
        gate_a <= gate_s;  // Assign the input signal to the output, delayed by 1 clock cycle
    end
end

endmodule

module GATE_A_Stand ( //generate gate_a based on standard clock
    input wire std_clk,      
    input wire reset,      
    input wire gate_a,    
    output reg gate_a_stand    
);

always @(posedge std_clk or posedge reset) begin
    if (reset) begin
        gate_a_stand <= 0;      // Reset output signal to 0
    end else begin
        gate_a_stand <= gate_a;  
    end
end

endmodule

module GATE_A_Test ( //generate gate_a based on test clock
    input wire test_clk,      
    input wire reset,     
    input wire gate_a,    
    output reg gate_a_test    
);

always @(posedge test_clk or posedge reset) begin
    if (reset) begin
        gate_a_test <= 0;      // Reset output signal to 0
    end else begin
        gate_a_test <= gate_a;  
    end
end

endmodule

module GATE_A_Fall_S( //make trigger for end of gate_a_stand
    input wire gate_a,
    input wire gate_a_stand,
    output reg gate_a_fall_s
    );
    
    always @(*) begin
    if (gate_a_stand == 1'b1 && gate_a == 1'b0) begin
        gate_a_fall_s = 1'b1;
    end else begin
        gate_a_fall_s = 1'b0;
    end
end
endmodule

module GATE_A_Fall_T( //make trigger for end of gate_a_test
    input wire gate_a,
    input wire gate_a_test,
    output reg gate_a_fall_t
    );
    
    always @(*) begin
    if (gate_a_test == 1'b1 && gate_a == 1'b0) begin
        gate_a_fall_t = 1'b1;
    end else begin
        gate_a_fall_t = 1'b0;
    end
end
endmodule

module COUNT_CLK_STD( //counter for gate under std_clk
    input wire std_clk,   
    input wire reset,
    input wire gate_a,    
    input wire gate_a_fall_s,
    output reg [31:0] cnt_clk_std_reg,   
    output reg [31:0] s_counter
);
    always @(posedge std_clk or posedge reset) begin
        if(reset) begin
            s_counter <= 0;
            cnt_clk_std_reg <= 0;
        end else if (gate_a) begin
            // Increment counter while gate_a is high
            s_counter <= s_counter + 1;
        end else if (gate_a_fall_s) begin
            // Store counter value and reset the counter when gate_a goes low
            cnt_clk_std_reg <= s_counter;
            s_counter <= 0;
        end
    end

endmodule

module COUNT_CLK_TEST( //counter for gate under test_clk
    input wire test_clk,  
    input wire gate_a,    
    input wire reset,
    input wire gate_a_fall_t,
    output reg [31:0] cnt_clk_test_reg,   
    output reg [31:0] t_counter
);
    always @(posedge test_clk or posedge reset) begin
         if(reset) begin
            t_counter <= 0;
            cnt_clk_test_reg <= 0;
        end else if (gate_a) begin
            // Increment counter while gate_a is high
            t_counter <= t_counter + 1;
        end else if (gate_a_fall_t) begin
            // Store counter value and reset the counter when gate_a goes low
            cnt_clk_test_reg <= t_counter;
            t_counter <= 0;
        end
    end

endmodule

module CALC_FLAG( //calculation flag after RISE_MAX is max
    input wire std_clk,
    input wire reset,
    input wire [28:0] counter,
    input wire [31:0] cnt_clk_test_reg,
    input wire [31:0] cnt_clk_std_reg,
    output reg calc_flag,
    output reg [63:0] freq_reg
    );
    
    always @(posedge std_clk or posedge reset) begin
        if (reset) begin
            calc_flag <= 0;
            freq_reg <= 0;
        end
        else if (counter == 29'h1AD2747F) begin //look for when counter hits max value to trigger flag
            calc_flag <= 1'b1;
            //Calculate frequency given counter values and standard clock frequency
            freq_reg <= (300000000 * cnt_clk_test_reg) / cnt_clk_std_reg;
        end else begin
            calc_flag <= 1'b0;
    end
end
endmodule

module CALC_FLAG_REG( //delayed calc flag for moving to register
    input wire std_clk,
    input wire reset,
    input wire calc_flag,
    output reg calc_flag_reg
    );
    
    always @(posedge std_clk or posedge reset) begin
        if (reset) begin
            calc_flag_reg <= 0;
        end else begin
            calc_flag_reg <= calc_flag;
    end
end
endmodule

module GET_FREQ( //output frequency calculation if flag is high
    input wire std_clk,
    input wire reset,
    input wire calc_flag_reg,
    input wire [63:0] freq_reg,
    output reg [63:0] freq
    );
    
    always @(posedge std_clk or posedge reset) begin
        if (reset) begin
            freq <= 0;
        end else if (calc_flag_reg)begin
            freq <= freq_reg;
    end
end
endmodule

module PROBE( //module to instantiate ILA probe
    input wire sys_clk,
    input wire [63:0] freq
    );
    
    ila_0 your_instance_name (
	.clk(sys_clk), // input wire clk


	.probe0(freq) // input wire [63:0] probe0
    );
    
endmodule
