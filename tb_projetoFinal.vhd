library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use ieee.numeric_std.all;

entity tb_projetoFinal is
end tb_projetoFinal;

architecture tb_gestao_vacinas of tb_projetoFinal is
	component projetoFinal port(
		clock: in std_logic;
		temp_1, temp_2, temp_3, temp_4, temp_5: in std_logic_vector(15 downto 0);
		sensor_1,sensor_2, sensor_3, sensor_4, sensor_5: in std_logic;
		led_1, led_2, led_3, led_4, led_5: out std_logic_vector(23 downto 0); -- saida rgb, verificar logica
		mensagem_1, mensagem_2, mensagem_3, mensagem_4, mensagem_5 : out std_logic_vector(2 downto 0);
		vacinas_data_1, vacinas_data_2, vacinas_data_3, vacinas_data_4, vacinas_data_5: in std_logic
	);
	end component;
	
   -- declaraÃ§oes de  signal in e out
	signal tipoVacina_1, tipoVacina_2, tipoVacina_3, tipoVacina_4, tipoVacina_5  : std_logic;
	signal porta_1, porta_2, porta_3, porta_4, porta_5 : std_logic:= '0';
	signal temperatura_1, temperatura_2, temperatura_3, temperatura_4, temperatura_5 : std_logic_vector(15 downto 0) := "0000000000000000";
	signal alerta_1, alerta_2, alerta_3, alerta_4, alerta_5: std_logic_vector(23 downto 0);
	signal notificacao_1, notificacao_2, notificacao_3, notificacao_4, notificacao_5: std_logic_vector(2 downto 0);
	
	--SINAIS DE LEITURA E ESCRITA
	signal read_data_in    : std_logic:='0';
   signal flag_write      : std_logic:='0';   
	
	-- Declaracao constant for clock
	signal clk: std_logic;
	constant PERIOD     : time := 30 ns;
   constant DUTY_CYCLE : real := 0.5;
   constant OFFSET     : time := 5 ns;
	constant max_value      : natural := 15;
	constant mim_value		: natural := 0;

-- declaracoes file
	file vacinas			: text open read_mode is "vacina.txt";
	file refrigerador_1	: text open write_mode is "refrigerador_1.txt";
	file refrigerador_2	: text open write_mode is "refrigerador_2.txt";
	file refrigerador_3	: text open write_mode is "refrigerador_3.txt";
	file refrigerador_4	: text open write_mode is "refrigerador_4.txt";
	file refrigerador_5	: text open write_mode is "refrigerador_5.txt";

-- Tipos De dados
	type vect is array (1 to 5) of std_logic;
	signal TipoVacina: vect ; 
	
	type vector is record
		Nome: string(1 to 6);
		Lote: string(4 downto 1);
	end record;
	
	
	--declaracoes de sinal utilizados entre process
	signal Vacina_1, Vacina_2, Vacina_3, Vacina_4, Vacina_5 : vector;
	
--declara as mensagens de erro como constantes 
	constant espaco: string           := "  ";
	constant mensagem1: string        := "                Refrigerador funcionando                ";
	constant msg_porta_alerta: string :="          ALERTA: Porta do refrigerador aberta!         ";
	constant msg_temp_alta: string    :="  VACINAS DESCARTADAS: Temperatura acima da permitida!  ";
	constant msg_temp_baixa: string   :="  VACINAS DESCARTADAS: Temperatura abaixo da permitida! ";
	constant msg_temp_subindo: string :="     ALERTA: Temperatura a temperatura esta subindo!    ";
	constant msg_temp_caindo: string  :="      ALERTA: Temperatura a temperatura esta caindo!    ";	
	
		------------------------------ PORT MAP ---------------------------------------
