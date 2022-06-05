LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
use IEEE.STD_logic_unsigned.all;
--library PWM_pkg;
use work.PWM_package.all;

entity PWM is
	port(
		reset : in std_logic;
		clk: in std_logic;
		sel: in std_logic_vector(1 downto 0);
		PWM_H1: out std_logic;
		PWM_L1: out std_logic;
		PWM_H2: out std_logic;
		PWM_L2:out std_logic;
		desfase:in integer range 0 to 278;
		d1: in integer range 0 to 279;
		d2:in integer range 0 to 279

		);
end PWM;

architecture behavior of PWM is

signal est_act, est_sig: state_type := idle;



--constant dutybuck_start : integer := 190;
--235 for vinmax=120V, 190 for vinmax=150 referred to high side switch d= 0.85 approx
--constant dutyboost_start: integer := 65;
--65 for vinmax=80V, 117 for vinmax=62V. referred to low side switch. d=0.20 approx


signal countactual1,countactual2: integer:= 0;
signal countsig1,countsig2: integer:= 0;
signal d1_act,d1_sig,d2_act,d2_sig: integer:=15;
signal PWM_H1_sig, PWM_L1_sig , PWM_H2_sig, PWM_L2_sig: std_logic:='0';
signal flagboost,flagbb:std_logic:='0';
--signal dutybuck,dutybuck_sig,dutyboost,dutyboost_sig: integer range 0 to 279:=0;

begin

CLK_process: process (Clk,reset)
begin
if (reset='0') then
	PWM_H1<='0';
	PWM_L1<='0';
	PWM_H2<='0';
	PWM_L2<='0';
	countactual1<=0;
	countactual2<=0;
	est_act<=idle;
	--softstart_duty_act <= 15;
	d1_act<= duty_min;
	d2_act<= duty_min;

elsif rising_edge(Clk) then

	countactual1<=countsig1;
	countactual2<=countsig2;
	PWM_H1<=PWM_H1_sig;
	PWM_L1<=PWM_L1_sig;
	PWM_H2<=PWM_H2_sig;
	PWM_L2<=PWM_L2_sig;
	est_act<=est_sig;
	d1_act<= d1_sig;
	d2_act<= d2_sig;
end if;
end process;



