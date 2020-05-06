------------------------------------------------------------------------------
-- Copyright 2018                                          iWavesystems Technologies Pvt. Ltd.
-- iWave Confidential Proprietary
------------------------------------------------------------------------------
-- Title       : Top Module for Arria 10 SX
-- Design      : GPIO
-- File        : hps_top.v
------------------------------------------------------------------------------
-- Version     : Ver 1.0
-- Generated   : 18/10/2018
-- Author      : Tushar Sharma                                          Tyler Davis
------------------------------------------------------------------------------
--  Description :
--      * Top wrapper for SoC system
--      * Added GPIO Controller
--      * Added Transceiver Interfaces
--      * Added SATA Interface
--      * Ported to VHDL from Verilog
------------------------------------------------------------------------------

LIBRARY IEEE ;                      --! Use standard library.
USE     IEEE.STD_LOGIC_1164.ALL;    --! Use standard logic elements.
USE     IEEE.NUMERIC_STD.ALL ;      --! Use numeric standard

LIBRARY altera;
USE altera.altera_primitives_components.all;

library pll;

ENTITY A10SoM_System IS
  PORT(
  
    -- FPGA clock
    fpga_clk_i                        : in std_logic;   -- 50 Mhz FPGA user clock
    clk_200                           : in std_logic;   -- 300 Mhz FPGA DDR Clock
    ddr_ref_clk_i                     : in std_logic;   -- 300 Mhz HPS DDR Clock
    sys_reset_n_i                     : in std_logic;   -- Active low system reset
  
    hps_memory_mem_act_n              : out std_logic;                             
    hps_memory_mem_bg                 : out std_logic;                          
    hps_memory_mem_par                : out std_logic;                           
    hps_memory_mem_alert_n            : in std_logic;                              
    hps_memory_mem_dbi_n              : inout std_logic_vector(4 downto 0);                            
  
    hps_memory_mem_a                  : out std_logic_vector(16 downto 0);                      
    hps_memory_mem_ba                 : out std_logic_vector(1 downto 0);                        
    hps_memory_mem_ck                 : out std_logic;                        
    hps_memory_mem_ck_n               : out std_logic;                          
    hps_memory_mem_cke                : out std_logic;                         
    hps_memory_mem_cs_n               : out std_logic;                          
    hps_memory_mem_reset_n            : out std_logic;                             

    hps_memory_mem_dq                 : inout std_logic_vector(39 downto 0);                          
    hps_memory_mem_dqs                : inout std_logic_vector(4 downto 0);                           
    hps_memory_mem_dqs_n              : inout std_logic_vector(4 downto 0);                             
    hps_memory_mem_odt                : out std_logic;                         
    hps_memory_oct_rzqin              : in std_logic;                            
    
    -- FPGA DDR memory controller ports
    FPGA_memory_mem1_ck               : out std_logic;                          
    FPGA_memory_mem1_ck_n             : out std_logic;                            
    FPGA_memory_mem1_a                : out std_logic_vector(16 downto 0);                          
    FPGA_memory_mem1_act_n            : out std_logic;                             
    FPGA_memory_mem1_ba               : out std_logic_vector(1 downto 0);                           
    FPGA_memory_mem1_bg               : out std_logic;                           
    FPGA_memory_mem1_cke              : out std_logic;                            
    FPGA_memory_mem1_cs_n             : out std_logic;                             
    FPGA_memory_mem1_odt              : out std_logic;                            
    FPGA_memory_mem1_reset_n          : out std_logic;                                
    FPGA_memory_mem1_par              : out std_logic;                            

    FPGA_memory_mem1_alert_n          : in std_logic := '0';                                 
    FPGA_memory_mem1_dqs              : inout std_logic_vector(7 downto 0);                             
    FPGA_memory_mem1_dqs_n            : inout std_logic_vector(7 downto 0);                               
    FPGA_memory_mem1_dq               : inout std_logic_vector(63 downto 0);                            
    FPGA_memory_mem1_dbi_n            : inout std_logic_vector(7 downto 0);                               
    FPGA_memory_oct1_rzqin            : in std_logic;                              
        
    -- HPS peripherals                                 
    hps_emac1_TX_CLK                  : out std_logic;                         
    hps_emac1_TXD0                    : out std_logic;                       
    hps_emac1_TXD1                    : out std_logic;                       
    hps_emac1_TXD2                    : out std_logic;                       
    hps_emac1_TXD3                    : out std_logic;                       
    hps_emac1_RXD0                    : in std_logic;                       
    hps_emac1_MDIO                    : inout std_logic;                       
    hps_emac1_MDC                     : out std_logic;                      
    hps_emac1_RX_CTL                  : in std_logic;                         
    hps_emac1_TX_CTL                  : out std_logic;                         
    hps_emac1_RX_CLK                  : in std_logic;                         
    hps_emac1_RXD1                    : in std_logic;                       
    hps_emac1_RXD2                    : in std_logic;                       
    hps_emac1_RXD3                    : in std_logic;                       
    hps_usb1_D0                       : inout std_logic;                    
    hps_usb1_D1                       : inout std_logic;                    
    hps_usb1_D2                       : inout std_logic;                    
    hps_usb1_D3                       : inout std_logic;                    
    hps_usb1_D4                       : inout std_logic;                    
    hps_usb1_D5                       : inout std_logic;                    
    hps_usb1_D6                       : inout std_logic;                    
    hps_usb1_D7                       : inout std_logic;                    
    hps_usb1_CLK                      : in std_logic;                     
    hps_usb1_STP                      : out std_logic;                     
    hps_usb1_DIR                      : in std_logic;                     
    hps_usb1_NXT                      : in std_logic;                     
    hps_uart1_RX                      : in std_logic;                     
    hps_uart1_TX                      : out std_logic;                     
    hps_i2c0_SDA                      : inout std_logic;                     
    hps_i2c0_SCL                      : inout std_logic;                     
    hps_sdio_CMD                      : inout std_logic;                     
    hps_sdio_CLK                      : out std_logic;                     
    hps_sdio_D0                       : inout std_logic;                    
    hps_sdio_D1                       : inout std_logic;                    
    hps_sdio_D2                       : inout std_logic;                    
    hps_sdio_D3                       : inout std_logic;                    
    hps_gpio2_GPIO6                   : inout std_logic;                        
    hps_gpio2_GPIO8                   : inout std_logic;                        
    hps_gpio_GPIO0                    : inout std_logic;                       
    hps_gpio_GPIO1                    : inout std_logic;                       
    hps_gpio_GPIO2                    : inout std_logic;                       
    hps_gpio_GPIO3                    : inout std_logic;                       
    hps_gpio_GPIO6                    : inout std_logic;                       
    hps_gpio_GPIO7                    : inout std_logic;                       
    hps_gpio_GPIO10                   : inout std_logic;                        
    hps_gpio_GPIO11                   : inout std_logic;                        
    hps_gpio_GPIO12                   : inout std_logic;                        
    hps_gpio_GPIO13                   : inout std_logic;                        
    hps_gpio_GPIO14                   : inout std_logic;                        
    hps_gpio_GPIO15                   : inout std_logic;                        
    hps_gpio_GPIO16                   : inout std_logic;                        
    hps_gpio_GPIO17                   : inout std_logic;                        
    hps_gpio_GPIO18                   : inout std_logic;                        
    hps_gpio_GPIO19                   : inout std_logic;                        
    hps_gpio_GPIO20                   : inout std_logic;                        
    hps_gpio_GPIO21                   : inout std_logic;                        
    hps_gpio_GPIO22                   : inout std_logic;                        
    hps_gpio_GPIO23                   : inout std_logic;                        
        
    -- GPIO Interface Signals
    fmc1_inout_pio1                   : inout std_logic_vector(19 downto 0);                         
    fmc1_inout_pio2                   : inout std_logic_vector(19 downto 0);                         
    fmc1_inout_pio3                   : inout std_logic_vector(19 downto 0);                         
    fmc1_inout_pio4                   : inout std_logic_vector(19 downto 0);                         
    fmc1_inout_pio5                   : inout std_logic_vector(19 downto 0);                         
    fmc2_inout_pio6                   : inout std_logic_vector(19 downto 0);                         
    fmc2_inout_pio7                   : inout std_logic_vector(19 downto 0);                         
    pciex4_inout_pio10                : inout std_logic_vector(1 downto 0);                            
    usb_inout_pio11                   : inout std_logic_vector(1 downto 0);                         
    pmod1_inout_pio8                  : inout std_logic_vector(7 downto 0);                          
    pmod2_inout_pio9                  : inout std_logic_vector(7 downto 0);                            
    som_config_pio                    : in std_logic_vector(4 downto 0);                          
        
    -- PCIe Interface Signals
    -- BANK 1C Signals       
    fmc_1C_tx_ch0                     : out std_logic;                        
    fmc_1C_tx_ch1                     : out std_logic;                        
    fmc_1C_tx_ch2                     : out std_logic;                        
    fmc_1C_tx_ch3                     : out std_logic;                        
    fmc_1C_rx_ch0                     : in std_logic;                       
    fmc_1C_rx_ch1                     : in std_logic;                       
    fmc_1C_rx_ch2                     : in std_logic;                       
    fmc_1C_rx_ch3                     : in std_logic;                       
    refclk_1C_p                       : in std_logic;                         -- 125 Mhz Transceiver reference clock
        
    -- BANK 1D Signals  
    fmc_1D_rx_ch0                     : in std_logic;                       
    fmc_1D_rx_ch1                     : in std_logic;                       
    fmc_1D_rx_ch2                     : in std_logic;                       
    fmc_1D_rx_ch3                     : in std_logic;                       
    fmc_1D_tx_ch0                     : out std_logic;                       
    fmc_1D_tx_ch1                     : out std_logic;                       
    fmc_1D_tx_ch2                     : out std_logic;                       
    fmc_1D_tx_ch3                     : out std_logic;                       
    refclk_1D_p                       : in std_logic;                         -- 125 Mhz Transceiver reference clock
        
    -- FMC Interface Signals  
    -- BANK 1E Signals        
    fmc_1E_tx_ch0                     : out std_logic;                       
    fmc_1E_tx_ch1                     : out std_logic;                       
    fmc_1E_tx_ch2                     : out std_logic;                       
    fmc_1E_tx_ch3                     : out std_logic;                       
    fmc_1E_rx_ch0                     : in std_logic;                       
    fmc_1E_rx_ch1                     : in std_logic;                       
    fmc_1E_rx_ch2                     : in std_logic;                       
    fmc_1E_rx_ch3                     : in std_logic;                       
    refclk_1E_p                       : in std_logic;                        -- 125 Mhz Transceiver reference clock
                                        
    -- BANK 1F Signals                  
    fmc_1F_rx_ch0                     : in std_logic;                      
    fmc_1F_rx_ch1                     : in std_logic;                      
    fmc_1F_tx_ch0                     : out std_logic;                       
    fmc_1F_tx_ch1                     : out std_logic;                       
    refclk_1F_p                       : in std_logic;                         -- 125 Mhz Transceiver reference clock
                                        
    -- SFP BANK 1F Signals              
    sfp_1F_rx_ch0                     : in std_logic;                       
    sfp_1F_tx_ch0                     : out std_logic;                       
    sfp_refclk_1F_p                   : in std_logic;                          
                                        
    pcie_npor_pin_perst               : in std_logic;                             
    pcie_rx_i                         : in std_logic;                   
    pcie_tx_o                         : out std_logic;                   
    pcie_refclk_clk                   : in std_logic; -- 125 Mhz PCIeReference clock
    AD1939_MCLK                       : in  std_logic
);