begin
	DUT: projetoFinal
    port map(clock     => clk,
				 temp_1    => temperatura_1,
				 temp_2		=> temperatura_2,
				 temp_3		=> temperatura_3,
				 temp_4		=> temperatura_4,
				 temp_5		=> temperatura_5,
				 led_1    => alerta_1,
				 led_2    => alerta_2,
				 led_3    => alerta_3,
				 led_4    => alerta_4,
				 led_5    => alerta_5,
				 sensor_1  => porta_1,
				 sensor_2  => porta_2,
				 sensor_3  => porta_3,
				 sensor_4  => porta_4,
				 sensor_5  => porta_5,
				 mensagem_1 => notificacao_1,
				 mensagem_2 => notificacao_2,
				 mensagem_3 => notificacao_3,
				 mensagem_4 => notificacao_4,
				 mensagem_5 => notificacao_5,
				 vacinas_data_1 => tipoVacina_1,
				 vacinas_data_2 => tipoVacina_2,
				 vacinas_data_3 => tipoVacina_3,
				 vacinas_data_4 => tipoVacina_4,
				 vacinas_data_5 => tipoVacina_5
			);	
				 

	temperatura_1 <= "1111111110110101", "1111111110110110" after 300 ns, "1111111110110101" after 400 ns, "1111111110110100" after 500 ns, "1111111110110101" after 600 ns, "1111111110110111" after 700 ns, "1111111110110011" after 800 ns;
	porta_1       <= '0', '1'  after 200 ns, '0' after 400 ns, '1' after 600 ns, '0' after 800 ns;
	
	temperatura_2 <= "0000000000000101", "0000000000000100" after 300 ns, "0000000000000001" after 400 ns, "0000000000000100" after 500 ns, "0000000000001001" after 600 ns, "0000000000000101" after 700 ns, "0000000000000110" after 800 ns, "0000000000000101" after 900 ns;
	porta_2       <= '0', '1'  after 200 ns, '0' after 400 ns, '1' after 600 ns, '0' after 800 ns;
	
	temperatura_3 <= "0000000000000101", "0000000000000100" after 400 ns, "0000000000000001" after 500 ns, "0000000000000100" after 600 ns, "0000000000001001" after 700 ns, "0000000000000101" after 800 ns, "0000000000000111" after 900 ns;
	porta_3       <= '0', '1'  after 200 ns, '0' after 400 ns, '1' after 600 ns, '0' after 800 ns;
	
	temperatura_4 <= "0000000000000101", "0000000000000100" after 500 ns, "0000000000000001" after 600 ns, "0000000000000100" after 700 ns, "0000000000001001" after 800 ns, "0000000000000101" after 900 ns, "0000000000000110" after 1000 ns;
	porta_4       <= '0', '1' after 400 ns, '1' after 600 ns, '0' after 800 ns;
	
	temperatura_5 <= "1111111110110101", "1111111110110110" after 600 ns, "1111111110110011" after 700 ns, "1111111110110101" after 800 ns, "1111111110110100" after 900 ns, "1111111110110101" after 1000 ns, "1111111110110111" after 1100 ns, "1111111110110011" after 1200 ns;
	porta_5       <= '0', '1'  after 200 ns, '0' after 400 ns, '1' after 600 ns, '0' after 800 ns;
------------------------------------------------------------------------------------
----------------- processo para gerar o sinal de clock 
------------------------------------------------------------------------------------		
	PROCESS 
        BEGIN
            WAIT for OFFSET;
            CLOCK_LOOP : LOOP
                clk <= '0';
                WAIT FOR (PERIOD - (PERIOD * DUTY_CYCLE));
                clk <= '1';
                WAIT FOR (PERIOD * DUTY_CYCLE);
            END LOOP CLOCK_LOOP;
        END PROCESS;
------------------------------------------------------------------------------------
----------------- processo para leer os dados do arquivo vacina.txt
------------------------------------------------------------------------------------
	leitura_vacinas_process: process
	variable linha : line;
	variable nomeVacina : string(6 downto 1);
	variable lote : string(4 downto 1);
	variable refri : integer;
	variable espaco 	  : character;
	
	begin
		wait until(falling_edge(clk));
		while(not endfile(vacinas)) loop
			if (read_data_in = '1' ) then
				readline(vacinas, linha);
				read(linha,nomeVacina);		
				read(linha, espaco);
				read(linha,lote);
				read(linha, espaco);
				read(linha, refri);
				
				if(nomeVacina = "Pfizer") then
					tipoVacina(refri) <= '1';
				else 
					tipoVacina(refri) <= '0';
				end if;	
				
				if(refri = 1) then
					vacina_1.Nome <= nomeVacina;
					vacina_1.Lote <= lote;
				elsif(refri = 2) then
					vacina_2.Nome <= nomeVacina;
					vacina_2.Lote <= lote;
				elsif(refri = 3) then
					vacina_3.Nome <= nomeVacina;
					vacina_3.Lote <= lote;
				elsif(refri = 4) then
					vacina_4.Nome <= nomeVacina;
					vacina_4.Lote <= lote;
				elsif(refri = 5) then
					vacina_5.Nome <= nomeVacina;
					vacina_5.Lote <= lote;	
				end if;
				
			end if;
			wait for PERIOD;
		end loop;
		tipoVacina_1 <= tipoVacina(1);
		tipoVacina_2 <= tipoVacina(2);
		tipoVacina_3 <= tipoVacina(3);
		tipoVacina_4 <= tipoVacina(4);
		tipoVacina_5 <= tipoVacina(5);		
		wait;
	end process leitura_vacinas_process;	
	
