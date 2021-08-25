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
		led_1, led_2, led_3, led_4, led_5: out std_logic_vector(23 downto 0);
		mensagem_1: out string
	 );
end projetoFinal;

architecture gestao_vacinas of projetoFinal is
	-- declarações signal
	signal clk          : std_logic;
	signal read_vacinas : std_logic := '0';
	signal vacinas_data : string(11 downto 0);
	signal padrao_temp_1 : std_logic_vector(15 downto 0);
	signal padrao_temp_1_max : std_logic_vector(15 downto 0);
	signal padrao_temp_1_min : std_logic_vector(15 downto 0);
	
--	signal padrao_temp_2: std_logic_vector(15 downto 0);
	--signal padrao_temp_3: std_logic_vector(15 downto 0);
	--signal padrao_temp_4: std_logic_vector(15 downto 0);
	--signal padrao_temp_5: std_logic_vector(15 downto 0);


	
	-- declarações constant
	constant espaco 	  : string := "		";
	constant PERIOD     : time := 20 ns;
   constant DUTY_CYCLE : real := 0.5;
   constant OFFSET     : time := 5 ns;
	constant astrazeneca: string := "Astrazeneca ";
	constant jasen		  : string := "Jansen      ";
	constant coronavac  : string := "Coronavac   ";
	constant pfizer	  : string := "Pfizer      "; 
	
	
	-- declarações variable
	variable linha : line;
	variable input : string(11 downto 0);
	
	
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
	
	--leitura dos dados vacinas.txt
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
	
	process (vacinas_data)
		begin
			for i in 0 to 11 loop
				if ((vacinas_data(i) = astrazeneca(i)) OR (vacinas_data(i) == jasen(i)) OR (vacinas_data(i) == coronavac(i))) then	--verificar parametros
					padrao_temp_1 <= "0000000000000101";
					padrao_temp_1_max <= "0000000000001000";
					padrao_temp_1_min <= "0000000000000010";
				end if;
			end loop;
	
			for i in 0 to 11 loop
				if (vacinas_data(i) = pfizer(i)) then
					padrao_temp_1 <= "1111111110110101";	-- revisar complemento de 2/sinal e magnitude
					padrao_temp_1_max <= padrao_temp_1;
					padrao_temp_1_min <= padrao_temp_1;
				end if;
			end loop;
			
			if ((unsigned(temp_1)) = (unsigned(padrao_temp_1)) AND (sensor_1 = '0')) then		-- temperatura ok, porta fechada
				led_1 <= x"00ff00";	-- led verde				
				mensagem_1 <= "Funcionamento dentro do padrão";
			
			elsif ((unsigned(temp_1)) = (unsigned(padrao_temp_1)) AND (sensor_1 = '1')) then		-- temperatura ok, porta aberta
				led_1 <= x"ffff00";	-- led amarelo
				mensagem_1 <= "ALERTA: Porta do refrigerador aberta!";
			
			elsif ((unsigned(temp_1)) > (unsigned(padrao_temp_1_max)) then			-- temperatura acima da faixa permitida
				led_1 <= x"ff0000";	-- led vermelho
				mensagem_1 <= "VACINAS DESCARTADAS: Temperatura acima da permitida!";
	
			
			elsif ((unsigned(temp_1)) < (unsigned(padrao_temp_1_min)) then			-- temperatura abaixo da faixa permitida
				led_1 <= x"ff0000";	-- led vermelho
				mensagem_1 <= "VACINAS DESCARTADAS: Temperatura abaixo da permitida!";
			
			elsif ((unsigned(padrao_temp_1)) < (unsigned(temp_1)) AND (unsigned(temp_1)) < (unsigned(padrao_temp_1_max))) then
				led_1 <= x"ffff00";	-- led amarelo
				mensagem_1 <= "ALERTA: Temperatura a temperatura está subindo!";
			
			elsif ((unsigned(padrao_temp_1)) > (unsigned(temp_1)) AND (unsigned(temp_1)) > (unsigned(padrao_temp_1_min))) then
				led_1 <= x"ffff00";	-- led amarelo
				mensagem_1 <= "ALERTA: Temperatura a temperatura está caindo!";
	
			end if;

end gestao_vacinas;