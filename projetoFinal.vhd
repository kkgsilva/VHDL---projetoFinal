library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use ieee.numeric_std.all;

entity projetoFinal is
    port (
		temp_1: in std_logic_vector(15 downto 0); 
		-- temp_2, temp_3, temp_4, temp_5: in std_logic_vector(15 downto 0);
		sensor_1: in std_logic;
		-- sensor_2 , sensor_3, sensor_4, sensor_5: in std_logic;
		led_1: out std_logic_vector(23 downto 0);
		-- led_2, led_3, led_4, led_5
		mensagem_1: out string(3 downto 1)
	 );
end projetoFinal;

architecture gestao_vacinas of projetoFinal is
	-- declarações signal
	signal clk          : std_logic;
	signal read_vacinas : std_logic := '0';
	type vect is array (0 to 4) of integer; --O indice do array é o numero do refrigerador 
	signal exp_output: vect;
	signal padrao_temp_1 : std_logic_vector(15 downto 0);
	signal padrao_temp_1_max : std_logic_vector(15 downto 0);
	signal padrao_temp_1_min : std_logic_vector(15 downto 0);
	signal start: std_logic;
	
-- declaraçoes constant
	constant espaco 	  	: string := " ";
	constant PERIOD     	: time := 20 ns;
   constant DUTY_CYCLE 	: real := 0.5;
   constant OFFSET     	: time := 5 ns; 
	constant max_value  	: natural := 15;
	constant mim_value  	:natural := 0;
	
-- declaracoes variable
	
	file vacinas: text open read_mode is "vacina.txt";
	file relatorio: text open write_mode is "relatorio.txt";
	
begin	
	process(clk)
		begin
			for i in 0 to 11 loop
				if (exp_output(0) = 1) then
					padrao_temp_1 <= "1111111110110101";	-- revisar complemento de 2/sinal e magnitude
					padrao_temp_1_max <= padrao_temp_1;
					padrao_temp_1_min <= padrao_temp_1;
				else
					padrao_temp_1 <= "0000000000000101";
					padrao_temp_1_max <= "0000000000001000";
					padrao_temp_1_min <= "0000000000000010";
				end if;
			end loop;
			
			if ((unsigned(temp_1)) = (unsigned(padrao_temp_1)) AND (sensor_1 = '0')) then		-- temperatura ok, porta fechada
				led_1 <= x"00ff00";	-- led verde				
				mensagem_1 <= "ok!";
		
			end if;
	end process;

end gestao_vacinas;