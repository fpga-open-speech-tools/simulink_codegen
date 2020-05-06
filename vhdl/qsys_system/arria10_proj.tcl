# -------------------------------------------------------------------------- #
#
# Copyright (C) 2018 Intel Corporation. All rights reserved.
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
# Intel and sold by Intel or its authorized distributors. Please
# refer to the applicable agreement for further details.
#
# -------------------------------------------------------------------------- #
#
# Quartus Prime
# Version 18.0.0 Build 614 04/24/2018 SJ Standard Edition
# Date created = 10:09:11 April 07, 2020
#
# -------------------------------------------------------------------------- #
#
# Notes:
#
# 1) The default values for assignments are stored in the file:
#		A10SoM_System_assignment_defaults.qdf
# If this file doesn't exist, see file:
#		assignment_defaults.qdf
#
# 2) Altera recommends that you do not modify this file. This
# file is updated automatically by the Quartus Prime software
# and any changes you make may be lost or overwritten.
#
# -------------------------------------------------------------------------- #


set_global_assignment -name FAMILY "Arria 10"
set_global_assignment -name DEVICE 10AS066H2F34I1HG
set_global_assignment -name TOP_LEVEL_ENTITY A10SoM_System
set_global_assignment -name ORIGINAL_QUARTUS_VERSION 18.0.0
set_global_assignment -name PROJECT_CREATION_TIME_DATE "10:09:11 APRIL 07, 2020"
set_global_assignment -name LAST_QUARTUS_VERSION "18.0.0 Standard Edition"
set_global_assignment -name MIN_CORE_JUNCTION_TEMP "-40"
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100

########################################################################################################################
# USB
########################################################################################################################
set_location_assignment PIN_AF10 -to usb_inout_pio11[0]
set_location_assignment PIN_AG10 -to usb_inout_pio11[1]

set_instance_assignment -name IO_STANDARD 1.8V -to usb_inout_pio11[0]
set_instance_assignment -name IO_STANDARD 1.8V -to usb_inout_pio11[1]


########################################################################################################################
# CLK
########################################################################################################################
set_location_assignment PIN_F6 -to clk_200
set_location_assignment PIN_F5 -to "clk_200(n)"
set_location_assignment PIN_E23 -to ddr_ref_clk_i
set_location_assignment PIN_E24 -to "ddr_ref_clk_i(n)"
set_location_assignment PIN_AD28 -to refclk_1C_p
set_location_assignment PIN_AD27 -to "refclk_1C_p(n)"
set_location_assignment PIN_Y28 -to refclk_1D_p
set_location_assignment PIN_Y27 -to "refclk_1D_p(n)"
set_location_assignment PIN_T28 -to refclk_1E_p
set_location_assignment PIN_T27 -to "refclk_1E_p(n)"
set_location_assignment PIN_M28 -to refclk_1F_p
set_location_assignment PIN_M27 -to "refclk_1F_p(n)"
set_location_assignment PIN_V28 -to sfp_refclk_1F_p
set_location_assignment PIN_V27 -to "sfp_refclk_1F_p(n)"

set_instance_assignment -name IO_STANDARD LVDS -to clk_200
set_instance_assignment -name IO_STANDARD LVDS -to "clk_200(n)"
set_instance_assignment -name IO_STANDARD LVDS -to ddr_ref_clk_i
set_instance_assignment -name IO_STANDARD LVDS -to "ddr_ref_clk_i(n)"
set_instance_assignment -name IO_STANDARD LVDS -to refclk_1C_p
set_instance_assignment -name IO_STANDARD LVDS -to "refclk_1C_p(n)"
set_instance_assignment -name IO_STANDARD LVDS -to refclk_1D_p
set_instance_assignment -name IO_STANDARD LVDS -to "refclk_1D_p(n)"
set_instance_assignment -name IO_STANDARD LVDS -to refclk_1E_p
set_instance_assignment -name IO_STANDARD LVDS -to "refclk_1E_p(n)"
set_instance_assignment -name IO_STANDARD LVDS -to refclk_1F_p
set_instance_assignment -name IO_STANDARD LVDS -to "refclk_1F_p(n)"
set_instance_assignment -name IO_STANDARD LVDS -to sfp_refclk_1F_p
set_instance_assignment -name IO_STANDARD LVDS -to "sfp_refclk_1F_p(n)"


########################################################################################################################
# HPS
########################################################################################################################
set_location_assignment PIN_L21 -to hps_i2c0_SCL
set_location_assignment PIN_M21 -to hps_i2c0_SDA

set_instance_assignment -name IO_STANDARD 1.8V -to hps_i2c0_SCL
set_instance_assignment -name IO_STANDARD 1.8V -to hps_i2c0_SDA

############################################################
# USB
############################################################
set_location_assignment PIN_J20 -to hps_usb1_CLK
set_location_assignment PIN_H17 -to hps_usb1_D0
set_location_assignment PIN_G21 -to hps_usb1_D1
set_location_assignment PIN_G18 -to hps_usb1_D2
set_location_assignment PIN_H18 -to hps_usb1_D3
set_location_assignment PIN_F18 -to hps_usb1_D4
set_location_assignment PIN_G17 -to hps_usb1_D5
set_location_assignment PIN_J19 -to hps_usb1_D6
set_location_assignment PIN_H19 -to hps_usb1_D7
set_location_assignment PIN_J17 -to hps_usb1_DIR
set_location_assignment PIN_F21 -to hps_usb1_NXT
set_location_assignment PIN_H20 -to hps_usb1_STP

set_instance_assignment -name IO_STANDARD 1.8V -to hps_usb1_CLK
set_instance_assignment -name IO_STANDARD 1.8V -to hps_usb1_D0
set_instance_assignment -name IO_STANDARD 1.8V -to hps_usb1_D1
set_instance_assignment -name IO_STANDARD 1.8V -to hps_usb1_D2
set_instance_assignment -name IO_STANDARD 1.8V -to hps_usb1_D3
set_instance_assignment -name IO_STANDARD 1.8V -to hps_usb1_D4
set_instance_assignment -name IO_STANDARD 1.8V -to hps_usb1_D5
set_instance_assignment -name IO_STANDARD 1.8V -to hps_usb1_D6
set_instance_assignment -name IO_STANDARD 1.8V -to hps_usb1_D7
set_instance_assignment -name IO_STANDARD 1.8V -to hps_usb1_DIR
set_instance_assignment -name IO_STANDARD 1.8V -to hps_usb1_NXT
set_instance_assignment -name IO_STANDARD 1.8V -to hps_usb1_STP

############################################################
# UART
############################################################
set_location_assignment PIN_H15 -to hps_uart1_RX
set_location_assignment PIN_F15 -to hps_uart1_TX

set_instance_assignment -name IO_STANDARD 1.8V -to hps_uart1_RX
set_instance_assignment -name IO_STANDARD 1.8V -to hps_uart1_TX

############################################################
# SDMMC
############################################################
set_location_assignment PIN_D15 -to hps_sdio_CLK
set_location_assignment PIN_C17 -to hps_sdio_CMD
set_location_assignment PIN_B15 -to hps_sdio_D0
set_location_assignment PIN_B17 -to hps_sdio_D1
set_location_assignment PIN_D16 -to hps_sdio_D2
set_location_assignment PIN_A16 -to hps_sdio_D3

