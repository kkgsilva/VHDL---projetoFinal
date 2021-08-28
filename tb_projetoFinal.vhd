library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use ieee.numeric_std.all;

entity tb_projetoFinal is
end tb_projetoFinal;

architecture tb_gestao_vacinas of tb_projetoFinal is
	component vacina port(
		clock: in std_logic;
		temp_1: in std_logic_vector(15 downto 0);
		sensor_1: in boolean;
		led_1: out std_logic_vector(23 downto 0);
		mensagem: out integer
	);
	end component;
	
   -- declaraçoes de  signal ine out
	type vect is array (1 to 5) of integer; 
	signal vacinas_data: vect; --O indice do array é o numero do refrigerador  [[[[[[verificar]]]]]]
	signal porta_1 : boolean;
	signal temperatura_1 : std_logic_vector(15 downto 0);
	signal alerta_1 : std_logic_vector(23 downto 0);
	signal notificacao: integer;
	
	--SINAIS DE LEITURA E ESCRITA
	signal read_data_in    : std_logic:='0';
   signal flag_write      : std_logic:='0';   
	
	-- declaraçoes constant for clock
	signal clk: std_logic;
	constant PERIOD     : time := 20 ns;
   constant DUTY_CYCLE : real := 0.5;
   constant OFFSET     : time := 5 ns;
	constant max_value      : natural := 15;
	constant mim_value		: natural := 0;

	-- declaracoes file
	file vacinas			: text open read_mode is "vacina.txt";
	file refrigerador_1	: text open write_mode is "refrigerador_1.txt";
	
	--declaracoes de sinal utilizados entre process
	signal  loteVacina : string(5 downto 1);
	signal numeroRefrigerador : integer;
	
		------------------------------ PORT MAP ---------------------------------------
begin
	DUT: vacina
    port map(clock     => clk,
				 temp_1    => temperatura_1,
				 led_1    => alerta_1,
             sensor_1  => porta_1,
				 mensagem => notificacao);
				 
------------------------------------------------------------------------------------
----------------- processo para gerar o sinal de clock 
------------------------------------------------------------------------------------		
        PROCESS    -- clock process for clock
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
	variable loteVacina : string(5 downto 1);
	variable numeroRefrigerador : integer;
	variable espaco 	  : character;
	
	
	begin
		wait until(falling_edge(clk));
		while(not endfile(vacinas)) loop
			if (read_data_in = '1' ) then
				readline(vacinas, linha);
				read(linha,nomeVacina);		
				read(linha, espaco);
				read(linha,loteVacina);
				read(linha, espaco);
				read(linha, numeroRefrigerador);
		   report "A vacina lida - " & nomeVacina;
			report "O lote -" & loteVacina;
			report "No refrigerador - " & integer'image(numeroRefrigerador);
				if(nomeVacina = "Pfizer") then
					vacinas_data(numeroRefrigerador) <= 1; 
				else 
					vacinas_data(numeroRefrigerador) <= 0;
				end if;	
			report "A vacina lida - " & nomeVacina;	
			end if;
			wait for PERIOD;
		end loop;
		wait;
	end process leitura_vacinas_process;	
	
	
------------------------------------------------------------------------------------
----------------- processo para gerar os estimulos de entrada
------------------------------------------------------------------------------------
   tb_stimulus : PROCESS
   BEGIN
        WAIT FOR (OFFSET);
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
-- ------ processo para escriber os dados de saida no arquivo relatorio.txt
-- ------------------------------------------------------------------------------------  

	escrita_vacina_outputs:process
		variable linha  : line;
		variable saida : integer;
		constant espaco: string := "  ";
		constant mensagem1: string := "Refrigerador funcionando";
		constant msg_porta_alerta: string :="ALERTA: Porta do refrigerador aberta!";
		constant msg_temp_alta: string :="VACINAS DESCARTADAS: Temperatura acima da permitida!";
		constant msg_temp_baixa: string :="VACINAS DESCARTADAS: Temperatura abaixo da permitida!";
		constant msg_temp_subindo: string :="ALERTA: Temperatura a temperatura esta subindo!";
		constant msg_temp_caindo: string := "ALERTA: Temperatura a temperatura esta caindo!";

	begin
		wait until (falling_edge(clk));
		while true loop
			write(linha,numeroRefrigerador);
			write(linha,espaco);
			
			saida := notificacao;
			if(saida = 1) then
				write(linha, mensagem1);
			elsif(saida = 2) then
				write(linha, msg_porta_alerta);
			elsif(saida = 3) then
				write(linha, msg_temp_alta);
			elsif(saida = 4) then
				write(linha, msg_temp_baixa);
			elsif(saida = 5) then
				write(linha, msg_temp_subindo);
			elsif(saida = 6) then
				write(linha, msg_temp_caindo);
			end if;
			
				write(linha,espaco);
				write(linha,loteVacina);
				write(linha,espaco);
				write(linha,temperatura_1);
				write(linha,espaco);
				write(linha,porta_1);
				writeline(refrigerador_1,linha);
				
		wait;
		end loop; 
	end process escrita_vacina_outputs; 
	
		
		
		--temperatura_1 <= "0000000000000100", "0000000000000010" after 10 ns, "0000000000000011" after 20 ns, "0000000000000111" after 30 ns, "0000000000000010" after 40ns, "0000000000000010" after 50ns, "0000000000000001" after 60ns;
		--porta_1 <= false, true after 15 ns, false after 5 ns, true after 30 ns, false after 20 ns, true after 50 ns;
	
end tb_gestao_vacinas;