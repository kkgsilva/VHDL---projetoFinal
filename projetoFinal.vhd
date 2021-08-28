library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use ieee.numeric_std.all;

entity projetoFinal is
    port (
		clock: in std_logic;
		temp_1: in std_logic_vector(15 downto 0);
		sensor_1: in std_logic;
		led_1: out std_logic_vector(23 downto 0); -- saida rgb, verificar logica
		mensagem: out integer
	 );
end projetoFinal;

architecture gestao_vacinas of projetoFinal is
	-- declarações signal
	signal clk          : std_logic;
	type vect is array (1 to 5) of integer; --O indice do array é o numero do refrigerador 
	signal vacinas_data: vect;
	
	
begin	
	process(clk)
		variable padrao_temp_1 : std_logic_vector(15 downto 0);
		variable padrao_temp_1_max : std_logic_vector(15 downto 0);
		variable padrao_temp_1_min : std_logic_vector(15 downto 0);
		
		begin
				if (vacinas_data(1) = 1) then
					padrao_temp_1 := "1111111110110101";	-- revisar complemento de 2/sinal e magnitude
					padrao_temp_1_max := padrao_temp_1;
					padrao_temp_1_min := padrao_temp_1;
				else
					padrao_temp_1 := "0000000000000101";
					padrao_temp_1_max := "0000000000001000";
					padrao_temp_1_min := "0000000000000010";
				end if;			
			
			if ((unsigned(temp_1)) = (unsigned(padrao_temp_1)) AND (sensor_1 = '0')) then		-- temperatura ok, porta fechada
				led_1 <= x"00ff00";	-- led verde				
				mensagem <= 1;
			
		
			end if;
	end process;

end gestao_vacinas;