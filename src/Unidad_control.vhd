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
  
END ARCHITECTURE Behavioral; -- Of entity unidad_control