end entity;
-- *****************************************************************************
-- *                 Internal signals and signalisters Declarations                 *
-- *****************************************************************************
ARCHITECTURE A10SoM_System_Arch OF A10SoM_System IS

component som_system is
  port (
    ad1939_abclk_clk                       : in    std_logic                     := 'X';             -- clk
    ad1939_alrclk_clk                      : in    std_logic                     := 'X';             -- clk
    ad1939_mclk_clk                        : in    std_logic                     := 'X';             -- clk
    ad1939_physical_ad1939_adc_asdata1     : in    std_logic                     := 'X';             -- ad1939_adc_asdata1
    ad1939_physical_ad1939_adc_asdata2     : in    std_logic                     := 'X';             -- ad1939_adc_asdata2
    ad1939_physical_ad1939_dac_dbclk       : out   std_logic;                                        -- ad1939_dac_dbclk
    ad1939_physical_ad1939_dac_dlrclk      : out   std_logic;                                        -- ad1939_dac_dlrclk
    ad1939_physical_ad1939_dac_dsdata1     : out   std_logic;                                        -- ad1939_dac_dsdata1
    ad1939_physical_ad1939_dac_dsdata2     : out   std_logic;                                        -- ad1939_dac_dsdata2
    ad1939_physical_ad1939_dac_dsdata3     : out   std_logic;                                        -- ad1939_dac_dsdata3
    ad1939_physical_ad1939_dac_dsdata4     : out   std_logic;                                        -- ad1939_dac_dsdata4
    addr_sel_in_add_sel                    : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- add_sel
    clk_100_clk                            : in    std_logic                     := 'X';             -- clk
    ddr_ref_clk_clk                        : in    std_logic                     := 'X';             -- clk
    emif_0_global_reset_n_reset_n          : in    std_logic                     := 'X';             -- reset_n
    emif_a10_hps_0_global_reset_reset_sink_reset_n : in    std_logic                     := 'X';             -- reset_n
    emif_0_mem_mem_ck                      : out   std_logic                     := 'X';                     -- mem_ck
    emif_0_mem_mem_ck_n                    : out   std_logic                     := 'X';                     -- mem_ck_n
    emif_0_mem_mem_a                       : out   std_logic_vector(16 downto 0);                    -- mem_a
    emif_0_mem_mem_act_n                   : out   std_logic                     := 'X';                     -- mem_act_n
    emif_0_mem_mem_ba                      : out   std_logic_vector(1 downto 0);                     -- mem_ba
    emif_0_mem_mem_bg                      : out   std_logic                     := 'X';                     -- mem_bg
    emif_0_mem_mem_cke                     : out   std_logic                     := 'X';                     -- mem_cke
    emif_0_mem_mem_cs_n                    : out   std_logic                     := 'X';                     -- mem_cs_n
    emif_0_mem_mem_odt                     : out   std_logic                     := 'X';                     -- mem_odt
    emif_0_mem_mem_reset_n                 : out   std_logic                     := 'X';                     -- mem_reset_n
    emif_0_mem_mem_par                     : out   std_logic                     := 'X';                     -- mem_par
    emif_0_mem_mem_alert_n                 : in    std_logic                     := 'X'; -- mem_alert_n
    emif_0_mem_mem_dqs                     : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dqs
    emif_0_mem_mem_dqs_n                   : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dqs_n
    emif_0_mem_mem_dq                      : inout std_logic_vector(63 downto 0) := (others => 'X'); -- mem_dq
    emif_0_mem_mem_dbi_n                   : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dbi_n
    emif_0_oct_oct_rzqin                   : in    std_logic                     := 'X';             -- oct_rzqin
    emif_0_pll_extra_clk_0_pll_extra_clk_0 : out   std_logic;                                        -- pll_extra_clk_0
    emif_0_pll_locked_pll_locked           : out   std_logic;                                        -- pll_locked
    emif_0_pll_ref_clk_clk                 : in    std_logic                     := 'X';             -- clk
    emif_0_status_local_cal_success        : out   std_logic;                                        -- local_cal_success
    emif_0_status_local_cal_fail           : out   std_logic;                                        -- local_cal_fail
    hps_0_h2f_reset_reset_n                : out   std_logic;                                        -- reset_n
    hps_io_hps_io_phery_emac1_TX_CLK       : out   std_logic;                                        -- hps_io_phery_emac1_TX_CLK
    hps_io_hps_io_phery_emac1_TXD0         : out   std_logic;                                        -- hps_io_phery_emac1_TXD0
    hps_io_hps_io_phery_emac1_TXD1         : out   std_logic;                                        -- hps_io_phery_emac1_TXD1
    hps_io_hps_io_phery_emac1_TXD2         : out   std_logic;                                        -- hps_io_phery_emac1_TXD2
    hps_io_hps_io_phery_emac1_TXD3         : out   std_logic;                                        -- hps_io_phery_emac1_TXD3
    hps_io_hps_io_phery_emac1_RX_CTL       : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RX_CTL
    hps_io_hps_io_phery_emac1_TX_CTL       : out   std_logic;                                        -- hps_io_phery_emac1_TX_CTL
    hps_io_hps_io_phery_emac1_RX_CLK       : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RX_CLK
    hps_io_hps_io_phery_emac1_RXD0         : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RXD0
    hps_io_hps_io_phery_emac1_RXD1         : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RXD1
    hps_io_hps_io_phery_emac1_RXD2         : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RXD2
    hps_io_hps_io_phery_emac1_RXD3         : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RXD3
    hps_io_hps_io_phery_emac1_MDIO         : inout std_logic                     := 'X';             -- hps_io_phery_emac1_MDIO
    hps_io_hps_io_phery_emac1_MDC          : out   std_logic;                                        -- hps_io_phery_emac1_MDC
    hps_io_hps_io_phery_sdmmc_CMD          : inout std_logic                     := 'X';             -- hps_io_phery_sdmmc_CMD
    hps_io_hps_io_phery_sdmmc_D0           : inout std_logic                     := 'X';             -- hps_io_phery_sdmmc_D0
    hps_io_hps_io_phery_sdmmc_D1           : inout std_logic                     := 'X';             -- hps_io_phery_sdmmc_D1
    hps_io_hps_io_phery_sdmmc_D2           : inout std_logic                     := 'X';             -- hps_io_phery_sdmmc_D2
    hps_io_hps_io_phery_sdmmc_D3           : inout std_logic                     := 'X';             -- hps_io_phery_sdmmc_D3
    hps_io_hps_io_phery_sdmmc_CCLK         : out   std_logic;                                        -- hps_io_phery_sdmmc_CCLK
    hps_io_hps_io_phery_usb1_DATA0         : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA0
    hps_io_hps_io_phery_usb1_DATA1         : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA1
    hps_io_hps_io_phery_usb1_DATA2         : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA2
    hps_io_hps_io_phery_usb1_DATA3         : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA3
    hps_io_hps_io_phery_usb1_DATA4         : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA4
    hps_io_hps_io_phery_usb1_DATA5         : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA5
    hps_io_hps_io_phery_usb1_DATA6         : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA6
    hps_io_hps_io_phery_usb1_DATA7         : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA7
    hps_io_hps_io_phery_usb1_CLK           : in    std_logic                     := 'X';             -- hps_io_phery_usb1_CLK
    hps_io_hps_io_phery_usb1_STP           : out   std_logic;                                        -- hps_io_phery_usb1_STP
    hps_io_hps_io_phery_usb1_DIR           : in    std_logic                     := 'X';             -- hps_io_phery_usb1_DIR
    hps_io_hps_io_phery_usb1_NXT           : in    std_logic                     := 'X';             -- hps_io_phery_usb1_NXT
    hps_io_hps_io_phery_uart1_RX           : in    std_logic                     := 'X';             -- hps_io_phery_uart1_RX
    hps_io_hps_io_phery_uart1_TX           : out   std_logic;                                        -- hps_io_phery_uart1_TX
    hps_io_hps_io_phery_i2c0_SDA           : inout std_logic                     := 'X';             -- hps_io_phery_i2c0_SDA
    hps_io_hps_io_phery_i2c0_SCL           : inout std_logic                     := 'X';             -- hps_io_phery_i2c0_SCL
    hps_io_hps_io_gpio_gpio2_io6           : inout std_logic                     := 'X';             -- hps_io_gpio_gpio2_io6
    hps_io_hps_io_gpio_gpio2_io8           : inout std_logic                     := 'X';             -- hps_io_gpio_gpio2_io8
    hps_io_hps_io_gpio_gpio0_io0           : inout std_logic                     := 'X';             -- hps_io_gpio_gpio0_io0
    hps_io_hps_io_gpio_gpio0_io1           : inout std_logic                     := 'X';             -- hps_io_gpio_gpio0_io1
    hps_io_hps_io_gpio_gpio0_io2           : inout std_logic                     := 'X';             -- hps_io_gpio_gpio0_io2
    hps_io_hps_io_gpio_gpio0_io3           : inout std_logic                     := 'X';             -- hps_io_gpio_gpio0_io3
    hps_io_hps_io_gpio_gpio0_io6           : inout std_logic                     := 'X';             -- hps_io_gpio_gpio0_io6
    hps_io_hps_io_gpio_gpio0_io7           : inout std_logic                     := 'X';             -- hps_io_gpio_gpio0_io7
    hps_io_hps_io_gpio_gpio0_io10          : inout std_logic                     := 'X';             -- hps_io_gpio_gpio0_io10
    hps_io_hps_io_gpio_gpio0_io11          : inout std_logic                     := 'X';             -- hps_io_gpio_gpio0_io11
    hps_io_hps_io_gpio_gpio1_io12          : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io12
    hps_io_hps_io_gpio_gpio1_io13          : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io13
    hps_io_hps_io_gpio_gpio1_io14          : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io14
    hps_io_hps_io_gpio_gpio1_io15          : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io15
    hps_io_hps_io_gpio_gpio1_io16          : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io16
    hps_io_hps_io_gpio_gpio1_io17          : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io17
    hps_io_hps_io_gpio_gpio1_io18          : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io18
    hps_io_hps_io_gpio_gpio1_io19          : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io19
    hps_io_hps_io_gpio_gpio1_io20          : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io20
    hps_io_hps_io_gpio_gpio1_io21          : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io21
    hps_io_hps_io_gpio_gpio1_io22          : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io22
    hps_io_hps_io_gpio_gpio1_io23          : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io23
    hps_spim0_mosi_o                       : out   std_logic;                                        -- mosi_o
    hps_spim0_miso_i                       : in    std_logic                     := 'X';             -- miso_i
    hps_spim0_ss_in_n                      : in    std_logic                     := 'X';             -- ss_in_n
    hps_spim0_mosi_oe                      : out   std_logic;                                        -- mosi_oe
    hps_spim0_ss0_n_o                      : out   std_logic;                                        -- ss0_n_o
    hps_spim0_ss1_n_o                      : out   std_logic;                                        -- ss1_n_o
    hps_spim0_ss2_n_o                      : out   std_logic;                                        -- ss2_n_o
    hps_spim0_ss3_n_o                      : out   std_logic;                                        -- ss3_n_o
    hps_spim0_sclk_out_clk                 : out   std_logic;                                        -- clk
    mclk_pll_locked_export                 : out   std_logic;                                        -- export
    mem_mem_ck                             : out   std_logic                     := 'X';                     -- mem_ck
    mem_mem_ck_n                           : out   std_logic                     := 'X';                     -- mem_ck_n
    mem_mem_a                              : out   std_logic_vector(16 downto 0);                    -- mem_a
    mem_mem_act_n                          : out   std_logic                     := 'X';                     -- mem_act_n
    mem_mem_ba                             : out   std_logic_vector(1 downto 0);                     -- mem_ba
    mem_mem_bg                             : out   std_logic                     := 'X';                     -- mem_bg
    mem_mem_cke                            : out   std_logic                     := 'X';                     -- mem_cke
    mem_mem_cs_n                           : out   std_logic                     := 'X';                     -- mem_cs_n
    mem_mem_odt                            : out   std_logic                     := 'X';                     -- mem_odt
    mem_mem_reset_n                        : out   std_logic                     := 'X';                     -- mem_reset_n
    mem_mem_par                            : out   std_logic                     := 'X';                     -- mem_par
    mem_mem_alert_n                        : in    std_logic                     := 'X'; -- mem_alert_n
    mem_mem_dqs                            : inout std_logic_vector(4 downto 0)  := (others => 'X'); -- mem_dqs
    mem_mem_dqs_n                          : inout std_logic_vector(4 downto 0)  := (others => 'X'); -- mem_dqs_n
    mem_mem_dq                             : inout std_logic_vector(39 downto 0) := (others => 'X'); -- mem_dq
    mem_mem_dbi_n                          : inout std_logic_vector(4 downto 0)  := (others => 'X'); -- mem_dbi_n
    oct_oct_rzqin                          : in    std_logic                     := 'X';             -- oct_rzqin
    reset_reset_n                          : in    std_logic                     := 'X';             -- reset_n
    som_config_pio_export                  : inout std_logic_vector(1 downto 0)  := (others => 'X'); -- export
    axi_clk_bridge_in_clk_clk              : in    std_logic                     := 'X'              -- clk
  );
