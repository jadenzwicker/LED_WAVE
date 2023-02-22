----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jaden Zwicker
-- 
-- Module Name: LedWave_BASYS3 - LedWave_BASYS3_ARCH
-- 
--      Wrapper file for LedWave component using the basys3 board.
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LedWave_BASYS3 is
    -- Here we define the ports from the default basys3 config file.
    -- Names must match config file names since we are porting from there.
    port (  
           btnC :   in  std_logic;
           clk :    in  std_logic;
           led :    out std_logic_vector (15 downto 0)
    );
end LedWave_BASYS3;

architecture LedWave_BASYS3_ARCH of LedWave_BASYS3 is
    -- This component is used to pull in the ports from the LedWave design.
    component LedWave
        port (
             reset:  in   std_logic;
             clock:  in   std_logic;
             leds:   out  std_logic_vector(15 downto 0)  
        );
    end component;
begin
    -- Mapping the config file pins to the ports in LedWave design.
    MY_DESIGN: LedWave port map (
        reset => btnC,
        clock => clk,
        leds => led
    );
end LedWave_BASYS3_ARCH;