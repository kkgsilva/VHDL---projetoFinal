library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use ieee.numeric_std.all;

entity projetoFinal is
    port (
		vacinas_data: in std_logic;
		clock: in std_logic;
		temp_1: in std_logic_vector(15 downto 0);
		sensor_1: in std_logic;
		led_1: out std_logic_vector(23 downto 0); -- saida rgb, verificar logica
		mensagem: out std_logic_vector(2 downto 0)
		
		--padrao_temp_1 : out std_logic_vector(15 downto 0);
		--padrao_temp_1_max : out std_logic_vector(15 downto 0);
		--padrao_temp_1_min : out std_logic_vector(15 downto 0);
	 );
end projetoFinal;

architecture gestao_vacinas of projetoFinal is
	-- declarações signal
signal padrao_temp_1 : std_logic_vector(15 downto 0);
signal  padrao_temp_1_max : std_logic_vector(15 downto 0);	
signal  padrao_temp_1_min : std_logic_vector(15 downto 0);
	
begin	
	process(vacinas_data)
	
		begin
				if (vacinas_data = '1') then
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
	
	
comparadores_process: process(padrao_temp_1,padrao_temp_1_max,padrao_temp_1_min, clock)
	begin 
	if (clock='1' and clock'event) then
	
		if ((unsigned(temp_1)) = (unsigned(padrao_temp_1)) AND (sensor_1 = '0')) then		-- temperatura ok, porta fechada
				led_1 <= x"00ff00";	-- led verde				
				mensagem <= "001";
				
		elsif ((unsigned(temp_1)) = (unsigned(padrao_temp_1)) AND (sensor_1 = '1')) then		-- temperatura ok, porta aberta
				led_1 <= x"ffff00";	-- led amarelo
				mensagem <= "010";
			
		elsif ((unsigned(temp_1)) > (unsigned(padrao_temp_1_max))) then			-- temperatura acima da faixa permitida
			led_1 <= x"ff0000";	-- led vermelho
			mensagem <= "011";
		
		elsif ((unsigned(temp_1)) < (unsigned(padrao_temp_1_min))) then			-- temperatura abaixo da faixa permitida
			led_1 <= x"ff0000";	-- led vermelho
			mensagem <= "100";
		
		elsif ((unsigned(padrao_temp_1)) < (unsigned(temp_1)) AND (unsigned(temp_1)) < (unsigned(padrao_temp_1_max))) then
			led_1 <= x"ffff00";	-- led amarelo
			mensagem <= "101";
		
		elsif ((unsigned(padrao_temp_1)) > (unsigned(temp_1)) AND (unsigned(temp_1)) > (unsigned(padrao_temp_1_min))) then
			led_1 <= x"ffff00";	-- led amarelo
			mensagem <= "110";
		end if;
		
	end if;
end process comparadores_process;	

end gestao_vacinas;