end component som_system;

  signal hps_fpga_reset_n : std_logic;
  signal reset_n : std_logic;
  signal Gen_pass : std_logic;
  signal Gen_fail : std_logic;
  signal Gen_timeout : std_logic;
  signal Cal_success : std_logic;
  signal Cal_success_1 : std_logic;  
  signal Cal_success_2 : std_logic;
  signal Cal_fail : std_logic;
  signal Cal_fail_1 : std_logic;
  signal Cal_fail_2 : std_logic;
  signal ddr_pio : std_logic_vector(1 downto 0) := (others =>'0');
  signal count : integer := 0;
  signal count1 : std_logic;
  signal reset1_n : std_logic;
  signal RESETn : std_logic;
  signal user_clk : std_logic;
  signal locked : std_logic;
  signal ddr_clk : std_logic;
  signal addr_sel : std_logic;  
  signal fmc_1C_rx_parallel_data_ch0 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1C_rx_parallel_data_ch1 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1C_rx_parallel_data_ch2 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1C_rx_parallel_data_ch3 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1C_tx_parallel_data_ch0 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1C_tx_parallel_data_ch1 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1C_tx_parallel_data_ch2 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1C_tx_parallel_data_ch3 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1C_rx_clkout_ch0_clk : std_logic;
  signal fmc_1C_rx_clkout_ch1_clk : std_logic;
  signal fmc_1C_rx_clkout_ch2_clk : std_logic;
  signal fmc_1C_rx_clkout_ch3_clk : std_logic;
  signal fmc_1C_tx_clkout_ch0_clk : std_logic;
  signal fmc_1C_tx_clkout_ch1_clk : std_logic;
  signal fmc_1C_tx_clkout_ch2_clk : std_logic;
  signal fmc_1C_tx_clkout_ch3_clk : std_logic;
  signal fmc_1D_rx_parallel_data_ch0 : std_logic_vector(31 downto 0) := (others => '0');  
  signal fmc_1D_rx_parallel_data_ch1 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1D_rx_parallel_data_ch2 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1D_rx_parallel_data_ch3 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1D_tx_parallel_data_ch0 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1D_tx_parallel_data_ch1 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1D_tx_parallel_data_ch2 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1D_tx_parallel_data_ch3 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1D_rx_clkout_ch0_clk : std_logic;
  signal fmc_1D_rx_clkout_ch1_clk : std_logic;
  signal fmc_1D_rx_clkout_ch2_clk : std_logic;
  signal fmc_1D_rx_clkout_ch3_clk : std_logic;
  signal fmc_1D_tx_clkout_ch0_clk : std_logic;
  signal fmc_1D_tx_clkout_ch1_clk : std_logic;
  signal fmc_1D_tx_clkout_ch2_clk : std_logic;
  signal fmc_1D_tx_clkout_ch3_clk : std_logic;
  signal fmc_1E_rx_parallel_data_ch0 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1E_rx_parallel_data_ch1 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1E_rx_parallel_data_ch2 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1E_rx_parallel_data_ch3 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1E_tx_parallel_data_ch0 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1E_tx_parallel_data_ch1 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1E_tx_parallel_data_ch2 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1E_tx_parallel_data_ch3 : std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1E_rx_clkout_ch0_clk : std_logic;
  signal fmc_1E_rx_clkout_ch1_clk : std_logic;
  signal fmc_1E_rx_clkout_ch2_clk : std_logic;
  signal fmc_1E_rx_clkout_ch3_clk : std_logic;
  signal fmc_1E_tx_clkout_ch0_clk : std_logic;
  signal fmc_1E_tx_clkout_ch1_clk : std_logic;
  signal fmc_1E_tx_clkout_ch2_clk : std_logic;
  signal fmc_1E_tx_clkout_ch3_clk : std_logic;
  signal fmc_1F_rx_parallel_data_ch0: std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1F_rx_parallel_data_ch1: std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1F_tx_parallel_data_ch0: std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1F_tx_parallel_data_ch1: std_logic_vector(31 downto 0) := (others => '0');
  signal fmc_1F_tx_clkout_ch0_clk : std_logic;
  signal fmc_1F_tx_clkout_ch1_clk : std_logic;
  signal fmc_1F_rx_clkout_ch0_clk : std_logic;
  signal fmc_1F_rx_clkout_ch1_clk : std_logic;
  signal sfp_1F_rx_parallel_data_ch0 : std_logic_vector(31 downto 0) := (others => '0');
  signal sfp_1F_tx_parallel_data_ch0 : std_logic_vector(31 downto 0) := (others => '0');
  signal sfp_1F_tx_clkout_ch0_clk : std_logic;   
  signal sfp_1F_rx_clkout_ch0_clk : std_logic;     
  
  signal corectl : std_logic;
  signal eoc_d : std_logic;  
  signal eoc : std_logic;  
  signal tempout: std_logic_vector(9 downto 0) := (others => '0');
  signal en_cntr: integer := 0;
  signal temp_out_hps: std_logic_vector(9 downto 0) := (others => '0');
  signal ddr_reset_clk : std_logic;
  signal temp_sens_clk : std_logic;
  signal activity_led_o : std_logic;
  
  signal coreclk_fanout_reset_n : std_logic;
  signal pcie_sim_ltssmstate: std_logic_vector(4 downto 0) := (others => '0'); 
  signal pcie_eidleinfersel0: std_logic_vector(2 downto 0) := (others => '0');
  signal pcie_powerdown0 : std_logic_vector(1 downto 0) := (others => '0');     
  signal pcie_rxpolarity0 : std_logic;
  signal pcie_txcompl0 : std_logic;
  signal pcie_npor_npor : std_logic;  

  signal reset_signal : std_logic;
  -- signal for connecting example_SM and VS WYISWYG
  signal corectl_signal_vs : std_logic;
  signal reconfig_signal_vs : std_logic;
  signal confin_signal_vs : std_logic;
  signal eos_signal_vs : std_logic;
  signal eos_signal_vs_d : std_logic;  
  signal eoc_signal_vs : std_logic;
  signal eoc_signal_vs_d : std_logic;
  signal dataout_signal_vs  : std_logic_vector(11 downto 0) := (others => '0');-- synthesis keep 
  signal dataout_signal_vs1 : std_logic_vector(11 downto 0) := (others => '0');
  signal vcc0: std_logic_vector(5 downto 0) := (others => '0');
  signal vcc1: std_logic_vector(5 downto 0) := (others => '0');
  signal vcc2: std_logic_vector(5 downto 0) := (others => '0');
  signal vcc3: std_logic_vector(5 downto 0) := (others => '0');
  signal vcc4: std_logic_vector(5 downto 0) := (others => '0');
  signal vcc5: std_logic_vector(5 downto 0) := (others => '0');
  signal vcc6: std_logic_vector(5 downto 0) := (others => '0');
  signal vcc7: std_logic_vector(5 downto 0) := (others => '0');
  signal chsel_signal_vs : std_logic_vector(3 downto 0) := (others => '0');
  signal conv : std_logic_vector(2 downto 0) := (others => '0');           
  signal reset_signal_vs : std_logic;         
  signal enable_cntr : integer := 0;   
  signal vs_reset : std_logic;
  
  signal spi_mosi : std_logic;
  signal spi_miso : std_logic;
  signal spi_clk  : std_logic;
  
  begin 
