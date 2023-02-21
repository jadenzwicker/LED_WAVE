entity LedPatternScanner is
port(
reset: in std_logic;
clock: in std_logic;
leds: out std_logic_vector(7 downto 0)
);
end LedPatternScanner;
architecture LedPatternScanner_ARCH of LedPatternScanner is
----general definitions--------------------------------------CONSTANTS
constant ACTIVE: std_logic := '1';
constant COUNT_4HZ: integer := (100000000/4)-1;
 ----bar display patterns-------------------------------------CONSTANTS
constant BLANK_LEDS: std_logic_vector(7 downto 0) := "00000000";
constant INSIDE_LEDS: std_logic_vector(7 downto 0) := "00011000";
constant MID_IN_LEDS: std_logic_vector(7 downto 0) := "00100100";
constant MID_OUT_LEDS: std_logic_vector(7 downto 0) := "01000010";
constant OUTSIDE_LEDS: std_logic_vector(7 downto 0) := "10000001";
 ----state-machine-declarations---------------------------------SIGNALS
 type States_t is (BLANK, CENTER, OUT1, OUT2, OUTSIDE, IN1, IN2);
 signal currentState: States_t;
 signal nextState: States_t;

 ----other-internal-signals-------------------------------------SIGNALS
 signal ledControl: std_logic;
begin

--=============================================================PROCESS
-- State register
 --====================================================================
STATE_REGISTER: process(reset, clock)
begin
if (reset=ACTIVE) then
currentState <= BLANK;
elsif (rising_edge(clock)) then
currentState <= nextState;
 end if;
end process;
 --=============================================================PROCESS
 -- State transitions
 --====================================================================
 STATE_TRANSITION: process(currentState, ledControl)
 begin
 case CurrentState is
 ---------------------------------------------------------BLANK
 when BLANK =>
 leds <= BLANK_LEDS;
 nextState <= CENTER;
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
 --==================================================================
 -- Set the blink rate for the 8 LED pattern. The ledControl output
 -- pulses for one clock cycle at a rate of 4 Hz.
 --==================================================================
 BLINK_RATE: process(reset, clock)
 variable count: integer range 0 to COUNT_4HZ;
 begin
 --manage-count-value--------------------------------------------
 if (reset = ACTIVE) then
 count := 0;
 elsif (rising_edge(clock)) then
 if (count = COUNT_4HZ) then
 count := 0;
 else
 count := count + 1;
 end if;
 end if;
 --update-enable-signal-------------------------------------------
 ledControl <= not ACTIVE;
 if (count=COUNT_4HZ) then
 ledControl <= ACTIVE;
 end if;
 end process BLINK_RATE;
end LedPatternScanner_ARCH;

