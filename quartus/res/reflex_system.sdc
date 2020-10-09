## Generated SDC file "A10SoM_System.out.sdc"

## Copyright (C) 2018  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 18.0.0 Build 614 04/24/2018 SJ Standard Edition"

## DATE    "Wed May 22 11:50:50 2019"

##
## DEVICE  "10AS066H2F34I1SG"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 33.333 -waveform { 0.000 16.666 } [get_ports {altera_reserved_tck}]
create_clock -name {u0|ddr4_ref_clock} -period 6.672 -waveform { 0.000 3.336 } [get_ports {hps_ddr4_pll_ref_clk}]
create_clock -name {hps_ddr4_dqs[0]_IN} -period 0.832 -waveform { 0.000 0.417 } [get_ports {hps_ddr4_dqs[0]}]
create_clock -name {hps_ddr4_dqs[1]_IN} -period 0.832 -waveform { 0.000 0.417 } [get_ports {hps_ddr4_dqs[1]}]
create_clock -name {hps_ddr4_dqs[2]_IN} -period 0.832 -waveform { 0.000 0.417 } [get_ports {hps_ddr4_dqs[2]}]
create_clock -name {hps_ddr4_dqs[3]_IN} -period 0.832 -waveform { 0.000 0.417 } [get_ports {hps_ddr4_dqs[3]}]
create_clock -name {hps_spim1_sclk_out} -period 1000.000 -waveform { 0.000 500.000 } [get_nodes {*spim_1_clk}]
create_clock -name {hps_i2c_internal} -period 2500.000 -waveform { 0.000 1250.000 } [get_registers {*~l4_sp_clk.reg}]

# HPS  Clocks
create_clock -period "25.0 MHz"  [get_ports {clk_25mhz_fpga}]

# AD1939 Clocks
# Note the period of a 12.288 MHz clock is 81.380208333333329
create_clock -period "12.288 MHz" [get_ports AD1939_MCLK]
create_clock -period "12.288 MHz" [get_ports AD1939_ADC_ABCLK] 
create_clock -period  "0.192 MHz" [get_ports AD1939_ADC_ALRCLK]

