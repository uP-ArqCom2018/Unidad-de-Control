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
	ALUop_o: OUT std_logic_vector(3 downto 0);
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
  funct7<= INSTR_i(31 downto 25);-- when opcode="0110011" OR opcode="0010011";
  
  --Si es tipo R, I, S, SB, asigno el valor funct3
  funct3 <=INSTR_i(14 downto 12);-- when opcode="0110011" OR opcode="0000011" OR opcode="0010011" OR opcode="1100111" OR opcode="0100011" OR opcode="1100011" OR opcode="1100111";

  
	MemWrite_o <=	'0' when opcode = "0110011" else --Si es de tipo R
					'0' when opcode = "0000011" and funct3 = "010" else -- instrucion lw
					'0' when opcode = "0010011" and funct3 = "000" else -- ADDI
					'0' when opcode = "0010011" and funct3 = "001" and funct7 = "0000000" else -- SLLI
					'1' when opcode = "0100011" and funct3 = "010" else	-- SW
					'1' when opcode = "1100011" and funct3 = "000" else	-- BEQ
					'1' when opcode = "1100011" and funct3 = "001"; -- BNE

	ALUsrc_o <=		'0' when opcode = "0110011" else --Si es de tipo R
					'1' when opcode = "0000011" and funct3 = "010" else -- instrucion lw
					'1' when opcode = "0010011" and funct3 = "000" else -- ADDI
					'1' when opcode = "0010011" and funct3 = "001" and funct7 = "0000000" else -- SLLI
					'1' when opcode = "0100011" and funct3 = "010" else	-- SW
					'0' when opcode = "1100011" and funct3 = "000" else	-- BEQ
					'0' when opcode = "1100011" and funct3 = "001"; -- BNE

	Uncondbranch_o <=		'0' when opcode = "0110011" else --Si es de tipo R
							'0' when opcode = "0000011" and funct3 = "010" else -- instrucion lw
							'0' when opcode = "0010011" and funct3 = "000" else -- ADDI
							'0' when opcode = "0010011" and funct3 = "001" and funct7 = "0000000" else -- SLLI
							'0' when opcode = "0100011" and funct3 = "010" else	-- SW
							'0' when opcode = "1100011" and funct3 = "000" else	-- BEQ
							'0' when opcode = "1100011" and funct3 = "001"; -- BNE

	Condbranch_o <=		'0' when opcode = "0110011" else --Si es de tipo R
					'0' when opcode = "0000011" and funct3 = "010" else -- instrucion lw
					'0' when opcode = "0010011" and funct3 = "000" else -- ADDI
					'0' when opcode = "0010011" and funct3 = "001" and funct7 = "0000000" else -- SLLI
					'0' when opcode = "0100011" and funct3 = "010" else	-- SW
					'1' when opcode = "1100011" and funct3 = "000" else	-- BEQ
					'1' when opcode = "1100011" and funct3 = "001"; -- BNE

	Reg_W_o <=		'1' when opcode = "0110011" else --Si es de tipo R
					'1' when opcode = "0000011" and funct3 = "010" else -- instrucion lw
					'1' when opcode = "0010011" and funct3 = "000" else -- ADDI
					'0' when opcode = "0010011" and funct3 = "001" and funct7 = "0000000" else -- SLLI
					'0' when opcode = "0100011" and funct3 = "010" else	-- SW
					'0' when opcode = "1100011" and funct3 = "000" else	-- BEQ
					'0' when opcode = "1100011" and funct3 = "001"; -- BNE

	MemtoReg_o <=	'0' when opcode = "0110011" else --Si es de tipo R
					'1' when opcode = "0000011" and funct3 = "010" else -- instrucion lw
					'0' when opcode = "0010011" and funct3 = "000" else -- ADDI
					'0' when opcode = "0010011" and funct3 = "001" and funct7 = "0000000" else -- SLLI
					'1' when opcode = "0100011" and funct3 = "010" else	-- SW
					'0' when opcode = "1100011" and funct3 = "000" else	-- BEQ
					'0' when opcode = "1100011" and funct3 = "001"; -- BNE

	MemRead_o <=	'0' when opcode = "0110011" else --Si es de tipo R
					'0' when opcode = "0000011" and funct3 = "010" else -- instrucion lw
					'1' when opcode = "0010011" and funct3 = "000" else -- ADDI
					'0' when opcode = "0010011" and funct3 = "001" and funct7 = "0000000" else -- SLLI
					'0' when opcode = "0100011" and funct3 = "010" else	-- SW
					'1' when opcode = "1100011" and funct3 = "000" else	-- BEQ
					'0' when opcode = "1100011" and funct3 = "001"; -- BNE

	NOzero <=	'0' when opcode = "0110011" else --Si es de tipo R
					'0' when opcode = "0000011" and funct3 = "010" else -- instrucion lw
					'0' when opcode = "0010011" and funct3 = "000" else -- ADDI
					'0' when opcode = "0010011" and funct3 = "001" and funct7 = "0000000" else -- SLLI
					'0' when opcode = "0100011" and funct3 = "010" else	-- SW
					'0' when opcode = "1100011" and funct3 = "000" else	-- BEQ
					'1' when opcode = "1100011" and funct3 = "001"; -- BNE

	ALUop_o <=	"0000" when opcode = "0110011" and funct3 = "000" and funct7 = "0000000" else	-- add
				"0001" when opcode = "0110011" and funct3 = "000" and funct7 = "0100000" else -- sub
				"0000" when opcode = "0000011" and funct3 = "010" else	-- lw
				"0000" when opcode = "0010011" and funct3 = "000" else 	-- addi
				"0111" when opcode = "0010011" and funct3 = "001" and funct7 = "0000000" else 	-- slli
				"0000" when opcode = "0100011" and funct3 = "010" else 	-- sw
				"0000" when opcode = "1100011" and funct3 = "000" else	-- beq
				"0000" when opcode = "1100011" and funct3 = "001";	-- bne


