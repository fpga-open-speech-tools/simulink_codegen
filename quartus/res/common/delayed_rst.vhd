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
-- Synchronize reset and generate a 'long' reset pulse.
-- Asynchronous assertion, synchronous de-assertion.
--
----------------------------------------------------------------------------------------------------
-- Version      Date            Author              Description
-- 0.1          2012/07/17      FLA                 Creation
----------------------------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

entity delayed_rst is
    generic (
          NB_BITS               : integer   := 2        -- number of bits for the internal counter. Ex. 2 will generate a 2**NB_BITS+3 cycles reset
    );
    port (
        -- Asynchronous inputs
          in_rst_n              : in    std_logic   := '1'  -- asynchronous active low reset (choose only one between active low or high reset).
        ; in_rst                : in    std_logic   := '0'  -- asynchronous active high reset (choose only one between active low or high reset).
        
        -- Synchronized outputs
        ; out_clk               : in    std_logic           -- clock used to synchronize reset and for counter
        ; out_rst_n             : out   std_logic           -- synchronous de-asserted active low reset
        ; out_rst               : out   std_logic           -- synchronous de-asserted active high reset
    );
end entity delayed_rst;

architecture rtl of delayed_rst is
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
    signal s_in_rst         : std_logic;
    signal s_int_rst_x      : std_logic;
    signal s_int_rst        : std_logic;
    signal s_cnt            : std_logic_vector(NB_BITS downto 0);
begin
    s_in_rst <= not(in_rst_n) or in_rst;
    
    -- Internal resynchronized reset
    process (out_clk, s_in_rst)
    begin
    if s_in_rst='1' then 
        s_int_rst_x <= '1'; s_int_rst <= '1';
    elsif rising_edge(out_clk) then
        s_int_rst_x <= '0'; s_int_rst <= s_int_rst_x;
    end if;
    end process; 
    
    -- Long reset
    process (out_clk, s_int_rst)
    begin
    if s_int_rst='1' then 
        s_cnt       <= (others=>'0');
        out_rst     <= '1';
        out_rst_n   <= '0';
    elsif rising_edge(out_clk) then
        if s_cnt(s_cnt'high)='0' then s_cnt <= std_logic_vector(unsigned(s_cnt) + 1); end if;
        out_rst     <= not(s_cnt(s_cnt'high));
        out_rst_n   <=     s_cnt(s_cnt'high);
    end if;
    end process; 
    
end architecture rtl;