-- *****************************************************************************
-- *                            Combinational logic                             *
-- *****************************************************************************

  reset_n             <= hps_fpga_reset_n and sys_reset_n_i;
  reset1_n            <= sys_reset_n_i and RESETn;
  ddr_pio             <= Cal_success_2 & Cal_fail_2;
  RESETn              <= count1;
  reset_signal        <= not vs_reset or not locked;
  pcie_npor_npor      <= hps_fpga_reset_n and pcie_npor_pin_perst and reset1_n;
  dataout_signal_vs1  <= dataout_signal_vs; 
  
-- *****************************************************************************
-- *                              Sequential logic                             *
-- *****************************************************************************

  process(ddr_reset_clk, sys_reset_n_i)
  begin 
    if sys_reset_n_i = '0' then 
      count <= 0;
      count1 <= '0';
    elsif rising_edge(ddr_reset_clk) then 
      if count = 16#1000000# then 
        count <= count;
        count1 <= '1';
      else
        count <= count + 1;
      end if;
    end if;
  end process;
 	  
  process(user_clk, sys_reset_n_i) 
  begin 
    if sys_reset_n_i = '0' then 
      Cal_success_1 <= '0';
      Cal_success_2 <= '0';
      Cal_fail_1 <= '0';
      Cal_fail_2 <= '0';
    elsif rising_edge(user_clk) then 
      Cal_success_1 <= Cal_success;
      Cal_success_2 <= Cal_success_1;
      Cal_fail_1 <= Cal_fail;
      Cal_fail_2 <= Cal_fail_1;
    end if;  
  end process;
 
  