set_instance_assignment -name IO_STANDARD 1.8V -to hps_sdio_CLK
set_instance_assignment -name IO_STANDARD 1.8V -to hps_sdio_CMD
set_instance_assignment -name IO_STANDARD 1.8V -to hps_sdio_D0
set_instance_assignment -name IO_STANDARD 1.8V -to hps_sdio_D1
set_instance_assignment -name IO_STANDARD 1.8V -to hps_sdio_D2
set_instance_assignment -name IO_STANDARD 1.8V -to hps_sdio_D3

############################################################
# IO
############################################################
set_location_assignment PIN_M17 -to hps_gpio_GPIO0
set_location_assignment PIN_M18 -to hps_gpio_GPIO1
set_location_assignment PIN_L20 -to hps_gpio_GPIO10
set_location_assignment PIN_M20 -to hps_gpio_GPIO11
set_location_assignment PIN_C18 -to hps_gpio_GPIO12
set_location_assignment PIN_D17 -to hps_gpio_GPIO13
set_location_assignment PIN_A18 -to hps_gpio_GPIO14
set_location_assignment PIN_B18 -to hps_gpio_GPIO15
set_location_assignment PIN_A19 -to hps_gpio_GPIO16
set_location_assignment PIN_A20 -to hps_gpio_GPIO17
set_location_assignment PIN_B22 -to hps_gpio_GPIO18
set_location_assignment PIN_A21 -to hps_gpio_GPIO19
set_location_assignment PIN_K18 -to hps_gpio_GPIO2
set_location_assignment PIN_B21 -to hps_gpio_GPIO20
set_location_assignment PIN_B20 -to hps_gpio_GPIO21
set_location_assignment PIN_C19 -to hps_gpio_GPIO22
set_location_assignment PIN_D19 -to hps_gpio_GPIO23
set_location_assignment PIN_L18 -to hps_gpio_GPIO3
set_location_assignment PIN_K21 -to hps_gpio_GPIO6
set_location_assignment PIN_J21 -to hps_gpio_GPIO7
set_location_assignment PIN_G15 -to hps_gpio2_GPIO6
set_location_assignment PIN_G16 -to hps_gpio2_GPIO8

set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio_GPIO0
set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio_GPIO1
set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio_GPIO10
set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio_GPIO11
set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio_GPIO12
set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio_GPIO13
set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio_GPIO14
set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio_GPIO15
set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio_GPIO16
set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio_GPIO17
set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio_GPIO18
set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio_GPIO19
set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio_GPIO2
set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio_GPIO20
set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio_GPIO21
set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio_GPIO22
set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio_GPIO23
set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio_GPIO3
set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio_GPIO6
set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio_GPIO7
set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio2_GPIO6
set_instance_assignment -name IO_STANDARD 1.8V -to hps_gpio2_GPIO8

############################################################
# MEMORY
############################################################
set_location_assignment PIN_AE23 -to hps_memory_mem_dbi_n[0]
set_location_assignment PIN_AP24 -to hps_memory_mem_dbi_n[1]
set_location_assignment PIN_AM27 -to hps_memory_mem_dbi_n[2]
set_location_assignment PIN_AD25 -to hps_memory_mem_dbi_n[3]
set_location_assignment PIN_C23 -to hps_memory_mem_dbi_n[4]
set_location_assignment PIN_AF24 -to hps_memory_mem_dq[0]
set_location_assignment PIN_AK24 -to hps_memory_mem_dq[1]
set_location_assignment PIN_AP21 -to hps_memory_mem_dq[10]
set_location_assignment PIN_AP22 -to hps_memory_mem_dq[11]
set_location_assignment PIN_AN23 -to hps_memory_mem_dq[12]
set_location_assignment PIN_AL25 -to hps_memory_mem_dq[13]
set_location_assignment PIN_AP20 -to hps_memory_mem_dq[14]
set_location_assignment PIN_AL24 -to hps_memory_mem_dq[15]
set_location_assignment PIN_AK26 -to hps_memory_mem_dq[16]
set_location_assignment PIN_AK27 -to hps_memory_mem_dq[17]
set_location_assignment PIN_AP25 -to hps_memory_mem_dq[18]
set_location_assignment PIN_AN25 -to hps_memory_mem_dq[19]
set_location_assignment PIN_AJ24 -to hps_memory_mem_dq[2]
set_location_assignment PIN_AL26 -to hps_memory_mem_dq[20]
set_location_assignment PIN_AP27 -to hps_memory_mem_dq[21]
set_location_assignment PIN_AP26 -to hps_memory_mem_dq[22]
set_location_assignment PIN_AN27 -to hps_memory_mem_dq[23]
set_location_assignment PIN_AE24 -to hps_memory_mem_dq[24]
set_location_assignment PIN_AH26 -to hps_memory_mem_dq[25]
set_location_assignment PIN_AJ26 -to hps_memory_mem_dq[26]
set_location_assignment PIN_AH25 -to hps_memory_mem_dq[27]
set_location_assignment PIN_AJ25 -to hps_memory_mem_dq[28]
set_location_assignment PIN_AH27 -to hps_memory_mem_dq[29]
set_location_assignment PIN_AK23 -to hps_memory_mem_dq[3]
set_location_assignment PIN_AD24 -to hps_memory_mem_dq[30]
set_location_assignment PIN_AJ27 -to hps_memory_mem_dq[31]
set_location_assignment PIN_B23 -to hps_memory_mem_dq[32]
set_location_assignment PIN_C27 -to hps_memory_mem_dq[33]
set_location_assignment PIN_B25 -to hps_memory_mem_dq[34]
set_location_assignment PIN_B27 -to hps_memory_mem_dq[35]
set_location_assignment PIN_A24 -to hps_memory_mem_dq[36]
set_location_assignment PIN_A25 -to hps_memory_mem_dq[37]
set_location_assignment PIN_A26 -to hps_memory_mem_dq[38]
set_location_assignment PIN_B26 -to hps_memory_mem_dq[39]
set_location_assignment PIN_AL23 -to hps_memory_mem_dq[4]
set_location_assignment PIN_AG23 -to hps_memory_mem_dq[5]
set_location_assignment PIN_AF23 -to hps_memory_mem_dq[6]
set_location_assignment PIN_AK22 -to hps_memory_mem_dq[7]
set_location_assignment PIN_AN24 -to hps_memory_mem_dq[8]
set_location_assignment PIN_AM23 -to hps_memory_mem_dq[9]
set_location_assignment PIN_AJ22 -to hps_memory_mem_alert_n
set_location_assignment PIN_L24 -to hps_memory_mem_reset_n
set_location_assignment PIN_F25 -to hps_memory_oct_rzqin
set_location_assignment PIN_AH24 -to hps_memory_mem_dqs_n[0]
set_location_assignment PIN_AN22 -to hps_memory_mem_dqs_n[1]
set_location_assignment PIN_AM26 -to hps_memory_mem_dqs_n[2]
set_location_assignment PIN_AF25 -to hps_memory_mem_dqs_n[3]
set_location_assignment PIN_D24 -to hps_memory_mem_dqs_n[4]
set_location_assignment PIN_AH23 -to hps_memory_mem_dqs[0]
set_location_assignment PIN_AM22 -to hps_memory_mem_dqs[1]
set_location_assignment PIN_AM25 -to hps_memory_mem_dqs[2]
set_location_assignment PIN_AG25 -to hps_memory_mem_dqs[3]
set_location_assignment PIN_C24 -to hps_memory_mem_dqs[4]
set_location_assignment PIN_L23 -to hps_memory_mem_ck
set_location_assignment PIN_M23 -to hps_memory_mem_ck_n
set_location_assignment PIN_H27 -to hps_memory_mem_a[0]
set_location_assignment PIN_G27 -to hps_memory_mem_a[1]
set_location_assignment PIN_G26 -to hps_memory_mem_a[10]
set_location_assignment PIN_F26 -to hps_memory_mem_a[11]
set_location_assignment PIN_F24 -to hps_memory_mem_a[12]
set_location_assignment PIN_E27 -to hps_memory_mem_a[13]
set_location_assignment PIN_D27 -to hps_memory_mem_a[14]
set_location_assignment PIN_E22 -to hps_memory_mem_a[15]
set_location_assignment PIN_F23 -to hps_memory_mem_a[16]
set_location_assignment PIN_G23 -to hps_memory_mem_a[2]
set_location_assignment PIN_G22 -to hps_memory_mem_a[3]
set_location_assignment PIN_H25 -to hps_memory_mem_a[4]
set_location_assignment PIN_G25 -to hps_memory_mem_a[5]
set_location_assignment PIN_H24 -to hps_memory_mem_a[6]
set_location_assignment PIN_H23 -to hps_memory_mem_a[7]
set_location_assignment PIN_H22 -to hps_memory_mem_a[8]
set_location_assignment PIN_J22 -to hps_memory_mem_a[9]
set_location_assignment PIN_J24 -to hps_memory_mem_act_n
set_location_assignment PIN_D26 -to hps_memory_mem_ba[0]
set_location_assignment PIN_D25 -to hps_memory_mem_ba[1]
set_location_assignment PIN_C25 -to hps_memory_mem_bg
set_location_assignment PIN_J27 -to hps_memory_mem_cke
set_location_assignment PIN_K24 -to hps_memory_mem_cs_n
set_location_assignment PIN_K25 -to hps_memory_mem_odt
set_location_assignment PIN_K22 -to hps_memory_mem_par