------------------------------------------------------------------------------------
----------------- processo para gerar os estimulos de entrada
------------------------------------------------------------------------------------
   tb_stimulus : PROCESS
   BEGIN
        WAIT FOR (OFFSET + 3*PERIOD);
            read_data_in <= '1';		
			for i in mim_value to max_value loop
		        wait for PERIOD;
		    end loop;
            read_data_in <= '0';		
		WAIT;
   END PROCESS tb_stimulus;	
   	
------------------------------------------------------------------------------------
------ processo para gerar os estimulos de escrita do arquivo de saida
------------------------------------------------------------------------------------ 
	escreve_outputs : PROCESS
    BEGIN
         WAIT FOR (OFFSET + 4*PERIOD);
             flag_write <= '1';
			 for i in mim_value to max_value loop
		         wait for PERIOD;
		     end loop;
             flag_write <= '0';			
		 WAIT;
    END PROCESS escreve_outputs;   
	
-- ------------------------------------------------------------------------------------
-- ------ processo para escriber os dados de saida no arquivo relatorio 1.txt
-- ------------------------------------------------------------------------------------  
	escrita_vacina_1_outputs:process
		variable linha  : line;
		variable saida : std_logic_vector(2 downto 0);
		
	begin
	wait for (275 ns);
		wait until (falling_edge(clk));
		while true loop
		
			saida := notificacao_1;
			if(saida = "001") then
				write(linha, mensagem1);
			elsif(saida = "010") then
				write(linha, msg_porta_alerta);
			elsif(saida = "011") then
				write(linha, msg_temp_alta);
			elsif(saida = "100") then
				write(linha, msg_temp_baixa);
			elsif(saida = "101") then
				write(linha, msg_temp_subindo);
			elsif(saida = "110") then
				write(linha, msg_temp_caindo);
			end if;
			
				write(linha,espaco);
				write(linha,vacina_1.Lote);
				write(linha,espaco);
				if( tipoVacina_1 = '1') then 
					write(linha, to_integer(signed(temperatura_1)),right, 8);
				elsif(tipoVacina_1 = '0') then
					write(linha, to_integer(unsigned(temperatura_1)),right, 8);
				end if;
				write(linha,espaco);
				write(linha,porta_1);
				writeline(refrigerador_1,linha);
				
		wait for PERIOD;
		end loop;
	end process escrita_vacina_1_outputs; 
	
-- ------------------------------------------------------------------------------------
-- ------ processo para escriber os dados de saida no arquivo relatorio 2.txt
-- ------------------------------------------------------------------------------------  
	escrita_vacina_2_outputs:process
		variable linha  : line;
		variable saida : std_logic_vector(2 downto 0);
		
	begin
	wait for (275 ns);
		wait until (falling_edge(clk));
		while true loop
		
			saida := notificacao_2;
			if(saida = "001") then
				write(linha, mensagem1);
			elsif(saida = "010") then
				write(linha, msg_porta_alerta);
			elsif(saida = "011") then
				write(linha, msg_temp_alta);
			elsif(saida = "100") then
				write(linha, msg_temp_baixa);
			elsif(saida = "101") then
				write(linha, msg_temp_subindo);
			elsif(saida = "110") then
				write(linha, msg_temp_caindo);
			end if;
			
				write(linha,espaco);
				write(linha,vacina_2.Lote);
				write(linha,espaco);
				if( tipoVacina_2 = '1') then 
					write(linha, to_integer(signed(temperatura_2)),right, 8);
				elsif(tipoVacina_2 = '0') then
					write(linha, to_integer(unsigned(temperatura_2)),right, 8);
				end if;
				write(linha,espaco);
				write(linha,porta_2);
				writeline(refrigerador_2,linha);
				
		wait for PERIOD;
		end loop; 
	end process escrita_vacina_2_outputs;
	
	
	
