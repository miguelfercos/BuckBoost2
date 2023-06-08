LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

package PWM_func is


		function sw_freq(sw180k:std_logic; i100k:integer; i180k:integer) return integer;
		
		function max_value(value1:integer; value2:integer) return integer;
		
		end package PWM_func;
		
		

		package body PWM_func is
	
		
		function sw_freq(sw180k:std_logic; i100k:integer; i180k:integer) return integer is
				begin
					if sw180k = '1' then -- this means I'm switching at 180k
						return i180k;
					else
						return i100k;
					end if;
      end function;
	 
	 function max_value(value1:integer; value2:integer) return integer is
		begin
			if value1 > value2 then 
				return value1;
			else 
				return value2;
			end if;
	end function;




	end package body PWM_func;