set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dbi_n[0]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dbi_n[1]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dbi_n[2]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dbi_n[3]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dbi_n[4]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[0]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[1]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[10]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[11]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[12]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[13]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[14]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[15]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[16]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[17]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[18]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[19]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[2]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[20]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[21]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[22]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[23]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[24]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[25]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[26]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[27]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[28]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[29]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[3]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[30]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[31]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[32]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[33]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[34]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[35]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[36]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[37]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[38]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[39]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[4]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[5]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[6]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[7]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[8]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to hps_memory_mem_dq[9]
set_instance_assignment -name IO_STANDARD 1.2V -to hps_memory_mem_alert_n
set_instance_assignment -name IO_STANDARD 1.2V -to hps_memory_mem_reset_n
set_instance_assignment -name IO_STANDARD 1.2V -to hps_memory_oct_rzqin
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to hps_memory_mem_dqs_n[0]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to hps_memory_mem_dqs_n[1]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to hps_memory_mem_dqs_n[2]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to hps_memory_mem_dqs_n[3]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to hps_memory_mem_dqs_n[4]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to hps_memory_mem_dqs[0]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to hps_memory_mem_dqs[1]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to hps_memory_mem_dqs[2]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to hps_memory_mem_dqs[3]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to hps_memory_mem_dqs[4]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V SSTL" -to hps_memory_mem_ck
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V SSTL" -to hps_memory_mem_ck_n
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_a[0]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_a[1]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_a[10]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_a[11]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_a[12]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_a[13]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_a[14]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_a[15]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_a[16]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_a[2]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_a[3]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_a[4]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_a[5]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_a[6]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_a[7]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_a[8]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_a[9]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_act_n
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_ba[0]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_ba[1]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_bg
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_cke
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_cs_n
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_odt
set_instance_assignment -name IO_STANDARD "SSTL-12" -to hps_memory_mem_par

############################################################
# ETHERNET
############################################################
set_location_assignment PIN_L19 -to hps_emac1_MDC
set_location_assignment PIN_K19 -to hps_emac1_MDIO
set_location_assignment PIN_G20 -to hps_emac1_RX_CLK
set_location_assignment PIN_F20 -to hps_emac1_RX_CTL
set_location_assignment PIN_F19 -to hps_emac1_RXD0
set_location_assignment PIN_E19 -to hps_emac1_RXD1
set_location_assignment PIN_C20 -to hps_emac1_RXD2
set_location_assignment PIN_D20 -to hps_emac1_RXD3
set_location_assignment PIN_E17 -to hps_emac1_TX_CLK
set_location_assignment PIN_E18 -to hps_emac1_TX_CTL
set_location_assignment PIN_E21 -to hps_emac1_TXD0
set_location_assignment PIN_D21 -to hps_emac1_TXD1
set_location_assignment PIN_D22 -to hps_emac1_TXD2
set_location_assignment PIN_C22 -to hps_emac1_TXD3

set_instance_assignment -name IO_STANDARD 1.8V -to hps_emac1_MDC
set_instance_assignment -name IO_STANDARD 1.8V -to hps_emac1_MDIO
set_instance_assignment -name IO_STANDARD 1.8V -to hps_emac1_RX_CLK
set_instance_assignment -name IO_STANDARD 1.8V -to hps_emac1_RX_CTL
set_instance_assignment -name IO_STANDARD 1.8V -to hps_emac1_RXD0
set_instance_assignment -name IO_STANDARD 1.8V -to hps_emac1_RXD1
set_instance_assignment -name IO_STANDARD 1.8V -to hps_emac1_RXD2
set_instance_assignment -name IO_STANDARD 1.8V -to hps_emac1_RXD3
set_instance_assignment -name IO_STANDARD 1.8V -to hps_emac1_TX_CLK
set_instance_assignment -name IO_STANDARD 1.8V -to hps_emac1_TX_CTL
set_instance_assignment -name IO_STANDARD 1.8V -to hps_emac1_TXD0
set_instance_assignment -name IO_STANDARD 1.8V -to hps_emac1_TXD1
set_instance_assignment -name IO_STANDARD 1.8V -to hps_emac1_TXD2
set_instance_assignment -name IO_STANDARD 1.8V -to hps_emac1_TXD3


########################################################################################################################
# MISC
########################################################################################################################
set_location_assignment PIN_J25 -to som_config_pio[0]
set_location_assignment PIN_J26 -to som_config_pio[1]
set_location_assignment PIN_K23 -to som_config_pio[2]
set_location_assignment PIN_A23 -to som_config_pio[3]
set_location_assignment PIN_AC24 -to som_config_pio[4]
set_location_assignment PIN_AC9 -to pmod1_inout_pio8[0]
set_location_assignment PIN_AB8 -to pmod1_inout_pio8[1]
set_location_assignment PIN_AC10 -to pmod1_inout_pio8[2]
set_location_assignment PIN_AB7 -to pmod1_inout_pio8[3]
set_location_assignment PIN_AG6 -to pmod1_inout_pio8[4]
set_location_assignment PIN_AE6 -to pmod1_inout_pio8[5]
set_location_assignment PIN_AF6 -to pmod1_inout_pio8[6]
set_location_assignment PIN_AE7 -to pmod1_inout_pio8[7]
set_location_assignment PIN_AF5 -to pmod2_inout_pio9[0]
set_location_assignment PIN_AC7 -to pmod2_inout_pio9[1]
set_location_assignment PIN_AG5 -to pmod2_inout_pio9[2]
set_location_assignment PIN_AD7 -to pmod2_inout_pio9[3]
set_location_assignment PIN_AD5 -to pmod2_inout_pio9[4]
set_location_assignment PIN_AK3 -to pmod2_inout_pio9[5]
set_location_assignment PIN_AD6 -to pmod2_inout_pio9[6]
set_location_assignment PIN_AK4 -to pmod2_inout_pio9[7]
set_location_assignment PIN_AN7 -to sys_reset_n_i
set_location_assignment PIN_J30 -to sfp_1F_rx_ch0
set_location_assignment PIN_J29 -to "sfp_1F_rx_ch0(n)"
set_location_assignment PIN_H32 -to sfp_1F_tx_ch0
set_location_assignment PIN_H31 -to "sfp_1F_tx_ch0(n)"

