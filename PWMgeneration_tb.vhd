LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity PWMgeneration_tb is
end PWMgeneration_tb;


architecture TestBench of PWMgeneration_tb is

 component PWMgeneration_top
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
		d1d2_led: out std_logic
		);
 end component;

 signal Reset    : std_logic;
 signal Clk      : std_logic;
 signal PWM_L1,PWM_H1, PWM_L2, PWM_H2, PWM_L1_sens,PWM_H1_sens, PWM_L2_sens, PWM_H2_sens	: std_logic;
 signal sel : std_logic_vector(1 downto 0);
 signal wdg_out : std_logic;
 signal set_btn: std_logic;
 signal reset_btn: std_logic;
 signal set_out, reset_out: std_logic;
 signal wdg_reset:std_logic;
 signal incdec,incdec_btn,d1d2,delay_incdec_btn: std_logic;
 signal d1d2_led: std_logic;
 
 begin  -- TestBench

 UUT: PWMgeneration_top
   port map (
		reset =>reset,
		clk => clk ,
		sel => sel,
		PWM_H1 => PWM_H1 , 
		PWM_H1_sens => PWM_H1_sens ,
		PWM_L1 => PWM_L1 ,
		PWM_L1_sens => PWM_L1_sens ,
		PWM_H2 => PWM_H2 ,
		PWM_H2_sens =>  PWM_H2_sens ,
		PWM_L2 => PWM_L2,
		PWM_L2_sens => PWM_L2_sens,
		wdg_out => wdg_out,
		set_btn => set_btn,
		reset_btn =>reset_btn,
		set_out => set_out,
		reset_out =>reset_out,
		wdg_reset =>wdg_reset,
		incdec =>incdec,
		incdec_btn => incdec_btn,
		delay_incdec_btn => delay_incdec_btn,
		d1d2 => d1d2,
		d1d2_led=> d1d2_led
    );


 Reset <= '0', '1' after 100 ns,'0' after 299 ms, '1' after 301 ms, '0' after 499 ms, '1' after 501 ms;


 sel <= "10","01" after 300 ms,"11" after 500 ms;
 p_clk : PROCESS
 BEGIN
    clk <= '1', '0' after 10 ns;
    wait for 20 ns;
 END PROCESS;
 
 p_inc_dec: process
  BEGIN
    incdec <= '0', '1' after 20300 us,'0' after 49500 us, '1' after 75000 us, '0' after 99000 us, '1' after 130000 us, '0' after 149 ms, '0' after 175 ms;
   wait for 2000000 us;
 END PROCESS;

p_incdecbtn: process
begin 
incdec_btn <= '0', '1' after 10 ms,'0' after 10500 us, '1' after 20 ms;
wait for 30 ms;
 end process;

p_delay:process
begin 
delay_incdec_btn <= '0';
wait for 30 ms;
delay_incdec_btn <= '0','1' after 50 ms, '0' after 50400 us, '1' after 51 ms,'0' after 60 ms, '1' after 75 ms; 
wait for 80 ms;
end process;

reset_btn <= '1';
set_btn <= '1';
wdg_reset <= '1', '0' after 20 ms;
 d1d2 <= '0', '1' after 300 ms, '0' after 1000 ms;


end TestBench;