#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {u0|ddr4_vco_clk_0} -source [get_ports {hps_ddr4_pll_ref_clk}] -multiply_by 8 -master_clock {u0|ddr4_ref_clock} [get_nets {u0|ddr4|arch|arch_inst|pll_inst|pll_vcoph[0]}] 
create_generated_clock -name {u0|ddr4_vco_clk_1} -source [get_ports {hps_ddr4_pll_ref_clk}] -multiply_by 8 -master_clock {u0|ddr4_ref_clock} [get_nets {u0|ddr4|arch|arch_inst|pll_inst|pll_inst~_DuplicateVCOPH0}] 
create_generated_clock -name {u0|ddr4_phy_clk_0} -source [get_nets {u0|ddr4|arch|arch_inst|pll_inst|pll_vcoph[0]}] -divide_by 2 -phase 22.500 -master_clock {u0|ddr4_vco_clk_0} [get_nets {u0|ddr4|arch|arch_inst|pll_inst|pll_loaden[0]}] 
create_generated_clock -name {u0|ddr4_phy_clk_1} -source [get_nets {u0|ddr4|arch|arch_inst|pll_inst|pll_inst~_DuplicateVCOPH0}] -divide_by 2 -phase 22.500 -master_clock {u0|ddr4_vco_clk_1} [get_nets {u0|ddr4|arch|arch_inst|pll_inst|pll_inst~_DuplicateLOADEN0}] 
create_generated_clock -name {u0|ddr4_phy_clk_l_0} -source [get_nets {u0|ddr4|arch|arch_inst|pll_inst|pll_vcoph[0]}] -divide_by 2 -phase 22.500 -master_clock {u0|ddr4_vco_clk_0} [get_nets {u0|ddr4|arch|arch_inst|pll_inst|pll_lvds_clk[0]}] 
create_generated_clock -name {u0|ddr4_phy_clk_l_1} -source [get_nets {u0|ddr4|arch|arch_inst|pll_inst|pll_inst~_DuplicateVCOPH0}] -divide_by 2 -phase 22.500 -master_clock {u0|ddr4_vco_clk_1} [get_nets {u0|ddr4|arch|arch_inst|pll_inst|pll_inst~_DuplicateLVDS_CLK0}] 
create_generated_clock -name {u0|ddr4_wf_clk_0} -source [get_pins {u0|ddr4|arch|arch_inst|pll_inst|pll_inst|vcoph[0]}] -master_clock {u0|ddr4_vco_clk_0} [get_registers {soc_system:u0|soc_system_altera_emif_a10_hps_180_oqueytq:ddr4|soc_system_altera_emif_arch_nf_180_hlqzivq:arch|soc_system_altera_emif_arch_nf_180_hlqzivq_top:arch_inst|altera_emif_arch_nf_io_tiles_wrap:io_tiles_wrap_inst|altera_emif_arch_nf_io_tiles:io_tiles_inst|tile_gen[0].lane_gen[0].lane_inst~out_phy_reg}] 
create_generated_clock -name {u0|ddr4_wf_clk_1} -source [get_pins {u0|ddr4|arch|arch_inst|pll_inst|pll_inst|vcoph[0]}] -master_clock {u0|ddr4_vco_clk_0} [get_registers {soc_system:u0|soc_system_altera_emif_a10_hps_180_oqueytq:ddr4|soc_system_altera_emif_arch_nf_180_hlqzivq:arch|soc_system_altera_emif_arch_nf_180_hlqzivq_top:arch_inst|altera_emif_arch_nf_io_tiles_wrap:io_tiles_wrap_inst|altera_emif_arch_nf_io_tiles:io_tiles_inst|tile_gen[0].lane_gen[2].lane_inst~out_phy_reg}] 
create_generated_clock -name {u0|ddr4_wf_clk_2} -source [get_pins {u0|ddr4|arch|arch_inst|pll_inst|pll_inst|vcoph[0]}] -master_clock {u0|ddr4_vco_clk_0} [get_registers {soc_system:u0|soc_system_altera_emif_a10_hps_180_oqueytq:ddr4|soc_system_altera_emif_arch_nf_180_hlqzivq:arch|soc_system_altera_emif_arch_nf_180_hlqzivq_top:arch_inst|altera_emif_arch_nf_io_tiles_wrap:io_tiles_wrap_inst|altera_emif_arch_nf_io_tiles:io_tiles_inst|tile_gen[0].lane_gen[1].lane_inst~out_phy_reg}] 
create_generated_clock -name {u0|ddr4_wf_clk_3} -source [get_pins {u0|ddr4|arch|arch_inst|pll_inst|pll_inst~_Duplicate|vcoph[0]}] -master_clock {u0|ddr4_vco_clk_1} [get_registers {soc_system:u0|soc_system_altera_emif_a10_hps_180_oqueytq:ddr4|soc_system_altera_emif_arch_nf_180_hlqzivq:arch|soc_system_altera_emif_arch_nf_180_hlqzivq_top:arch_inst|altera_emif_arch_nf_io_tiles_wrap:io_tiles_wrap_inst|altera_emif_arch_nf_io_tiles:io_tiles_inst|tile_gen[1].lane_gen[0].lane_inst~out_phy_reg}] 
create_generated_clock -name {u0|ddr4_wf_clk_4} -source [get_pins {u0|ddr4|arch|arch_inst|pll_inst|pll_inst~_Duplicate|vcoph[0]}] -master_clock {u0|ddr4_vco_clk_1} [get_registers {soc_system:u0|soc_system_altera_emif_a10_hps_180_oqueytq:ddr4|soc_system_altera_emif_arch_nf_180_hlqzivq:arch|soc_system_altera_emif_arch_nf_180_hlqzivq_top:arch_inst|altera_emif_arch_nf_io_tiles_wrap:io_tiles_wrap_inst|altera_emif_arch_nf_io_tiles:io_tiles_inst|tile_gen[1].lane_gen[1].lane_inst~out_phy_reg}] 
create_generated_clock -name {u0|ddr4_wf_clk_5} -source [get_pins {u0|ddr4|arch|arch_inst|pll_inst|pll_inst~_Duplicate|vcoph[0]}] -master_clock {u0|ddr4_vco_clk_1} [get_registers {soc_system:u0|soc_system_altera_emif_a10_hps_180_oqueytq:ddr4|soc_system_altera_emif_arch_nf_180_hlqzivq:arch|soc_system_altera_emif_arch_nf_180_hlqzivq_top:arch_inst|altera_emif_arch_nf_io_tiles_wrap:io_tiles_wrap_inst|altera_emif_arch_nf_io_tiles:io_tiles_inst|tile_gen[1].lane_gen[2].lane_inst~out_phy_reg}] 
create_generated_clock -name {u0|ddr4_wf_clk_6} -source [get_pins {u0|ddr4|arch|arch_inst|pll_inst|pll_inst~_Duplicate|vcoph[0]}] -master_clock {u0|ddr4_vco_clk_1} [get_registers {soc_system:u0|soc_system_altera_emif_a10_hps_180_oqueytq:ddr4|soc_system_altera_emif_arch_nf_180_hlqzivq:arch|soc_system_altera_emif_arch_nf_180_hlqzivq_top:arch_inst|altera_emif_arch_nf_io_tiles_wrap:io_tiles_wrap_inst|altera_emif_arch_nf_io_tiles:io_tiles_inst|tile_gen[1].lane_gen[3].lane_inst~out_phy_reg}] 


