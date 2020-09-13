----------------------------------------------------------------------------------
-- Harvard architecture memory setup
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity memory is
    port(
        clk : in std_logic;
        pc_en : in std_logic;
        pc_in : in std_logic_vector(7 downto 0);
        pc_out : out std_logic_vector(7 downto 0);
		rwe : in std_logic;
        rwa : in std_logic_vector(3 downto 0);
        rwd : in std_logic_vector(15 downto 0);
        rd1 : out std_logic_vector(15 downto 0);
        rd2 : out std_logic_vector(15 downto 0);
        instr : out std_logic_vector(15 downto 0);
        rst : in std_logic
    );
end memory;

architecture rtl of memory is

    -- distributed memory 16x256 rom ip core
    component imem
    port (
        a : in std_logic_vector(7 downto 0);
        spo : out std_logic_vector(15 downto 0)
    );    
    end component;

    type registers is array (0 to 15) of std_logic_vector(15 downto 0); 

    signal rf : registers;
    signal pc : std_logic_vector(7 downto 0);
    signal instr_bus : std_logic_vector(15 downto 0);
    signal ra2 : std_logic_vector(3 downto 0);

begin

    -- program counter 
    pc_entity: process(rst, clk)
    begin
        if (rst = '1') then
            pc <= x"08"; -- 8 addresses are reserved for interrupts vectors
        elsif (rising_edge(clk)) then
            if (pc_en = '1') then
                pc <= pc_in;
            end if;
        end if;
    end process;
    
    pc_out <= pc;
    
    -- register file   
    reg_file_entity: process (clk)
    begin
        if (rising_edge(clk)) then
            if (rwe = '1') then
                rf(CONV_INTEGER(rwa)) <= rwd;
            end if;
        end if;
    end process;
    
    ra2 <= (instr_bus(15) and instr_bus(14) and instr_bus(3)) & instr_bus(2 downto 0);
    rd1 <= rf(CONV_INTEGER(instr_bus(7 downto 4)));
    rd2 <= rf(CONV_INTEGER(ra2));
    
    -- instructions rom  
    instructions_rom: imem 
    port map(
        a => pc,
        spo => instr_bus
    );
    
    instr <= instr_bus;

end rtl;

