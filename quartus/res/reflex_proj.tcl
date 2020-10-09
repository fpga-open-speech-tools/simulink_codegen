# -------------------------------------------------------------------------- #
#
# Copyright (C) 2018  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License 
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel FPGA IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Intel and sold by Intel or its authorized distributors.  Please
# refer to the applicable agreement for further details.
#
# -------------------------------------------------------------------------- #
#
# Quartus Prime
# Version 18.0.0 Build 614 04/24/2018 SJ Standard Edition
# Date created = 12:18:12  April 19, 2019
#
# -------------------------------------------------------------------------- #
#
# Notes:
#
# 1) The default values for assignments are stored in the file:
#		A10SoM_System_assignment_defaults.qdf
#    If this file doesn't exist, see file:
#		assignment_defaults.qdf
#
# 2) Altera recommends that you do not modify this file. This
#    file is updated automatically by the Quartus Prime software
#    and any changes you make may be lost or overwritten.
#
# -------------------------------------------------------------------------- #


# -------------------------------------------------------------------------- #
#
# Copyright (C) 2018  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License 
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel FPGA IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Intel and sold by Intel or its authorized distributors.  Please
# refer to the applicable agreement for further details.
#
# -------------------------------------------------------------------------- #
#
# Quartus Prime
# Version 18.0.0 Build 614 04/24/2018 SJ Standard Edition
# Date created = 13:48:42  July 16, 2018
#
# -------------------------------------------------------------------------- #
#
# Notes:
#
# 1) The default values for assignments are stored in the file:
#		A10_System_assignment_defaults.qdf
#    If this file doesn't exist, see file:
#		assignment_defaults.qdf
#
# 2) Altera recommends that you do not modify this file. This
#    file is updated automatically by the Quartus Prime software
#    and any changes you make may be lost or overwritten.
#
# -------------------------------------------------------------------------- #