#**************************************************************
# Set Clock Latency
#**************************************************************


#**************************************************************
# Set Clock Uncertainty
#**************************************************************

derive_clock_uncertainty


#**************************************************************
# Set Input Delay
#**************************************************************

# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_alert_n[0]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dbi_n[0]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dbi_n[1]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dbi_n[2]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dbi_n[3]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[0]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[1]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[2]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[3]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[4]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[5]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[6]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[7]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[8]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[9]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[10]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[11]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[12]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[13]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[14]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[15]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[16]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[17]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[18]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[19]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[20]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[21]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[22]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[23]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[24]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[25]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[26]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[27]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[28]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[29]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[30]}]
# set_input_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[31]}]


#**************************************************************
# Set Output Delay
#**************************************************************

# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_a[0]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_a[1]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_a[2]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_a[3]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_a[4]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_a[5]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_a[6]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_a[7]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_a[8]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_a[9]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_a[10]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_a[11]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_a[12]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_a[13]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_a[14]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_a[15]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_a[16]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_act_n[0]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_ba[0]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_ba[1]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_bg[0]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_bg[1]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_ck[0]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_ck_n[0]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_cke[0]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_cs_n[0]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dbi_n[0]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dbi_n[1]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dbi_n[2]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dbi_n[3]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[0]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[1]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[2]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[3]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[4]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[5]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[6]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[7]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[8]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[9]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[10]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[11]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[12]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[13]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[14]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[15]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[16]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[17]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[18]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[19]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[20]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[21]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[22]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[23]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[24]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[25]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[26]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[27]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[28]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[29]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[30]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dq[31]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dqs[0]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dqs[1]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dqs[2]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dqs[3]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dqs_n[0]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dqs_n[1]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dqs_n[2]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_dqs_n[3]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_odt[0]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_par[0]}]
# set_output_delay -add_delay  -clock [get_clocks {u0|ddr4_ref_clock}]  0.000 [get_ports {hps_ddr4_reset_n[0]}]


#**************************************************************
# Set Clock Groups
#**************************************************************

# set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous \
						-group { AD1939_MCLK \
						         AD1939_ADC_ABCLK \
						         AD1939_ADC_ALRCLK \
						       } \
						-group { clk_25mhz_fpga } 

#**************************************************************
# Set False Path
#**************************************************************

