-------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jaden Zwicker
-- 
-- Module Name: LedWave - LedWave_ARCH
-- 
-- Description:
-- LED wave pattern for BASYS3 board. To be set as new default.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LedWave is
    port(
        reset: in  std_logic;
        clock: in  std_logic;
        leds:  out std_logic_vector(15 downto 0)
    );
end LedWave;

architecture LedWave_ARCH of LedWave is

    -- Defining general constants
    constant ACTIVE: std_logic := '1';
    constant COUNT_4HZ: integer := (100000000/4)-1;
    
    -- Defining Constants for led illumination values
    constant BLANK_LEDS: std_logic_vector(15 downto 0) := "0000000000000000";
    constant LEFT_LEDS:  std_logic_vector(15 downto 0) := "1000000000000000";
    constant POS1_LEDS:  std_logic_vector(15 downto 0) := "1100000000000000";
    constant POS2_LEDS:  std_logic_vector(15 downto 0) := "0110000000000000";
    constant POS3_LEDS:  std_logic_vector(15 downto 0) := "0011000000000000";
    constant POS4_LEDS:  std_logic_vector(15 downto 0) := "0001100000000000";
    constant POS5_LEDS:  std_logic_vector(15 downto 0) := "0000110000000000";
    constant POS6_LEDS:  std_logic_vector(15 downto 0) := "0000011000000000";
    constant POS7_LEDS:  std_logic_vector(15 downto 0) := "0000001100000000";
    constant POS8_LEDS:  std_logic_vector(15 downto 0) := "0000000110000000";
    constant POS9_LEDS:  std_logic_vector(15 downto 0) := "0000000011000000";
    constant POS10_LEDS: std_logic_vector(15 downto 0) := "0000000001100000";
    constant POS11_LEDS: std_logic_vector(15 downto 0) := "0000000000110000";
    constant POS12_LEDS: std_logic_vector(15 downto 0) := "0000000000011000";
    constant POS13_LEDS: std_logic_vector(15 downto 0) := "0000000000001100";
    constant POS14_LEDS: std_logic_vector(15 downto 0) := "0000000000000110";
    constant POS15_LEDS: std_logic_vector(15 downto 0) := "0000000000000011";
    constant RIGHT_LEDS: std_logic_vector(15 downto 0) := "0000000000000001";
    
    -- Right and left states contain one led lit at the left and rightmost postion.
    -- All other states contain 2 lit leds scrolling accross the panel from
    -- left to right.
    type States_t is (BLANK, LEFT, POS1, POS2, POS3, POS4, POS5, POS6, POS7, POS8,
                       POS9, POS10, POS11, POS12, POS13, POS14, RIGHT);
                       
    -- Creating signals for state machine, of type States_t which is all
    -- possible states. 
    signal currentState: States_t;
    signal nextState: States_t;
    
    -- Creating pulse signal to active state machine due to clock speed = 100MHz
    signal pulse: std_logic;
    
begin
    
    STATE_REGISTER: process(reset, clock)
    begin
        if (reset=ACTIVE) then
            currentState <= BLANK;
        elsif (rising_edge(clock)) then
            currentState <= nextState;
        end if;
    end process;
    
    STATE_TRANSITION: process(currentState, pulse)
    begin
        case CurrentState is
            -- BLANK
            when BLANK =>
            leds <= BLANK_LEDS;
            nextState <= LEFT;
            --------------------------------------------------------CENTER
            when CENTER =>
            leds <= INSIDE_LEDS;
            if (ledControl=ACTIVE) then
            nextState <= OUT1;
            else
            nextState <= CENTER;
            end if;
            ----------------------------------------------------------OUT1
            when OUT1 =>
            leds <= MID_IN_LEDS;
            
            if (ledControl=ACTIVE) then
            nextState <= OUT2;
            else
            nextState <= OUT1;
            end if;
            ---------------------------------------------------------OUT2
            when OUT2 =>
            leds <= MID_OUT_LEDS;
            if (ledControl=ACTIVE) then
            nextState <= OUTSIDE;
            else
            nextState <= OUT2;
            end if;
            ------------------------------------------------------OUTSIDE
            when OUTSIDE =>
            leds <= OUTSIDE_LEDS;
            if (ledControl=ACTIVE) then
            nextState <= IN1;
            else
            nextState <= OUTSIDE;
            end if;
            ----------------------------------------------------------IN1
            when IN1 =>
            leds <= MID_OUT_LEDS;
            if (ledControl=ACTIVE) then
            nextState <= IN2;
            else
            nextState <= IN1;
            end if;
            ----------------------------------------------------------IN2
            when IN2 =>
            leds <= MID_IN_LEDS;
            
            if (ledControl=ACTIVE) then
            nextState <= CENTER;
            else
            nextState <= IN2;
            end if;
        end case;
    end process;
    
    PULSE_GENERATOR: process(reset, clock)
    variable count: integer range 0 to COUNT_4HZ;
    begin
        -- Control count variables incrementation and reset
        if (reset = ACTIVE) then
            count := 0;
        elsif (rising_edge(clock)) then
            if (count = COUNT_4HZ) then
                count := 0;
            else
                count := count + 1;
            end if;
        end if;
        
        -- Update pulse depending on counts value
        pulse <= not ACTIVE;                                    -- default case
        if (count = COUNT_4HZ) then
            pulse <= ACTIVE;
        end if;
    end process PULSE_GENERATOR;
end LedWave_ARCH;

