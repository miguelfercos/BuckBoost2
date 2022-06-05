LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
use IEEE.STD_logic_unsigned.all;
--library PWM_pkg;
--use PWM_pkg.PWM_package.all;
library work;
use work.PWM_package.all;

 entity incdec_duty is
 port(
 	clk: in std_logic;
	reset: in std_logic;
   incdec: in std_logic; -- if '1' increments, if '0' decrements
   incdec_btn: in std_logic; -- button. when pressed, increments/decrements depending on incdec
   delay_incdec_btn: in std_logic; -- when pressed, increments/decrements delay

	d1d2:in std_logic;
	delay_out: out integer range 0 to 278; -- outputs delay value, sends it to PWM
	sel: in std_logic_vector(1 downto 0);
	d1: out integer range 0 to 279;
   d2: out integer range 0 to 279;
	d1d2_led: out std_logic
 );
 end incdec_Duty;

architecture behavior of incdec_duty is

signal count_init_act, count_init_sig: std_logic := '0';
signal flag_inc: integer:=0;
signal d1_act,d1_sig,d2_act,d2_sig:integer range 0 to 278 ; -- act created to read in the combinatorial section. sig  is for the sequential
signal delay_prev: std_logic_vector (1 downto 0):="00";
signal delay_act, delay_sig: integer range 0 to 278:=30;
signal incdec_prev: std_logic_vector(1 downto 0):="00";
signal mode_act,mode_sig: mode:= idle;

 begin

 CLK_incdec_process: process(reset,clk,sel)
 begin
if (reset='0') then
  incdec_prev <= "00";
  delay_prev <= "00";
  mode_act<= idle;
  case sel is
    when "00" => -- idle

      d1<= dutybuck;
      d1_act<=dutybuck;
      d2<= dutyboost;
      d2_act<=dutyboost;
      delay_act<= delay_min;
      delay_out<= delay_min;
     -- count_init_act='0';
    when "01" => --boost
      d1<= period;
      d1_act<=period;
      d2<= dutyboost;
      d2_act<=dutyboost;
      delay_act<= delay_min;
      delay_out<= delay_min;
	--count_init_act='0';

    when "10" => --buck
      d1<= dutybuck; --start with duty for buck
      d1_act<=dutybuck;
      d2<= period; --
      d2_act<= period;
      delay_act<= delay_min; --delay wth respect to d1
      delay_out<=delay_min;
--count_init_act='0';

    when "11" => --buck-boost
      d1<= dutybuck; --start with duty for buck
      d1_act<=dutybuck;
      d2<= dutyboost; --
      d2_act<= dutyboost;
      delay_act<= delay_min; --delay wth respect to d1
      delay_out<=delay_min;
--count_init_act='0';

    when others=>
      d1<= dutybuck;
      d1_act<=dutybuck;
      d2<= dutyboost;
      d2_act<=dutyboost;
      delay_act<= delay_min;
      delay_out<= delay_min;
--	count_init_act='0';

  end case;



elsif rising_edge(clk) then
   d1 <= d1_sig;
   d1_act<=d1_sig; --created so that combinatorial PROCESS CAN READ output.
   d2 <= d2_sig;
   d2_act<=d2_sig;--created so that combinatorial PROCESS CAN READ output.
   incdec_prev<=incdec_prev(0) & incdec_btn;
   delay_prev <= delay_prev(0) & delay_incdec_btn;

   delay_out<= delay_sig;
   delay_act<=delay_sig; --created so that combinatorial PROCESS CAN READ output.
--	count_init_act<= count_init_sig;
	mode_act<=mode_sig;
 end if;
 end process;

increase_decrease_duty : process (incdec_prev,mode_act,sel,d1_act,d2_act,incdec,d1d2)
begin
    d1_sig <=d1_act;
    d2_sig<=d2_act;