-- ------------------------------------------------------------------------------------
-- ------ processo para escriber os dados de saida no arquivo relatorio 3.txt
-- ------------------------------------------------------------------------------------  
	escrita_vacina_3_outputs:process
		variable linha  : line;
		variable saida : std_logic_vector(2 downto 0);
		
	begin
	wait for (275 ns);
		wait until (falling_edge(clk));
		while true loop
		
			saida := notificacao_3;
			if(saida = "001") then
				write(linha, mensagem1);
			elsif(saida = "010") then
				write(linha, msg_porta_alerta);
			elsif(saida = "011") then
				write(linha, msg_temp_alta);
			elsif(saida = "100") then
				write(linha, msg_temp_baixa);
			elsif(saida = "101") then
				write(linha, msg_temp_subindo);
			elsif(saida = "110") then
				write(linha, msg_temp_caindo);
			end if;
			
				write(linha,espaco);
				write(linha,vacina_3.Lote);
				write(linha,espaco);
				if( tipoVacina_3 = '1') then 
					write(linha, to_integer(signed(temperatura_3)),right, 8);
				elsif(tipoVacina_3 = '0') then
					write(linha, to_integer(unsigned(temperatura_3)),right, 8);
				end if;
				write(linha,espaco);
				write(linha,porta_1);
				writeline(refrigerador_3,linha);
				
		wait for PERIOD;
		end loop; 
	end process escrita_vacina_3_outputs; 
	
-- ------------------------------------------------------------------------------------
-- ------ processo para escriber os dados de saida no arquivo relatorio 4.txt
-- ------------------------------------------------------------------------------------  
	escrita_vacina_4_outputs:process
		variable linha  : line;
		variable saida : std_logic_vector(2 downto 0);
		
	begin
	wait for (275 ns);
		wait until (falling_edge(clk));
		while true loop
		
			saida := notificacao_4;
			if(saida = "001") then
				write(linha, mensagem1);
			elsif(saida = "010") then
				write(linha, msg_porta_alerta);
			elsif(saida = "011") then
				write(linha, msg_temp_alta);
			elsif(saida = "100") then
				write(linha, msg_temp_baixa);
			elsif(saida = "101") then
				write(linha, msg_temp_subindo);
			elsif(saida = "110") then
				write(linha, msg_temp_caindo);
			end if;
			
				write(linha,espaco);
				write(linha,vacina_4.Lote);
				write(linha,espaco);
				if( tipoVacina_4 = '1') then 
					write(linha, to_integer(signed(temperatura_4)),right, 8);
				elsif(tipoVacina_4 = '0') then
					write(linha, to_integer(unsigned(temperatura_4)),right, 8);
				end if;
				write(linha,espaco);
				write(linha,porta_1);
				writeline(refrigerador_4,linha);
				
		wait for PERIOD;
		end loop; 
	end process escrita_vacina_4_outputs; 
	
-- ------------------------------------------------------------------------------------
-- ------ processo para escriber os dados de saida no arquivo relatorio 5.txt
-- ------------------------------------------------------------------------------------  
	escrita_vacina_5_outputs:process
		variable linha  : line;
		variable saida : std_logic_vector(2 downto 0);
		
	begin
	wait for (275 ns);
		wait until (falling_edge(clk));
		while true loop
		
			saida := notificacao_5;
			if(saida = "001") then
				write(linha, mensagem1);
			elsif(saida = "010") then
				write(linha, msg_porta_alerta);
			elsif(saida = "011") then
				write(linha, msg_temp_alta);
			elsif(saida = "100") then
				write(linha, msg_temp_baixa);
			elsif(saida = "101") then
				write(linha, msg_temp_subindo);
			elsif(saida = "110") then
				write(linha, msg_temp_caindo);
			end if;
			
				write(linha,espaco);
				write(linha,vacina_5.Lote);
				write(linha,espaco);
				if( tipoVacina_5 = '1') then 
					write(linha, to_integer(signed(temperatura_5)),right, 8);
				elsif(tipoVacina_5 = '0') then
					write(linha, to_integer(unsigned(temperatura_5)),right, 8);
				end if;
				
				
				write(linha,espaco);
				write(linha,porta_5);
				writeline(refrigerador_5,linha);
				
		wait for PERIOD;
		end loop; 
	end process escrita_vacina_5_outputs; 
	

end tb_gestao_vacinas;