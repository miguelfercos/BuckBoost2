LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
use IEEE.STD_logic_unsigned.all;
--library PWM_pkg;
--use PWM_pkg.PWM_package.all;
use work.PWM_package.all;

entity PWMgeneration_top is
	port(
		reset : in std_logic;
		clk: in std_logic;
	sel: in std_logic_vector(1 downto 0);
		PWM_H1: out std_logic;
		PWM_H1_sens: out std_logic;
		PWM_L1: out std_logic;
		PWM_L1_sens: out std_logic;
		PWM_H2: out std_logic;
		PWM_H2_sens: out std_logic;
		PWM_L2:out std_logic;
		PWM_L2_sens:out std_logic;
		wdg_out:out std_logic;
		set_btn:in std_logic;
		reset_btn:in std_logic;
		set_out: out std_logic;
		reset_out: out std_logic;
		wdg_reset:in std_logic;
   incdec: in std_logic; -- if '1' increments, if '0' decrements
   incdec_btn: in std_logic; -- button. when pressed, increments/decrements depending on incdec
   delay_incdec_btn: in std_logic; -- when pressed, increments/decrements delay
	d1d2:in std_logic;
	d1d2_led:out std_logic
		);
end PWMgeneration_top;

architecture RTL of PWMgeneration_top is 

signal d1 : integer range 0 to 279;
signal d2 : integer range 0 to 279;
signal desfase : integer range 0 to 260;
signal reset_btn_inv : std_logic;
signal set_btn_inv : std_logic;
signal inc_not,dec_not : std_logic;
signal H1sens,L1sens, H2sens,L2sens: std_logic;
signal delay_incdec_btn_not,incdec_btn_not:std_logic;
--signal d1d2_led : std_logic;
component PWM
port(
		reset : in std_logic;
		clk: in std_logic;
		sel: in std_logic_vector(1 downto 0);
		PWM_H1: out std_logic;
		PWM_L1: out std_logic;
		PWM_H2: out std_logic;
		PWM_L2:out std_logic;
		desfase:in integer range 0 to 279;
		d1: integer range 0 to 279;
		d2:integer range 0 to 279
);
end component;

component set_reset
port(clk: in std_logic;
set_btn:in std_logic;
reset_btn:in std_logic;
set_out: out std_logic;
reset_out: out std_logic
);
end component;

component watchdog
	port(clk: in std_logic;
	wdg_reset:in std_logic;
	wdg_out:out std_logic
	);
end component;

component incdec_duty
 port(
   incdec: in std_logic; -- if '1' increments, if '0' decrements
   incdec_btn: in std_logic; -- button. when pressed, increments/decrements depending on incdec
   delay_incdec_btn: in std_logic; -- when pressed, increments/decrements delay
   delay_out: out integer range 0 to 260; -- outputs delay value, sends it to PWM
	d1d2:in std_logic;
	clk: in std_logic;
	reset: in std_logic;
	sel: in std_logic_vector(1 downto 0);
	d1: out integer range 0 to 279;
   d2: out integer range 0 to 279;
	d1d2_led: out std_logic
 );
end component;




begin

reset_btn_inv<= not reset_btn; -- added so that set_btn and reset_btn work with the slide switches instead of
set_btn_inv <= not set_btn; -- the push buttons. same with  inc and dec but the opposite.
delay_incdec_btn_not <= not delay_incdec_btn;
incdec_btn_not <= not incdec_btn;


PWMtest: PWM
port map(
		reset=>reset,
		clk=>clk,
		sel=>sel,
		d1=>d1,
		d2=>d2,
		desfase=>desfase,
		PWM_H1=>H1sens,
		PWM_L1=>L1sens,
		PWM_H2=>H2sens,
		PWM_L2=>L2sens
);
PWM_H1<=H1sens ; --duplicate output for the sake of being able to measure them
PWM_L1<=L1sens ;
PWM_H2<=H2sens ;
PWM_L2<=L2sens ;
PWM_H1_sens<=H1sens ;
PWM_L1_sens<=L1sens ;
PWM_H2_sens<=H2sens ;
PWM_L2_sens<=L2sens ;


set_reset_test: set_reset
port map(
clk=>clk,
set_btn=>set_btn_inv,
reset_btn=>reset_btn_inv,
set_out=>set_out,
reset_out=>reset_out
);

watchdog_test: watchdog
port map(
clk=>clk,
	wdg_reset=>wdg_reset,
	wdg_out=>wdg_out
);

incdecdutytest: incdec_duty
port map(
		reset=>reset,
		incdec_btn=>incdec_btn_not,
		incdec=>incdec,
		sel=>sel,
		clk=>clk,
		d1=>d1,
		d2=>d2,
		delay_out=>desfase,
		delay_incdec_btn=>delay_incdec_btn_not,
		d1d2=>d1d2,
		d1d2_led=>d1d2_led
);

end RTL;
