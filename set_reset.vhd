LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
use IEEE.STD_logic_unsigned.all;

entity set_reset is
port(clk: in std_logic;
set_btn:in std_logic;
reset_btn:in std_logic;
set_out: out std_logic;
reset_out: out std_logic
);
end set_reset;
architecture behavior of set_reset is
signal countreset_act, countset_act, countset_sig, countreset_sig : integer range 0 to 500001:=0;
signal reset_flag,set_flag : std_logic:='0';
begin


	set_process: process(set_btn, countset_act,set_flag)
	begin
		if ((set_btn)='0') then
			set_flag <='1';
			
			set_out <= '1';
			if countset_act>=500000 then
				countset_sig<=0;
			else
			countset_sig <= countset_act+1;
			end if;
		else
			if (countset_act) < 500000 and set_flag = '1' then
			set_out <='1';
			countset_sig <= countset_act+1;
			set_flag <='1';
			else
			set_out <='0';
			countset_sig <= 0;
			set_flag <='0';
		end if;
		end if;
	end process;

	reset_process: process(reset_btn,countreset_act,reset_flag)
	begin
		if ((reset_btn)='0') then

			countreset_sig <= countreset_act+1;
			reset_out <= '1';
			reset_flag <= '1';
						if countreset_act>=500000 then
				countreset_sig<=0;
			else
			countreset_sig <= countreset_act+1;
			end if;
		else
			if (countreset_act) < 500000 and reset_flag ='1' then
			reset_out <='1';
			countreset_sig <= countreset_act+1;
			reset_flag <='1';
			else
			reset_out <='0';
			countreset_sig <= 0;
			reset_flag <='0';
		end if;
		end if;
		end process;

CLK_set_reset_process : process (Clk)
begin
if (clk'event and clk='1') then
countset_act <= countset_sig;
countreset_act <= countreset_sig;
end if;
end process;

end;