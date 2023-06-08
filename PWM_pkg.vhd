LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
use work.PWM_func.all;	

	package PWM_package is
	--PROCEDURE DIDNT WORK
--		procedure incr( constant max_value: in integer;
--										constant min_value: in integer;
--										signal val_sig: out integer;
--										signal val_act: in integer;
--										constant valor: in integer
--		);
--
--		procedure decr( constant max_value: in integer;
--										constant min_value: in integer;
--										signal val_sig: out integer;
--										signal val_act: in integer;
--										constant valor: in integer
--		);



	 
		type mode is (buck, boost,buckboost,idle);
		type state_type is (idle, buck1,buck2,boost1softs,boost2softs, boost1,boost2,buckboost1);

		constant sel_sw_freq: std_logic:='1';-- '1' if we want 180 kHz, '0' if we want 100kHz	 
	 	constant d1_max,d2_max,duty_max: integer:= sw_freq(sel_sw_freq,470,268);--180 khz ->268--100 khz->470 -> 546;
		constant d1_min,d2_min,duty_min: integer:= sw_freq(sel_sw_freq,10,10);
		constant dutybuck: integer := sw_freq(sel_sw_freq,380,190);-- 100 khz-> 380; --190;   --235 for vinmax=120V, 190 for vinmax=150 referred to high side switch d= 0.85 approx
		constant dutyboost: integer := sw_freq(sel_sw_freq,130,65);-- 100 khz-> 110 --130; --65 for vinmax=80V, 117 for vinmax=62V. referred to low side switch.
		constant delay_min: integer:=sw_freq(sel_sw_freq,0,0);
		constant delay_max: integer:=sw_freq(sel_sw_freq,500,250); --100 khz 470 --180 khz-> 250 --500;
		constant period : integer := sw_freq(sel_sw_freq,500,278); --100 khz 500 --556; 180 kHz-> 278
		constant softstart_duty_final: integer := sw_freq(sel_sw_freq,500,278); -- 100 khz->500 180 kHz->578 556;
		constant deadtime1_buck : integer:= sw_freq(sel_sw_freq,2,2); -- 7 for gan, 17 for si. from low to high low side
		constant deadtime2_buck : integer:= sw_freq(sel_sw_freq,1,1); --3 for gan, 15 for si
		constant deadtime1_boost : integer:= sw_freq(sel_sw_freq,1,1); -- 7 for gan 17 for si
		constant deadtime2_boost : integer:= sw_freq(sel_sw_freq,1,1); -- 3 for gan 15 for si
		constant deadtime1_buckboost: integer:=sw_freq(sel_sw_freq,3,3); -- 7 for gan 17for si
		constant deadtime2_buckboost: integer:=sw_freq(sel_sw_freq,3,3);--(sel_sw_freq,17,17); -- 3 for gan 15for si
		constant valor: integer:=5;
 		
		
		end package PWM_package;

		package body PWM_package is
		
		

	 
--PROCEDURE DIDN'T WORK
--		procedure incr( constant max_value: in integer;
--										constant min_value: in integer;
--										signal val_sig: out integer range 0 to 278;
--										signal val_act: in integer range 0 to 278;
--										constant valor: in integer
--		) is
--		BEGIN
--			if (val_act > max_value) then
--				val_sig <= min_value;
--			else
--				val_sig<=val_act+5;
--			end if;
--	end incr;


--	procedure decr( 			constant max_value: in integer;
--									constant min_value: in integer;
--									signal val_sig: out integer range 0 to 278;
--									signal val_act: in integer range 0 to 278;
--									constant valor: in integer
--	) is
--	BEGIN
--		if (val_act < min_value) then
--			val_sig <= max_value;
--		else
--			val_sig<=val_act-5;
--		end if;
--	end decr;


	end package body PWM_package;