set_instance_assignment -name IO_STANDARD 1.2V -to som_config_pio[0]
set_instance_assignment -name IO_STANDARD 1.2V -to som_config_pio[1]
set_instance_assignment -name IO_STANDARD 1.2V -to som_config_pio[2]
set_instance_assignment -name IO_STANDARD 1.2V -to som_config_pio[3]
set_instance_assignment -name IO_STANDARD 1.2V -to som_config_pio[4]
set_instance_assignment -name IO_STANDARD 1.8V -to pmod1_inout_pio8[0]
set_instance_assignment -name IO_STANDARD 1.8V -to pmod1_inout_pio8[1]
set_instance_assignment -name IO_STANDARD 1.8V -to pmod1_inout_pio8[2]
set_instance_assignment -name IO_STANDARD 1.8V -to pmod1_inout_pio8[3]
set_instance_assignment -name IO_STANDARD 1.8V -to pmod1_inout_pio8[4]
set_instance_assignment -name IO_STANDARD 1.8V -to pmod1_inout_pio8[5]
set_instance_assignment -name IO_STANDARD 1.8V -to pmod1_inout_pio8[6]
set_instance_assignment -name IO_STANDARD 1.8V -to pmod1_inout_pio8[7]
set_instance_assignment -name IO_STANDARD 1.8V -to pmod2_inout_pio9[0]
set_instance_assignment -name IO_STANDARD 1.8V -to pmod2_inout_pio9[1]
set_instance_assignment -name IO_STANDARD 1.8V -to pmod2_inout_pio9[2]
set_instance_assignment -name IO_STANDARD 1.8V -to pmod2_inout_pio9[3]
set_instance_assignment -name IO_STANDARD 1.8V -to pmod2_inout_pio9[4]
set_instance_assignment -name IO_STANDARD 1.8V -to pmod2_inout_pio9[5]
set_instance_assignment -name IO_STANDARD 1.8V -to pmod2_inout_pio9[6]
set_instance_assignment -name IO_STANDARD 1.8V -to pmod2_inout_pio9[7]
set_instance_assignment -name IO_STANDARD 1.8V -to sys_reset_n_i
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to sfp_1F_rx_ch0
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "sfp_1F_rx_ch0(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to sfp_1F_tx_ch0
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "sfp_1F_tx_ch0(n)"


########################################################################################################################
# FMC2
########################################################################################################################
set_location_assignment PIN_AL1 -to fmc2_inout_pio6[0]
set_location_assignment PIN_AK1 -to fmc2_inout_pio6[1]
set_location_assignment PIN_AG1 -to fmc2_inout_pio6[10]
set_location_assignment PIN_AG2 -to fmc2_inout_pio6[11]
set_location_assignment PIN_AJ1 -to fmc2_inout_pio6[12]
set_location_assignment PIN_AH2 -to fmc2_inout_pio6[13]
set_location_assignment PIN_AL16 -to fmc2_inout_pio6[14]
set_location_assignment PIN_AM16 -to fmc2_inout_pio6[15]
set_location_assignment PIN_AJ5 -to fmc2_inout_pio6[16]
set_location_assignment PIN_AH5 -to fmc2_inout_pio6[17]
set_location_assignment PIN_AD10 -to fmc2_inout_pio6[18]
set_location_assignment PIN_AD11 -to fmc2_inout_pio6[19]
set_location_assignment PIN_AK2 -to fmc2_inout_pio6[2]
set_location_assignment PIN_AJ2 -to fmc2_inout_pio6[3]
set_location_assignment PIN_AM3 -to fmc2_inout_pio6[4]
set_location_assignment PIN_AL3 -to fmc2_inout_pio6[5]
set_location_assignment PIN_AC8 -to fmc2_inout_pio6[6]
set_location_assignment PIN_AD9 -to fmc2_inout_pio6[7]
set_location_assignment PIN_AE2 -to fmc2_inout_pio6[8]
set_location_assignment PIN_AE3 -to fmc2_inout_pio6[9]
set_location_assignment PIN_AF4 -to fmc2_inout_pio7[0]
set_location_assignment PIN_AF3 -to fmc2_inout_pio7[1]
set_location_assignment PIN_AH3 -to fmc2_inout_pio7[10]
set_location_assignment PIN_AG3 -to fmc2_inout_pio7[11]
set_location_assignment PIN_AB6 -to fmc2_inout_pio7[12]
set_location_assignment PIN_AB5 -to fmc2_inout_pio7[13]
set_location_assignment PIN_AB10 -to fmc2_inout_pio7[14]
set_location_assignment PIN_AB11 -to fmc2_inout_pio7[15]
set_location_assignment PIN_AD2 -to fmc2_inout_pio7[16]
set_location_assignment PIN_AD1 -to fmc2_inout_pio7[17]
set_location_assignment PIN_AH7 -to fmc2_inout_pio7[18]
set_location_assignment PIN_AG7 -to fmc2_inout_pio7[19]
set_location_assignment PIN_AE4 -to fmc2_inout_pio7[2]
set_location_assignment PIN_AD4 -to fmc2_inout_pio7[3]
set_location_assignment PIN_AF1 -to fmc2_inout_pio7[4]
set_location_assignment PIN_AE1 -to fmc2_inout_pio7[5]
set_location_assignment PIN_AC4 -to fmc2_inout_pio7[6]
set_location_assignment PIN_AC5 -to fmc2_inout_pio7[7]
set_location_assignment PIN_AH8 -to fmc2_inout_pio7[8]
set_location_assignment PIN_AG8 -to fmc2_inout_pio7[9]

set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio6[0]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio6[1]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio6[10]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio6[11]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio6[12]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio6[13]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio6[14]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio6[15]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio6[16]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio6[17]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio6[18]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio6[19]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio6[2]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio6[3]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio6[4]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio6[5]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio6[6]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio6[7]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio6[8]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio6[9]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio7[0]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio7[1]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio7[10]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio7[11]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio7[12]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio7[13]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio7[14]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio7[15]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio7[16]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio7[17]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio7[18]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio7[19]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio7[2]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio7[3]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio7[4]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio7[5]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio7[6]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio7[7]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio7[8]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc2_inout_pio7[9]


