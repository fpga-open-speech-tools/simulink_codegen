-------------------------------------------------------------------------------------
--
--! @file       A10SoM_System.vhd
--! @brief      AD1939 using the Audio Research Board on the Arria 10.
--! @details    Top Level Design for a pass through system using the
--!             Audio Research Board, developed by Flat Earth Inc.
--! @author     Connor Dack
--! @date       July 2018
--! @copyright  Copyright (C) 2018 Flat Earth Inc
--!
--! Software Released Under the MIT License
--
--  Permission is hereby granted, free of charge, to any person obtaining a copy
--  of this software and associated documentation files (the "Software"), to deal
--  IN the Software without restriction, including without limitation the rights
--  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--  copies of the Software, and to permit persons to whom the Software is furnished
--  to do so, subject to the following conditions:
--
--  The above copyright notice and this permission notice shall be included IN all
--  copies or substantial portions of the Software.
--
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
--  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
--  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
--  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
--  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--
--  Connor Dack
--  Flat Earth Inc
--  985 Technology Blvd,
--  Bozeman, MT 59718
--
------------------------------------------------------------------------------------------

LIBRARY IEEE ;                      --! Use standard library.
USE     IEEE.STD_LOGIC_1164.ALL;    --! Use standard logic elements.
USE     IEEE.NUMERIC_STD.ALL ;      --! Use numeric standard.

LIBRARY PLL_SYS;                    --! Use PLL_SYS Library.
LIBRARY HPS;                        --! Use HPS Library.

LIBRARY altera;
USE altera.altera_primitives_components.all;

------------------------------------------------------------------------------------------
--
--! @brief      A10 AD1939 Pass Through
--! @details    Top Level of the Arria 10 AD1939 Pass Through System using
--!             the Audio Research Daughter Card connect to the LPC FMC.
--!
--! @param      clk_25mhz_fpga : In - 25MHz Clock
--! @param
--! @param      fmc_std_scl    : INOUT - I2C Bus is common for both FMC Connectors
--! @param      fmc_std_sda    : INOUT - I2C Bus is common for both FMC Connectors
--!
--
------------------------------------------------------------------------------------------