case mode_act is
	when idle=>
		d1_sig<= dutybuck;
		d2_sig<= dutyboost;

		case sel is
			when "00"=>
				mode_sig<=idle;

			when "01"=>
				mode_sig<=boost;
				d1_sig<=period;
				d2_sig<=dutyboost;
			when "10"=>
				mode_sig<=buck;
				d1_sig<=dutybuck;
				d2_sig<=period;
			when "11"=>
				mode_sig<=buckboost; --these values need to be readjusted
				d1_sig<=dutybuck;
				d2_sig<=dutyboost;
			when others=>
				mode_sig<=idle;
				d1_sig<=duty_min;
				d2_sig<=duty_min;
		end case;
	when buck=>

		d2_sig<= period;

		d1_sig<= d1_act;
    if(incdec_prev="01") then
      if (incdec ='1') then --This means i want to increment value
        --incr(duty_max,duty_min,d1_sig,d1_act,5);

  		  if (d1_act >= duty_max) then --IF 3
  				d1_sig <= duty_min;
  			else --ELSE 3
  				d1_sig<=d1_act+valor;
  			end if;-- end if 3--incr(duty_max,duty_min,d2_sig,d2_act,5);

  	 else
        --decr(duty_max,duty_min,d1_sig,d1_act,5);
  			if (d1_act <= duty_min) then --if 4
  				d1_sig <= duty_max;
  			else --else 4
  				d1_sig<=d1_act-valor;--decr(duty_max,duty_min,d2_sig,d2_act,5);
  			end if;--end if 4

  	 end if;
    end if;

		case sel is
			when "00"=>
				mode_sig<=idle;
				d1_sig<= d1_act;
				d2_sig<= d2_act;
			when "01"=>
				mode_sig<=boost;
				d1_sig<= period;
				d2_sig<= dutyboost;
			when "10"=>
				mode_sig<=buck;
				-- d1 and d2 sig dont need to be updated
			when "11"=>
				mode_sig<=buckboost;
				d1_sig<=dutybuck;
				d2_sig<=dutyboost;
			when others=>
				mode_sig<=idle;
				d1_sig<= duty_min;
				d2_sig<= duty_min;
		end case;

	when boost=>
		d1_sig<= period;
		d2_sig<= d2_act;
    if(incdec_prev="01") then
      if (incdec ='1') then --This means i want to increment value
        --incr(duty_max,duty_min,d2_sig,d2_act,5);
        if (d2_act >= duty_max) then --IF 3
  				d2_sig <= duty_min;
  			else --ELSE 3
  				d2_sig<=d2_act+valor;
  			end if;-- end if 3--incr(duty_max,duty_min,d2_sig,d2_act,5);

  	   else -- else i decrement
        --decr(duty_max,duty_min,d2_sig,d2_act,5);
  		    if (d2_act <= duty_min) then --if 4
  				    d2_sig <= duty_max;
  			  else --else 4
  				     d2_sig<=d2_act-valor;--decr(duty_max,duty_min,d2_sig,d2_act,5);
  			  end if;--end if 4
  	   end if;
    end if;

    case sel is
			when "00"=>
				mode_sig<=idle;
				d1_sig<=d1_act;
				d2_sig<= d2_act;
			when "01"=>
				mode_sig<=boost;

			when "10"=>
				mode_sig<=buck;
				d1_sig<= dutybuck;
				d2_sig<= period;
			when "11"=>
				mode_sig<=buckboost;
				d1_sig<= dutybuck;
				d2_sig<= dutyboost;
			when others=>
				mode_sig<=idle;
				d1_sig<= duty_min;
				d2_sig<= duty_min;
		end case;

	when buckboost=>
		d1_sig<= d1_act;
		d2_sig<= d2_act;
    if(incdec_prev="01") then--if 0
			if(d1d2='1')then  --IF 1-- this means i want to change d2
						d1d2_led<='0';
						if (incdec ='1') then --IF 2 --This means i want to increment value

								if (d2_act >= duty_max) then --IF 3
									d2_sig <= duty_min;
								else --ELSE 3
									d2_sig<=d2_act+valor;
								end if;-- end if 3--incr(duty_max,duty_min,d2_sig,d2_act,5);

						else--else 2
					
								if (d2_act <= duty_min) then --if 4
									d2_sig <= duty_max;
								else --else 4
									d2_sig<=d2_act-valor;--decr(duty_max,duty_min,d2_sig,d2_act,5);
								end if;--end if 4

						end if; --END if 2

			else -- else 1 otherwise i want to change d1
				d1d2_led<='1';
					if (incdec ='1') then -- if 5--This means i want to increment value
						
						if (d1_act >= duty_max) then--if 6
							d1_sig <= duty_min;
							d1d2_led<='0';
						else  --else 6
  				         d1d2_led<='1';
							d1_sig<=d1_act+valor;
							d1d2_led<='0';
						end if;--end if 6 --incr(duty_max,duty_min,d2_sig,d2_act,5);

					else--else 5 -- now i wat to decrement value
						if (d1_act <= duty_min) then --if 7
								d1d2_led<='1';
  					         d1_sig <= duty_max;
						else --else 7
								d1_sig<=d1_act-valor;
								d1d2_led<='0';
						end if;--end if 7 --decr(duty_max,duty_min,d2_sig,d2_act,5);

					end if; --end if 5

			end if;-- end if 1;
   else --else 0
     d1_sig<= d1_act;
     d2_sig<= d2_act;
   end if; --end if 0
		case sel is
			when "00"=>
				mode_sig<=idle;
				d1_sig<= d1_act;
				d2_sig<= d2_act;
			when "01"=>
				mode_sig<=boost;
				d1_sig<= period;
				d2_sig<= dutyboost;
			when "10"=>
				mode_sig<=buck;
				d1_sig<= dutybuck;
				d2_sig<= period;
			when "11"=>
				mode_sig<=buckboost;

			when others=>
				mode_sig<=idle;
				d1_sig<= duty_min;
				d2_sig<= duty_min;
		end case;
end case;
end process;

delay_process: process(delay_act,sel,delay_prev,incdec,d2_act)
BEGIN
if sel ="11" then
if (delay_prev="01") then
  if (incdec ='1') then --This means i want to increment value
			 if (delay_act >= period-d2_act-deadtime1_buckboost-deadtime2_buckboost) then
				delay_sig <= delay_min;
			else
				delay_sig<=delay_act+valor;
			end if;
	 --incr(delay_max,delay_min,delay_sig,delay_act,1);
  else -- i want to decrement value
        if (delay_act <= delay_min+valor) then --if 4
				delay_sig <= period-d2_act-deadtime1_buckboost-deadtime2_buckboost;
			else --else 4
				
				delay_sig<=delay_act-valor;--decr(duty_max,duty_min,d2_sig,d2_act,5);
				
			end if;--end if 4	--decr(delay_max,delay_min,delay_sig,delay_act,1);
  end if;
else
  delay_sig<=delay_act;
end if;
else 
	delay_sig <= delay_min;
end if;
end process;

end behavior;
