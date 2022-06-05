
	package PWM_package is
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
		constant d1_max,d2_max,duty_max: integer:= 260;
		constant d1_min,d2_min,duty_min: integer:= 30;
		constant dutybuck: integer := 190; --190;   --235 for vinmax=120V, 190 for vinmax=150 referred to high side switch d= 0.85 approx
		constant dutyboost: integer := 65; --65;  --65 for vinmax=80V, 117 for vinmax=62V. referred to low side switch.
		constant delay_min: integer:=0;
		constant delay_max: integer:=248;
		constant period : integer := 278;
		constant softstart_duty_final: integer := 278;
		constant deadtime1_buck : integer:= 7;
		constant deadtime2_buck : integer:= 3;
		constant deadtime1_boost : integer:= 7;
		constant deadtime2_boost : integer:= 3;
		constant deadtime1_buckboost: integer:=7;
		constant deadtime2_buckboost: integer:=3;
		constant valor: integer:=5;
		end package PWM_package;

		package body PWM_package is

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
