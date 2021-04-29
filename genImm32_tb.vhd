library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity testbench is
-- empty
end testbench; 

architecture tb of testbench is


component genImm32 is port(
	instr: in std_logic_vector(31 downto 0);
    imm32: out signed(31 downto 0);
);

end component;

-- Sinais para conectar nas entradas e saídas

signal i: std_logic_vector(31 downto 0);
signal imm: signed(31 downto 0);

begin

  DUT: genImm32 port map(instr => i, imm32 => imm);

  process
  begin
  	report "****Inicio do testbench****";
    
    i <= x"000002b3";
    wait for 1 ns;
	assert(imm= x"00000000") report "Falha teste tipo R";
    
    i <= x"01002283";
    wait for 1 ns;
	assert(imm = x"00000010") report "Falha teste tipo I (lw)";
    
    i <= x"f9c00313";
    wait for 1 ns;
	assert(imm = x"ffffff9c") report "Falha teste tipo I (addi negativo)"; 
    
    i <= x"fff2c293";
    wait for 1 ns;
	assert(imm = x"ffffffff") report "Falha teste tipo I (xori)";
    
    i <= x"16200313";
    wait for 1 ns;
	assert(imm = x"00000162") report "Falha teste tipo I (addi)";
    
    i <= x"01800067";
    wait for 1 ns;
	assert(imm = x"00000018") report "Falha teste tipo I (jalr)";
    
    i <= x"00002437";
    wait for 1 ns;
	assert(imm = x"00002000") report "Falha teste tipo U (lui)";
    
    i <= x"02542e23";
    wait for 1 ns;
	assert(imm = x"000003c") report "Falha teste tipo S (sw)";
    
    i <= x"fe5290e3";
    wait for 1 ns;
	assert(imm = x"ffffffe0") report "Falha teste tipo SB (bne)";
    
    i <= x"00c000ef";
    wait for 1 ns;
	assert(imm = x"0000000c") report "Falha teste tipo UJ (jal)";    
    

	i <= x"00000000";
    assert false report "****Fim dos testes****" severity note;
    wait;
  end process;
end tb;

