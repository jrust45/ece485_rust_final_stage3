library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instr_mem is
    Port (
        addr    : in  STD_LOGIC_VECTOR(31 downto 0);
        instr   : out STD_LOGIC_VECTOR(31 downto 0)
    );
end instr_mem;

-- Note: the Real RISC-V uses the ADDI for the NOP instruction, but I'm pretending 0x0000000000000000 is a NOP
-- inserting NOPs to avoid hazards
architecture Behavioral of instr_mem is
    type memory_array is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
    signal memory : memory_array := (
        0 => x"00900293", -- addi x5, x0, 9         
        1 => x"00000317", -- load_addr x6, array                             
        2 => x"00032383", -- lw x7, 0(x6)
        3 => x"00430313", -- loop: addi x6, x6, 4 
        4 => x"00032503", --       lw x10, 0(x6)  
        5 => x"007503B3", --      add x7, x10, x7 
        6 => x"00129293", --      subi x5, x5, 1 (or "addi x5, x5, -1") 
        7 => x"FC029CE3", --      bne x5, x0, loop [jump -20 note: assumes PC is incremented by 4]
                                                    --1 111100 00000 00101 001 100 0 1 1100011
                                                    --   F   8    0   2    9      8     E    3
        8 => x"FF9FF06F", -- done: j done
        others => (others => '0')
        
--        0 => x"00900293", -- addi x5, x0, 9         
--        1 => x"00000317", -- load_addr x6, array                             
--        2 => x"00000013", -- addi x0, x0, 0 - NOP
--        3 => x"00000013", -- addi x0, x0, 0 - NOP
--        4 => x"00000013", -- addi x0, x0, 0 - NOP
--        5 => x"00032383", -- lw x7, 0(x6)
--        6 => x"00430313", -- loop: addi x6, x6, 4 
--        7 => x"00000013", --       addi x0, x0, 0 - NOP
--        8 => x"00000013", --       addi x0, x0, 0 - NOP
--        9 => x"00000013", --       addi x0, x0, 0 - NOP
--        10 => x"00032503", --       lw x10, 0(x6)  
--        11 => x"00000013", --       addi x0, x0, 0 - NOP
--        12 => x"00000013", --       addi x0, x0, 0 - NOP
--        13 => x"00000013", --      addi x0, x0, 0 - NOP
--        14 => x"007503B3", --      add x7, x10, x7 
--        15 => x"00129293", --      subi x5, x5, 1 (or "addi x5, x5, -1") 
--        16 => x"00000013", --      addi x0, x0, 0 - NOP
--        17 => x"00000013", --      addi x0, x0, 0 - NOP
--        18 => x"00000013", --      addi x0, x0, 0 - NOP 
--        19 => x"F80298E3", --      bne x5, x0, loop [jump -56 note: assumes PC is incremented by 4]
--                                                    --1 111100 00000 00101 001 100 0 1 1100011
--                                                    --   F   8    0   2    9      8     E    3
--        20 => x"00000013", --      addi x0, x0, 0 - NOP
--        21 => x"00000013", --      addi x0, x0, 0 - NOP
--        22 => x"00000013", --      addi x0, x0, 0 - NOP  
--        23 => x"FF9FF06F", -- done: j done
--        others => (others => '0')
        
    );
begin
    process(addr)
    begin
        instr <= memory(to_integer(unsigned(addr(7 downto 0))));
    end process;
end Behavioral;