########################################################################################################################
# FMC1
########################################################################################################################
set_location_assignment PIN_Y1 -to fmc1_inout_pio1[0]
set_location_assignment PIN_Y2 -to fmc1_inout_pio1[1]
set_location_assignment PIN_Y6 -to fmc1_inout_pio1[10]
set_location_assignment PIN_Y7 -to fmc1_inout_pio1[11]
set_location_assignment PIN_U3 -to fmc1_inout_pio1[12]
set_location_assignment PIN_V3 -to fmc1_inout_pio1[13]
set_location_assignment PIN_R1 -to fmc1_inout_pio1[14]
set_location_assignment PIN_P1 -to fmc1_inout_pio1[15]
set_location_assignment PIN_T4 -to fmc1_inout_pio1[16]
set_location_assignment PIN_R4 -to fmc1_inout_pio1[17]
set_location_assignment PIN_AL5 -to fmc1_inout_pio1[18]
set_location_assignment PIN_AL4 -to fmc1_inout_pio1[19]
set_location_assignment PIN_V2 -to fmc1_inout_pio1[2]
set_location_assignment PIN_U2 -to fmc1_inout_pio1[3]
set_location_assignment PIN_Y8 -to fmc1_inout_pio1[4]
set_location_assignment PIN_Y9 -to fmc1_inout_pio1[5]
set_location_assignment PIN_AJ9 -to fmc1_inout_pio1[6]
set_location_assignment PIN_AK9 -to fmc1_inout_pio1[7]
set_location_assignment PIN_AF9 -to fmc1_inout_pio1[8]
set_location_assignment PIN_AE9 -to fmc1_inout_pio1[9]
set_location_assignment PIN_T3 -to fmc1_inout_pio2[0]
set_location_assignment PIN_R3 -to fmc1_inout_pio2[1]
set_location_assignment PIN_AN8 -to fmc1_inout_pio2[10]
set_location_assignment PIN_AE17 -to fmc1_inout_pio2[11]
set_location_assignment PIN_AH18 -to fmc1_inout_pio2[12]
set_location_assignment PIN_AH19 -to fmc1_inout_pio2[13]
set_location_assignment PIN_AF11 -to fmc1_inout_pio2[14]
set_location_assignment PIN_AG11 -to fmc1_inout_pio2[15]
set_location_assignment PIN_AK18 -to fmc1_inout_pio2[16]
set_location_assignment PIN_AL18 -to fmc1_inout_pio2[17]
set_location_assignment PIN_AG16 -to fmc1_inout_pio2[18]
set_location_assignment PIN_AF16 -to fmc1_inout_pio2[19]
set_location_assignment PIN_AF8 -to fmc1_inout_pio2[2]
set_location_assignment PIN_AE8 -to fmc1_inout_pio2[3]
set_location_assignment PIN_AM17 -to fmc1_inout_pio2[4]
set_location_assignment PIN_AN17 -to fmc1_inout_pio2[5]
set_location_assignment PIN_AJ15 -to fmc1_inout_pio2[6]
set_location_assignment PIN_AH15 -to fmc1_inout_pio2[7]
set_location_assignment PIN_AD19 -to fmc1_inout_pio2[8]
set_location_assignment PIN_AE18 -to fmc1_inout_pio2[9]
set_location_assignment PIN_AM7 -to fmc1_inout_pio3[0]
set_location_assignment PIN_W1 -to fmc1_inout_pio3[1]
set_location_assignment PIN_P5 -to fmc1_inout_pio3[10]
set_location_assignment PIN_Y3 -to fmc1_inout_pio3[11]
set_location_assignment PIN_Y4 -to fmc1_inout_pio3[12]
set_location_assignment PIN_T5 -to fmc1_inout_pio3[13]
set_location_assignment PIN_T6 -to fmc1_inout_pio3[14]
set_location_assignment PIN_AJ7 -to fmc1_inout_pio3[15]
set_location_assignment PIN_AJ6 -to fmc1_inout_pio3[16]
set_location_assignment PIN_AL6 -to fmc1_inout_pio3[17]
set_location_assignment PIN_AK6 -to fmc1_inout_pio3[18]
set_location_assignment PIN_AP7 -to fmc1_inout_pio3[19]
set_location_assignment PIN_W2 -to fmc1_inout_pio3[2]
set_location_assignment PIN_AA3 -to fmc1_inout_pio3[3]
set_location_assignment PIN_AA4 -to fmc1_inout_pio3[4]
set_location_assignment PIN_AA8 -to fmc1_inout_pio3[5]
set_location_assignment PIN_AA9 -to fmc1_inout_pio3[6]
set_location_assignment PIN_V5 -to fmc1_inout_pio3[7]
set_location_assignment PIN_V4 -to fmc1_inout_pio3[8]
set_location_assignment PIN_P4 -to fmc1_inout_pio3[9]
set_location_assignment PIN_AP6 -to fmc1_inout_pio4[0]
set_location_assignment PIN_AM1 -to fmc1_inout_pio4[1]
set_location_assignment PIN_R2 -to fmc1_inout_pio4[10]
set_location_assignment PIN_AB2 -to fmc1_inout_pio4[11]
set_location_assignment PIN_AB3 -to fmc1_inout_pio4[12]
set_location_assignment PIN_W6 -to fmc1_inout_pio4[13]
set_location_assignment PIN_W7 -to fmc1_inout_pio4[14]
set_location_assignment PIN_AA5 -to fmc1_inout_pio4[15]
set_location_assignment PIN_AA6 -to fmc1_inout_pio4[16]
set_location_assignment PIN_AK7 -to fmc1_inout_pio4[17]
set_location_assignment PIN_AK8 -to fmc1_inout_pio4[18]
set_location_assignment PIN_AP5 -to fmc1_inout_pio4[19]
set_location_assignment PIN_AM2 -to fmc1_inout_pio4[2]
set_location_assignment PIN_AC3 -to fmc1_inout_pio4[3]
set_location_assignment PIN_AC2 -to fmc1_inout_pio4[4]
set_location_assignment PIN_AB1 -to fmc1_inout_pio4[5]
set_location_assignment PIN_AA1 -to fmc1_inout_pio4[6]
set_location_assignment PIN_U6 -to fmc1_inout_pio4[7]
set_location_assignment PIN_U5 -to fmc1_inout_pio4[8]
set_location_assignment PIN_P2 -to fmc1_inout_pio4[9]
set_location_assignment PIN_AN5 -to fmc1_inout_pio5[0]
set_location_assignment PIN_AM6 -to fmc1_inout_pio5[1]
set_location_assignment PIN_AP17 -to fmc1_inout_pio5[10]
set_location_assignment PIN_AN12 -to fmc1_inout_pio5[11]
set_location_assignment PIN_AP12 -to fmc1_inout_pio5[12]
set_location_assignment PIN_AC17 -to fmc1_inout_pio5[13]
set_location_assignment PIN_AE12 -to fmc1_inout_pio5[14]
set_location_assignment PIN_AE11 -to fmc1_inout_pio5[15]
set_location_assignment PIN_AL9 -to fmc1_inout_pio5[16]
set_location_assignment PIN_AL8 -to fmc1_inout_pio5[17]
set_location_assignment PIN_AJ17 -to fmc1_inout_pio5[18]
set_location_assignment PIN_AK17 -to fmc1_inout_pio5[19]
set_location_assignment PIN_AM5 -to fmc1_inout_pio5[2]
set_location_assignment PIN_AP4 -to fmc1_inout_pio5[3]
set_location_assignment PIN_AN4 -to fmc1_inout_pio5[4]
set_location_assignment PIN_W4 -to fmc1_inout_pio5[5]
set_location_assignment PIN_W5 -to fmc1_inout_pio5[6]
set_location_assignment PIN_AN13 -to fmc1_inout_pio5[7]
set_location_assignment PIN_AM13 -to fmc1_inout_pio5[8]
set_location_assignment PIN_AP16 -to fmc1_inout_pio5[9]
set_location_assignment PIN_AL30 -to fmc_1C_rx_ch0
set_location_assignment PIN_AL29 -to "fmc_1C_rx_ch0(n)"
set_location_assignment PIN_AJ30 -to fmc_1C_rx_ch1
set_location_assignment PIN_AJ29 -to "fmc_1C_rx_ch1(n)"
set_location_assignment PIN_AG30 -to fmc_1C_rx_ch2
set_location_assignment PIN_AG29 -to "fmc_1C_rx_ch2(n)"
set_location_assignment PIN_AF32 -to fmc_1C_rx_ch3
set_location_assignment PIN_AF31 -to "fmc_1C_rx_ch3(n)"
set_location_assignment PIN_AP32 -to fmc_1C_tx_ch0
set_location_assignment PIN_AP31 -to "fmc_1C_tx_ch0(n)"
set_location_assignment PIN_AM32 -to fmc_1C_tx_ch1
set_location_assignment PIN_AM31 -to "fmc_1C_tx_ch1(n)"
set_location_assignment PIN_AK32 -to fmc_1C_tx_ch2
set_location_assignment PIN_AK31 -to "fmc_1C_tx_ch2(n)"
set_location_assignment PIN_AH32 -to fmc_1C_tx_ch3
set_location_assignment PIN_AH31 -to "fmc_1C_tx_ch3(n)"
set_location_assignment PIN_AC30 -to fmc_1D_rx_ch0
set_location_assignment PIN_AC29 -to "fmc_1D_rx_ch0(n)"
set_location_assignment PIN_AB32 -to fmc_1D_rx_ch1
set_location_assignment PIN_AB31 -to "fmc_1D_rx_ch1(n)"
set_location_assignment PIN_AA30 -to fmc_1D_rx_ch2
set_location_assignment PIN_AA29 -to "fmc_1D_rx_ch2(n)"
set_location_assignment PIN_Y32 -to fmc_1D_rx_ch3
set_location_assignment PIN_Y31 -to "fmc_1D_rx_ch3(n)"
set_location_assignment PIN_AJ34 -to fmc_1D_tx_ch0
set_location_assignment PIN_AJ33 -to "fmc_1D_tx_ch0(n)"
set_location_assignment PIN_AG34 -to fmc_1D_tx_ch1
set_location_assignment PIN_AG33 -to "fmc_1D_tx_ch1(n)"
set_location_assignment PIN_AE34 -to fmc_1D_tx_ch2
set_location_assignment PIN_AE33 -to "fmc_1D_tx_ch2(n)"
set_location_assignment PIN_AC34 -to fmc_1D_tx_ch3
set_location_assignment PIN_AC33 -to "fmc_1D_tx_ch3(n)"
set_location_assignment PIN_U30 -to fmc_1E_rx_ch0
set_location_assignment PIN_U29 -to "fmc_1E_rx_ch0(n)"
set_location_assignment PIN_T32 -to fmc_1E_rx_ch1
set_location_assignment PIN_T31 -to "fmc_1E_rx_ch1(n)"
set_location_assignment PIN_R30 -to fmc_1E_rx_ch2
set_location_assignment PIN_R29 -to "fmc_1E_rx_ch2(n)"
set_location_assignment PIN_P32 -to fmc_1E_rx_ch3
set_location_assignment PIN_P31 -to "fmc_1E_rx_ch3(n)"
set_location_assignment PIN_U34 -to fmc_1E_tx_ch0
set_location_assignment PIN_U33 -to "fmc_1E_tx_ch0(n)"
set_location_assignment PIN_R34 -to fmc_1E_tx_ch1
set_location_assignment PIN_R33 -to "fmc_1E_tx_ch1(n)"
set_location_assignment PIN_N34 -to fmc_1E_tx_ch2
set_location_assignment PIN_N33 -to "fmc_1E_tx_ch2(n)"
set_location_assignment PIN_L34 -to fmc_1E_tx_ch3
set_location_assignment PIN_L33 -to "fmc_1E_tx_ch3(n)"
set_location_assignment PIN_L30 -to fmc_1F_rx_ch0
set_location_assignment PIN_L29 -to "fmc_1F_rx_ch0(n)"
set_location_assignment PIN_K32 -to fmc_1F_rx_ch1
set_location_assignment PIN_K31 -to "fmc_1F_rx_ch1(n)"
set_location_assignment PIN_E34 -to fmc_1F_tx_ch0
set_location_assignment PIN_E33 -to "fmc_1F_tx_ch0(n)"
set_location_assignment PIN_C34 -to fmc_1F_tx_ch1
set_location_assignment PIN_C33 -to "fmc_1F_tx_ch1(n)"

