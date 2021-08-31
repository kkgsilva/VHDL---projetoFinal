library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use ieee.numeric_std.all;

entity projetoFinal is
    port (
		vacinas_data_1, vacinas_data_2, vacinas_data_3, vacinas_data_4, vacinas_data_5: in std_logic;
		clock: in std_logic;
		temp_1, temp_2, temp_3, temp_4, temp_5: in std_logic_vector(15 downto 0) := "0000000000000000";
		sensor_1,sensor_2, sensor_3, sensor_4, sensor_5: in std_logic := '0';
		led_1, led_2, led_3, led_4, led_5: out std_logic_vector(23 downto 0) := x"000000"; -- saida rgb, verificar logica
		mensagem_1, mensagem_2, mensagem_3, mensagem_4, mensagem_5: out std_logic_vector(2 downto 0)
	);
end projetoFinal;


architecture gestao_vacinas of projetoFinal is

signal  padrao_temp_1, padrao_temp_2, padrao_temp_3, padrao_temp_4, padrao_temp_5 : std_logic_vector(15 downto 0);
signal  padrao_temp_1_max, padrao_temp_2_max, padrao_temp_3_max, padrao_temp_4_max, padrao_temp_5_max : std_logic_vector(15 downto 0);	
signal  padrao_temp_1_min, padrao_temp_2_min, padrao_temp_3_min, padrao_temp_4_min, padrao_temp_5_min : std_logic_vector(15 downto 0);

begin
	
