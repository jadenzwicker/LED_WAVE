-------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jaden Zwicker
-- 
-- Module Name: LedWave - LedWave_ARCH
-- 
-- Course Name: CPE 3020/01
-- Lab 2
--
-- Description:
-- This test bench is to fully explore all possible input combinations of 
-- LedWave.vhd. 
--
-- Detailed variable naming explanations and overall function is explained
-- in LedWave.vhd file.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LedWave_TB is
end LedWave_TB;

architecture LedWave_TB_ARCH of LedWave_TB is
    --unit-under-test-------------------------------------COMPONENT
    component LedWave
        port (
            reset:   in   std_logic;
            clock:   in  std_logic;
            leds:    out  std_logic_vector(15 downto 0)
        );
    end component;
    
    --uut-signals-------------------------------------------SIGNALS
    signal reset:   std_logic;
    signal clock:   std_logic;
    signal leds:    std_logic_vector(15 downto 0);
    
    constant NUM_STATES: integer := 18;
    constant ACTIVE:     std_logic := '1';
    
begin
    --Unit-Under-Test-------------------------------------------UUT
    UUT: LedWave port map(
         reset => reset,
         clock => clock,
         leds  => leds
    );
    
    --Switch and Button Driver----------------------------------------PROCESS
    
        TEST_CASE_DRIVER: process
    variable temp_count : integer range 0 to 1000;
    begin
        for i in 0 to 1000 loop
            clock <= not ACTIVE;
              -- ONLY USING ps DUE TO SIMULATION TIMING OUT TOO SOON IF ns USED
            wait for 10 ps;
            clock <= ACTIVE;
            wait for 10 ps;
            temp_count := temp_count + 1;
            if (temp_count / 400 = 1) then
                reset <= ACTIVE;
            else     
                reset <= not ACTIVE;
            end if;
        end loop;
        report "simulation finished successfully" severity FAILURE;
    end process;
end LedWave_TB_ARCH;
