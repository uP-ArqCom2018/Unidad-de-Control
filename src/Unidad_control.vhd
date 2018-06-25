library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY unidad_control IS
	PORT(
	INSTR_i: IN std_logic_vector(31 downto 0);
	MemWrite_o: OUT std_logic := '0';
	ALUsrc_o: OUT std_logic:= '0';
	Uncondbranch_o: OUT std_logic:= '0';
	Condbranch_o: OUT std_logic:= '0';
	Reg_W_o: OUT std_logic:= '0';
	MemtoReg_o: OUT std_logic:= '0';
	MemRead_o: OUT std_logic:= '0';
	ALUop_o: OUT std_logic_vector(3 downto 0):= "0000";
	NOzero: OUT std_logic:= '0'
	);  
END ENTITY unidad_control;

ARCHITECTURE Behavioral OF unidad_control IS
  -- put declarations here.
  SIGNAL funct7 : std_logic_vector(6 downto 0);
  SIGNAL funct3 : std_logic_vector(2 downto 0);
  SIGNAL opcode : std_logic_vector(6 downto 0);
  
BEGIN
  -- put concurrent statements here. 
  opcode <= INSTR_i(6 downto 0);
  -- Verifico el tipo de instruccion
  --Si es tipo R y uno de tipo I, asigno el valor funct7;
  funct7<= INSTR_i(31 downto 25) when opcode="0110011" OR opcode="0010011";
  
  --Si es tipo R, I, S, SB, asigno el valor funct3
  funct3 <=INSTR_i(14 downto 12) when opcode="0110011" OR opcode="0000011" OR opcode="0010011" OR opcode="1100111" OR opcode="0100011" OR opcode="1100011" OR opcode="1100111";



tipo : PROCESS(opcode,funct3,funct7) IS
  -- Put declarations here.
BEGIN
  -- Put sequential statements here.
	IF (opcode="0110011") THEN --Si es tipo R
		MemWrite_o<='0';
   		ALUsrc_o<='0';
		Uncondbranch_o<='0';
		Condbranch_o<='0';
		Reg_W_o<='1';
		MemtoReg_o<='0';
		MemRead_o<='0';
		NOzero<='0';
		CASE funct3 IS
			WHEN "000" =>
			
				IF (funct7="0000000") THEN --add
				    	ALUop_o<="0000"; 
				ELSIF (funct7="0100000") THEN --sub
						ALUop_o<="0001"; 
				END IF;		
	  --		WHEN "001" =>
	  --	WHEN "100" =>
	  --		WHEN "101" =>
	--		WHEN "110" =>
	--		WHEN "111" =>
	--		WHEN "011" =>*/
			WHEN OTHERS => ALUop_o<="0000";
		END CASE;
	ELSIF (opcode="0000011") THEN --Si es tipo I (se tienen 3 tipos de opcode)
		CASE funct3 IS
			WHEN "010" => --Instruccion LW
						MemWrite_o<='0';
   						ALUsrc_o<='1';
						Uncondbranch_o<='0';
						Condbranch_o<='0';
						Reg_W_o<='1';
						MemtoReg_o<='1';
						MemRead_o<='1';
						ALUop_o<="0000";

			WHEN OTHERS => ALUop_o<="0000";
		END CASE;
	ELSIF (opcode="0010011") THEN --Si es tipo I
		CASE funct3 IS
			WHEN "000" =>         --INSTRUCCION ADDI
						MemWrite_o<='0';
   						ALUsrc_o<='1';
						Uncondbranch_o<='0';
						Condbranch_o<='0';
						Reg_W_o<='1';
						MemtoReg_o<='0';
						MemRead_o<='0';
						ALUop_o<="0000";
						NOzero<='0';
			WHEN "001" => 
				IF (funct7="0000000") THEN -- INSTRUCCION SLLI
						MemWrite_o<='0';
   						ALUsrc_o<='1';
						Uncondbranch_o<='0';
						Condbranch_o<='0';
						Reg_W_o<='1';
						MemtoReg_o<='0';
						MemRead_o<='0';
						ALUop_o<="0111";
						NOzero<='0';
				END IF; 			
			WHEN OTHERS => ALUop_o<="0000";
		END CASE;
	ELSIF (opcode="0100011") THEN --Si es tipo S  
		CASE funct3 IS
			WHEN "010" =>  --INSTRUCCION SW
						MemWrite_o<='1';
   						ALUsrc_o<='1';
						Uncondbranch_o<='0';
						Condbranch_o<='0';
						Reg_W_o<='0';
						MemtoReg_o<='1';
						MemRead_o<='0';
						ALUop_o<="0000";
						NOzero<='0';
			WHEN OTHERS => ALUop_o<="0000";
		END CASE;
	ELSIF (opcode="1100011") THEN --Si es tipo SB 
		CASE funct3 IS
			WHEN "000" =>  -- INstruccion BEQ
						MemWrite_o<='0';
   						ALUsrc_o<='0';
						Uncondbranch_o<='0';
						Condbranch_o<='1';
						Reg_W_o<='0';
						MemtoReg_o<='0';
						MemRead_o<='0';
						ALUop_o<="0001";
						NOzero<='0';     
			WHEN "001" =>  -- INstruccion BNE
						MemWrite_o<='0';
   						ALUsrc_o<='0';
						Uncondbranch_o<='0';
						Condbranch_o<='1';
						Reg_W_o<='0';
						MemtoReg_o<='0';
						MemRead_o<='0';
						ALUop_o<="0001";
						NOzero<='1';			
			WHEN OTHERS => ALUop_o<="0000";	   
		END CASE;
	--Faltarian tipo U-UJ pero todavia no se implementan
	END IF;
      
END PROCESS tipo;
  
   
  
END ARCHITECTURE Behavioral; -- Of entity unidad_control