set_false_path -to [get_keepers {*altera_std_synchronizer:*|din_s1}]
set_false_path -to [get_pins -nocase -compatibility_mode {*|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*|clrn}]
set_false_path -from [get_registers {*altera_jtag_src_crosser:*|sink_data_buffer*}] -to [get_registers {*altera_jtag_src_crosser:*|src_data*}]
set_false_path -to [get_keepers {{hps_ddr4_a[0]} {hps_ddr4_a[1]} {hps_ddr4_a[2]} {hps_ddr4_a[3]} {hps_ddr4_a[4]} {hps_ddr4_a[5]} {hps_ddr4_a[6]} {hps_ddr4_a[7]} {hps_ddr4_a[8]} {hps_ddr4_a[9]} {hps_ddr4_a[10]} {hps_ddr4_a[11]} {hps_ddr4_a[12]} {hps_ddr4_a[13]} {hps_ddr4_a[14]} {hps_ddr4_a[15]} {hps_ddr4_a[16]} {hps_ddr4_act_n[0]} {hps_ddr4_ba[0]} {hps_ddr4_ba[1]} {hps_ddr4_bg[0]} {hps_ddr4_bg[1]} {hps_ddr4_cke[0]} {hps_ddr4_cs_n[0]} {hps_ddr4_odt[0]} {hps_ddr4_par[0]}}]
set_false_path -to [get_keepers {{hps_ddr4_dq[0]} {hps_ddr4_dq[1]} {hps_ddr4_dq[2]} {hps_ddr4_dq[3]} {hps_ddr4_dq[4]} {hps_ddr4_dq[5]} {hps_ddr4_dq[6]} {hps_ddr4_dq[7]} {hps_ddr4_dq[8]} {hps_ddr4_dq[9]} {hps_ddr4_dq[10]} {hps_ddr4_dq[11]} {hps_ddr4_dq[12]} {hps_ddr4_dq[13]} {hps_ddr4_dq[14]} {hps_ddr4_dq[15]} {hps_ddr4_dq[16]} {hps_ddr4_dq[17]} {hps_ddr4_dq[18]} {hps_ddr4_dq[19]} {hps_ddr4_dq[20]} {hps_ddr4_dq[21]} {hps_ddr4_dq[22]} {hps_ddr4_dq[23]} {hps_ddr4_dq[24]} {hps_ddr4_dq[25]} {hps_ddr4_dq[26]} {hps_ddr4_dq[27]} {hps_ddr4_dq[28]} {hps_ddr4_dq[29]} {hps_ddr4_dq[30]} {hps_ddr4_dq[31]}}]
set_false_path -from [get_keepers {{hps_ddr4_dq[0]} {hps_ddr4_dq[1]} {hps_ddr4_dq[2]} {hps_ddr4_dq[3]} {hps_ddr4_dq[4]} {hps_ddr4_dq[5]} {hps_ddr4_dq[6]} {hps_ddr4_dq[7]} {hps_ddr4_dq[8]} {hps_ddr4_dq[9]} {hps_ddr4_dq[10]} {hps_ddr4_dq[11]} {hps_ddr4_dq[12]} {hps_ddr4_dq[13]} {hps_ddr4_dq[14]} {hps_ddr4_dq[15]} {hps_ddr4_dq[16]} {hps_ddr4_dq[17]} {hps_ddr4_dq[18]} {hps_ddr4_dq[19]} {hps_ddr4_dq[20]} {hps_ddr4_dq[21]} {hps_ddr4_dq[22]} {hps_ddr4_dq[23]} {hps_ddr4_dq[24]} {hps_ddr4_dq[25]} {hps_ddr4_dq[26]} {hps_ddr4_dq[27]} {hps_ddr4_dq[28]} {hps_ddr4_dq[29]} {hps_ddr4_dq[30]} {hps_ddr4_dq[31]}}] 
set_false_path -to [get_keepers {{hps_ddr4_dbi_n[0]} {hps_ddr4_dbi_n[1]} {hps_ddr4_dbi_n[2]} {hps_ddr4_dbi_n[3]}}]
set_false_path -from [get_keepers {{hps_ddr4_dbi_n[0]} {hps_ddr4_dbi_n[1]} {hps_ddr4_dbi_n[2]} {hps_ddr4_dbi_n[3]}}] 
set_false_path -to [get_keepers {{hps_ddr4_dqs[0]} {hps_ddr4_dqs[1]} {hps_ddr4_dqs[2]} {hps_ddr4_dqs[3]}}]
set_false_path -to [get_keepers {{hps_ddr4_dqs_n[0]} {hps_ddr4_dqs_n[1]} {hps_ddr4_dqs_n[2]} {hps_ddr4_dqs_n[3]}}]
set_false_path -from [get_keepers {{hps_ddr4_dqs[0]} {hps_ddr4_dqs[1]} {hps_ddr4_dqs[2]} {hps_ddr4_dqs[3]}}] 
set_false_path -from [get_keepers {{hps_ddr4_dqs_n[0]} {hps_ddr4_dqs_n[1]} {hps_ddr4_dqs_n[2]} {hps_ddr4_dqs_n[3]}}] 
set_false_path -to [get_keepers {{hps_ddr4_ck[0]}}]
set_false_path -to [get_keepers {{hps_ddr4_ck_n[0]}}]
set_false_path -to [get_keepers {{hps_ddr4_reset_n[0]} {hps_ddr4_alert_n[0]}}]
set_false_path -from [get_keepers {{hps_ddr4_reset_n[0]} {hps_ddr4_alert_n[0]}}] 