ENTITY A10SoM_System IS
   PORT(
		----------------------------------------
		--  CLOCK Inputs
		----------------------------------------
		clk_25mhz_fpga : in std_logic;

		AD1939_ADC_ALRCLK     : in std_logic;
		AD1939_ADC_ASDATA1    : in std_logic;
		AD1939_ADC_ASDATA2    : in std_logic;
		
    AD1939_DAC_DLRCLK     : out std_logic;
		AD1939_DAC_DSDATA1    : out std_logic;
		AD1939_DAC_DSDATA2    : out std_logic;
		AD1939_DAC_DSDATA3    : out std_logic;
		AD1939_DAC_DSDATA4    : out std_logic;
		
    AD1939_RESET_n        : out std_logic;
		AD1939_spi_CCLK       : out std_logic;
		AD1939_spi_CIN        : out std_logic;
		AD1939_spi_CLATCH_n   : out std_logic;
		AD1939_spi_COUT       : in std_logic;
		
    INMP621_mic_CLK       : in std_logic;
		INMP621_mic_DATA      : in std_logic;
		
    TPA6130_power_off     : out std_logic;
		TPA6130_i2c_SCL       : inout std_logic;
		TPA6130_i2c_SDA       : inout std_logic;
		
    AD1939_ADC_ABCLK      : in std_logic;
		AD1939_DAC_DBCLK      : out std_logic;
		AD1939_MCLK           : in std_logic;
    
    PREAMP_CS             : out std_logic;

    ------------------------------------------------------------------------------------------
    -- FMC Top/Bot (HPC)
    ------------------------------------------------------------------------------------------
    --hpc_gbtclk0_m2c              : IN    std_logic
    --hpc_gbtclk1_m2c              : IN    std_logic
    --hpc_dp_m2c                   : IN    std_logic_vector(  9 DOWNTO  0)
    --hpc_dp_c2m                   : OUT   std_logic_vector(  9 DOWNTO  0)
    hpc_clk0_m2c                 : IN    std_logic                     := 'X';             -- hpc_clk0_m2c
    hpc_clk1_m2c                 : IN    std_logic                     := 'X';             -- hpc_clk1_m2c
    hpc_clk2_bidir               : OUT   std_logic;                                        -- hpc_clk2_bidir
    hpc_clk3_bidir               : OUT   std_logic;                                        -- hpc_clk3_bidir
    fmc_std_scl                  : INOUT std_logic                     := 'X';             -- fmc_std_scl
    fmc_std_sda                  : INOUT std_logic                     := 'X';             -- fmc_std_sda

    ------------------------------------------------------------------------------------------
    -- FMC Bot (LPC)
    ------------------------------------------------------------------------------------------
    -- lpc_clk1_m2c                 : IN    std_logic                     := 'X';             -- lpc_clk1_m2c

    -- lpc_la_n              : in std_logic_vector(0 to 25);
    -- lpc_la_p              : in std_logic_vector(0 to 25);
    ------------------------------------------------------------------------------------------
    -- FPGA <=> MAX
    ------------------------------------------------------------------------------------------
    lnk_m2f_dat                   : IN    std_logic                     := 'X';             -- lnk_m2f_dat
    lnk_f2m_dat                   : OUT   std_logic;
    hps_good                      : OUT   std_logic;
    lnk_m2f_rst                   : IN    std_logic                     := 'X';             -- lnk_m2f_rst
    hps_rst                       : IN    std_logic                     := 'X';             -- hps_rst
  
    ----------------------------------------
    -- microphone array
    ----------------------------------------
    mic_array_led_ws              : out std_logic;
    mic_array_led_sd              : out std_logic;
    mic_array_sdi                  : in  std_logic;
    mic_array_sdo                  : out std_logic;
    mic_array_sck                 : out std_logic;
    
    ------------------------------------------------------------------------------------------
    -- HPS
    ------------------------------------------------------------------------------------------
    hps_ddr4_ck                  : OUT   std_logic_vector(0 DOWNTO 0);                     -- mem_ck
    hps_ddr4_ck_n                : OUT   std_logic_vector(0 DOWNTO 0);                     -- mem_ck_n
    hps_ddr4_a                   : OUT   std_logic_vector(16 DOWNTO 0);                    -- mem_a
    hps_ddr4_act_n               : OUT   std_logic_vector(0 DOWNTO 0);                     -- mem_act_n
    hps_ddr4_ba                  : OUT   std_logic_vector(1 DOWNTO 0);                     -- mem_ba
    hps_ddr4_bg                  : OUT   std_logic_vector(1 DOWNTO 0);                     -- mem_bg
    hps_ddr4_cke                 : OUT   std_logic_vector(0 DOWNTO 0);                     -- mem_cke
    hps_ddr4_cs_n                : OUT   std_logic_vector(0 DOWNTO 0);                     -- mem_cs_n
    hps_ddr4_odt                 : OUT   std_logic_vector(0 DOWNTO 0);                     -- mem_odt
    hps_ddr4_reset_n             : OUT   std_logic_vector(0 DOWNTO 0);                     -- mem_reset_n
    hps_ddr4_par                 : OUT   std_logic_vector(0 DOWNTO 0);                     -- mem_par
    hps_ddr4_alert_n             : IN    std_logic_vector(0 DOWNTO 0)  := (OTHERS => 'X'); -- mem_alert_n
    hps_ddr4_dqs                 : INOUT std_logic_vector(3 DOWNTO 0)  := (OTHERS => 'X'); -- mem_dqs<generate_label>:
    hps_ddr4_dqs_n               : INOUT std_logic_vector(3 DOWNTO 0)  := (OTHERS => 'X'); -- mem_dqs_n
    hps_ddr4_dq                  : INOUT std_logic_vector(31 DOWNTO 0) := (OTHERS => 'X'); -- mem_dq
    hps_ddr4_dbi_n               : INOUT std_logic_vector(3 DOWNTO 0)  := (OTHERS => 'X'); -- mem_dbi_n
    hps_ddr4_oct_rzqin           : IN    std_logic                     := 'X';             -- oct_rzqin
    hps_ddr4_pll_ref_clk         : IN    std_logic                     := 'X';             -- clk

    hps_io_phery_sdmmc_CMD       : INOUT std_logic                     := 'X';             -- hps_io_phery_sdmmc_CMD
    hps_io_phery_sdmmc_D0        : INOUT std_logic                     := 'X';             -- hps_io_phery_sdmmc_D0
    hps_io_phery_sdmmc_D1        : INOUT std_logic                     := 'X';             -- hps_io_phery_sdmmc_D1
    hps_io_phery_sdmmc_D2        : INOUT std_logic                     := 'X';             -- hps_io_phery_sdmmc_D2
    hps_io_phery_sdmmc_D3        : INOUT std_logic                     := 'X';             -- hps_io_phery_sdmmc_D3
    hps_io_phery_sdmmc_D4        : INOUT std_logic                     := 'X';             -- hps_io_phery_sdmmc_D4
    hps_io_phery_sdmmc_D5        : INOUT std_logic                     := 'X';             -- hps_io_phery_sdmmc_D5
    hps_io_phery_sdmmc_D6        : INOUT std_logic                     := 'X';             -- hps_io_phery_sdmmc_D6
    hps_io_phery_sdmmc_D7        : INOUT std_logic                     := 'X';             -- hps_io_phery_sdmmc_D7
    hps_io_phery_sdmmc_CCLK      : OUT   std_logic;                                        -- hps_io_phery_sdmmc_CCLK

	 hps_io_phery_emac1_TX_CLK         : out   std_logic;                                        -- hps_io_phery_emac1_TX_CLK
    hps_io_phery_emac1_TXD0           : out   std_logic;                                        -- hps_io_phery_emac1_TXD0
    hps_io_phery_emac1_TXD1           : out   std_logic;                                        -- hps_io_phery_emac1_TXD1
    hps_io_phery_emac1_TXD2           : out   std_logic;                                        -- hps_io_phery_emac1_TXD2
    hps_io_phery_emac1_TXD3           : out   std_logic;                                        -- hps_io_phery_emac1_TXD3
    hps_io_phery_emac1_RX_CTL         : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RX_CTL
    hps_io_phery_emac1_TX_CTL         : out   std_logic;                                        -- hps_io_phery_emac1_TX_CTL
    hps_io_phery_emac1_RX_CLK         : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RX_CLK
    hps_io_phery_emac1_RXD0           : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RXD0
    hps_io_phery_emac1_RXD1           : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RXD1
    hps_io_phery_emac1_RXD2           : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RXD2
    hps_io_phery_emac1_RXD3           : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RXD3
    hps_io_phery_emac1_MDIO           : inout std_logic                     := 'X';             -- hps_io_phery_emac1_MDIO
    hps_io_phery_emac1_MDC            : out   std_logic;                                        -- hps_io_phery_emac1_MDC

    hps_io_phery_emac2_TX_CLK         : out   std_logic;                                        -- hps_io_phery_emac2_TX_CLK
    hps_io_phery_emac2_TXD0           : out   std_logic;                                        -- hps_io_phery_emac2_TXD0
    hps_io_phery_emac2_TXD1           : out   std_logic;                                        -- hps_io_phery_emac2_TXD1
    hps_io_phery_emac2_TXD2           : out   std_logic;                                        -- hps_io_phery_emac2_TXD2
    hps_io_phery_emac2_TXD3           : out   std_logic;                                        -- hps_io_phery_emac2_TXD3
    hps_io_phery_emac2_RX_CTL         : in    std_logic                     := 'X';             -- hps_io_phery_emac2_RX_CTL
    hps_io_phery_emac2_TX_CTL         : out   std_logic;                                        -- hps_io_phery_emac2_TX_CTL
    hps_io_phery_emac2_RX_CLK         : in    std_logic                     := 'X';             -- hps_io_phery_emac2_RX_CLK
    hps_io_phery_emac2_RXD0           : in    std_logic                     := 'X';             -- hps_io_phery_emac2_RXD0
    hps_io_phery_emac2_RXD1           : in    std_logic                     := 'X';             -- hps_io_phery_emac2_RXD1
    hps_io_phery_emac2_RXD2           : in    std_logic                     := 'X';             -- hps_io_phery_emac2_RXD2
    hps_io_phery_emac2_RXD3           : in    std_logic                     := 'X';             -- hps_io_phery_emac2_RXD3
    hps_io_phery_emac2_MDIO           : inout std_logic                     := 'X';             -- hps_io_phery_emac2_MDIO
    hps_io_phery_emac2_MDC            : out   std_logic;                                        -- hps_io_phery_emac2_MDC

    hps_io_phery_usb1_DATA0      : INOUT std_logic                     := 'X';             -- hps_io_phery_usb1_DATA0
    hps_io_phery_usb1_DATA1      : INOUT std_logic                     := 'X';             -- hps_io_phery_usb1_DATA1
    hps_io_phery_usb1_DATA2      : INOUT std_logic                     := 'X';             -- hps_io_phery_usb1_DATA2
    hps_io_phery_usb1_DATA3      : INOUT std_logic                     := 'X';             -- hps_io_phery_usb1_DATA3
    hps_io_phery_usb1_DATA4      : INOUT std_logic                     := 'X';             -- hps_io_phery_usb1_DATA4
    hps_io_phery_usb1_DATA5      : INOUT std_logic                     := 'X';             -- hps_io_phery_usb1_DATA5
    hps_io_phery_usb1_DATA6      : INOUT std_logic                     := 'X';             -- hps_io_phery_usb1_DATA6
    hps_io_phery_usb1_DATA7      : INOUT std_logic                     := 'X';             -- hps_io_phery_usb1_DATA7
    hps_io_phery_usb1_CLK        : IN    std_logic                     := 'X';             -- hps_io_phery_usb1_CLK
    hps_io_phery_usb1_STP        : OUT   std_logic;                                        -- hps_io_phery_usb1_STP
    hps_io_phery_usb1_DIR        : IN    std_logic                     := 'X';             -- hps_io_phery_usb1_DIR
    hps_io_phery_usb1_NXT        : IN    std_logic                     := 'X';             -- hps_io_phery_usb1_NXT

    hps_io_phery_uart0_RX        : IN    std_logic                     := 'X';             -- hps_io_phery_uart0_RX
    hps_io_phery_uart0_TX        : OUT   std_logic;                                        -- hps_io_phery_uart0_TX
    hps_io_phery_uart0_CTS_N     : IN    std_logic                     := 'X';             -- hps_io_phery_uart0_CTS_N
    hps_io_phery_uart0_RTS_N     : OUT   std_logic;                                        -- hps_io_phery_uart0_RTS_N

--	 hps_io_phery_i2c0_SDA             : inout std_logic                     := 'X';             -- hps_io_phery_i2c0_SDA
--    hps_io_phery_i2c0_SCL             : inout std_logic                     := 'X';             -- hps_io_phery_i2c0_SCL
    ------------------------------------------------------------------------------------------
    -- Misc.
    ------------------------------------------------------------------------------------------
    led_usr_g_n                  : OUT   std_logic;                                        -- led_usr_g_n
    led_usr_r_n                  : OUT   std_logic                                         -- led_usr_r_n
    --clk_sync_pwr                 : OUT   std_logic

  );
