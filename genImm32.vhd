--Alexandre Santana Sousa
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package i_format is
	type FORMAT_RV is (R_type, I_type, S_type, SB_type, UJ_type, U_type);
end i_format;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.i_format.all;

entity genImm32 is port(
	instr: in std_logic_vector(31 downto 0);
    	imm32: out signed(31 downto 0));
end genImm32;


architecture behavior of genImm32 is
signal temp: signed(31 downto 0);
signal inst_type: FORMAT_RV; 
signal opcode: unsigned(6 downto 0);

begin
	imm32 <= temp;
    	opcode <= unsigned(instr(6 downto 0));  

   	process(instr, inst_type, opcode)
    	begin
        case opcode is
        	when b"0110011" =>
            	inst_type <= R_type;
            when b"0000011" | b"0010011" | b"1100111" => 
            	inst_type <= I_type;
            when b"0100011" =>
            	inst_type <= S_type;
            when b"1100011" => 
            	inst_type <= SB_type;
            when b"0110111" => 
            	inst_type <= U_type;
            when others =>
            	inst_type <= UJ_type;
       	end case;        
        
        case inst_type is
        	when R_type =>
            	temp <= x"00000000";
      		when I_type =>
            	temp <= to_signed(to_integer(signed(instr(31 downto 20))),32);
            when S_type =>
            	temp <= to_signed(to_integer(signed(instr(31 downto 25) & instr(11 downto 7))),32);
            when SB_type =>
            	temp <= to_signed(to_integer(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8)) & '0'),32); 
            when UJ_type =>
            	temp <= to_signed(to_integer(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0')),32);
            when others =>
                temp <= shift_left(to_signed(to_integer(signed(instr(31 downto 12))),32), 12);
        end case;
	end process; 
end behavior;