--					  
--	ALUsrc_o <= '0' when opcode="0110011"; 
--	Uncondbranch_o <= '0' when opcode="0110011"; 
--	Condbranch_o <= '0' when opcode="0110011"; 
--	Reg_W_o <= '1' when opcode="0110011"; 
--	MemtoReg_o <= '0' when opcode="0110011"; 
--	MemRead_o <= '0' when opcode="0110011"; 
--	NOzero <= '0' when opcode="0110011"; 
--	
--	ALUop_o <= "0000" when opcode="0110011" and funct3 = "000" and funct7="0000000" else	-- add
--				  "0001" when opcode="0110011" and funct3 = "000" and funct7="0100000";		-- sub
--				  
--	-- Cuando es tipo I, se tienen 3 tipos de opcode
--	
--	-- instruccion LW
--	MemWrite_o <= '0' when opcode = "0000011" and funct3 = "010"; 
--	ALUsrc_o <= '1' when opcode="0000011" and funct3 = "010";
--	Uncondbranch_o <= '0' when opcode="0000011" and funct3 = "010";
--	Condbranch_o <= '0' when opcode="0000011" and funct3 = "010";
--	Reg_W_o <= '1' when opcode="0000011" and funct3 = "010";
--	MemtoReg_o <= '1' when opcode="0000011" and funct3 = "010";
--	MemRead_o <= '1' when opcode="0000011" and funct3 = "010";
--	ALUop_o <= "0000" when opcode="0000011" and funct3 = "010";
--	
--	-- Instruccion ADDI
--	MemWrite_o<='0' when opcode="0010011" and funct3 = "000";
--	ALUsrc_o<='1' when opcode="0010011" and funct3 = "000";
--	Uncondbranch_o<='0' when opcode="0010011" and funct3 = "000";
--	Condbranch_o<='0' when opcode="0010011" and funct3 = "000";
--	Reg_W_o<='1' when opcode="0010011" and funct3 = "000";
--	MemtoReg_o<='0' when opcode="0010011" and funct3 = "000";
--	MemRead_o<='0' when opcode="0010011" and funct3 = "000";
--	ALUop_o<="0000" when opcode="0010011" and funct3 = "000";
--	NOzero<='0' when opcode="0010011" and funct3 = "000";
  
