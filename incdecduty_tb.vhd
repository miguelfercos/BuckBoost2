LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity incdecduty_tb is
end incdecduty_tb;


architecture TestBench of incdecduty_tb is

 signal Reset    : std_logic;
 signal Clk      : std_logic;
 signal incdec,incdec_btn,delay_incdec_btn,d1d2	: std_logic;
 signal sel : std_logic_vector(1 downto 0);
 signal d1,d2:integer range 0 to 279;
 signal delay_out:integer range 0 to 278;
 begin  -- TestBench

 UUTincdec: entity work.incdec_duty
   port map (
		reset =>reset,
		clk => clk ,
		sel => sel,
		incdec_btn=> incdec_btn,
		delay_incdec_btn => delay_incdec_btn,
		d1d2 => d1d2,
		incdec=> incdec,
		delay_out=>delay_out,
		d1=>d1,
		d2=>d2
    );


 Reset <= '0', '1' after 100 ns;
process
begin
 sel <= "00","10" after 55300 us,"01" after 100300 us,"11" after 153500 us;
wait for 500000 us;
end process;
 
p_clk : PROCESS
 BEGIN
    clk <= '1', '0' after 10 ns;
    wait for 55 ns;
 END PROCESS;
 
 p_inc_dec: process
  BEGIN
    incdec <= '0', '1' after 20300 us,'0' after 49500 us, '1' after 75000 us, '0' after 99000 us, '1' after 130000 us, '0' after 149 ms, '0' after 175 ms;
   wait for 200000 us;
 END PROCESS;

p_incdec_btn: process
begin 
incdec_btn <= '0', '1' after 10 ms,'0' after 10500 us, '1' after 20 ms;
wait for 30 ms;
end process;

process
begin 
delay_incdec_btn <= '0';
wait for 30 ms;
delay_incdec_btn <= '0','1' after 50 ms, '0' after 50400 us, '1' after 51 ms,'0' after 60 ms, '1' after 75 ms; 
wait for 80 ms;
end process;
d1d2 <='0', '1' after 190 ms;  


end TestBench;