END ENTITY A10SoM_System;

ARCHITECTURE A10SoM_System_Arch OF A10SoM_System IS

   ------------------------------------------------------------------------------------------
   -- Component Declerations
   ------------------------------------------------------------------------------------------

    component reflex_system is
        port (
            ad1939_abclk_clk                     : in    std_logic                     := 'X';             -- clk
            ad1939_alrclk_clk                    : in    std_logic                     := 'X';             -- clk
            ad1939_mclk_clk                      : in    std_logic                     := 'X';             -- clk
            ad1939_physical_ad1939_adc_asdata1   : in    std_logic                     := 'X';             -- ad1939_adc_asdata1
            ad1939_physical_ad1939_adc_asdata2   : in    std_logic                     := 'X';             -- ad1939_adc_asdata2
            ad1939_physical_ad1939_dac_dbclk     : out   std_logic;                                        -- ad1939_dac_dbclk
            ad1939_physical_ad1939_dac_dlrclk    : out   std_logic;                                        -- ad1939_dac_dlrclk
            ad1939_physical_ad1939_dac_dsdata1   : out   std_logic;                                        -- ad1939_dac_dsdata1
            ad1939_physical_ad1939_dac_dsdata2   : out   std_logic;                                        -- ad1939_dac_dsdata2
            ad1939_physical_ad1939_dac_dsdata3   : out   std_logic;                                        -- ad1939_dac_dsdata3
            ad1939_physical_ad1939_dac_dsdata4   : out   std_logic;                                        -- ad1939_dac_dsdata4
            clk_clk                              : in    std_logic                     := 'X';             -- clk
            ddr4_global_reset_reset_sink_reset_n : in    std_logic                     := 'X';             -- reset_n
            ddr4_mem_conduit_end_mem_ck          : out   std_logic_vector(0 downto 0);                     -- mem_ck
            ddr4_mem_conduit_end_mem_ck_n        : out   std_logic_vector(0 downto 0);                     -- mem_ck_n
            ddr4_mem_conduit_end_mem_a           : out   std_logic_vector(16 downto 0);                    -- mem_a
            ddr4_mem_conduit_end_mem_act_n       : out   std_logic_vector(0 downto 0);                     -- mem_act_n
            ddr4_mem_conduit_end_mem_ba          : out   std_logic_vector(1 downto 0);                     -- mem_ba
            ddr4_mem_conduit_end_mem_bg          : out   std_logic_vector(1 downto 0);                     -- mem_bg
            ddr4_mem_conduit_end_mem_cke         : out   std_logic_vector(0 downto 0);                     -- mem_cke
            ddr4_mem_conduit_end_mem_cs_n        : out   std_logic_vector(0 downto 0);                     -- mem_cs_n
            ddr4_mem_conduit_end_mem_odt         : out   std_logic_vector(0 downto 0);                     -- mem_odt
            ddr4_mem_conduit_end_mem_reset_n     : out   std_logic_vector(0 downto 0);                     -- mem_reset_n
            ddr4_mem_conduit_end_mem_par         : out   std_logic_vector(0 downto 0);                     -- mem_par
            ddr4_mem_conduit_end_mem_alert_n     : in    std_logic_vector(0 downto 0)  := (others => 'X'); -- mem_alert_n
            ddr4_mem_conduit_end_mem_dqs         : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
            ddr4_mem_conduit_end_mem_dqs_n       : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
            ddr4_mem_conduit_end_mem_dq          : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
            ddr4_mem_conduit_end_mem_dbi_n       : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dbi_n
            ddr4_oct_conduit_end_oct_rzqin       : in    std_logic                     := 'X';             -- oct_rzqin
            ddr4_pll_ref_clk_clock_sink_clk      : in    std_logic                     := 'X';             -- clk
            hps_f2h_cold_reset_req_reset_n       : in    std_logic                     := 'X';             -- reset_n
            hps_f2h_irq0_irq                     : in    std_logic_vector(31 downto 0) := (others => 'X'); -- irq
            hps_f2h_irq1_irq                     : in    std_logic_vector(31 downto 0) := (others => 'X'); -- irq
            hps_f2h_warm_reset_req_reset_n       : in    std_logic                     := 'X';             -- reset_n
            hps_i2c0_sda_i                       : in    std_logic                     := 'X';             -- sda_i
            hps_i2c0_sda_oe                      : out   std_logic;                                        -- sda_oe
            hps_i2c0_clk_clk                     : out   std_logic;                                        -- clk
            hps_i2c0_scl_in_clk                  : in    std_logic                     := 'X';             -- clk
            hps_io_hps_io_phery_emac1_TX_CLK     : out   std_logic;                                        -- hps_io_phery_emac1_TX_CLK
            hps_io_hps_io_phery_emac1_TXD0       : out   std_logic;                                        -- hps_io_phery_emac1_TXD0
            hps_io_hps_io_phery_emac1_TXD1       : out   std_logic;                                        -- hps_io_phery_emac1_TXD1
            hps_io_hps_io_phery_emac1_TXD2       : out   std_logic;                                        -- hps_io_phery_emac1_TXD2
            hps_io_hps_io_phery_emac1_TXD3       : out   std_logic;                                        -- hps_io_phery_emac1_TXD3
            hps_io_hps_io_phery_emac1_RX_CTL     : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RX_CTL
            hps_io_hps_io_phery_emac1_TX_CTL     : out   std_logic;                                        -- hps_io_phery_emac1_TX_CTL
            hps_io_hps_io_phery_emac1_RX_CLK     : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RX_CLK
            hps_io_hps_io_phery_emac1_RXD0       : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RXD0
            hps_io_hps_io_phery_emac1_RXD1       : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RXD1
            hps_io_hps_io_phery_emac1_RXD2       : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RXD2
            hps_io_hps_io_phery_emac1_RXD3       : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RXD3
            hps_io_hps_io_phery_emac1_MDIO       : inout std_logic                     := 'X';             -- hps_io_phery_emac1_MDIO
            hps_io_hps_io_phery_emac1_MDC        : out   std_logic;                                        -- hps_io_phery_emac1_MDC
            hps_io_hps_io_phery_emac2_TX_CLK     : out   std_logic;                                        -- hps_io_phery_emac2_TX_CLK
            hps_io_hps_io_phery_emac2_TXD0       : out   std_logic;                                        -- hps_io_phery_emac2_TXD0
            hps_io_hps_io_phery_emac2_TXD1       : out   std_logic;                                        -- hps_io_phery_emac2_TXD1
            hps_io_hps_io_phery_emac2_TXD2       : out   std_logic;                                        -- hps_io_phery_emac2_TXD2
            hps_io_hps_io_phery_emac2_TXD3       : out   std_logic;                                        -- hps_io_phery_emac2_TXD3
            hps_io_hps_io_phery_emac2_RX_CTL     : in    std_logic                     := 'X';             -- hps_io_phery_emac2_RX_CTL
            hps_io_hps_io_phery_emac2_TX_CTL     : out   std_logic;                                        -- hps_io_phery_emac2_TX_CTL
            hps_io_hps_io_phery_emac2_RX_CLK     : in    std_logic                     := 'X';             -- hps_io_phery_emac2_RX_CLK
            hps_io_hps_io_phery_emac2_RXD0       : in    std_logic                     := 'X';             -- hps_io_phery_emac2_RXD0
            hps_io_hps_io_phery_emac2_RXD1       : in    std_logic                     := 'X';             -- hps_io_phery_emac2_RXD1
            hps_io_hps_io_phery_emac2_RXD2       : in    std_logic                     := 'X';             -- hps_io_phery_emac2_RXD2
            hps_io_hps_io_phery_emac2_RXD3       : in    std_logic                     := 'X';             -- hps_io_phery_emac2_RXD3
            hps_io_hps_io_phery_emac2_MDIO       : inout std_logic                     := 'X';             -- hps_io_phery_emac2_MDIO
            hps_io_hps_io_phery_emac2_MDC        : out   std_logic;                                        -- hps_io_phery_emac2_MDC
            hps_io_hps_io_phery_sdmmc_CMD        : inout std_logic                     := 'X';             -- hps_io_phery_sdmmc_CMD
            hps_io_hps_io_phery_sdmmc_D0         : inout std_logic                     := 'X';             -- hps_io_phery_sdmmc_D0
            hps_io_hps_io_phery_sdmmc_D1         : inout std_logic                     := 'X';             -- hps_io_phery_sdmmc_D1
            hps_io_hps_io_phery_sdmmc_D2         : inout std_logic                     := 'X';             -- hps_io_phery_sdmmc_D2
            hps_io_hps_io_phery_sdmmc_D3         : inout std_logic                     := 'X';             -- hps_io_phery_sdmmc_D3
            hps_io_hps_io_phery_sdmmc_D4         : inout std_logic                     := 'X';             -- hps_io_phery_sdmmc_D4
            hps_io_hps_io_phery_sdmmc_D5         : inout std_logic                     := 'X';             -- hps_io_phery_sdmmc_D5
            hps_io_hps_io_phery_sdmmc_D6         : inout std_logic                     := 'X';             -- hps_io_phery_sdmmc_D6
            hps_io_hps_io_phery_sdmmc_D7         : inout std_logic                     := 'X';             -- hps_io_phery_sdmmc_D7
            hps_io_hps_io_phery_sdmmc_CCLK       : out   std_logic;                                        -- hps_io_phery_sdmmc_CCLK
            hps_io_hps_io_phery_usb1_DATA0       : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA0
            hps_io_hps_io_phery_usb1_DATA1       : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA1
            hps_io_hps_io_phery_usb1_DATA2       : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA2
            hps_io_hps_io_phery_usb1_DATA3       : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA3
            hps_io_hps_io_phery_usb1_DATA4       : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA4
            hps_io_hps_io_phery_usb1_DATA5       : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA5
            hps_io_hps_io_phery_usb1_DATA6       : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA6
            hps_io_hps_io_phery_usb1_DATA7       : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA7
            hps_io_hps_io_phery_usb1_CLK         : in    std_logic                     := 'X';             -- hps_io_phery_usb1_CLK
            hps_io_hps_io_phery_usb1_STP         : out   std_logic;                                        -- hps_io_phery_usb1_STP
            hps_io_hps_io_phery_usb1_DIR         : in    std_logic                     := 'X';             -- hps_io_phery_usb1_DIR
            hps_io_hps_io_phery_usb1_NXT         : in    std_logic                     := 'X';             -- hps_io_phery_usb1_NXT
            hps_io_hps_io_phery_uart0_RX         : in    std_logic                     := 'X';             -- hps_io_phery_uart0_RX
            hps_io_hps_io_phery_uart0_TX         : out   std_logic;                                        -- hps_io_phery_uart0_TX
            hps_io_hps_io_phery_uart0_CTS_N      : in    std_logic                     := 'X';             -- hps_io_phery_uart0_CTS_N
            hps_io_hps_io_phery_uart0_RTS_N      : out   std_logic;                                        -- hps_io_phery_uart0_RTS_N
            hps_spim1_mosi_o                     : out   std_logic;                                        -- mosi_o
            hps_spim1_miso_i                     : in    std_logic                     := 'X';             -- miso_i
            hps_spim1_ss_in_n                    : in    std_logic                     := 'X';             -- ss_in_n
            hps_spim1_mosi_oe                    : out   std_logic;                                        -- mosi_oe
            hps_spim1_ss0_n_o                    : out   std_logic;                                        -- ss0_n_o
            hps_spim1_ss1_n_o                    : out   std_logic;                                        -- ss1_n_o
            hps_spim1_ss2_n_o                    : out   std_logic;                                        -- ss2_n_o
            hps_spim1_ss3_n_o                    : out   std_logic;                                        -- ss3_n_o
            hps_spim1_sclk_out_clk               : out   std_logic;                                        -- clk
            mclk_pll_locked_export               : out   std_logic;                                        -- export
            reset_reset_n                        : in    std_logic                     := 'X';             -- reset_n
            rj45_interface_serial_data_in        : in    std_logic                     := 'X';             -- serial_data_in
            rj45_interface_serial_data_out       : out   std_logic;                                        -- serial_data_out
            rj45_interface_serial_clk_out        : out   std_logic                                         -- serial_clk_out
        );
    end component reflex_system;


   ------------------------------------------------------------------------------------------
   -- Constant and Type Declarations
   ------------------------------------------------------------------------------------------
   ATTRIBUTE keep               : boolean;
   ATTRIBUTE noprune            : boolean;
   ATTRIBUTE preserve           : boolean;
   CONSTANT C_SYS_CLK_PERIOD    : time      := 10 ns;
   CONSTANT C_SYS_CLK_FREQUENCY : integer   := 100000000;
   CONSTANT C_RST_DELAY_NB_BITS : integer   := 3;

   ------------------------------------------------------------------------------------------
   -- Signal Declarations
   ------------------------------------------------------------------------------------------
   SIGNAL s_sys_clk     : std_logic;
   SIGNAL s_sys_rst     : std_logic;
   SIGNAL s_sys_rstn    : std_logic;
   SIGNAL s_tick_1s     : std_logic;
   SIGNAL s_tick_8hz    : std_logic;

   SIGNAL sb_pll_locked : std_logic;
   SIGNAL sb_rst        : std_logic        := '1';
   SIGNAL sb_rst_dly    : std_logic;
   SIGNAL sb_hps_rst_n  : std_logic;
   SIGNAL sb_ddr_rst_n  : std_logic;
   SIGNAL sb_reset_dly  : std_logic_vector(1 DOWNTO 0);

	SIGNAL ad1939_adc_bclk   : std_logic;
	SIGNAL ad1939_adc_lrclk  : std_logic;
	SIGNAL ad1939_adc_sdata1 : std_logic;
	SIGNAL ad1939_adc_sdata2 : std_logic;
	SIGNAL ad1939_dac_bclk   : std_logic;
	SIGNAL ad1939_dac_lrclk  : std_logic;
	SIGNAL ad1939_dac_sdata1 : std_logic;
	SIGNAL ad1939_dac_sdata2 : std_logic;
	SIGNAL ad1939_dac_sdata3 : std_logic;
	SIGNAL ad1939_dac_sdata4 : std_logic;

	SIGNAL spis0_CLK         : std_logic;
	SIGNAL spis0_MOSI        : std_logic;
	SIGNAL spis0_MISO        : std_logic;
   SIGNAL spis0_SS0_N       : std_logic;
   SIGNAL spis0_oe          : std_logic;
	signal AD1939_spi_clatch_counter    : std_logic_vector(16 downto 0) := (others => '0');  							--! AD1939 SPI signal = ss_n: slave select (active low)

	SIGNAL i2c_0_i2c_serial_sda_in		: std_logic;
	SIGNAL i2c_serial_scl_in				: std_logic;
	SIGNAL i2c_serial_sda_oe				: std_logic;
	SIGNAL serial_scl_oe						: std_logic;

	signal cnt : integer := 0;
