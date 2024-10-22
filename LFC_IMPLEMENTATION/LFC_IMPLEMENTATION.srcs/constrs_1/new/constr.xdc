set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { sys_clk }]; #IO_L13P_T2_MRCC_35 Sch=sysclk
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { sys_clk }];

##Switches
set_property -dict { PACKAGE_PIN M20   IOSTANDARD LVCMOS33 } [get_ports { reset }]; #IO_L7N_T1_AD2N_35 Sch=sw[0]

##Raspberry Digital I/O 
set_property -dict { PACKAGE_PIN A20   IOSTANDARD LVCMOS33 } [get_ports { test_clk }]; #IO_L2N_T0_AD8N_35 Sch=rpio_20_r
set_property -dict { PACKAGE_PIN W9    IOSTANDARD LVCMOS33 } [get_ports { std_clk }]; #IO_L16N_T2_13 Sch=rpio_26_r