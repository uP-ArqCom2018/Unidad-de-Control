library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY unidad_control_tb IS
END ENTITY unidad_control_tb;

ARCHITECTURE Behavioral OF unidad_control_tb IS

COMPONENT unidad_control
	PORT(
	INSTR_i: IN std_logic_vector(31 downto 0);
	MemWrite_o: OUT std_logic;
	ALUsrc_o: OUT std_logic;
	Uncondbranch_o: OUT std_logic;
	Condbranch_o: OUT std_logic;
	Reg_W_o: OUT std_logic;
	MemtoReg_o: OUT std_logic;
	MemRead_o: OUT std_logic;
	ALUop_o: OUT std_logic_vector(3 downto 0)
	NOzero: OUT std_logic
	);
END COMPONENT; 

SIGNAL INSTR_i: std_logic_vector(31 downto 0);
SIGNAL MemRead_o,MemtoReg_o,MemWrite_o,Uncondbranch_o,Condbranch_o,ALUsrc_o,Reg_W_o: std_logic;
SIGNAL ALUop_o: std_logic_vector(3 downto 0);   
SIGNAL NOzero: std_logic;
  -- put declarations here.
BEGIN
  -- Instancio el componente para luego generar los estimulos
  uut: unidad_control port map(INSTR_i,
	MemWrite_o,
	ALUsrc_o,
	Uncondbranch_o,
	Condbranch_o,
	Reg_W_o,
	MemtoReg_o,
	MemRead_o,
	ALUop_o,
	NOzerosignal Memoria_ram: ram_memory;);
estimulos : PROCESS IS
  -- Put declarations here.
BEGIN
	
	INSTR_i<=x"06400213";
	wait for 30 ns;
	INSTR_i<=x"00A0A483";
	wait for 30 ns;
	wait;
END PROCESS estimulos;

END ARCHITECTURE Behavioral; -- Of entity unidad_control_tb