--	attribute keep of cnt: integer is true;
BEGIN

   ------------------------------------------------------------------------------------------
    -- PLL reset
   ------------------------------------------------------------------------------------------
    PROCESS(clk_25mhz_fpga)
       BEGIN
          IF(rising_edge(clk_25mhz_fpga)) THEN
              sb_rst <=  '0';
          END IF;
    END PROCESS;

   ------------------------------------------------------------------------------------------
   -- PLL (inclock=25MHz)
   --  c0 : 100.0MHz (must be consistent with C_SYS_CLK_PERIOD)
   ------------------------------------------------------------------------------------------
   i_pll_sys : entity pll_sys.pll_sys port map
       ( locked   => sb_pll_locked     -- out std_logic        -- locked.export
       , outclk_0 => s_sys_clk         -- out std_logic        -- outclk0.clk
       , refclk   => clk_25mhz_fpga    -- in  std_logic := '0' -- refclk.clk
       , rst      => sb_rst            -- in  std_logic := '0' -- reset.reset
   );

   ------------------------------------------------------------------------------------------
   -- Delayed reset.
   ------------------------------------------------------------------------------------------
   i_delayed_rst : entity WORK.delayed_rst generic map
       ( NB_BITS   => C_RST_DELAY_NB_BITS          --     integer   := 2   -- number of bits for the internal counter. Ex. 2 will generate a 2**NB_BITS+3 cycles reset
   ) port map
       ( in_rst    => lnk_m2f_rst                  -- in  std_logic := '0' -- asynchronous active high reset (choose only one between active low or high reset).
       , out_clk   => clk_25mhz_fpga               -- in  std_logic        -- clock used to synchronize reset and for counter
       , out_rst   => sb_rst_dly                   -- out std_logic        -- synchronous de-asserted active high reset
   );

   ------------------------------------------------------------------------------------------
   -- Generate reset
   ------------------------------------------------------------------------------------------
   i_sync_rst : entity WORK.sync_rst generic map
       ( NB_RESET      => 1                --     integer                               := 1             -- number of reset to synchronize
   ) port map
       ( in_com_rst    => sb_rst_dly       -- in  std_logic                             := '0'           -- asynchronous active high reset  common to all clock domains /!\ choose only one reset source for each output /!\
       , in_rst   (0)  => '0'              -- in  std_logic_vector(NB_RESET-1 downto 0) := (others=>'0') -- asynchronous active high resets                            /!\ choose only one reset source for each output /!\
       , out_clk  (0)  => s_sys_clk        -- in  std_logic_vector(NB_RESET-1 downto 0)                  -- clocks used to synchronize resets
       , out_rst_n(0)  => s_sys_rstn       -- out std_logic_vector(NB_RESET-1 downto 0)                  -- synchronous de-asserted active low resets
       , out_rst  (0)  => s_sys_rst        -- out std_logic_vector(NB_RESET-1 downto 0)                  -- synchronous de-asserted active high resets
   );

   ------------------------------------------------------------------------------------------
   -- Tick generators and timestamp
   ------------------------------------------------------------------------------------------
   -- 8Hz
   i_tick_gen_8hz : entity WORK.tick_gen generic map
       ( NB_CYCLE    => C_SYS_CLK_FREQUENCY/8      --     integer   := 160000000 -- generate one 'tick' every NB_CYCLE clock periodes
   ) port map
       ( rst         => s_sys_rst                  -- in  std_logic := '0'       -- asynchronous active high reset
       , clk         => s_sys_clk                  -- in  std_logic              -- module and base clock
       , tick        => s_tick_8hz                 -- out std_logic              -- '1' for one cycle
       , tick_toggle => open                       -- out std_logic              -- inverted each time
   );

   PROCESS (s_sys_rst, s_sys_clk)
      BEGIN
         IF(s_sys_rst='1') THEN
            sb_reset_dly    <= (OTHERS=>'1');
         ELSIF(rising_edge(s_sys_clk)) THEN
            IF s_tick_8hz='1' THEN
               sb_reset_dly <= sb_reset_dly(sb_reset_dly'HIGH-1 DOWNTO 0) & '0';
            END IF;
         END IF;
    END PROCESS;


   sb_ddr_rst_n <= not(sb_reset_dly(0)); -- de-assert HPS DDR reset 125ms after reset from M10 (which is de-assert after Si5341 cnfiguration)
   sb_hps_rst_n <= not(sb_reset_dly(1)); -- de-assert HPS     reset 125ms after HPS DDR reset


   u0 : COMPONENT reflex_system
     PORT MAP (

      -- clock and data connections to AD1939
      ad1939_abclk_clk                          =>  AD1939_ADC_ABCLK,
      ad1939_alrclk_clk                         =>  AD1939_ADC_ALRCLK,
      ad1939_mclk_clk                           =>  AD1939_MCLK,
      ad1939_physical_ad1939_adc_asdata1        =>  AD1939_ADC_ASDATA1,
      ad1939_physical_ad1939_adc_asdata2        =>  AD1939_ADC_ASDATA2,
      ad1939_physical_ad1939_dac_dbclk          =>  AD1939_DAC_DBCLK,
      ad1939_physical_ad1939_dac_dlrclk         =>  AD1939_DAC_DLRCLK,
      ad1939_physical_ad1939_dac_dsdata1        =>  AD1939_DAC_DSDATA1,
      ad1939_physical_ad1939_dac_dsdata2        =>  AD1939_DAC_DSDATA2,
      ad1939_physical_ad1939_dac_dsdata3        =>  AD1939_DAC_DSDATA3,
      ad1939_physical_ad1939_dac_dsdata4        =>  AD1939_DAC_DSDATA4,

      ddr4_global_reset_reset_sink_reset_n    => sb_ddr_rst_n,                  -- ddr4_global_reset_reset_sink.reset_n
      ddr4_mem_conduit_end_mem_ck             => hps_ddr4_ck,                   --         ddr4_mem_conduit_end.mem_ck
      ddr4_mem_conduit_end_mem_ck_n           => hps_ddr4_ck_n,                 --                             .mem_ck_n
      ddr4_mem_conduit_end_mem_a              => hps_ddr4_a,                    --                             .mem_a
      ddr4_mem_conduit_end_mem_act_n          => hps_ddr4_act_n,                --                             .mem_act_n
      ddr4_mem_conduit_end_mem_ba             => hps_ddr4_ba,                   --                             .mem_ba
      ddr4_mem_conduit_end_mem_bg             => hps_ddr4_bg,                   --                             .mem_bg
      ddr4_mem_conduit_end_mem_cke            => hps_ddr4_cke,                  --                             .mem_cke
      ddr4_mem_conduit_end_mem_cs_n           => hps_ddr4_cs_n,                 --                             .mem_cs_n
      ddr4_mem_conduit_end_mem_odt            => hps_ddr4_odt,                  --                             .mem_odt
      ddr4_mem_conduit_end_mem_reset_n        => hps_ddr4_reset_n,              --                             .mem_reset_n
      ddr4_mem_conduit_end_mem_par            => hps_ddr4_par,                  --                             .mem_par
      ddr4_mem_conduit_end_mem_alert_n        => hps_ddr4_alert_n,              --                             .mem_alert_n
      ddr4_mem_conduit_end_mem_dqs            => hps_ddr4_dqs,                  --                             .mem_dqs
      ddr4_mem_conduit_end_mem_dqs_n          => hps_ddr4_dqs_n,                --                             .mem_dqs_n
      ddr4_mem_conduit_end_mem_dq             => hps_ddr4_dq,                   --                             .mem_dq
      ddr4_mem_conduit_end_mem_dbi_n          => hps_ddr4_dbi_n,                --                             .mem_dbi_n
      ddr4_oct_conduit_end_oct_rzqin          => hps_ddr4_oct_rzqin,            --         ddr4_oct_conduit_end.oct_rzqin
      ddr4_pll_ref_clk_clock_sink_clk         => hps_ddr4_pll_ref_clk,          --  ddr4_pll_ref_clk_clock_sink.clk
      clk_clk                                 => s_sys_clk,                --                          clk.clk
      reset_reset_n                           => s_sys_rstn,                    --                        reset.reset_n
      hps_f2h_cold_reset_req_reset_n          => sb_hps_rst_n and not(hps_rst), --       hps_f2h_cold_reset_req.reset_n
      hps_f2h_irq0_irq                        => (OTHERS => '0'),               --                 hps_f2h_irq0.irq
      hps_f2h_irq1_irq                        => (OTHERS => '0'),               --                 hps_f2h_irq1.irq
      hps_f2h_warm_reset_req_reset_n          => sb_hps_rst_n and not(hps_rst), --       hps_f2h_warm_reset_req.reset_n
      hps_io_hps_io_phery_sdmmc_CMD           => hps_io_phery_sdmmc_CMD,        --                             .hps_io_phery_sdmmc_CMD
      hps_io_hps_io_phery_sdmmc_D0            => hps_io_phery_sdmmc_D0,         --                             .hps_io_phery_sdmmc_D0
      hps_io_hps_io_phery_sdmmc_D1            => hps_io_phery_sdmmc_D1,         --                             .hps_io_phery_sdmmc_D1
      hps_io_hps_io_phery_sdmmc_D2            => hps_io_phery_sdmmc_D2,         --                             .hps_io_phery_sdmmc_D2
      hps_io_hps_io_phery_sdmmc_D3            => hps_io_phery_sdmmc_D3,         --                             .hps_io_phery_sdmmc_D3
      hps_io_hps_io_phery_sdmmc_D4            => hps_io_phery_sdmmc_D4,         --                             .hps_io_phery_sdmmc_D4
      hps_io_hps_io_phery_sdmmc_D5            => hps_io_phery_sdmmc_D5,         --                             .hps_io_phery_sdmmc_D5
      hps_io_hps_io_phery_sdmmc_D6            => hps_io_phery_sdmmc_D6,         --                             .hps_io_phery_sdmmc_D6
      hps_io_hps_io_phery_sdmmc_D7            => hps_io_phery_sdmmc_D7,         --                             .hps_io_phery_sdmmc_D7
      hps_io_hps_io_phery_sdmmc_CCLK          => hps_io_phery_sdmmc_CCLK,       --                             .hps_io_phery_sdmmc_CCLK
      hps_io_hps_io_phery_emac1_TX_CLK     => hps_io_phery_emac1_TX_CLK,         -- out   std_logic                                        -- hps_io.hps_io_phery_emac1_TX_CLK
      hps_io_hps_io_phery_emac1_TXD0       => hps_io_phery_emac1_TXD0,           -- out   std_logic                                        -- .hps_io_phery_emac1_TXD0
      hps_io_hps_io_phery_emac1_TXD1       => hps_io_phery_emac1_TXD1,           -- out   std_logic                                        -- .hps_io_phery_emac1_TXD1
      hps_io_hps_io_phery_emac1_TXD2       => hps_io_phery_emac1_TXD2,           -- out   std_logic                                        -- .hps_io_phery_emac1_TXD2
      hps_io_hps_io_phery_emac1_TXD3       => hps_io_phery_emac1_TXD3,           -- out   std_logic                                        -- .hps_io_phery_emac1_TXD3
      hps_io_hps_io_phery_emac1_RX_CTL     => hps_io_phery_emac1_RX_CTL,         -- in    std_logic                     := '0'             -- .hps_io_phery_emac1_RX_CTL
      hps_io_hps_io_phery_emac1_TX_CTL     => hps_io_phery_emac1_TX_CTL,         -- out   std_logic                                        -- .hps_io_phery_emac1_TX_CTL
      hps_io_hps_io_phery_emac1_RX_CLK     => hps_io_phery_emac1_RX_CLK,         -- in    std_logic                     := '0'             -- .hps_io_phery_emac1_RX_CLK
      hps_io_hps_io_phery_emac1_RXD0       => hps_io_phery_emac1_RXD0,           -- in    std_logic                     := '0'             -- .hps_io_phery_emac1_RXD0
      hps_io_hps_io_phery_emac1_RXD1       => hps_io_phery_emac1_RXD1,           -- in    std_logic                     := '0'             -- .hps_io_phery_emac1_RXD1
      hps_io_hps_io_phery_emac1_RXD2       => hps_io_phery_emac1_RXD2,           -- in    std_logic                     := '0'             -- .hps_io_phery_emac1_RXD2
      hps_io_hps_io_phery_emac1_RXD3       => hps_io_phery_emac1_RXD3,           -- in    std_logic                     := '0'             -- .hps_io_phery_emac1_RXD3
      hps_io_hps_io_phery_emac1_MDIO       => hps_io_phery_emac1_MDIO,           -- inout std_logic                     := '0'             -- .hps_io_phery_emac1_MDIO
      hps_io_hps_io_phery_emac1_MDC        => hps_io_phery_emac1_MDC,            -- out   std_logic                                        -- .hps_io_phery_emac1_MDC
      hps_io_hps_io_phery_emac2_TX_CLK     => hps_io_phery_emac2_TX_CLK,         -- out   std_logic                                        -- .hps_io_phery_emac2_TX_CLK
      hps_io_hps_io_phery_emac2_TXD0       => hps_io_phery_emac2_TXD0,           -- out   std_logic                                        -- .hps_io_phery_emac2_TXD0
      hps_io_hps_io_phery_emac2_TXD1       => hps_io_phery_emac2_TXD1,           -- out   std_logic                                        -- .hps_io_phery_emac2_TXD1
      hps_io_hps_io_phery_emac2_TXD2       => hps_io_phery_emac2_TXD2,           -- out   std_logic                                        -- .hps_io_phery_emac2_TXD2
      hps_io_hps_io_phery_emac2_TXD3       => hps_io_phery_emac2_TXD3,           -- out   std_logic                                        -- .hps_io_phery_emac2_TXD3
      hps_io_hps_io_phery_emac2_RX_CTL     => hps_io_phery_emac2_RX_CTL,         -- in    std_logic                     := '0'             -- .hps_io_phery_emac2_RX_CTL
      hps_io_hps_io_phery_emac2_TX_CTL     => hps_io_phery_emac2_TX_CTL,         -- out   std_logic                                        -- .hps_io_phery_emac2_TX_CTL
      hps_io_hps_io_phery_emac2_RX_CLK     => hps_io_phery_emac2_RX_CLK,         -- in    std_logic                     := '0'             -- .hps_io_phery_emac2_RX_CLK
      hps_io_hps_io_phery_emac2_RXD0       => hps_io_phery_emac2_RXD0,           -- in    std_logic                     := '0'             -- .hps_io_phery_emac2_RXD0
      hps_io_hps_io_phery_emac2_RXD1       => hps_io_phery_emac2_RXD1,           -- in    std_logic                     := '0'             -- .hps_io_phery_emac2_RXD1
      hps_io_hps_io_phery_emac2_RXD2       => hps_io_phery_emac2_RXD2,           -- in    std_logic                     := '0'             -- .hps_io_phery_emac2_RXD2
      hps_io_hps_io_phery_emac2_RXD3       => hps_io_phery_emac2_RXD3,           -- in    std_logic                     := '0'             -- .hps_io_phery_emac2_RXD3
      hps_io_hps_io_phery_emac2_MDIO       => hps_io_phery_emac2_MDIO,           -- inout std_logic                     := '0'             -- .hps_io_phery_emac2_MDIO
      hps_io_hps_io_phery_emac2_MDC        => hps_io_phery_emac2_MDC,            -- out   std_logic                                        -- .hps_io_phery_emac2_MDC
		hps_io_hps_io_phery_usb1_DATA0       => hps_io_phery_usb1_DATA0,           -- inout std_logic                     := '0'             -- .hps_io_phery_usb1_DATA0
      hps_io_hps_io_phery_usb1_DATA1       => hps_io_phery_usb1_DATA1,           -- inout std_logic                     := '0'             -- .hps_io_phery_usb1_DATA1
      hps_io_hps_io_phery_usb1_DATA2       => hps_io_phery_usb1_DATA2,           -- inout std_logic                     := '0'             -- .hps_io_phery_usb1_DATA2
      hps_io_hps_io_phery_usb1_DATA3       => hps_io_phery_usb1_DATA3,           -- inout std_logic                     := '0'             -- .hps_io_phery_usb1_DATA3
      hps_io_hps_io_phery_usb1_DATA4       => hps_io_phery_usb1_DATA4,           -- inout std_logic                     := '0'             -- .hps_io_phery_usb1_DATA4
      hps_io_hps_io_phery_usb1_DATA5       => hps_io_phery_usb1_DATA5,           -- inout std_logic                     := '0'             -- .hps_io_phery_usb1_DATA5
      hps_io_hps_io_phery_usb1_DATA6       => hps_io_phery_usb1_DATA6,           -- inout std_logic                     := '0'             -- .hps_io_phery_usb1_DATA6
      hps_io_hps_io_phery_usb1_DATA7       => hps_io_phery_usb1_DATA7,           -- inout std_logic                     := '0'             -- .hps_io_phery_usb1_DATA7
      hps_io_hps_io_phery_usb1_CLK         => hps_io_phery_usb1_CLK,             -- in    std_logic                     := '0'             -- .hps_io_phery_usb1_CLK
      hps_io_hps_io_phery_usb1_STP         => hps_io_phery_usb1_STP,             -- out   std_logic                                        -- .hps_io_phery_usb1_STP
      hps_io_hps_io_phery_usb1_DIR         => hps_io_phery_usb1_DIR,             -- in    std_logic                     := '0'             -- .hps_io_phery_usb1_DIR
      hps_io_hps_io_phery_usb1_NXT         => hps_io_phery_usb1_NXT,             -- in    std_logic                     := '0'             -- .hps_io_phery_usb1_NXT
		hps_io_hps_io_phery_uart0_RX         => hps_io_phery_uart0_RX,             -- in    std_logic                     := '0'             -- .hps_io_phery_uart0_RX
      hps_io_hps_io_phery_uart0_TX         => hps_io_phery_uart0_TX,             -- out   std_logic                                        -- .hps_io_phery_uart0_TX
      hps_io_hps_io_phery_uart0_CTS_N      => hps_io_phery_uart0_CTS_N,          -- in    std_logic                     := '0'             -- .hps_io_phery_uart0_CTS_N
      hps_io_hps_io_phery_uart0_RTS_N      => hps_io_phery_uart0_RTS_N,          -- out   std_logic
  		hps_spim1_mosi_o                     => AD1939_spi_CIN,
      hps_spim1_miso_i                     => AD1939_spi_COUT,
      hps_spim1_ss_in_n                    => '1',
      hps_spim1_mosi_oe                    => open,
      hps_spim1_sclk_out_clk               => spis0_CLK,
      hps_spim1_ss0_n_o                    => AD1939_spi_CLATCH_n,                    --                             .ss0_n_o
      hps_spim1_ss1_n_o                    => PREAMP_CS,                    --                             .ss1_n_o
      hps_spim1_ss2_n_o                    => open,                    --                             .ss2_n_o
      hps_spim1_ss3_n_o                    => open,                    --                             .ss3_n_o
      hps_i2c0_scl_in_clk                     => i2c_serial_scl_in,
      hps_i2c0_clk_clk                        => serial_scl_oe,
      hps_i2c0_sda_i                          => i2c_0_i2c_serial_sda_in,
      hps_i2c0_sda_oe                         => i2c_serial_sda_oe,
      rj45_interface_serial_data_in        => mic_array_sdi,        --               rj45_interface.serial_data_in
      rj45_interface_serial_data_out       => mic_array_sdo,       --                             .serial_data_out
      rj45_interface_serial_clk_out        => mic_array_sck         --                             .serial_clk_out
    );


     -- PREAMP_CS <= '0';
--	  spis0_CLK    <= AD1939_spi_CCLK;
	AD1939_spi_CCLK<= spis0_CLK;
--	  spis0_MOSI   <= AD1939_spi_COUT;
--	  AD1939_spi_CIN <= spis0_MISO;
--	  spis0_SS0_N  <= AD1939_spi_CLATCH_n;

  process(clk_25mhz_fpga)
  variable i : integer := 0;
  begin
    if rising_edge(clk_25mhz_fpga) then
      if i < 25000000/2 then
        led_usr_g_n <= '1';
        led_usr_r_n <= '0';
        i := i+1;
      elsif i < 25000000 then
        led_usr_g_n <= '0';
        led_usr_r_n <= '1';
        i := i+1;
      else
        i := 0;
      end if;
    end if;
  end process;

 	-------------------------------------------------------
	-- AD1939
	-------------------------------------------------------
	AD1939_RESET_n <= '1'; -- hold AD1939 out of reset

 	-------------------------------------------------------
	-- TPA6130
	-------------------------------------------------------
  TPA6130_power_off <= '1';  --! Enable the headphone amplifier output

  ---------------------------------------------------------------------------------------------
	-- Tri-state buffer the I2C signals
	---------------------------------------------------------------------------------------------
	  ubuf1 : component alt_iobuf
	  port map(
			  i   => '0',
			  oe  => i2c_serial_sda_oe,
			  io  => TPA6130_i2c_SDA,
			  o   => i2c_0_i2c_serial_sda_in
		 );

		ubuf2 : component alt_iobuf
		 port map(
			  i   => '0',
			  oe  => serial_scl_oe,
			  io  => TPA6130_i2c_SCL,
			  o   => i2c_serial_scl_in
		 );


END ARCHITECTURE;
