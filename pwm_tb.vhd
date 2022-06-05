LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity PWM_tb is
end PWM_tb;


architecture TestBench of PWM_tb is

 signal Reset    : std_logic;
 signal Clk      : std_logic;
 signal PWM_L1,PWM_H1, PWM_L2, PWM_H2, PWM_L1_sens,PWM_H1_sens, PWM_L2_sens, PWM_H2_sens	: std_logic;
 signal sel : std_logic_vector(1 downto 0);
 signal d1,d2: integer range 0 to 279;
 signal desfase: integer range 0 to 278;
 begin  -- TestBench

 UUTpwm: entity work.PWM
   port map (
		reset =>reset,
		clk => clk ,
		sel => sel,
		PWM_H1 => PWM_H1 , 
		PWM_L1 => PWM_L1 ,
		PWM_H2 => PWM_H2 ,
		PWM_L2 => PWM_L2,
		d1 =>d1,
		d2=>d2,
		desfase =>desfase
    );


 Reset <= '0', '1' after 100 ns,'0' after 299 ms, '1' after 301 ms, '0' after 499 ms, '1' after 501 ms;

 sel <= "10","01" after 300 ms,"11" after 500 ms;
 p_clk : PROCESS
 BEGIN
    clk <= '1', '0' after 10 ns;
    wait for 20 ns;
 END PROCESS;
 
 d1 <= 190, 150 after 410 ms ;
d2 <= 65, 35 after 390 ms;
desfase <= 0, 35 after 450 ms;


end TestBench;