set_global_assignment -name FAMILY "Arria 10"
set_global_assignment -name DEVICE 10AS066H2F34I1SG
set_global_assignment -name TOP_LEVEL_ENTITY A10SoM_System
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 4
set_global_assignment -name MIN_CORE_JUNCTION_TEMP "-40"
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100
set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
set_global_assignment -name VHDL_INPUT_VERSION VHDL_2008
set_global_assignment -name VHDL_SHOW_LMF_MAPPING_MESSAGES OFF
set_location_assignment PIN_R9 -to AD1939_ADC_ALRCLK
set_location_assignment PIN_T10 -to AD1939_ADC_ASDATA1
set_location_assignment PIN_U10 -to AD1939_ADC_ASDATA2
set_location_assignment PIN_U8 -to AD1939_DAC_DLRCLK
set_location_assignment PIN_AH19 -to AD1939_DAC_DSDATA1
set_location_assignment PIN_AJ15 -to AD1939_DAC_DSDATA2
set_location_assignment PIN_AH18 -to AD1939_DAC_DSDATA3
set_location_assignment PIN_AG18 -to AD1939_DAC_DSDATA4
set_location_assignment PIN_AF18 -to AD1939_RESET_n
set_location_assignment PIN_L8 -to AD1939_spi_CCLK
set_location_assignment PIN_V8 -to AD1939_spi_CIN
set_location_assignment PIN_V9 -to AD1939_spi_CLATCH_n
set_location_assignment PIN_R7 -to AD1939_spi_COUT
set_location_assignment PIN_AG16 -to INMP621_mic_CLK
set_location_assignment PIN_AF16 -to INMP621_mic_DATA
set_location_assignment PIN_T5 -to TPA6130_power_off
set_location_assignment PIN_D15 -to hps_io_phery_sdmmc_CCLK
set_location_assignment PIN_C17 -to hps_io_phery_sdmmc_CMD
set_location_assignment PIN_B15 -to hps_io_phery_sdmmc_D0
set_location_assignment PIN_B17 -to hps_io_phery_sdmmc_D1
set_location_assignment PIN_D16 -to hps_io_phery_sdmmc_D2
set_location_assignment PIN_A16 -to hps_io_phery_sdmmc_D3
set_location_assignment PIN_G16 -to hps_io_phery_sdmmc_D4
set_location_assignment PIN_A15 -to hps_io_phery_sdmmc_D5
set_location_assignment PIN_C15 -to hps_io_phery_sdmmc_D6
set_location_assignment PIN_F16 -to hps_io_phery_sdmmc_D7
set_location_assignment PIN_L19 -to hps_io_phery_emac1_MDC
set_location_assignment PIN_K19 -to hps_io_phery_emac1_MDIO
set_location_assignment PIN_G20 -to hps_io_phery_emac1_RX_CLK
set_location_assignment PIN_F20 -to hps_io_phery_emac1_RX_CTL
set_location_assignment PIN_F19 -to hps_io_phery_emac1_RXD0
set_location_assignment PIN_E19 -to hps_io_phery_emac1_RXD1
set_location_assignment PIN_C20 -to hps_io_phery_emac1_RXD2
set_location_assignment PIN_D20 -to hps_io_phery_emac1_RXD3
set_location_assignment PIN_E17 -to hps_io_phery_emac1_TX_CLK
set_location_assignment PIN_E18 -to hps_io_phery_emac1_TX_CTL
set_location_assignment PIN_E21 -to hps_io_phery_emac1_TXD0
set_location_assignment PIN_D21 -to hps_io_phery_emac1_TXD1
set_location_assignment PIN_D22 -to hps_io_phery_emac1_TXD2
set_location_assignment PIN_C22 -to hps_io_phery_emac1_TXD3
set_location_assignment PIN_J21 -to hps_io_phery_emac2_MDC
set_location_assignment PIN_K21 -to hps_io_phery_emac2_MDIO
set_location_assignment PIN_A18 -to hps_io_phery_emac2_RX_CLK
set_location_assignment PIN_B18 -to hps_io_phery_emac2_RX_CTL
set_location_assignment PIN_B22 -to hps_io_phery_emac2_RXD0
set_location_assignment PIN_A21 -to hps_io_phery_emac2_RXD1
set_location_assignment PIN_C19 -to hps_io_phery_emac2_RXD2
set_location_assignment PIN_D19 -to hps_io_phery_emac2_RXD3
set_location_assignment PIN_C18 -to hps_io_phery_emac2_TX_CLK
set_location_assignment PIN_D17 -to hps_io_phery_emac2_TX_CTL
set_location_assignment PIN_A19 -to hps_io_phery_emac2_TXD0
set_location_assignment PIN_A20 -to hps_io_phery_emac2_TXD1
set_location_assignment PIN_B21 -to hps_io_phery_emac2_TXD2
set_location_assignment PIN_B20 -to hps_io_phery_emac2_TXD3
set_location_assignment PIN_AE12 -to hps_good
set_location_assignment PIN_M17 -to hps_io_phery_uart0_CTS_N
set_location_assignment PIN_M18 -to hps_io_phery_uart0_RTS_N
set_location_assignment PIN_L18 -to hps_io_phery_uart0_RX
set_location_assignment PIN_K18 -to hps_io_phery_uart0_TX
set_location_assignment PIN_J20 -to hps_io_phery_usb1_CLK
set_location_assignment PIN_H17 -to hps_io_phery_usb1_DATA0
set_location_assignment PIN_G21 -to hps_io_phery_usb1_DATA1
set_location_assignment PIN_G18 -to hps_io_phery_usb1_DATA2
set_location_assignment PIN_H18 -to hps_io_phery_usb1_DATA3
set_location_assignment PIN_F18 -to hps_io_phery_usb1_DATA4
set_location_assignment PIN_G17 -to hps_io_phery_usb1_DATA5
set_location_assignment PIN_J19 -to hps_io_phery_usb1_DATA6
set_location_assignment PIN_H19 -to hps_io_phery_usb1_DATA7
set_location_assignment PIN_J17 -to hps_io_phery_usb1_DIR
set_location_assignment PIN_F21 -to hps_io_phery_usb1_NXT
set_location_assignment PIN_H20 -to hps_io_phery_usb1_STP
set_location_assignment PIN_A26 -to hps_rst
set_location_assignment PIN_AG1 -to TPA6130_i2c_SCL
set_location_assignment PIN_AK3 -to TPA6130_i2c_SDA
set_location_assignment PIN_H27 -to hps_ddr4_a[0]
set_location_assignment PIN_G27 -to hps_ddr4_a[1]
set_location_assignment PIN_G26 -to hps_ddr4_a[10]
set_location_assignment PIN_F26 -to hps_ddr4_a[11]
set_location_assignment PIN_F24 -to hps_ddr4_a[12]
set_location_assignment PIN_E27 -to hps_ddr4_a[13]
set_location_assignment PIN_D27 -to hps_ddr4_a[14]
set_location_assignment PIN_E22 -to hps_ddr4_a[15]
set_location_assignment PIN_F23 -to hps_ddr4_a[16]
set_location_assignment PIN_G23 -to hps_ddr4_a[2]
set_location_assignment PIN_G22 -to hps_ddr4_a[3]
set_location_assignment PIN_H25 -to hps_ddr4_a[4]
set_location_assignment PIN_G25 -to hps_ddr4_a[5]
set_location_assignment PIN_H24 -to hps_ddr4_a[6]
set_location_assignment PIN_H23 -to hps_ddr4_a[7]
set_location_assignment PIN_H22 -to hps_ddr4_a[8]
set_location_assignment PIN_J22 -to hps_ddr4_a[9]
set_location_assignment PIN_J24 -to hps_ddr4_act_n[0]
set_location_assignment PIN_AN20 -to hps_ddr4_alert_n[0]
set_location_assignment PIN_D26 -to hps_ddr4_ba[0]
set_location_assignment PIN_D25 -to hps_ddr4_ba[1]
set_location_assignment PIN_C25 -to hps_ddr4_bg[0]
set_location_assignment PIN_M24 -to hps_ddr4_bg[1]
set_location_assignment PIN_M23 -to hps_ddr4_ck_n[0]
set_location_assignment PIN_L23 -to hps_ddr4_ck[0]
set_location_assignment PIN_J27 -to hps_ddr4_cke[0]
set_location_assignment PIN_K24 -to hps_ddr4_cs_n[0]
set_location_assignment PIN_AP24 -to hps_ddr4_dbi_n[0]
set_location_assignment PIN_AE23 -to hps_ddr4_dbi_n[1]
set_location_assignment PIN_AM27 -to hps_ddr4_dbi_n[2]
set_location_assignment PIN_AD25 -to hps_ddr4_dbi_n[3]
set_location_assignment PIN_AP21 -to hps_ddr4_dq[0]
set_location_assignment PIN_AN24 -to hps_ddr4_dq[1]
set_location_assignment PIN_AK22 -to hps_ddr4_dq[10]
set_location_assignment PIN_AK24 -to hps_ddr4_dq[11]
set_location_assignment PIN_AF23 -to hps_ddr4_dq[12]
set_location_assignment PIN_AJ24 -to hps_ddr4_dq[13]
set_location_assignment PIN_AG23 -to hps_ddr4_dq[14]
set_location_assignment PIN_AL23 -to hps_ddr4_dq[15]
set_location_assignment PIN_AP26 -to hps_ddr4_dq[16]
set_location_assignment PIN_AL26 -to hps_ddr4_dq[17]
set_location_assignment PIN_AP27 -to hps_ddr4_dq[18]
set_location_assignment PIN_AK26 -to hps_ddr4_dq[19]
set_location_assignment PIN_AP22 -to hps_ddr4_dq[2]
set_location_assignment PIN_AP25 -to hps_ddr4_dq[20]
set_location_assignment PIN_AK27 -to hps_ddr4_dq[21]
set_location_assignment PIN_AN25 -to hps_ddr4_dq[22]
set_location_assignment PIN_AN27 -to hps_ddr4_dq[23]
set_location_assignment PIN_AJ27 -to hps_ddr4_dq[24]
set_location_assignment PIN_AD24 -to hps_ddr4_dq[25]
set_location_assignment PIN_AJ26 -to hps_ddr4_dq[26]
set_location_assignment PIN_AH27 -to hps_ddr4_dq[27]
set_location_assignment PIN_AJ25 -to hps_ddr4_dq[28]
set_location_assignment PIN_AE24 -to hps_ddr4_dq[29]
set_location_assignment PIN_AL24 -to hps_ddr4_dq[3]
set_location_assignment PIN_AH25 -to hps_ddr4_dq[30]
set_location_assignment PIN_AH26 -to hps_ddr4_dq[31]
set_location_assignment PIN_AP20 -to hps_ddr4_dq[4]
set_location_assignment PIN_AL25 -to hps_ddr4_dq[5]
set_location_assignment PIN_AM23 -to hps_ddr4_dq[6]
set_location_assignment PIN_AN23 -to hps_ddr4_dq[7]
set_location_assignment PIN_AK23 -to hps_ddr4_dq[8]
set_location_assignment PIN_AF24 -to hps_ddr4_dq[9]
set_location_assignment PIN_AN22 -to hps_ddr4_dqs_n[0]
set_location_assignment PIN_AH24 -to hps_ddr4_dqs_n[1]
set_location_assignment PIN_AM26 -to hps_ddr4_dqs_n[2]
set_location_assignment PIN_AF25 -to hps_ddr4_dqs_n[3]
set_location_assignment PIN_AM22 -to hps_ddr4_dqs[0]
set_location_assignment PIN_AH23 -to hps_ddr4_dqs[1]
set_location_assignment PIN_AM25 -to hps_ddr4_dqs[2]
set_location_assignment PIN_AG25 -to hps_ddr4_dqs[3]
set_location_assignment PIN_F25 -to hps_ddr4_oct_rzqin
set_location_assignment PIN_K25 -to hps_ddr4_odt[0]
set_location_assignment PIN_K22 -to hps_ddr4_par[0]
set_location_assignment PIN_AL27 -to hps_ddr4_pll_ref_clk
set_location_assignment PIN_L24 -to hps_ddr4_reset_n[0]
set_location_assignment PIN_R6 -to hpc_clk0_m2c
set_location_assignment PIN_W1 -to hpc_clk1_m2c
set_location_assignment PIN_G5 -to hpc_clk2_bidir
set_location_assignment PIN_D11 -to hpc_clk3_bidir
set_location_assignment PIN_J25 -to led_usr_g_n
set_location_assignment PIN_J26 -to led_usr_r_n
set_location_assignment PIN_AG7 -to lnk_f2m_dat
set_location_assignment PIN_AH7 -to lnk_m2f_dat
set_location_assignment PIN_AK8 -to lnk_m2f_rst
set_location_assignment PIN_AJ9 -to clk_25mhz_fpga

