library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use ieee.numeric_std.all;

entity projetoFinal is
    port (
		start: in boolean;
		temp_1, temp_2, temp_3, temp_4, temp_5: in std_logic_vector(15 downto 0);
		sensor_1 , sensor_2 , sensor_3, sensor_4, sensor_5: in boolean;
		led_1, led_2, led_3, led_4, led_5: out std_logic;
	 );
end projetoFinal;

architecture gestao_vacinas of projetoFinal is
	-- declarações signal
	signal clk          : std_logic;
	signal read_vacinas : std_logic := '0';
	signal vacinas_data : std_logic_vector(3 downto 0);

	
	-- declarações constant
	constant espaco 	  : string := "		";
	constant PERIOD     : time := 20 ns;
   constant DUTY_CYCLE : real := 0.5;
   constant OFFSET     : time := 5 ns;
	
	
	-- declarações variable
	variable linha : line;
	variable input : std_logic_vector(3 downto 0); 
	
	
	file vacinas: text open read_mode is "vacina.txt";
	file relatorio: text open write_mode is "relatorio.txt";
	
	
	
	-- clock process
	process    
		begin
      wait for OFFSET;
      clock_loop : LOOP
			clk <= '0';
         wait for (PERIOD - (PERIOD * DUTY_CYCLE));
				clk <= '1';
            wait for (PERIOD * DUTY_CYCLE);
		end loop clock_loop;
	end process;
	
	--leitura dos dados vacina.txt
	read_vacinas_process: process
	begin
		wait until(falling_edge(clk));
		while(not endfile(vacinas)) loop
			if start = '1' then	
				readline(vacinas, linha);
				read(linha, input);
				vacinas_data <= input;
			  end if;
			  wait for PERIOD;
		end loop;
		wait;
	end process read_vacinas_process;	
	
	-- gera estimulos de entrada
	gera_estimulos_process: process
   begin
		wait for(OFFSET + 3*PERIOD);
            start <= '1';		
			for i in mim_value to max_value loop
				wait for PERIOD;
		   end loop;
            start <= '0';		
		wait;
   end process gera_estimulos_process;	
	
	
	
	
	
	
	process ()
		begin
			if(temp_1 = padrao_temp_1 AND sensor_1 = '0') then
			
			elsif(temp_1 = padrao_temp_1 AND sensor_1 = '1') then
			
			elsif(temp_1 > padrao_temp_1 AND sensor_1 = '0') then
			
			elsif(temp_1 > padrao_temp_1 AND sensor_1 = '1') then
			
			elsif(temp_1 < padrao_temp_1 AND sensor_1 = '0') then
			
			elsif(temp_1 < padrao_temp_1 AND sensor_1 = '1') then
	
	-- ultimo elsif 
	
	end if;

end gestao_vacinas;