set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio1[0]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio1[1]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio1[10]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio1[11]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio1[12]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio1[13]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio1[14]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio1[15]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio1[16]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio1[17]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio1[18]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio1[19]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio1[2]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio1[3]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio1[4]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio1[5]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio1[6]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio1[7]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio1[8]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio1[9]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio2[0]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio2[1]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio2[10]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio2[11]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio2[12]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio2[13]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio2[14]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio2[15]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio2[16]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio2[17]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio2[18]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio2[19]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio2[2]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio2[3]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio2[4]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio2[5]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio2[6]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio2[7]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio2[8]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio2[9]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio3[0]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio3[1]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio3[10]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio3[11]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio3[12]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio3[13]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio3[14]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio3[15]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio3[16]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio3[17]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio3[18]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio3[19]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio3[2]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio3[3]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio3[4]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio3[5]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio3[6]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio3[7]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio3[8]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio3[9]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio4[0]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio4[1]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio4[10]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio4[11]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio4[12]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio4[13]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio4[14]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio4[15]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio4[16]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio4[17]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio4[18]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio4[19]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio4[2]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio4[3]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio4[4]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio4[5]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio4[6]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio4[7]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio4[8]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio4[9]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio5[0]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio5[1]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio5[10]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio5[11]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio5[12]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio5[13]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio5[14]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio5[15]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio5[16]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio5[17]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio5[18]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio5[19]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio5[2]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio5[3]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio5[4]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio5[5]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio5[6]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio5[7]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio5[8]
set_instance_assignment -name IO_STANDARD 1.8V -to fmc1_inout_pio5[9]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1C_rx_ch0
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1C_rx_ch0(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1C_rx_ch1
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1C_rx_ch1(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1C_rx_ch2
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1C_rx_ch2(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1C_rx_ch3
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1C_rx_ch3(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1C_tx_ch0
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1C_tx_ch0(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1C_tx_ch1
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1C_tx_ch1(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1C_tx_ch2
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1C_tx_ch2(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1C_tx_ch3
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1C_tx_ch3(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1D_rx_ch0
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1D_rx_ch0(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1D_rx_ch1
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1D_rx_ch1(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1D_rx_ch2
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1D_rx_ch2(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1D_rx_ch3
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1D_rx_ch3(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1D_tx_ch0
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1D_tx_ch0(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1D_tx_ch1
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1D_tx_ch1(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1D_tx_ch2
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1D_tx_ch2(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1D_tx_ch3
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1D_tx_ch3(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1E_rx_ch0
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1E_rx_ch0(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1E_rx_ch1
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1E_rx_ch1(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1E_rx_ch2
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1E_rx_ch2(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1E_rx_ch3
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1E_rx_ch3(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1E_tx_ch0
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1E_tx_ch0(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1E_tx_ch1
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1E_tx_ch1(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1E_tx_ch2
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1E_tx_ch2(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1E_tx_ch3
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1E_tx_ch3(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1F_rx_ch0
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1F_rx_ch0(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1F_rx_ch1
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1F_rx_ch1(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1F_tx_ch0
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1F_tx_ch0(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to fmc_1F_tx_ch1
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "fmc_1F_tx_ch1(n)"


########################################################################################################################
# PCIE
########################################################################################################################
set_location_assignment PIN_AE16 -to pcie_npor_pin_perst
set_location_assignment PIN_AP9 -to pciex4_inout_pio10[0]
set_location_assignment PIN_AN9 -to pciex4_inout_pio10[1]
set_location_assignment PIN_AF28 -to pcie_refclk_clk
set_location_assignment PIN_AF27 -to "pcie_refclk_clk(n)"
set_location_assignment PIN_AE30 -to pcie_rx_i
set_location_assignment PIN_AE29 -to "pcie_rx_i(n)"
set_location_assignment PIN_AN34 -to pcie_tx_o
set_location_assignment PIN_AN33 -to "pcie_tx_o(n)"

set_instance_assignment -name IO_STANDARD 1.8V -to pcie_npor_pin_perst
set_instance_assignment -name IO_STANDARD 1.8V -to pciex4_inout_pio10[0]
set_instance_assignment -name IO_STANDARD 1.8V -to pciex4_inout_pio10[1]
set_instance_assignment -name IO_STANDARD HCSL -to pcie_refclk_clk
set_instance_assignment -name IO_STANDARD HCSL -to "pcie_refclk_clk(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to pcie_rx_i
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "pcie_rx_i(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to pcie_tx_o
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "pcie_tx_o(n)"


########################################################################################################################
# MEMORY
########################################################################################################################
set_location_assignment PIN_N3 -to FPGA_memory_mem1_dbi_n[0]
set_location_assignment PIN_L6 -to FPGA_memory_mem1_dbi_n[1]
set_location_assignment PIN_P6 -to FPGA_memory_mem1_dbi_n[2]
set_location_assignment PIN_W9 -to FPGA_memory_mem1_dbi_n[3]
set_location_assignment PIN_D10 -to FPGA_memory_mem1_dbi_n[4]
set_location_assignment PIN_G11 -to FPGA_memory_mem1_dbi_n[5]
set_location_assignment PIN_D7 -to FPGA_memory_mem1_dbi_n[6]
set_location_assignment PIN_A9 -to FPGA_memory_mem1_dbi_n[7]
set_location_assignment PIN_K3 -to FPGA_memory_mem1_dq[0]
set_location_assignment PIN_K2 -to FPGA_memory_mem1_dq[1]
set_location_assignment PIN_M7 -to FPGA_memory_mem1_dq[10]
set_location_assignment PIN_L4 -to FPGA_memory_mem1_dq[11]
set_location_assignment PIN_N4 -to FPGA_memory_mem1_dq[12]
set_location_assignment PIN_M5 -to FPGA_memory_mem1_dq[13]
set_location_assignment PIN_M6 -to FPGA_memory_mem1_dq[14]
set_location_assignment PIN_L5 -to FPGA_memory_mem1_dq[15]
set_location_assignment PIN_K7 -to FPGA_memory_mem1_dq[16]
set_location_assignment PIN_N7 -to FPGA_memory_mem1_dq[17]
set_location_assignment PIN_N9 -to FPGA_memory_mem1_dq[18]
set_location_assignment PIN_R7 -to FPGA_memory_mem1_dq[19]
set_location_assignment PIN_L3 -to FPGA_memory_mem1_dq[2]
set_location_assignment PIN_P9 -to FPGA_memory_mem1_dq[20]
set_location_assignment PIN_P7 -to FPGA_memory_mem1_dq[21]
set_location_assignment PIN_L8 -to FPGA_memory_mem1_dq[22]
set_location_assignment PIN_R8 -to FPGA_memory_mem1_dq[23]
set_location_assignment PIN_R9 -to FPGA_memory_mem1_dq[24]
set_location_assignment PIN_U7 -to FPGA_memory_mem1_dq[25]
set_location_assignment PIN_T8 -to FPGA_memory_mem1_dq[26]
set_location_assignment PIN_V9 -to FPGA_memory_mem1_dq[27]
set_location_assignment PIN_T9 -to FPGA_memory_mem1_dq[28]
set_location_assignment PIN_V8 -to FPGA_memory_mem1_dq[29]
set_location_assignment PIN_K1 -to FPGA_memory_mem1_dq[3]
set_location_assignment PIN_W10 -to FPGA_memory_mem1_dq[30]
set_location_assignment PIN_V7 -to FPGA_memory_mem1_dq[31]
set_location_assignment PIN_E12 -to FPGA_memory_mem1_dq[32]
set_location_assignment PIN_B10 -to FPGA_memory_mem1_dq[33]
set_location_assignment PIN_E11 -to FPGA_memory_mem1_dq[34]
set_location_assignment PIN_F11 -to FPGA_memory_mem1_dq[35]
set_location_assignment PIN_D12 -to FPGA_memory_mem1_dq[36]
set_location_assignment PIN_C10 -to FPGA_memory_mem1_dq[37]
set_location_assignment PIN_C13 -to FPGA_memory_mem1_dq[38]
set_location_assignment PIN_C12 -to FPGA_memory_mem1_dq[39]
set_location_assignment PIN_M3 -to FPGA_memory_mem1_dq[4]
set_location_assignment PIN_M13 -to FPGA_memory_mem1_dq[40]
set_location_assignment PIN_H12 -to FPGA_memory_mem1_dq[41]
set_location_assignment PIN_J12 -to FPGA_memory_mem1_dq[42]
set_location_assignment PIN_F13 -to FPGA_memory_mem1_dq[43]
set_location_assignment PIN_L13 -to FPGA_memory_mem1_dq[44]
set_location_assignment PIN_E13 -to FPGA_memory_mem1_dq[45]
set_location_assignment PIN_H13 -to FPGA_memory_mem1_dq[46]
set_location_assignment PIN_G12 -to FPGA_memory_mem1_dq[47]
set_location_assignment PIN_B6 -to FPGA_memory_mem1_dq[48]
set_location_assignment PIN_C5 -to FPGA_memory_mem1_dq[49]
set_location_assignment PIN_L1 -to FPGA_memory_mem1_dq[5]
set_location_assignment PIN_A5 -to FPGA_memory_mem1_dq[50]
set_location_assignment PIN_B5 -to FPGA_memory_mem1_dq[51]
set_location_assignment PIN_A6 -to FPGA_memory_mem1_dq[52]
set_location_assignment PIN_D5 -to FPGA_memory_mem1_dq[53]
set_location_assignment PIN_D4 -to FPGA_memory_mem1_dq[54]
set_location_assignment PIN_C4 -to FPGA_memory_mem1_dq[55]
set_location_assignment PIN_D9 -to FPGA_memory_mem1_dq[56]
set_location_assignment PIN_C8 -to FPGA_memory_mem1_dq[57]
set_location_assignment PIN_C9 -to FPGA_memory_mem1_dq[58]
set_location_assignment PIN_B8 -to FPGA_memory_mem1_dq[59]
set_location_assignment PIN_M2 -to FPGA_memory_mem1_dq[6]
set_location_assignment PIN_A11 -to FPGA_memory_mem1_dq[60]
set_location_assignment PIN_B7 -to FPGA_memory_mem1_dq[61]
set_location_assignment PIN_A10 -to FPGA_memory_mem1_dq[62]
set_location_assignment PIN_C7 -to FPGA_memory_mem1_dq[63]
set_location_assignment PIN_M1 -to FPGA_memory_mem1_dq[7]
set_location_assignment PIN_N5 -to FPGA_memory_mem1_dq[8]
set_location_assignment PIN_K4 -to FPGA_memory_mem1_dq[9]
set_location_assignment PIN_N2 -to FPGA_memory_mem1_alert_n
set_location_assignment PIN_M10 -to FPGA_memory_mem1_reset_n
set_location_assignment PIN_F3 -to FPGA_memory_oct1_rzqin
set_location_assignment PIN_AM15 -to fpga_clk_i
set_location_assignment PIN_J2 -to FPGA_memory_mem1_dqs_n[0]
set_location_assignment PIN_J5 -to FPGA_memory_mem1_dqs_n[1]
set_location_assignment PIN_M8 -to FPGA_memory_mem1_dqs_n[2]
set_location_assignment PIN_T10 -to FPGA_memory_mem1_dqs_n[3]
set_location_assignment PIN_B12 -to FPGA_memory_mem1_dqs_n[4]
set_location_assignment PIN_K13 -to FPGA_memory_mem1_dqs_n[5]
set_location_assignment PIN_A4 -to FPGA_memory_mem1_dqs_n[6]
set_location_assignment PIN_E9 -to FPGA_memory_mem1_dqs_n[7]
set_location_assignment PIN_J1 -to FPGA_memory_mem1_dqs[0]
set_location_assignment PIN_J4 -to FPGA_memory_mem1_dqs[1]
set_location_assignment PIN_N8 -to FPGA_memory_mem1_dqs[2]
set_location_assignment PIN_U10 -to FPGA_memory_mem1_dqs[3]
set_location_assignment PIN_B11 -to FPGA_memory_mem1_dqs[4]
set_location_assignment PIN_K12 -to FPGA_memory_mem1_dqs[5]
set_location_assignment PIN_A3 -to FPGA_memory_mem1_dqs[6]
set_location_assignment PIN_E8 -to FPGA_memory_mem1_dqs[7]
set_location_assignment PIN_L9 -to FPGA_memory_mem1_ck
set_location_assignment PIN_L10 -to FPGA_memory_mem1_ck_n
set_location_assignment PIN_G1 -to FPGA_memory_mem1_a[0]
set_location_assignment PIN_F1 -to FPGA_memory_mem1_a[1]
set_location_assignment PIN_G5 -to FPGA_memory_mem1_a[10]
set_location_assignment PIN_G6 -to FPGA_memory_mem1_a[11]
set_location_assignment PIN_E3 -to FPGA_memory_mem1_a[12]
set_location_assignment PIN_E2 -to FPGA_memory_mem1_a[13]
set_location_assignment PIN_D2 -to FPGA_memory_mem1_a[14]
set_location_assignment PIN_E7 -to FPGA_memory_mem1_a[15]
set_location_assignment PIN_E6 -to FPGA_memory_mem1_a[16]
set_location_assignment PIN_H5 -to FPGA_memory_mem1_a[2]
set_location_assignment PIN_H4 -to FPGA_memory_mem1_a[3]
set_location_assignment PIN_G2 -to FPGA_memory_mem1_a[4]
set_location_assignment PIN_G3 -to FPGA_memory_mem1_a[5]
set_location_assignment PIN_E1 -to FPGA_memory_mem1_a[6]
set_location_assignment PIN_D1 -to FPGA_memory_mem1_a[7]
set_location_assignment PIN_H3 -to FPGA_memory_mem1_a[8]
set_location_assignment PIN_H2 -to FPGA_memory_mem1_a[9]
set_location_assignment PIN_L11 -to FPGA_memory_mem1_act_n
set_location_assignment PIN_E4 -to FPGA_memory_mem1_ba[0]
set_location_assignment PIN_C3 -to FPGA_memory_mem1_ba[1]
set_location_assignment PIN_B3 -to FPGA_memory_mem1_bg
set_location_assignment PIN_J6 -to FPGA_memory_mem1_cke
set_location_assignment PIN_M11 -to FPGA_memory_mem1_cs_n
set_location_assignment PIN_K8 -to FPGA_memory_mem1_odt
set_location_assignment PIN_J9 -to FPGA_memory_mem1_par

set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dbi_n[0]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dbi_n[1]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dbi_n[2]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dbi_n[3]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dbi_n[4]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dbi_n[5]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dbi_n[6]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dbi_n[7]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[0]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[1]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[10]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[11]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[12]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[13]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[14]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[15]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[16]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[17]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[18]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[19]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[2]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[20]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[21]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[22]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[23]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[24]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[25]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[26]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[27]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[28]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[29]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[3]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[30]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[31]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[32]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[33]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[34]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[35]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[36]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[37]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[38]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[39]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[4]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[40]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[41]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[42]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[43]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[44]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[45]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[46]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[47]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[48]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[49]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[5]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[50]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[51]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[52]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[53]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[54]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[55]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[56]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[57]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[58]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[59]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[6]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[60]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[61]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[62]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[63]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[7]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[8]
set_instance_assignment -name IO_STANDARD "1.2-V POD" -to FPGA_memory_mem1_dq[9]
set_instance_assignment -name IO_STANDARD 1.2V -to FPGA_memory_mem1_alert_n
set_instance_assignment -name IO_STANDARD 1.2V -to FPGA_memory_mem1_reset_n
set_instance_assignment -name IO_STANDARD 1.2V -to FPGA_memory_oct1_rzqin
set_instance_assignment -name IO_STANDARD 1.8V -to fpga_clk_i
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to FPGA_memory_mem1_dqs_n[0]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to FPGA_memory_mem1_dqs_n[1]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to FPGA_memory_mem1_dqs_n[2]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to FPGA_memory_mem1_dqs_n[3]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to FPGA_memory_mem1_dqs_n[4]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to FPGA_memory_mem1_dqs_n[5]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to FPGA_memory_mem1_dqs_n[6]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to FPGA_memory_mem1_dqs_n[7]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to FPGA_memory_mem1_dqs[0]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to FPGA_memory_mem1_dqs[1]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to FPGA_memory_mem1_dqs[2]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to FPGA_memory_mem1_dqs[3]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to FPGA_memory_mem1_dqs[4]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to FPGA_memory_mem1_dqs[5]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to FPGA_memory_mem1_dqs[6]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V POD" -to FPGA_memory_mem1_dqs[7]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V SSTL" -to FPGA_memory_mem1_ck
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.2-V SSTL" -to FPGA_memory_mem1_ck_n
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_a[0]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_a[1]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_a[10]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_a[11]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_a[12]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_a[13]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_a[14]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_a[15]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_a[16]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_a[2]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_a[3]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_a[4]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_a[5]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_a[6]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_a[7]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_a[8]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_a[9]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_act_n
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_ba[0]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_ba[1]
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_bg
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_cke
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_cs_n
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_odt
set_instance_assignment -name IO_STANDARD "SSTL-12" -to FPGA_memory_mem1_par

set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT -section_id Top
set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top