------------------------------------------------------------------------------------
----------------- processo do refrigerador 1 
------------------------------------------------------------------------------------
	process(clock, vacinas_data_1)
	
		begin
				if (vacinas_data_1 = '1') then
					report"entrou aqui";
					padrao_temp_1 <= "1111111110110101";	-- revisar complemento de 2/sinal e magnitude
					padrao_temp_1_max <= padrao_temp_1;
					padrao_temp_1_min <= padrao_temp_1;
				else
					padrao_temp_1 <= "0000000000000101";
					padrao_temp_1_max <= "0000000000001000";
					padrao_temp_1_min <= "0000000000000010";
				end if;
	end process;


	comparador_1_process: process(padrao_temp_1,padrao_temp_1_max,padrao_temp_1_min, clock)
	begin 
	if (clock='1' and clock'event) then
		if ((unsigned(temp_1)) = (unsigned(padrao_temp_1)) AND (sensor_1 = '0')) then		-- temperatura ok, porta fechada
				led_1 <= x"00ff00";	-- led verde				
				mensagem_1 <= "001";
				
		elsif ((unsigned(temp_1)) = (unsigned(padrao_temp_1)) AND (sensor_1 = '1')) then		-- temperatura ok, porta aberta
				led_1 <= x"ffff00";	-- led amarelo
				mensagem_1 <= "010";
			
		elsif ((unsigned(temp_1)) > (unsigned(padrao_temp_1_max))) then			-- temperatura acima da faixa permitida
			led_1 <= x"ff0000";	-- led vermelho
			mensagem_1 <= "011";
		
		elsif ((unsigned(temp_1)) < (unsigned(padrao_temp_1_min))) then			-- temperatura abaixo da faixa permitida
			led_1 <= x"ff0000";	-- led vermelho
			mensagem_1 <= "100";
		
		elsif ((unsigned(padrao_temp_1)) < (unsigned(temp_1)) AND (unsigned(temp_1)) < (unsigned(padrao_temp_1_max))) then
			led_1 <= x"ffff00";	-- led amarelo
			mensagem_1 <= "101";
		
		elsif ((unsigned(padrao_temp_1)) > (unsigned(temp_1)) AND (unsigned(temp_1)) > (unsigned(padrao_temp_1_min))) then
			led_1 <= x"ffff00";	-- led amarelo
			mensagem_1 <= "110";
		end if;	
	end if;
end process comparador_1_process;	





------------------------------------------------------------------------------------
----------------- processo do refrigerador 2 -------------------------------------- 
------------------------------------------------------------------------------------
	process(clock,vacinas_data_2)
		begin
				if (vacinas_data_2 = '1') then
					report"entrou aqui";
					padrao_temp_2 <= "1111111110110101";	-- revisar complemento de 2/sinal e magnitude
					padrao_temp_2_max <= padrao_temp_2;
					padrao_temp_2_min <= padrao_temp_2;
				else
					padrao_temp_2 <= "0000000000000101";
					padrao_temp_2_max <= "0000000000001000";
					padrao_temp_2_min <= "0000000000000010";
				end if;
	end process;
		
comparador_2_process: process(padrao_temp_2,padrao_temp_2_max,padrao_temp_2_min, clock)
	begin 
	if (clock='1' and clock'event) then
	
		if ((unsigned(temp_2)) = (unsigned(padrao_temp_2)) AND (sensor_2 = '0')) then		-- temperatura ok, porta fechada
				led_2 <= x"00ff00";	-- led verde				
				mensagem_2 <= "001";
				
		elsif ((unsigned(temp_2)) = (unsigned(padrao_temp_2)) AND (sensor_2 = '1')) then		-- temperatura ok, porta aberta
				led_2 <= x"ffff00";	-- led amarelo
				mensagem_2 <= "010";
			
		elsif ((unsigned(temp_2)) > (unsigned(padrao_temp_2_max))) then			-- temperatura acima da faixa permitida
			led_2 <= x"ff0000";	-- led vermelho
			mensagem_2 <= "011";
		
		elsif ((unsigned(temp_2)) < (unsigned(padrao_temp_2_min))) then			-- temperatura abaixo da faixa permitida
			led_2 <= x"ff0000";	-- led vermelho
			mensagem_2 <= "100";
		
		elsif ((unsigned(padrao_temp_2)) < (unsigned(temp_2)) AND (unsigned(temp_2)) < (unsigned(padrao_temp_2_max))) then
			led_2 <= x"ffff00";	-- led amarelo
			mensagem_2 <= "101";
		
		elsif ((unsigned(padrao_temp_2)) > (unsigned(temp_2)) AND (unsigned(temp_2)) > (unsigned(padrao_temp_2_min))) then
			led_2 <= x"ffff00";	-- led amarelo
			mensagem_2 <= "110";
		end if;
		
	end if;
end process comparador_2_process;	



------------------------------------------------------------------------------------
----------------- processo do refrigerador 3 -------------------------------------- 
------------------------------------------------------------------------------------	
	process(clock, vacinas_data_3)
		begin
				if (vacinas_data_3 = '1') then
					report"entrou aqui";
					padrao_temp_3 <= "1111111110110101";	-- revisar complemento de 2/sinal e magnitude
					padrao_temp_3_max <= padrao_temp_2;
					padrao_temp_3_min <= padrao_temp_2;
				else
					padrao_temp_3 <= "0000000000000101";
					padrao_temp_3_max <= "0000000000001000";
					padrao_temp_3_min <= "0000000000000010";
				end if;
	end process;
	
	
comparador_3_process: process(padrao_temp_3,padrao_temp_3_max,padrao_temp_3_min, clock)
	begin 
	if (clock='1' and clock'event) then
	
		if ((unsigned(temp_3)) = (unsigned(padrao_temp_3)) AND (sensor_3 = '0')) then		-- temperatura ok, porta fechada
				led_3 <= x"00ff00";	-- led verde				
				mensagem_3 <= "001";
				
		elsif ((unsigned(temp_3)) = (unsigned(padrao_temp_3)) AND (sensor_3 = '1')) then		-- temperatura ok, porta aberta
				led_3 <= x"ffff00";	-- led amarelo
				mensagem_3 <= "010";
			
		elsif ((unsigned(temp_3)) > (unsigned(padrao_temp_3_max))) then			-- temperatura acima da faixa permitida
			led_3 <= x"ff0000";	-- led vermelho
			mensagem_3 <= "011";
		
		elsif ((unsigned(temp_3)) < (unsigned(padrao_temp_3_min))) then			-- temperatura abaixo da faixa permitida
			led_3 <= x"ff0000";	-- led vermelho
			mensagem_3 <= "100";
		
		elsif ((unsigned(padrao_temp_3)) < (unsigned(temp_3)) AND (unsigned(temp_3)) < (unsigned(padrao_temp_3_max))) then
			led_3 <= x"ffff00";	-- led amarelo
			mensagem_3 <= "101";
		
		elsif ((unsigned(padrao_temp_3)) > (unsigned(temp_3)) AND (unsigned(temp_3)) > (unsigned(padrao_temp_3_min))) then
			led_3 <= x"ffff00";	-- led amarelo
			mensagem_3 <= "110";
		end if;
		
	end if;
end process comparador_3_process;




------------------------------------------------------------------------------------
----------------- processo do refrigerador 4 -------------------------------------- 
------------------------------------------------------------------------------------
	process(clock, vacinas_data_4)
	
		begin
				if (vacinas_data_4 = '1') then
					report"entrou aqui";
					padrao_temp_4 <= "1111111110110101";	-- revisar complemento de 4/sinal e magnitude
					padrao_temp_4_max <= padrao_temp_4;
					padrao_temp_4_min <= padrao_temp_4;
				else
					padrao_temp_4 <= "0000000000000101";
					padrao_temp_4_max <= "0000000000001000";
					padrao_temp_4_min <= "0000000000000010";
				end if;
	end process;
	
	
comparador_4_process: process(padrao_temp_4,padrao_temp_4_max,padrao_temp_4_min, clock)
	begin 
	if (clock='1' and clock'event) then
	
		if ((unsigned(temp_4)) = (unsigned(padrao_temp_4)) AND (sensor_4 = '0')) then		-- temperatura ok, porta fechada
				led_4 <= x"00ff00";	-- led verde				
				mensagem_4 <= "001";
				
		elsif ((unsigned(temp_4)) = (unsigned(padrao_temp_4)) AND (sensor_4 = '1')) then		-- temperatura ok, porta aberta
				led_4 <= x"ffff00";	-- led amarelo
				mensagem_4 <= "010";
			
		elsif ((unsigned(temp_4)) > (unsigned(padrao_temp_4_max))) then			-- temperatura acima da faixa permitida
			led_4 <= x"ff0000";	-- led vermelho
			mensagem_4 <= "011";
		
		elsif ((unsigned(temp_4)) < (unsigned(padrao_temp_4_min))) then			-- temperatura abaixo da faixa permitida
			led_4 <= x"ff0000";	-- led vermelho
			mensagem_4 <= "100";
		
		elsif ((unsigned(padrao_temp_4)) < (unsigned(temp_4)) AND (unsigned(temp_4)) < (unsigned(padrao_temp_4_max))) then
			led_4 <= x"ffff00";	-- led amarelo
			mensagem_4 <= "101";
		
		elsif ((unsigned(padrao_temp_4)) > (unsigned(temp_4)) AND (unsigned(temp_4)) > (unsigned(padrao_temp_4_min))) then
			led_4 <= x"ffff00";	-- led amarelo
			mensagem_4 <= "110";
		end if;
		
	end if;
end process comparador_4_process;




------------------------------------------------------------------------------------
----------------- processo do refrigerador 4 -------------------------------------- 
------------------------------------------------------------------------------------
	process(clock, vacinas_data_5)
	
		begin
				if (vacinas_data_5 = '1') then
					report"entrou aqui";
					padrao_temp_5 <= "1111111110110101";	-- revisar complemento de 5/sinal e magnitude
					padrao_temp_5_max <= padrao_temp_5;
					padrao_temp_5_min <= padrao_temp_5;
				else
					padrao_temp_5 <= "0000000000000101";
					padrao_temp_5_max <= "0000000000001000";
					padrao_temp_5_min <= "0000000000000010";
				end if;
	end process;
	
	
comparador_5_process: process(padrao_temp_5,padrao_temp_5_max,padrao_temp_5_min, clock)
	begin 
	if (clock='1' and clock'event) then
	
		if ((unsigned(temp_5)) = (unsigned(padrao_temp_5)) AND (sensor_5 = '0')) then		-- temperatura ok, porta fechada
				led_5 <= x"00ff00";	-- led verde				
				mensagem_5 <= "001";
				
		elsif ((unsigned(temp_5)) = (unsigned(padrao_temp_5)) AND (sensor_5 = '1')) then		-- temperatura ok, porta aberta
				led_5 <= x"ffff00";	-- led amarelo
				mensagem_5 <= "010";
			
		elsif ((unsigned(temp_5)) > (unsigned(padrao_temp_5_max))) then			-- temperatura acima da faixa permitida
			led_5 <= x"ff0000";	-- led vermelho
			mensagem_5 <= "011";
		
		elsif ((unsigned(temp_5)) < (unsigned(padrao_temp_5_min))) then			-- temperatura abaixo da faixa permitida
			led_5 <= x"ff0000";	-- led vermelho
			mensagem_5 <= "100";
		
		elsif ((unsigned(padrao_temp_5)) < (unsigned(temp_5)) AND (unsigned(temp_5)) < (unsigned(padrao_temp_5_max))) then
			led_5 <= x"ffff00";	-- led amarelo
			mensagem_5 <= "101";
		
		elsif ((unsigned(padrao_temp_5)) > (unsigned(temp_5)) AND (unsigned(temp_5)) > (unsigned(padrao_temp_5_min))) then
			led_5 <= x"ffff00";	-- led amarelo
			mensagem_5 <= "110";
		end if;
		
	end if;
end process comparador_5_process;

end gestao_vacinas;
