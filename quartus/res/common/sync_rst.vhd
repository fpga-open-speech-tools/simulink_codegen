----------------------------------------------------------------------------------------------------
-- Copyright (c) ReFLEX CES 1998-2012
--
-- Use of this source code through a simulator and/or a compiler tool
-- is illegal if not authorised through ReFLEX CES License agreement.
----------------------------------------------------------------------------------------------------
-- Project     : 
----------------------------------------------------------------------------------------------------
-- Author      : flavenant@reflexces.com
-- Company     : ReFLEX CES
--               2, rue du gevaudan
--               91047 LISSES
--               FRANCE
--               http://www.reflexces.com
-- Plateforme  : Windows XP
-- Simulator   : Mentor Graphics ModelSim
-- Synthesis   : Quartus II
-- Dependency  :
----------------------------------------------------------------------------------------------------
-- Description :
-- Synchronize reset.
-- Asynchronous assertion, synchronous de-assertion.
--
----------------------------------------------------------------------------------------------------
-- Version      Date            Author              Description
-- 0.1          2011/12/29      FLA                 Creation
-- 0.2          2012/07/12      FLA                 Add multi reset support, but keep a common reset input option.
----------------------------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

entity sync_rst is
    generic (
          NB_RESET              : integer           := 1        -- number of reset to synchronize
    );
    port (
        -- Asynchronous inputs
          in_rst_n              : in    std_logic_vector(NB_RESET-1 downto 0)   := (others=>'1')      -- asynchronous active low resets                             /!\ choose only one reset source for each output /!\
        ; in_rst                : in    std_logic_vector(NB_RESET-1 downto 0)   := (others=>'0')      -- asynchronous active high resets                            /!\ choose only one reset source for each output /!\
        ; in_com_rst_n          : in    std_logic                               :=          '1'       -- asynchronous active low reset  common to all clock domains /!\ choose only one reset source for each output /!\
        ; in_com_rst            : in    std_logic                               :=          '0'       -- asynchronous active high reset common to all clock domains /!\ choose only one reset source for each output /!\
        
        -- Synchronized outputs
        ; out_clk               : in    std_logic_vector(NB_RESET-1 downto 0)                           -- clocks used to synchronize resets
        ; out_rst_n             : out   std_logic_vector(NB_RESET-1 downto 0)                           -- synchronous de-asserted active low resets
        ; out_rst               : out   std_logic_vector(NB_RESET-1 downto 0)                           -- synchronous de-asserted active high resets
    );
end entity sync_rst;

architecture rtl of sync_rst is
	----------------------------------------------------------------
	-- Type declarations
	----------------------------------------------------------------
    
	----------------------------------------------------------------
	-- Function declarations
	----------------------------------------------------------------
    
	----------------------------------------------------------------
	-- Component declarations
	----------------------------------------------------------------
    
	----------------------------------------------------------------
	-- Constant declarations
	----------------------------------------------------------------

	----------------------------------------------------------------
	-- Signal declarations
	----------------------------------------------------------------
    signal s_in_rst_n       : std_logic_vector(NB_RESET-1 downto 0);
    signal s_out_rst_n      : std_logic_vector(NB_RESET-1 downto 0);
    signal s_out_rst        : std_logic_vector(NB_RESET-1 downto 0);
begin
    gen_rst : for i in 0 to NB_RESET-1 generate
        s_in_rst_n(i) <= (in_rst_n(i) and in_com_rst_n) and not(in_rst(i) or in_com_rst);
        process (out_clk(i), s_in_rst_n(i))
        begin
        if s_in_rst_n(i)='0' then 
            s_out_rst_n(i)  <= '0'; out_rst_n(i) <= '0';
            s_out_rst(i)    <= '1'; out_rst(i)   <= '1';
        elsif rising_edge(out_clk(i)) then
            s_out_rst_n(i)  <= '1'; out_rst_n(i) <= s_out_rst_n(i);
            s_out_rst(i)    <= '0'; out_rst(i)   <= s_out_rst(i);
        end if;
        end process;   
    end generate gen_rst;
    
end architecture rtl;