state_process: process(est_act,countactual1,countactual2,sel,d1_act,d1,d2_act,d2,desfase)
begin
		est_sig<=est_act;
		countsig1<=countactual1;
		countsig2<=countactual2;
		d1_sig<=d1_act;
		d2_sig<=d2_act;
		case est_act is
			when idle =>
				PWM_H1_sig<='0';
				PWM_L1_sig<='0';
				PWM_H2_sig<='0';
				PWM_L2_sig<='0';
				d1_sig<=duty_min;
				d2_sig<=duty_min;

				if sel=("01") then
					est_sig <= boost1softs;
				elsif sel=("10") then--boost
					est_sig <= buck1; --this state is a buck mode before reaching boost (sft start purposes))
				elsif sel=("11") then
					est_sig <= boost1softs;
				else
					est_sig<= idle;
					end if;

			when buck1 =>
				PWM_H1_sig<='0'; -- it starts off to avoid inrush
				PWM_L1_sig<='1';
				PWM_H2_sig<='1';
				PWM_L2_sig<='0';
				countsig2<= period;
				if (countactual1 >= period - deadtime2_buck- d1_act - deadtime1_buck) then
					PWM_H1_sig <='0';
					PWM_L1_sig <='0';
					PWM_H2_sig <='1';
					PWM_L2_sig <='0';
					if (countactual1 >= period - d1_act - deadtime1_buck) then
						est_sig <= buck2;
						countsig1 <= countactual1+1;
						--countsig1<=0;
					else
					countsig1 <= countactual1+1;
					end if;
				else
				countsig1 <= countactual1 +1;
			end if;

			when buck2 =>
					PWM_H1_sig<='1';
					PWM_L1_sig<='0';
					PWM_H2_sig<='1';
					PWM_L2_sig<='0';
					countsig2<= period;
				if (countactual1 >= period-deadtime1_buck) then
					PWM_H1_sig<='0';
					PWM_L1_sig<='0';
					PWM_H2_sig<='1';
					PWM_L2_sig<='0';

					if (countactual1 >= period) then
						countsig1 <= 0;
						est_sig<= buck1;
						if (d1_act >= d1) then --softstart section
							d1_sig <= d1;
						else
							d1_sig <= d1_act + 1;
						end if;
					else
						countsig1<=countactual1 + 1;
					end if;
				else
					countsig1 <= countactual1 + 1;
				end if;


				when boost1softs => -- buck mode before going to boost mode
					PWM_H1_sig<='0';
					PWM_L1_sig<='1';
					PWM_H2_sig<='1';
					PWM_L2_sig<='0';

				if (countactual1 >= period-deadtime2_buck-d1_act-deadtime1_buck) then
					PWM_H1_sig <='0';
					PWM_L1_sig <='0';
					PWM_H2_sig <='1';
					PWM_L2_sig <='0';
					if (countactual1 >= period - d1_act- deadtime1_buck) then
						est_sig <= boost2softs;
						countsig1 <= countactual1+1;
						--countsig1<=0;
					else
						countsig1 <= countactual1+1;
					end if;
				else
					countsig1 <= countactual1 +1;
				end if;


				when boost2softs =>
					PWM_H1_sig<='1';
					PWM_L1_sig<='0';
					PWM_H2_sig<='1';
					PWM_L2_sig<='0';
				if (countactual1 >= period-deadtime1_buck) then
					PWM_H1_sig<='0';
					PWM_L1_sig<='0';
					PWM_H2_sig<='1';
					PWM_L2_sig<='0';
					if (countactual1 >= period) then
						countsig1 <= 0;
						if (d1_act >=  d1) then
							d1_sig <= d1;
							d2_sig <= d2_min;
							if sel = "01" then
								est_sig <= boost2;
								
							elsif sel="11" then
								est_sig<= buckboost1;
							else
								est_sig<= idle;
							end if;
						else
							d1_sig <= d1_act + 1;  -- d1 will increase until reaching final value. d2 will be increased upon reaching boost1 bost2 stateds
							d2_sig <= d2_min;
							est_sig <= boost1softs;
						end if;
					else
						countsig1<=countactual1 + 1;
					end if;
				else
					countsig1 <= countactual1 + 1;
				end if;

				when boost1 =>
					PWM_H1_sig<='1';
					PWM_L1_sig<='0';
					PWM_H2_sig<='0';
					PWM_L2_sig<='1';
				if (countactual2 >= d2_act) then
					PWM_H1_sig<='1';
					PWM_L1_sig<='0';
					PWM_H2_sig<='0';
					PWM_L2_sig<='0';
					if (countactual2 >= d2_act+deadtime1_boost) then
						est_sig <= boost2;
						countsig2 <= countactual2+1;
					else
					countsig2 <= countactual2+1;
					end if;
				else
				countsig2 <= countactual2 +1;
				end if;

				when boost2 =>
				PWM_H1_sig<='1';
				PWM_L1_sig<='0';
				PWM_H2_sig<='1';
				PWM_L2_sig<='0';
				if (countactual2 >= period-deadtime2_boost) then
					PWM_H1_sig<='1';
					PWM_L1_sig<='0';
					PWM_H2_sig<='0';
					PWM_L2_sig<='0';
					if (countactual2 >= period) then
						est_sig <= boost1;
						countsig2 <= 0;
						if (d2_act >= d2) then
						d2_sig <= d2;
						else
						d2_sig <= d2_act+1;
						end if;
					else
					countsig2 <= countactual2+1;
					end if;
				else
				countsig2 <= countactual2 +1;
				end if;

				when buckboost1 =>
					est_sig<=buckboost1; -- to avoid latch
					countsig1<=countactual1+1;
					countsig2<=countactual2+1;
					if countactual1 < d1_Act then -- duty 1
						PWM_H1_sig<='1';
						PWM_L1_sig<='0';
					elsif countactual1 >= d1_act and countactual1 < d1_act + deadtime2_buckboost then -- deadtime
						PWM_H1_sig<='0';
						PWM_L1_sig<='0';					
					elsif countactual1 >= d1_act + deadtime2_buckboost and countactual1 < period - deadtime1_buckboost then --(1-duty) 
						PWM_H1_sig<='0';
						PWM_L1_sig<='1';					
					elsif countactual1 >= period - deadtime1_buckboost and countactual1 < period then--deadtime
						PWM_H1_sig<='0';
						PWM_L1_sig<='0';					
					else --
						PWM_H1_sig<='0';
						PWM_L1_sig<='0';
						countsig1<=0;
					end if;

					