set_location_assignment PIN_M6 -to mic_array_sdi
set_location_assignment PIN_L6 -to mic_array_sdo
set_location_assignment PIN_L5 -to mic_array_sck
set_location_assignment PIN_M7 -to mic_array_led_ws
set_location_assignment PIN_M5 -to mic_array_led_sd


set_instance_assignment -name IO_STANDARD 1.8V -to mic_array_sck
set_instance_assignment -name IO_STANDARD 1.8V -to mic_array_ws
set_instance_assignment -name IO_STANDARD 1.8V -to mic_array_sd
set_instance_assignment -name IO_STANDARD 1.8V -to mic_array_led_ws
set_instance_assignment -name IO_STANDARD 1.8V -to mic_array_led_sd


set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT -section_id Top
set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
set_instance_assignment -name IO_STANDARD "1.8 V" -to AD1939_ADC_ALRCLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to AD1939_ADC_ASDATA1
set_instance_assignment -name IO_STANDARD "1.8 V" -to AD1939_ADC_ASDATA2
set_instance_assignment -name IO_STANDARD 1.8V -to AD1939_DAC_DLRCLK
set_instance_assignment -name IO_STANDARD 1.8V -to AD1939_DAC_DSDATA1
set_instance_assignment -name IO_STANDARD 1.8V -to AD1939_DAC_DSDATA2
set_instance_assignment -name IO_STANDARD 1.8V -to AD1939_DAC_DSDATA3
set_instance_assignment -name IO_STANDARD 1.8V -to AD1939_DAC_DSDATA4
set_instance_assignment -name IO_STANDARD 1.8V -to AD1939_RESET_n
set_instance_assignment -name IO_STANDARD 1.8V -to AD1939_spi_CCLK
set_instance_assignment -name IO_STANDARD 1.8V -to AD1939_spi_CIN
set_instance_assignment -name IO_STANDARD 1.8V -to AD1939_spi_CLATCH_n
set_instance_assignment -name IO_STANDARD 1.8V -to AD1939_spi_COUT
set_instance_assignment -name IO_STANDARD 1.8V -to INMP621_mic_CLK
set_instance_assignment -name IO_STANDARD 1.8V -to INMP621_mic_DATA
set_instance_assignment -name IO_STANDARD 1.8V -to TPA6130_power_off
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_sdmmc_CCLK
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_sdmmc_CMD
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_sdmmc_D0
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_sdmmc_D1
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_sdmmc_D2
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_sdmmc_D3
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_sdmmc_D4
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_sdmmc_D5
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_sdmmc_D6
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_sdmmc_D7
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac1_MDC
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac1_MDIO
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac1_RX_CLK
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac1_RX_CTL
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac1_RXD0
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac1_RXD1
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac1_RXD2
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac1_RXD3
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac1_TX_CLK
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac1_TX_CTL
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac1_TXD0
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac1_TXD1
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac1_TXD2
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac1_TXD3
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac2_MDC
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac2_MDIO
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac2_RX_CLK
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac2_RX_CTL
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac2_RXD0
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac2_RXD1
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac2_RXD2
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac2_RXD3
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac2_TX_CLK
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac2_TX_CTL
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac2_TXD0
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac2_TXD1
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac2_TXD2
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_emac2_TXD3
set_instance_assignment -name IO_STANDARD 1.2V -to hps_good
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_uart0_CTS_N
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_uart0_RTS_N
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_uart0_RX
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_uart0_TX
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_usb1_CLK
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_usb1_DATA0
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_usb1_DATA1
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_usb1_DATA2
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_usb1_DATA3
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_usb1_DATA4
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_usb1_DATA5
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_usb1_DATA6
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_usb1_DATA7
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_usb1_DIR
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_usb1_NXT
set_instance_assignment -name IO_STANDARD 1.8V -to hps_io_phery_usb1_STP
set_instance_assignment -name IO_STANDARD 1.2V -to hps_rst
set_instance_assignment -name IO_STANDARD "1.8 V" -to TPA6130_i2c_SCL
set_instance_assignment -name IO_STANDARD "1.8 V" -to TPA6130_i2c_SDA
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_a[0]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_a[1]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_a[10]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_a[11]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_a[12]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_a[13]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_a[14]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_a[15]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_a[16]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_a[2]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_a[3]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_a[4]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_a[5]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_a[6]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_a[7]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_a[8]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_a[9]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_act_n[0]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_alert_n[0]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_ba[0]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_ba[1]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_bg[0]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_bg[1]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V SSTL" -to hps_ddr4_ck_n[0]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V SSTL" -to hps_ddr4_ck[0]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_cke[0]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_cs_n[0]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dbi_n[0]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dbi_n[1]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dbi_n[2]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dbi_n[3]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[0]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[1]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[10]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[11]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[12]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[13]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[14]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[15]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[16]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[17]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[18]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[19]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[2]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[20]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[21]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[22]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[23]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[24]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[25]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[26]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[27]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[28]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[29]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[3]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[30]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[31]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[4]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[5]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[6]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[7]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[8]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_ddr4_dq[9]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to hps_ddr4_dqs_n[0]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to hps_ddr4_dqs_n[1]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to hps_ddr4_dqs_n[2]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to hps_ddr4_dqs_n[3]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to hps_ddr4_dqs[0]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to hps_ddr4_dqs[1]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to hps_ddr4_dqs[2]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to hps_ddr4_dqs[3]
set_instance_assignment -name IO_STANDARD 1.2V -to hps_ddr4_oct_rzqin
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_odt[0]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_ddr4_par[0]
set_instance_assignment -name IO_STANDARD 1.2V -to hps_ddr4_pll_ref_clk
set_instance_assignment -name IO_STANDARD 1.2V -to hps_ddr4_reset_n[0]
set_instance_assignment -name IO_STANDARD LVDS -to hpc_clk0_m2c
set_instance_assignment -name IO_STANDARD LVDS -to hpc_clk1_m2c
set_instance_assignment -name IO_STANDARD LVDS -to hpc_clk2_bidir
set_instance_assignment -name IO_STANDARD LVDS -to hpc_clk3_bidir
set_instance_assignment -name IO_STANDARD 1.2V -to led_usr_g_n
set_instance_assignment -name IO_STANDARD 1.2V -to led_usr_r_n
set_instance_assignment -name IO_STANDARD 1.2V -to lnk_f2m_dat
set_instance_assignment -name IO_STANDARD 1.2V -to lnk_m2f_dat
set_instance_assignment -name IO_STANDARD 1.2V -to lnk_m2f_rst
set_instance_assignment -name IO_STANDARD 1.2V -to clk_25mhz_fpga
set_location_assignment PIN_AL15 -to AD1939_ADC_ABCLK
set_location_assignment PIN_AM15 -to AD1939_DAC_DBCLK
set_location_assignment PIN_AD11 -to AD1939_MCLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to AD1939_ADC_ABCLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to AD1939_DAC_DBCLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to AD1939_MCLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to PREAMP_CS
set_location_assignment PIN_M8 -to PREAMP_CS
set_global_assignment -name SDC_FILE A10SoM_System.sdc
set_global_assignment -name QSYS_FILE mw_ip/pll_sys.qsys
set_global_assignment -name QIP_FILE mw_ip/mw_ip.qip
set_global_assignment -name QIP_FILE jlf/pkg_jlf.qip
set_global_assignment -name QIP_FILE jlf/buffer2ck.qip
set_global_assignment -name QIP_FILE common/common.qip
set_global_assignment -name QSYS_FILE soc_system.qsys
set_global_assignment -name VHDL_FILE A10SoM_System.vhd
set_global_assignment -name PROJECT_IP_REGENERATION_POLICY NEVER_REGENERATE_IP
set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top