--
--tipo : PROCESS(opcode,funct3,funct7) IS
--  -- Put declarations here.
--BEGIN
--  -- Put sequential statements here.
--	IF (opcode="0110011") THEN --Si es tipo R
--		MemWrite_o<='0';
--   		ALUsrc_o<='0';
--		Uncondbranch_o<='0';
--		Condbranch_o<='0';
--		Reg_W_o<='1';
--		MemtoReg_o<='0';
--		MemRead_o<='0';
--		NOzero<='0';
--		CASE funct3 IS
--			WHEN "000" =>
--			
--				IF (funct7="0000000") THEN --add
--				    	ALUop_o<="0000"; 
--				ELSIF (funct7="0100000") THEN --sub
--						ALUop_o<="0001"; 
--				END IF;		
--	  --		WHEN "001" =>
--	  --	WHEN "100" =>
--	  --		WHEN "101" =>
--	--		WHEN "110" =>
--	--		WHEN "111" =>
--	--		WHEN "011" =>*/
--			WHEN OTHERS => ALUop_o<="0000";
--		END CASE;
--	ELSIF (opcode="0000011") THEN --Si es tipo I (se tienen 3 tipos de opcode)
--		CASE funct3 IS
--			WHEN "010" => --Instruccion LW
--						MemWrite_o<='0';
--   						ALUsrc_o<='1';
--						Uncondbranch_o<='0';
--						Condbranch_o<='0';
--						Reg_W_o<='1';
--						MemtoReg_o<='1';
--						MemRead_o<='1';
--						ALUop_o<="0000";
--
--			WHEN OTHERS => ALUop_o<="0000";
--		END CASE;
--	ELSIF (opcode="0010011") THEN --Si es tipo I
--		CASE funct3 IS
--			WHEN "000" =>         --INSTRUCCION ADDI
--						MemWrite_o<='0';
--   						ALUsrc_o<='1';
--						Uncondbranch_o<='0';
--						Condbranch_o<='0';
--						Reg_W_o<='1';
--						MemtoReg_o<='0';
--						MemRead_o<='0';
--						ALUop_o<="0000";
--						NOzero<='0';
--			WHEN "001" => 
--				IF (funct7="0000000") THEN -- INSTRUCCION SLLI
--						MemWrite_o<='0';
--   						ALUsrc_o<='1';
--						Uncondbranch_o<='0';
--						Condbranch_o<='0';
--						Reg_W_o<='1';
--						MemtoReg_o<='0';
--						MemRead_o<='0';
--						ALUop_o<="0111";
--						NOzero<='0';
--				END IF; 			
--			WHEN OTHERS => ALUop_o<="0000";
--		END CASE;
--	ELSIF (opcode="0100011") THEN --Si es tipo S  
--		CASE funct3 IS
--			WHEN "010" =>  --INSTRUCCION SW
--						MemWrite_o<='1';
--   						ALUsrc_o<='1';
--						Uncondbranch_o<='0';
--						Condbranch_o<='0';
--						Reg_W_o<='0';
--						MemtoReg_o<='1';
--						MemRead_o<='0';
--						ALUop_o<="0000";
--						NOzero<='0';
--			WHEN OTHERS => ALUop_o<="0000";
--		END CASE;
--	ELSIF (opcode="1100011") THEN --Si es tipo SB 
--		CASE funct3 IS
--			WHEN "000" =>  -- INstruccion BEQ
--						MemWrite_o<='0';
--   						ALUsrc_o<='0';
--						Uncondbranch_o<='0';
--						Condbranch_o<='1';
--						Reg_W_o<='0';
--						MemtoReg_o<='0';
--						MemRead_o<='0';
--						ALUop_o<="0001";
--						NOzero<='0';     
--			WHEN "001" =>  -- INstruccion BNE
--						MemWrite_o<='0';
--   						ALUsrc_o<='0';
--						Uncondbranch_o<='0';
--						Condbranch_o<='1';
--						Reg_W_o<='0';
--						MemtoReg_o<='0';
--						MemRead_o<='0';
--						ALUop_o<="0001";
--						NOzero<='1';			
--			WHEN OTHERS => ALUop_o<="0000";	   
--		END CASE;
--	--Faltarian tipo U-UJ pero todavia no se implementan
--	END IF;
--      
--END PROCESS tipo;
--  
   
  
END ARCHITECTURE Behavioral; -- Of entity unidad_control

