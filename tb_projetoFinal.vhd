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
		start: in integer:= 0;
		temp_1: in std_logic_vector(15 downto 0);
		sensor_1: in boolean;
		led_1: out std_logic
	);
	end component;
	
	
-- declaraçoes de  signal

	type vect is array (1 to 5) of integer; --O indice do array é o numero do refrigerador 
	signal vacinas_data: vect;
	signal mensagem: vect;
	signal clk: std_logic;
	signal read_vacinas: std_logic := '0';
	signal lote_data: string;
	signal refrigerador_data: integer;
	signal flag_write   : std_logic := '0';
	signal start: integer;
	signal vacinas_output      : std_logic_vector(7 downto 0);
	signal porta_1 : boolean;
	signal temperatura_1 : std_logic_vector(15 downto 0);

	
	-- declaraçoes constant
	constant PERIOD     : time := 20 ns;
   constant DUTY_CYCLE : real := 0.5;
   constant OFFSET     : time := 5 ns;
	constant max_value      : natural := 15;
	constant mim_value		: natural := 0;

	-- declaraÃ§Ãµes file
	file vacinas			: text open read_mode is "vacina.txt";
	file refrigerador_1	: text open write_mode is "refrigerador_1.txt";
	file refrigerador_2	: text open write_mode is "refrigerador_2.txt";
	file refrigerador_3	: text open write_mode is "refrigerador_3.txt";
	
		------------------------------ PORT MAP ---------------------------------------
begin
	DUT: vacina
    port map(temp_1      	=> temperatura_1,
             sensor_1       => porta_1);
				 
	-- clock process
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
	

	--leitura dos dados vacina.txt
leitura_vacinas_process: process
	variable linha : line;
	variable nomeVacina : string;
	variable loteVacina : string;
	variable numeroRefrigerador : integer;
	variable espaco 	  : character;
	variable input : std_logic_vector(3 downto 0);
	
	
	begin
		wait until(falling_edge(clk));
		while(not endfile(vacinas)) loop
			if (start = 1) then
				readline(vacinas, linha);
				read(linha,nomeVacina);		
				
				read(linha, espaco);
				
				read(linha,loteVacina);
				lote_data <= loteVacina;
				
				read(linha, espaco);
				
				read(linha, numeroRefrigerador);
				refrigerador_data <= numeroRefrigerador;
				
				if(nomeVacina = "Pfizer") then
					vacinas_data(numeroRefrigerador) <= 1; 
				else 
					vacinas_data(numeroRefrigerador) <= 2;
				end if;		
			end if;
		end loop;
		wait;
	end process leitura_vacinas_process;	
	
	
	
	-- gera estimulos de entrada
	gera_estimulos_entrada_process: process
   begin
		wait for(OFFSET + 3*PERIOD);
            start <= 1;		
			for i in mim_value to max_value loop
				wait for PERIOD;
		   end loop;
            start <= 0;		
		wait;
end process gera_estimulos_entrada_process;	
   	

	-- gera estimulos de saida
gera_estimulos_saida_process: process
	begin
		wait for(OFFSET + 4*PERIOD);
			flag_write <= '1';
			for i in mim_value to max_value loop
				wait for PERIOD;
		   end loop;
         flag_write <= '0';			
		 wait;
end process gera_estimulos_saida_process;   
   
	
	
	
	-- escreve relatorio
escreve_relatorio: process
	variable linha : line;
	variable output : std_logic_vector(3 downto 0); 
	begin
		--wait until clk ='0';
		while true loop
			if (flag_write ='1')then
				output := vacinas_output;
				write(linha, output);
				writeline(refrigerador_1,linha);
			 end if;
			 wait for PERIOD;
		 end loop; 
end process escreve_relatorio;   
	-- escrita do relatorio 
	escrita_vacina_outputs:process
		variable linha  : line;
		variable saida : integer;
		constant espaco: string := "  ";
		constant mensagem1: "Refrigerador funcionando";
		constant msg_porta_alerta: "ALERTA: Porta do refrigerador aberta!";
		constant msg_temp_alta: "VACINAS DESCARTADAS: Temperatura acima da permitida!";
		constant msg_temp_baixa: "VACINAS DESCARTADAS: Temperatura abaixo da permitida!";
		constant msg_temp_subindo: "ALERTA: Temperatura a temperatura esta subindo!";
		constant msg_temp_caindo: "ALERTA: Temperatura a temperatura esta caindo!";

	begin
		wait until (falling_edge(clk));
		while true loop
			saida := mensagem(1);
			if(saida = 1) then
				write(linha, mensagem1);
				write(linha,espaco);
				write(linha,temperatura_1);
				write(linha,espaco);
				write(linha,porta_1);
				writeline(refrigerador_1,linha);
				
			end if;
		wait;
		end loop; 
	end process escrita_vacina_outputs; 
	
	
end tb_gestao_vacinas;