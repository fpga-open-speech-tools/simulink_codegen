----------------------------------------------------------------------------------------------------
-- Copyright (c) ReFLEX CES 1998-2012
--
-- Use of this source code through a simulator and/or a compiler tool
-- is illegal if not authorised through ReFLEX CES License agreement.
----------------------------------------------------------------------------------------------------
-- Project     : 
----------------------------------------------------------------------------------------------------
-- Top level   : top.vhd
-- File        : tick_gen.vhd
-- Author      : Frederic LAVENANT       flavenant@reflexces.com
-- Company     : ReFLEX CES
--               2, rue du gevaudan
--               91047 LISSES
--               FRANCE
--               http://www.reflexces.com
-- Plateforme  : Windows XP
-- Simulator   : Mentor Graphics ModelSim
-- Synthesis   : 
-- Target      : 
-- Dependency  :
----------------------------------------------------------------------------------------------------
-- Description :
--
-- Generate a one cycle pulse at rate specified by GENERIC
--
----------------------------------------------------------------------------------------------------
-- Version      Date            Author               Description
-- 0.1          2012/01/26      FLA                  Creation
-- 0.2          2012/07/20      FLA                  Add: active high reset
----------------------------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
--use     ieee.std_logic_unsigned.all;

entity tick_gen is
	generic (
          NB_CYCLE                        : integer          := 160000000                          -- generate one 'tick' every NB_CYCLE clock periodes
	);
	port (
	    -- Reset and clocks
          rst                             : in     std_logic := '0'                                -- asynchronous active high reset
        ; rst_n                           : in     std_logic := '1'                                -- asynchronous active low reset
        ; clk                             : in     std_logic                                       -- module and base clock

        -- Output
        ; tick                            : out    std_logic                                       -- '1' for one cycle
        ; tick_toggle                     : out    std_logic                                       -- inverted each time
	);
end entity tick_gen;

architecture rtl of tick_gen is
	----------------------------------------------------------------
	-- Type declarations
	----------------------------------------------------------------

	----------------------------------------------------------------
	-- Function declarations
	----------------------------------------------------------------
    -- Use "local" log2 function to avoid use of package
    function LocalLog2(a : natural) return integer is
        variable i : integer := 0;
    begin
        if a=0 then
            i := 0;
        else
            while (a>2**i) loop
                i := i + 1;
            end loop;
        end if;
        return i;
    end function LocalLog2;
    
	----------------------------------------------------------------
	-- Constant declarations
	----------------------------------------------------------------

	----------------------------------------------------------------
	-- Signal declarations
	----------------------------------------------------------------
    signal s_cnt          : unsigned(LocalLog2(NB_CYCLE)+1 downto 0);
    signal s_tick_toggle  : std_logic;

begin
	proc_count : process (rst, rst_n, clk)
    begin
    if rst_n='0' or rst='1' then
        s_cnt         <= (others=>'0');
        s_tick_toggle <= '0';
    
    elsif rising_edge(clk) then
        if s_cnt(s_cnt'high)='1' then s_cnt <= to_unsigned(NB_CYCLE-2, s_cnt'length);
        else                          s_cnt <= s_cnt - 1;
        end if;
        s_tick_toggle <= s_tick_toggle xor s_cnt(s_cnt'high);
    end if;
    end process proc_count;
    
    tick        <= s_cnt(s_cnt'high);  
    tick_toggle <= s_tick_toggle;

end architecture rtl;