#**************************************************************
# Set Multicycle Path
#**************************************************************

set_multicycle_path -setup -end -from [get_clocks *] -through [get_pins {u0|ddr4|arch|arch_inst|io_tiles_wrap_inst|io_tiles_inst|tile_gen[*].lane_gen[*].lane_inst|reset_n}]  -to [get_keepers {u0|ddr4|arch|arch_inst|io_tiles_wrap_inst|io_tiles_inst|tile_gen[*].lane_gen[*].lane_inst*}] 7
set_multicycle_path -hold -end -from [get_clocks *] -through [get_pins {u0|ddr4|arch|arch_inst|io_tiles_wrap_inst|io_tiles_inst|tile_gen[*].lane_gen[*].lane_inst|reset_n}]  -to [get_keepers {u0|ddr4|arch|arch_inst|io_tiles_wrap_inst|io_tiles_inst|tile_gen[*].lane_gen[*].lane_inst*}] 6
set_multicycle_path -setup -end -from [get_clocks *] -through [get_pins {u0|ddr4|arch|arch_inst|io_tiles_wrap_inst|io_tiles_inst|tile_gen[*].tile_ctrl_inst*|global_reset_n}]  -to [get_keepers {u0|ddr4|arch|arch_inst|io_tiles_wrap_inst|io_tiles_inst|tile_gen[*].tile_ctrl_inst*}] 7
set_multicycle_path -hold -end -from [get_clocks *] -through [get_pins {u0|ddr4|arch|arch_inst|io_tiles_wrap_inst|io_tiles_inst|tile_gen[*].tile_ctrl_inst*|global_reset_n}]  -to [get_keepers {u0|ddr4|arch|arch_inst|io_tiles_wrap_inst|io_tiles_inst|tile_gen[*].tile_ctrl_inst*}] 6
set_multicycle_path -setup -end -from [get_clocks *] -through [get_pins {u0|ddr4|arch|arch_inst|io_aux_inst|io_aux|core_usr_reset_n}]  -to [get_keepers {u0|ddr4|arch|arch_inst|io_aux_inst|io_aux*}] 7
set_multicycle_path -hold -end -from [get_clocks *] -through [get_pins {u0|ddr4|arch|arch_inst|io_aux_inst|io_aux|core_usr_reset_n}]  -to [get_keepers {u0|ddr4|arch|arch_inst|io_aux_inst|io_aux*}] 6

#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