--NOW FOR DUTY 2

					if countactual2 < desfase then --desfase
						PWM_H2_sig<='1';
						PWM_L2_sig<='0';					
					
					elsif countactual2 >= desfase and countactual2 < desfase + d2_Act then -- duty 2
						PWM_H2_sig<='0';
						PWM_L2_sig<='1';
					elsif countactual2 >= desfase + d2_Act  and countactual1 < d2_act + desfase + deadtime2_buckboost then -- deadtime
						PWM_H2_sig<='0';
						PWM_L2_sig<='0';					
					elsif countactual2 >= desfase + deadtime2_buckboost +d2_Act and countactual2 < period - deadtime1_buckboost then --(1-duty) 
						PWM_H2_sig<='1';
						PWM_L2_sig<='0';					
					elsif countactual2 >= period - deadtime1_buckboost and countactual1 < period then--deadtime
						PWM_H2_sig<='0';
						PWM_L2_sig<='0';					
					else --
						PWM_H2_sig<='0';
						PWM_L2_sig<='0';
						countsig2<=0;
					end if;
			
						if (d2_act >= d2) then
							d2_sig <= d2;
						else
							d2_sig <= d2_act+1;
						end if;
						
						if d1_act >= d1 then
							d1_sig <= d1;
						else 
							d1_sig <= d1_Act+1;
						end if;
					
--				PWM_H1_sig<='1';
--				PWM_L1_sig<='0';
--				countsig2<=countactual2+1;
--				if (countactual2 < desfase) then
--					PWM_H2_sig<='1';
--					PWM_L2_sig<='0';
--
--				elsif countactual2 >desfase and countactual2 < desfase + deadtime2_buckboost then
--					PWM_H2_sig<='0';
--					PWM_L2_sig<='0';
--				elsif countactual2 >desfase+deadtime2_buckboost and countactual2 < desfase + deadtime2_buckboost + d2_Act then
--					PWM_H2_sig<='0';
--					PWM_L2_sig<='1';
--				else
--					PWM_H2_sig<='0';
--					PWM_L2_sig<='0';
--					if countactual2>=period then
--					countsig2<=0;
--					end if;
--				end if;
--
--			if (countactual1 >= d1_act) then
--				PWM_H1_sig<='0';
--				PWM_L1_sig<='0';
--				if (countactual1 >= d1_act + deadtime1_buckboost) then
--					est_sig <= buckboost2;
--					countsig1 <= countactual1+1;
--				else
--				countsig1 <= countactual1+1;
--				end if;
--			else
--			countsig1 <= countactual1 +1;
--			end if;
--
--
--				when buckboost2 =>
--				PWM_H1_sig<='0';
--				PWM_L1_sig<='1';
--
--				countsig2<=countactual2+1;
--				if (countactual2 <= desfase) then
--					PWM_H2_sig<='1';
--					PWM_L2_sig<='0';
--
--				elsif countactual2>desfase and countactual2 <= desfase + deadtime2_buckboost then
--					PWM_H2_sig<='0';
--					PWM_L2_sig<='0';
--				elsif countactual2>desfase + deadtime2_buckboost and countactual2 <= desfase + deadtime2_buckboost + d2_act then
--					PWM_H2_sig<='0';
--					PWM_L2_sig<='1';
--				else
--					PWM_H2_sig<='0';
--					PWM_L2_sig<='0';
--
--				if countactual2>=period then
--					countsig2<=0;
--					end if;
--			end if;
--				if (countactual1 >= period-deadtime2_boost) then
--					PWM_H1_sig<='0';
--					PWM_L1_sig<='0';
--
--					if (countactual1 >= period) then
--						est_sig <= buckboost1;
--						countsig1 <= 0;
--			
--						if (d2_act >= d2) then
--						d2_sig <= d2;
--						else
--						d2_sig <= d2_act+1;
--						end if;
--					else
--					countsig1 <= countactual1+1;
--					end if;
--				else
--				countsig1 <= countactual1 +1;
--				end if;



		end case;

	end process;

	end behavior;
