LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
use IEEE.STD_logic_unsigned.all;

entity watchdog is
	
	port(clk: in std_logic;
	wdg_reset:in std_logic;
	wdg_out:out std_logic
	);
	end watchdog;
	
architecture behavior of watchdog is
signal countwdg_act,countwdg_sig : integer:=0;
constant period : integer := 278;
constant half_period : integer:= period/2;
begin 

CLK_wdg_process : process (Clk,wdg_reset)
begin
if (wdg_reset ='0') then
countwdg_act<=0;
elsif (clk'event and clk='1') then
countwdg_act <= countwdg_sig;
end if;
end process;

wdg_process: process(countwdg_act)
begin
if (countwdg_act < half_period) then
	wdg_out <= '1';
else
	wdg_out <='0';
end if;

if (countwdg_act >= period) then
	countwdg_sig <= 0;
else
	countwdg_sig <= countwdg_act+1;
end if;
end process;

end behavior;