-- *******************************************************************************
-- *                              Internal Modules                               *
-- *******************************************************************************

 -- Clock Genereation using PLL
  pll_entity : entity pll.pll port map 
  ( 
    rst       => not sys_reset_n_i,                                         
    refclk    => fpga_clk_i,                                             
    locked    => locked,  
    outclk_0  => user_clk, -- 100 Mhz O/P
    outclk_1  => ddr_reset_clk,                                           -- 266.66 Mhz O/P
    outclk_2  => temp_sens_clk   -- 20 Mhz O/P 
  );
  
   
 -- QSYS Design 
  i0: component som_system
    port map(
    -- Clock
    clk_100_clk                                    => user_clk,                                            
    -- HPS DDR Signals                             
    ddr_ref_clk_clk                                => ddr_ref_clk_i,
    emif_0_global_reset_n_reset_n                  => RESETn,
    emif_0_mem_mem_ck                              => FPGA_memory_mem1_ck,
    emif_0_mem_mem_ck_n                            => FPGA_memory_mem1_ck_n,
    emif_0_mem_mem_a                               => FPGA_memory_mem1_a,
    emif_0_mem_mem_act_n                           => FPGA_memory_mem1_act_n,
    emif_0_mem_mem_ba                              => FPGA_memory_mem1_ba,
    emif_0_mem_mem_bg                              => FPGA_memory_mem1_bg,
    emif_0_mem_mem_cke                             => FPGA_memory_mem1_cke,
    emif_0_mem_mem_cs_n                            => FPGA_memory_mem1_cs_n,
    emif_0_mem_mem_odt                             => FPGA_memory_mem1_odt,
    emif_0_mem_mem_reset_n                         => FPGA_memory_mem1_reset_n,
    emif_0_mem_mem_par                             => FPGA_memory_mem1_par,
    emif_0_mem_mem_alert_n                         => FPGA_memory_mem1_alert_n,
    emif_0_mem_mem_dqs                             => FPGA_memory_mem1_dqs,
    emif_0_mem_mem_dqs_n                           => FPGA_memory_mem1_dqs_n,
    emif_0_mem_mem_dq                              => FPGA_memory_mem1_dq,
    emif_0_mem_mem_dbi_n                           => FPGA_memory_mem1_dbi_n,
    emif_0_oct_oct_rzqin                           => FPGA_memory_oct1_rzqin,
    emif_0_pll_ref_clk_clk                         => clk_200,
    emif_0_status_local_cal_success                => Cal_success,
    emif_0_status_local_cal_fail                   => Cal_fail,
    emif_a10_hps_0_global_reset_reset_sink_reset_n => reset_n,
    hps_0_h2f_reset_reset_n                        => hps_fpga_reset_n,                                         
    
    --HPS PIN Muxing Signals	
    hps_io_hps_io_phery_emac1_TX_CLK               => hps_emac1_TX_CLK,
    hps_io_hps_io_phery_emac1_TXD0                 => hps_emac1_TXD0,                                              
    hps_io_hps_io_phery_emac1_TXD1                 => hps_emac1_TXD1,
    hps_io_hps_io_phery_emac1_TXD2                 => hps_emac1_TXD2,
    hps_io_hps_io_phery_emac1_TXD3                 => hps_emac1_TXD3,                                         
    hps_io_hps_io_phery_emac1_MDIO                 => hps_emac1_MDIO,
    hps_io_hps_io_phery_emac1_MDC                  => hps_emac1_MDC,
    hps_io_hps_io_phery_emac1_RX_CTL               => hps_emac1_RX_CTL,
    hps_io_hps_io_phery_emac1_TX_CTL               => hps_emac1_TX_CTL,
    hps_io_hps_io_phery_emac1_RX_CLK               => hps_emac1_RX_CLK,
    hps_io_hps_io_phery_emac1_RXD0                 => hps_emac1_RXD0,
    hps_io_hps_io_phery_emac1_RXD1                 => hps_emac1_RXD1,
    hps_io_hps_io_phery_emac1_RXD2                 => hps_emac1_RXD2,
    hps_io_hps_io_phery_emac1_RXD3                 => hps_emac1_RXD3,
    hps_io_hps_io_phery_usb1_DATA0                 => hps_usb1_D0,
    hps_io_hps_io_phery_usb1_DATA1                 => hps_usb1_D1,
    hps_io_hps_io_phery_usb1_DATA2                 => hps_usb1_D2,
    hps_io_hps_io_phery_usb1_DATA3                 => hps_usb1_D3,
    hps_io_hps_io_phery_usb1_DATA4                 => hps_usb1_D4,
    hps_io_hps_io_phery_usb1_DATA5                 => hps_usb1_D5,
    hps_io_hps_io_phery_usb1_DATA6                 => hps_usb1_D6,
    hps_io_hps_io_phery_usb1_DATA7                 => hps_usb1_D7,
    hps_io_hps_io_phery_usb1_CLK                   => hps_usb1_CLK,
    hps_io_hps_io_phery_usb1_STP                   => hps_usb1_STP,
    hps_io_hps_io_phery_usb1_DIR                   => hps_usb1_DIR,
    hps_io_hps_io_phery_usb1_NXT                   => hps_usb1_NXT,    
    hps_io_hps_io_phery_uart1_RX                   => hps_uart1_RX,
    hps_io_hps_io_phery_uart1_TX                   => hps_uart1_TX,  
    hps_io_hps_io_phery_sdmmc_CMD                  => hps_sdio_CMD,
    hps_io_hps_io_phery_sdmmc_D0                   => hps_sdio_D0,
    hps_io_hps_io_phery_sdmmc_D1                   => hps_sdio_D1,
    hps_io_hps_io_phery_sdmmc_D2                   => hps_sdio_D2,
    hps_io_hps_io_phery_sdmmc_D3                   => hps_sdio_D3,
    hps_io_hps_io_phery_sdmmc_CCLK                 => hps_sdio_CLK,
    hps_io_hps_io_phery_i2c0_SDA                   => hps_i2c0_SDA,
    hps_io_hps_io_phery_i2c0_SCL                   => hps_i2c0_SCL,                                         
    hps_io_hps_io_gpio_gpio2_io6                   => hps_gpio2_GPIO6,                                         
    hps_io_hps_io_gpio_gpio2_io8                   => hps_gpio2_GPIO8,                                         	 
    hps_io_hps_io_gpio_gpio0_io0                   => hps_gpio_GPIO0,                                         
    hps_io_hps_io_gpio_gpio0_io1                   => hps_gpio_GPIO1,
    hps_io_hps_io_gpio_gpio0_io2                   => hps_gpio_GPIO2,
    hps_io_hps_io_gpio_gpio0_io3                   => hps_gpio_GPIO3,
    hps_io_hps_io_gpio_gpio0_io6                   => hps_gpio_GPIO6,                             
    hps_io_hps_io_gpio_gpio0_io7                   => hps_gpio_GPIO7,                             
    hps_io_hps_io_gpio_gpio0_io10                  => hps_gpio_GPIO10,
    hps_io_hps_io_gpio_gpio0_io11                  => hps_gpio_GPIO11,
    hps_io_hps_io_gpio_gpio1_io12                  => hps_gpio_GPIO12,
    hps_io_hps_io_gpio_gpio1_io13                  => hps_gpio_GPIO13,
    hps_io_hps_io_gpio_gpio1_io14                  => hps_gpio_GPIO14,
    hps_io_hps_io_gpio_gpio1_io15                  => hps_gpio_GPIO15,
    hps_io_hps_io_gpio_gpio1_io16                  => hps_gpio_GPIO16,
    hps_io_hps_io_gpio_gpio1_io17                  => hps_gpio_GPIO17,
    hps_io_hps_io_gpio_gpio1_io18                  => hps_gpio_GPIO18,
    hps_io_hps_io_gpio_gpio1_io19                  => hps_gpio_GPIO19,
    hps_io_hps_io_gpio_gpio1_io20                  => hps_gpio_GPIO20,                             
    hps_io_hps_io_gpio_gpio1_io21                  => hps_gpio_GPIO21,                             
    hps_io_hps_io_gpio_gpio1_io22                  => hps_gpio_GPIO22,                             
    hps_io_hps_io_gpio_gpio1_io23                  => hps_gpio_GPIO23,                                         

    -- FPGA SPI Signals
    hps_spim0_mosi_o                               => spi_mosi,                               --                              hps_spim0.mosi_o
    hps_spim0_miso_i                               => spi_miso,                               --                                       .miso_i
    hps_spim0_ss_in_n                              => '1',                              --                                       .ss_in_n
    hps_spim0_mosi_oe                              => open,                              --                                       .mosi_oe
    hps_spim0_ss0_n_o                              => fmc1_inout_pio3(15), -- AD1939                              --                                       .ss0_n_o
    hps_spim0_ss1_n_o                              => fmc1_inout_pio4(16), -- PGA 2505                             --                                       .ss1_n_o
    hps_spim0_ss2_n_o                              => open,                              --                                       .ss2_n_o
    hps_spim0_ss3_n_o                              => open,                              --                                       .ss3_n_o
    hps_spim0_sclk_out_clk                         => spi_clk,                         --                     hps_spim0_sclk_out.clk
            
            
    -- FPGA DDR Signals
    mem_mem_a                                      => hps_memory_mem_a,
    mem_mem_act_n                                  => hps_memory_mem_act_n,
    mem_mem_par                                    => hps_memory_mem_par,
    mem_mem_alert_n                                => hps_memory_mem_alert_n,
    mem_mem_ba                                     => hps_memory_mem_ba,
    mem_mem_bg                                     => hps_memory_mem_bg,
    mem_mem_ck                                     => hps_memory_mem_ck,
    mem_mem_ck_n                                   => hps_memory_mem_ck_n,
    mem_mem_cke                                    => hps_memory_mem_cke,
    mem_mem_cs_n                                   => hps_memory_mem_cs_n,
    mem_mem_reset_n                                => hps_memory_mem_reset_n,
    mem_mem_dq                                     => hps_memory_mem_dq,
    mem_mem_dqs                                    => hps_memory_mem_dqs,
    mem_mem_dqs_n                                  => hps_memory_mem_dqs_n,
    mem_mem_dbi_n                                  => hps_memory_mem_dbi_n,
    mem_mem_odt                                    => hps_memory_mem_odt,
    oct_oct_rzqin                                  => hps_memory_oct_rzqin,
    reset_reset_n                                  => reset1_n,                                         
    
    -- DDR Clock Mappings
    emif_0_pll_extra_clk_0_pll_extra_clk_0 => ddr_clk,                      
    axi_clk_bridge_in_clk_clk              => ddr_clk,                                             

  -- AD1939 Connections
  ad1939_abclk_clk                          =>  fmc1_inout_pio3(2),   -- Pin 177 connector 2 (FMC1 H5)
  ad1939_alrclk_clk                         =>  fmc1_inout_pio3(12),  -- Pin 146 connector 2 (FMC G22)
  ad1939_mclk_clk                           =>  AD1939_MCLK,          -- Pin 171 connector 2 (FMC G3)
  ad1939_physical_ad1939_adc_asdata1        =>  fmc1_inout_pio4(11),  -- Pin 136 connector 2 (FMC H19)
  ad1939_physical_ad1939_adc_asdata2        =>  fmc1_inout_pio4(12),  -- Pin 138 connector 2 (FMC H20)
  ad1939_physical_ad1939_dac_dbclk          =>  fmc1_inout_pio3(1),   -- Pin 175 connector 2 (FMC H4)
  ad1939_physical_ad1939_dac_dlrclk         =>  fmc1_inout_pio3(9),   -- Pin 164 connector 2 (FMC G18)
  ad1939_physical_ad1939_dac_dsdata1        =>  fmc1_inout_pio4(8),   -- Pin 153 connector 2 (FMC H14)
  ad1939_physical_ad1939_dac_dsdata2        =>  fmc1_inout_pio4(9),   -- Pin 163 connector 2 (FMC H16)
  ad1939_physical_ad1939_dac_dsdata3        =>  fmc1_inout_pio3(7),   -- Pin 148 connector 2 (FMC G15)
  ad1939_physical_ad1939_dac_dsdata4        =>  fmc1_inout_pio3(8),   -- Pin 150 connector 2 (FMC G16) 

  mclk_pll_locked_export                    => open
            
		
  );              

-- TODO: 
--  Add SPI to Qsys system

fmc1_inout_pio4(7) <= '1';   -- AD1939 reset_n      Pin 151  connector 2 (FMC H13)
fmc1_inout_pio4(17) <= '1'; -- TPA630A2 shutdown    Pin 38   connector 1 (FMC H28)

-- fmc1_inout_pio4(16) -- Pre amp CS                Pin 184  connector 2 (FMC H26)
-- fmc1_inout_pio3(15) -- Codec CS                  Pin 44   connector 1 (FMC G27)

spi_miso            <= fmc1_inout_pio3(16); -- FPGA CIN                  Pin 42   connector 1 (FMC G28)
fmc1_inout_pio4(14) <= spi_mosi;            -- FPGA COUT                 Pin 154  connector 2 (FMC H23)
fmc1_inout_pio3(18) <= spi_clk;             -- FPGA CCLK                 Pin 34   connector 1 (FMC G31)

  



end architecture;
